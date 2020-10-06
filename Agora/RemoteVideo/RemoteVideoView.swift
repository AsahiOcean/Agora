import UIKit

class RemoteVideoView: UIView {
    
    var progressIndicator: ProgressIndicator!
    
    fileprivate func extractedFunc() {
        self.progressIndicator = ProgressIndicator(frame: self.bounds)
        self.addSubview(progressIndicator)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.2890075445, green: 0.2517263889, blue: 0.352177918, alpha: 1)
        extractedFunc()
    }

    required init?(coder aDecoder: NSCoder) {
        if aDecoder == .none {
            fatalError("init(coder:) has not been implemented")
        } else {
            super.init(coder: aDecoder)
        }
    }
}
