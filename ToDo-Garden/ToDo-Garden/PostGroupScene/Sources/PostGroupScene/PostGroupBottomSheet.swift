import Combine
import UIKit

import TDFoundationExtension
import ToDoGardenUIAPI
import ToDoGardenUIResource

final class PostGroupBottomSheet: UIViewController {
  var delegate: PostGroupBottomSheetDelegate?
  private let dimmedView: UIView
  private let bottomSheetView: UIView
  private let grabberView: UIView
  private let colorPickerList: ColorPickerListAPI
  private let bottomButton: UIButton
  
  private var bottomSheetHeight: CGFloat {
    return view.bounds.height * Constant.BottomSheet.multiplier
  }
  
  private var subscriptions = Set<AnyCancellable>()
  
  init(colorPickerList: ColorPickerListAPI, bottomButton: UIButton) {
    self.dimmedView = UIView()
    self.bottomSheetView = UIView()
    self.grabberView = UIView()
    self.colorPickerList = colorPickerList
    self.bottomButton = bottomButton
    super.init(nibName: nil, bundle: nil)
    self.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
    self.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupView()
    self.setupGesture()
    self.setupBindings()
    self.setupButtonAction()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
    UIView.animate(
      withDuration: Constant.BottomSheet.Animation.duration,
      animations: { [weak self] in
        self?.dimmedView.alpha = CGFloat.zero
        self?.bottomSheetView.transform = CGAffineTransform(
          translationX: CGFloat.zero,
          y: self?.bottomSheetHeight ?? CGFloat.zero
        )
      },
      completion: { _ in
        super.dismiss(animated: false, completion: completion)
      }
    )
  }
  
  func setupCurrentColor(color: UIColor?) {
    guard let color = color else {
      return
    }
    
    let index = self.colorPickerList.colors.firstIndex(of: color)
    self.colorPickerList.selected.send(index)
  }
}

extension PostGroupBottomSheet {
  private func setupView() {
  }
  
  private func setupGesture() {
  }

  private func setupBindings() {
  }
  
  private func setupButtonAction() {
  }
}

protocol PostGroupBottomSheetDelegate: AnyObject {
  func dismissedBottomSheet(color: UIColor)
}
