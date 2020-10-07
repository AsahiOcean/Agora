import UIKit

class RemoteVideoView: UIView {
    
    fileprivate var progressIndicator: ProgressIndicator!
    
    public var isRemoteVideoRender: Bool = true {
        didSet {
            self.isHidden = !isRemoteVideoRender
            self.progressIndicator.isHidden = !isRemoteVideoRender
        }
    }
                    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.2890075445, green: 0.2517263889, blue: 0.352177918, alpha: 1)
        self.layer.zPosition = -1
        self.isUserInteractionEnabled = false
        
        self.progressIndicator = ProgressIndicator(frame: self.frame)
        self.progressIndicator.layer.zPosition = layer.zPosition - 1
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
