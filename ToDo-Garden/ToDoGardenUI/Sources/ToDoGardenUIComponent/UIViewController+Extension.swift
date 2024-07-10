import UIKit

extension UIViewController {
  // MARK: - showAlert으로 띄워진 UIViewController의 경우에만 closeAlert의 효과를 누릴 수 있습니다.
  /// showAlert으로 띄운 뷰컨의 경우 꼭 closeAlert으로 제거해주시기 바랍니다.
  public func showAlert(_ base: UIViewController) {
    self.modalPresentationStyle = .overFullScreen
    self.splitViewController?.modalTransitionStyle = .crossDissolve
    
    let dimmingView = UIView(frame: self.view.bounds)
    dimmingView.backgroundColor = .black.withAlphaComponent(0.3)
    dimmingView.alpha = 0
    dimmingView.tag = dimmingID
    
    self.view.addSubview(dimmingView)
    UIView.animate(withDuration: 0.3) {
      dimmingView.alpha = 1
    }
    self.present(base, animated: false)
  }
  
  public func closeAlert() {
    guard let dimmingView = self.view.viewWithTag(dimmingID) else { return }
    UIView.animate(withDuration: 0.3) {
      dimmingView.alpha = 0
      self.dismiss(animated: false)
    } completion: { _ in
      dimmingView.removeFromSuperview()
    }
  }
}
/// DimmingView Tag를 100으로 설정했습니다.
private let dimmingID = 100
