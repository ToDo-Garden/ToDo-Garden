//
//  EnterGuideSceneViewController.swift
//  SettingScene
//
//  Created by SONG on 3/25/25.
//

import UIKit

import GuideScene
import ToDoGardenUIComponent

// swiftlint: disable all
final class EnterGuideSceneViewController: UIViewController {
  private let homeGuideButton: EnterGuideSceneButton
  private let groupManagementButton: EnterGuideSceneButton
  private let editToDoButton: EnterGuideSceneButton
  private let shareGardenButton: EnterGuideSceneButton
  
  init() {
    self.homeGuideButton = EnterGuideSceneButton(title: Constant.StringLiteral.homeTitle)
    self.groupManagementButton = EnterGuideSceneButton(title: Constant.StringLiteral.groupManagementTitle)
    self.editToDoButton = EnterGuideSceneButton(title: Constant.StringLiteral.editToDoTitle)
    self.shareGardenButton = EnterGuideSceneButton(title: Constant.StringLiteral.shareGarden)
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.white
    self.setupUI()
    self.setupButtonAction()
  }
  
  override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    self.navigationController?.navigationBar.isHidden = false
  }
  
  private func setupUI() {
    self.title = Constant.StringLiteral.mainTitle
    let stackView = UIStackView(
      arrangedSubviews: [
        self.homeGuideButton,
        self.groupManagementButton,
        self.editToDoButton,
        self.shareGardenButton
      ]
    )
    stackView.isUserInteractionEnabled = true
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.spacing = Constant.Layout.commonSpacing
    stackView.usingAutolayout()
    
    self.view.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(
        equalTo: self.view.leadingAnchor,
        constant: Constant.Layout.commonSpacing
      ),
      stackView.trailingAnchor.constraint(
        equalTo: self.view.trailingAnchor,
        constant: -Constant.Layout.commonSpacing
      ),
      stackView.topAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.topAnchor,
        constant: Constant.Layout.top
      ),
      stackView.heightAnchor.constraint(equalToConstant: Constant.Layout.height)
    ])
  }
}

extension EnterGuideSceneViewController {
  private func setupButtonAction() {
    self.homeGuideButton.addAction(UIAction { [weak self] _ in
      guard let self = self else { return }
      
      self.navigationController?.present(
        self.withFullScreenModal(GuideDetailViewController.todoCreate()),
        animated: true
      )
    }, for: UIControl.Event.touchUpInside)
    
    self.groupManagementButton.addAction(UIAction { [weak self] _ in
      guard let self = self else { return }
      
      self.navigationController?.present(
        self.withFullScreenModal(GuideDetailViewController.groupManagement()),
        animated: true
      )
    }, for: UIControl.Event.touchUpInside)
    
    self.editToDoButton.addAction(UIAction { [weak self] _ in
      guard let self = self else { return }
      
      self.navigationController?.present(
        self.withFullScreenModal(GuideDetailViewController.todoEdit()),
        animated: true
      )
    }, for: UIControl.Event.touchUpInside)
    
    self.shareGardenButton.addAction(UIAction { [weak self] _ in
      guard let self = self else { return }
      
      self.navigationController?.present(
        self.withFullScreenModal(GuideDetailViewController.shareTab()),
        animated: true
      )
    }, for: UIControl.Event.touchUpInside)
  }
  
  private func withFullScreenModal(_ vc: UIViewController) -> UIViewController {
    vc.modalPresentationStyle = .fullScreen
    vc.modalTransitionStyle = .crossDissolve
    return vc
  }
}
// swiftlint: enable all

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let view = EnterGuideSceneViewController()
  return view
}
#endif
