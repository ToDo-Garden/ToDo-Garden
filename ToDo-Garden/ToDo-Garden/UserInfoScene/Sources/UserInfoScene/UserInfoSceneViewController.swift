//
//  UserInfoSceneViewController.swift
//  
//
//  Created by Wood on 8/28/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import ToDoGardenUIComponent
import ToDoGardenUIResource
import UserInfoSceneAPI
import UserInfoSceneEntity

protocol UserInfoSceneDisplayLogic: AnyObject {
  func displaySomething(viewModel: UserInfoScene.Something.ViewModel)
}

final class UserInfoSceneViewController: UIViewController, UserInfoSceneViewControllable {
  private let profileImageView: ProfileImageView

  // MARK: - VIP Properties
  
  var interactor: UserInfoSceneBusinessLogic?
  var router: (UserInfoSceneRoutingLogic & UserInfoSceneDataPassing)?
  
  // MARK: - Object lifecycle
  
  init() {
    self.profileImageView = ProfileImageView(size: Constant.ProfileImageView.size)
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupMainUI()
    self.doSomething()
  }
}

// MARK: - Confirm display logic protocol

extension UserInfoSceneViewController: UserInfoSceneDisplayLogic {
  func displaySomething(viewModel: UserInfoScene.Something.ViewModel) {
    // self.nameTextField.text = viewModel.name
  }
}

// MARK: - Request to interactor

extension UserInfoSceneViewController {
  func doSomething() {
    let request = UserInfoScene.Something.Request()
    self.interactor?.doSomething(request: request)
  }
}

// MARK: - Private Functions

extension UserInfoSceneViewController {
  private func setup() {
    self.setupMainUI()
    self.setupSubviewsLayout()
  }

  private func setupMainUI() {
    self.title = UserInfoSceneTheme.StringLiteral.title
    self.view.backgroundColor = UIColor.toDoGardenWhite
  }
}

// MARK: - Set Subviews Layout

extension UserInfoSceneViewController {
  private func setupSubviewsLayout() {
    self.setupProfileImageViewLayout()
  }

  private func setupProfileImageViewLayout() {
    self.view.addSubview(self.profileImageView)
    self.profileImageView.usingAutolayout()

    let constant = Constant.ProfileImageView.self
    NSLayoutConstraint.activate(
      [
        self.profileImageView.topAnchor.constraint(
          equalTo: self.view.safeAreaLayoutGuide.topAnchor,
          constant: constant.topMargin
        ),
        self.profileImageView.widthAnchor.constraint(equalToConstant: constant.size.width),
        self.profileImageView.heightAnchor.constraint(equalToConstant: constant.size.height),
        self.profileImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
      ]
    )
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  return UINavigationController(rootViewController: UserInfoSceneViewController())
}
#endif
