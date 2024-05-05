//
//  ToDoGardenAlertController.swift
//
//
//  Created by SONG on 5/5/24.
//

import UIKit.UIViewController

import ToDoGardenUIConstant

public final class ToDoGardenAlertController: UIViewController {
  private var alertView: ToDoGardenAlertView
  
  public init(for alertType: ToDoGardenAlertView.Configuration) {
    self.alertView = ToDoGardenAlertView(configuration: alertType)
    super.init(nibName: nil, bundle: nil)
    self.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.toDoGardenBlack.withAlphaComponent(0.2)
    // TODO: - Constant 논의 이후 변경예정
    self.layout()
  }
  
  private func layout() {
    
  }
}
