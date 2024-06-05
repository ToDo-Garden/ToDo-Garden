//
//  ToDoGardenAlertController.swift
//
//
//  Created by SONG on 5/5/24.
//

import UIKit

import ToDoGardenUIAPI
import ToDoGardenUIConstant

public final class ToDoGardenAlertController: UIViewController {

  private var _delegate: ToDoGardenAlertControllerDelegate?
  
  private var alertView: ToDoGardenAlertView
  
  public init(for alertType: ToDoGardenAlertView.Configuration) {
    self.alertView = ToDoGardenAlertView(configuration: alertType)
    super.init(nibName: nil, bundle: nil)
    self.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
    self.setButtonAction()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.toDoGardenBlack.withAlphaComponent(0.2)
    self.layout()
  }
  
  private func layout() {
    self.view.addSubview(self.alertView)
    self.alertView.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        self.alertView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        self.alertView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
      ]
    )
  }
  
  private func setButtonAction() {
    self.alertView.buttonActionHandler = { [weak self] actionType in
      self?.handleButtonAction(actionType)
    }
  }
  
  private func handleButtonAction(_ actionType: Constant.ToDoGardenAlertView.Content.ButtonActionType) {
    self._delegate?.handleButtonAction(actionType)
  }
}

extension ToDoGardenAlertController: ToDoGardenAlertViewControllable {
  public var delegate: ToDoGardenAlertControllerDelegate? {
    get {
      return self._delegate
    }
    set(newValue) {
      self._delegate = newValue
    }
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let view = ToDoGardenAlertController(for: .welldone)
  return view
}
#endif
