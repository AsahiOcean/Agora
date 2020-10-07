import AgoraRtcKit

extension VideoChatViewController: AgoraRtcEngineDelegate {
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid:UInt, size:CGSize, elapsed:Int) {
        self.remoteVideo.isRemoteVideoRender = true

        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = remoteVideo
        videoCanvas.renderMode = .hidden
        agoraKit.setupRemoteVideo(videoCanvas)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid:UInt, reason:AgoraUserOfflineReason) {
        self.remoteVideo.isRemoteVideoRender = false
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted:Bool, byUid:UInt) {
        self.remoteVideo.isRemoteVideoRender = !muted
    }
}

extension VideoChatViewController {
    @objc func touched(_ gestureRecognizer: UIGestureRecognizer) {
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
}
