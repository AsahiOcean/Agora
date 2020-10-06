import UIKit

class LocalVideoView: UIView {
        
    var progressIndicator: ProgressIndicator!
    
    fileprivate func extractedFunc() {
        self.progressIndicator = ProgressIndicator(frame: self.bounds)
        self.addSubview(progressIndicator)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.5268502831, green: 0.474650979, blue: 0.5886558294, alpha: 1)
        self.layer.cornerRadius = 10
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
