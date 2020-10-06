import UIKit
import AgoraRtcKit

class VideoChatViewController: UIViewController {
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBAction func didClickMuteButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        agoraKit.muteLocalAudioStream(sender.isSelected)
    }
    @IBAction func didClickSwitchCameraButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        agoraKit.switchCamera()
    }
    
    var agoraKit: AgoraRtcEngineKit!
        
    var isRemoteVideoRender: Bool = true {
        didSet {
            remoteVideo.isHidden = !isRemoteVideoRender
        }
    }
    
    var isStartCalling: Bool = true {
        didSet {
            if isStartCalling {
                micButton.isSelected = false
            }
            micButton.isHidden = !isStartCalling
            cameraButton.isHidden = !isStartCalling
        }
    }
    
    //MARK: -- RemoteVideo
    fileprivate var remoteVideo: RemoteVideoView!
    
    private func remoteVideoViewFunc(autoclosure: @autoclosure (() -> Void)) {
        self.remoteVideo = RemoteVideoView(frame: self.view.frame)
        self.remoteVideo.layer.zPosition = -1
        self.view.addSubview(remoteVideo)
        autoclosure()
    }
            
    //MARK: -- LocalVideo
    
    fileprivate var localVideoView: LocalVideoView!
    
    private func localVideoFunc(completion: () throws -> Void) {
        let gestRec = UIPanGestureRecognizer(
            target: self,
            action: #selector(self.touched(_:)))
        self.localVideoView = LocalVideoView(frame: CGRect(
                    x: UIScreen.main.bounds.maxX * 0.70,
                    y: UIScreen.main.bounds.maxY * 0.60,
                    width: UIScreen.main.bounds.width / 3.75,
                    height: UIScreen.main.bounds.height / 4.75))
        self.localVideoView.addGestureRecognizer(gestRec)
        self.view.addSubview(localVideoView)
        try? completion()
    }
    
    //MARK: Dragging local video
    fileprivate var beginLocation: CGPoint = .zero
    fileprivate var localVideoLocation: CGPoint? = nil
            
    @objc private func touched(_ gestureRecognizer: UIGestureRecognizer) {
        if let touched = gestureRecognizer.view {
            if gestureRecognizer.state == .began {
                beginLocation = gestureRecognizer.location(in: touched)
            } else if gestureRecognizer.state == .ended {
            } else if gestureRecognizer.state == .changed {
                let locationInView = gestureRecognizer.location(in: touched)
                touched.frame.origin = CGPoint(x: touched.frame.origin.x + locationInView.x - beginLocation.x, y: touched.frame.origin.y + locationInView.y - beginLocation.y)
            }
        }
    }
    //MARK: Setup Local Video
    private func setupLocalVideo() {
        self.agoraKit?.enableVideo()
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.view = self.localVideoView
        videoCanvas.renderMode = .hidden
        self.remoteVideo.bringSubviewToFront(self.localVideoView)
        self.agoraKit?.setupLocalVideo(videoCanvas)
    }
    
    //MARK: -- Agora Settings

    private func initializeAgoraEngine(completion: () throws -> Void) {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: API.appID, delegate: self)
        try? completion()
    }
    
    private func setupVideo() {
        agoraKit.enableVideo()
        agoraKit.setVideoEncoderConfiguration(AgoraVideoEncoderConfiguration(size: AgoraVideoDimension640x360, frameRate: .fps15, bitrate: AgoraVideoBitrateStandard, orientationMode: .adaptative))
    }
        
    private func joinChannel(completion: @escaping () throws -> Void) {
        agoraKit?.joinChannel(byToken: API.token, channelId: API.channelId, info: nil, uid: 0, joinSuccess: { (channel, uid, elapsed) -> Void in
            try? completion()
        })
        isStartCalling = true
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    //MARK: -- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.remoteVideoViewFunc(autoclosure: {
            self.localVideoFunc(completion: {
                self.setupLocalVideo()
            })
        }())

        self.initializeAgoraEngine(completion: {
            joinChannel(completion: {
                self.setupVideo()
            })
        })
    }
    
    //MARK: -- Others (touches event, etc.)
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            self.localVideoLocation = touch.location(in: self.view)
        }
    }
}

//MARK: Extensions
extension VideoChatViewController: AgoraRtcEngineDelegate {
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid:UInt, size:CGSize, elapsed:Int) {
        isRemoteVideoRender = true

        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = remoteVideo
        videoCanvas.renderMode = .hidden
        agoraKit.setupRemoteVideo(videoCanvas)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid:UInt, reason:AgoraUserOfflineReason) {
        isRemoteVideoRender = false
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted:Bool, byUid:UInt) {
        isRemoteVideoRender = !muted
    }
}
