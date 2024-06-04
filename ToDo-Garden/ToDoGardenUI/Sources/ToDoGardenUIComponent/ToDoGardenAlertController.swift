//
//  ToDoGardenAlertController.swift
//
//
//  Created by SONG on 5/5/24.
//

import UIKit

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
    self.view.addSubview(self.alertView)
    self.alertView.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        self.alertView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        self.alertView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
      ]
    )
  }
}

extension ToDoGardenAlertController: ToDoGardenAlertViewDelegate {
  public func didTapCancel() {
    print("취소 버튼 실행할 코드")
  }
  
  public func didTapDelete() {
    print("삭제 버튼 실행할 코드")
  }
  
  public func didTapLogout() {
    print("로그아웃 버튼 실행할 코드")
  }
  
  public func didTapGoHome() {
    print("홈으로 버튼 실행할 코드")
  }
  
  public func didTapUnsubscribe() {
    print("탈퇴하기 버튼 실행할 코드")
  }
  
  public func didTapKeepConcentration() {
    print("집중하기 버튼 실행할 코드")
  }
  
  public func didTapStopConcentration() {
    print("그만하기 버튼 실행할 코드")
  }
}

// #if DEBUG
// @available(iOS 17.0, *)
// #Preview {
//   let view = ToDoGardenAlertController(for: .askToDeleteGroup)
//   return view
// }
// #endif
