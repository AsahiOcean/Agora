import UIKit

class ProgressIndicator: UIView {
    
    public var radius: CGFloat = 20
    
    fileprivate lazy var trackLayer: CAShapeLayer = {
        let track = CAShapeLayer()
        track.position = self.center
        track.lineCap = .round
        track.lineWidth = 2
        track.fillColor = .none
        track.strokeColor = #colorLiteral(red: 0.3363491595, green: 0.2730357051, blue: 0.4258503616, alpha: 1)
        track.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        track.path = UIBezierPath(arcCenter: .zero,
                                  radius: self.radius,
                                  startAngle: 0,
                                  endAngle: 2 * CGFloat.pi,
                                  clockwise: true).cgPath
        return track
    }()
    
    fileprivate lazy var shapeLayer: CAShapeLayer = {
        let shape = CAShapeLayer()
        shape.position = self.center
        shape.lineCap = .round
        shape.lineWidth = 2
        shape.fillColor = .none
        shape.strokeColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        shape.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        shape.path = UIBezierPath(arcCenter: .zero,
                                  radius: self.radius,
                                  startAngle: 0,
                                  endAngle: 2 * CGFloat.pi,
                                  clockwise: true).cgPath
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1
        animation.autoreverses = false
        animation.repeatCount = .infinity
        shape.add(animation, forKey: "line")
        shape.transform = CATransform3DMakeRotation(-CGFloat.pi/2,0,0,1)
        return shape
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.addSublayer(trackLayer)
        self.layer.addSublayer(shapeLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        if aDecoder == .none {
            fatalError("init(coder:) has not been implemented")
        } else {
            super.init(coder: aDecoder)
        }
    }
}
