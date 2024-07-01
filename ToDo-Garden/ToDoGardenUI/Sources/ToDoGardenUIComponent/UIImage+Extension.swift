import UIKit

extension UIImageView {
  public func setImageWithZoomTransition(newImage: UIImage?, duration: TimeInterval = 0.3) {
    UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve) {
      self.image = newImage
      self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
    } completion: { _ in
      UIView.animate(withDuration: duration) {
        self.transform = .identity
      }
    }
  }
}
