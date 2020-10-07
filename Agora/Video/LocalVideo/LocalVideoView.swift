import UIKit
import AgoraRtcKit

class LocalVideoView: UIView {
        
    fileprivate func extractedFunc() {
        if TARGET_IPHONE_SIMULATOR == 1 {
            UIView.animate(withDuration: 2.0, animations: {
                self.frame.origin.x = UIScreen.main.bounds.maxX - self.bounds.width / 5
            })
        } else {
            self.subviews.forEach({ $0.removeFromSuperview() })
        }
    }
    
    public func setupLocalVideo(_ agoraKit: AgoraRtcEngineKit!, _ remoteVideo: RemoteVideoView!) {
        agoraKit.enableVideo()
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.view = self
        videoCanvas.view?.layer.cornerRadius = 10
        videoCanvas.view?.didAppear({
            self.extractedFunc()
        }())
        videoCanvas.renderMode = .hidden
        remoteVideo.bringSubviewToFront(self)
        agoraKit.setupLocalVideo(videoCanvas)
    }
    
    init(framee: CGRect? = nil) {
        let defaultFrame: CGRect = CGRect(
            x: UIScreen.main.bounds.maxX * 0.70,
            y: UIScreen.main.bounds.maxY * 0.60,
            width: UIScreen.main.bounds.width / 3.75,
            height: UIScreen.main.bounds.height / 4.75)
        super.init(frame: framee ?? defaultFrame)
                
        self.backgroundColor = #colorLiteral(red: 0.5268502831, green: 0.474650979, blue: 0.5886558294, alpha: 1)
        
        let progressIndicator = ProgressIndicator(frame: self.bounds)
        self.addSubview(progressIndicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        if aDecoder == .none {
            fatalError("init(coder:) has not been implemented")
        } else {
            super.init(coder: aDecoder)
        }
    }
}
