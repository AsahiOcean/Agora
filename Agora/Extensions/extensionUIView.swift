import UIKit

extension UIView {
    public func didAppear(_ autoclosureEscaping: @autoclosure @escaping () -> Void? = nil) {
        if self.superview != nil {
            autoclosureEscaping()
        }
    }
    public func didDisappear(_ autoclosureEscaping: @autoclosure @escaping () -> Void? = nil) {
        if self.superview == nil {
            autoclosureEscaping()
        }
    }
}
