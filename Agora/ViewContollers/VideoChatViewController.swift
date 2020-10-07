import UIKit
import AgoraRtcKit

class VideoChatViewController: UIViewController {
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBAction func didClickMuteButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        self.agoraKit.muteLocalAudioStream(sender.isSelected)
    }
    @IBAction func didClickSwitchCameraButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        self.agoraKit.switchCamera()
    }
    @IBAction func didClickHangUpButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        micButton.isHidden.toggle()
        cameraButton.isHidden.toggle()
        if sender.isSelected {
            agoraKit.leaveChannel(nil)
            UIApplication.shared.isIdleTimerDisabled = false
        } else {
            self.joinChannel.connect()
        }
    }
        
    fileprivate(set) var agoraKit: AgoraRtcEngineKit!
    fileprivate(set) var remoteVideo: RemoteVideoView!
    fileprivate(set) var localVideo: LocalVideoView!
    fileprivate(set) var joinChannel: JoinChannel!
    
    internal var beginLocation: CGPoint = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: API.appID, delegate: self)
        _ = SetupVideo(agoraKit: self.agoraKit)
        self.joinChannel = JoinChannel(self.agoraKit, completion: {
            self.remoteVideo = RemoteVideoView(frame: self.view.frame)
            self.localVideo = LocalVideoView()
            self.view.addSubview(self.remoteVideo)
            self.view.addSubview(self.localVideo)
            self.localVideo.addGestureRecognizer(UIPanGestureRecognizer(
                                                    target: self,
                                                    action: #selector(self.touched(_:))))
            self.localVideo.setupLocalVideo(self.agoraKit, self.remoteVideo)
        })
    }
}
