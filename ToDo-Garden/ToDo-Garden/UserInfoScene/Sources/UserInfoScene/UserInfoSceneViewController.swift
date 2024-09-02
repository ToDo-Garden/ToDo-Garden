//
//  UserInfoSceneViewController.swift
//  
//
//  Created by Wood on 8/28/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import TDUtility
import ToDoGardenUIComponent
import ToDoGardenUIResource
import UserInfoSceneAPI
import UserInfoSceneEntity

protocol UserInfoSceneDisplayLogic: AnyObject {
  func displaySomething(viewModel: UserInfoScene.Something.ViewModel)
}

final class UserInfoSceneViewController: UIViewController, UserInfoSceneViewControllable {
  private let profileImageView: ProfileImageView
  private let editProfileImageButton: UIButton
  private let profileInfoCollectionView: UICollectionView

  // MARK: - VIP Properties
  
  var interactor: UserInfoSceneBusinessLogic?
  var router: (UserInfoSceneRoutingLogic & UserInfoSceneDataPassing)?
  
  // MARK: - Object lifecycle
  
  init() {
    self.profileImageView = ProfileImageView(size: Constant.ProfileImageView.size)
    self.editProfileImageButton = UIButton()
    self.profileInfoCollectionView = UICollectionView(
      frame: CGRect.zero,
      collectionViewLayout: UICollectionViewLayout()
    )
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
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
    self.setupEditProfileImageButton()
    self.setupProfileInfoCollectionView()
    self.setupSubviewsLayout()
  }

  private func setupMainUI() {
    self.title = UserInfoSceneTheme.StringLiteral.title
    self.view.backgroundColor = UIColor.toDoGardenWhite
  }

  private func setupEditProfileImageButton() {
    let buttonTitle = UserInfoSceneTheme.StringLiteral.EditProfileImageButton.title
    let attributedTitle = buttonTitle.applyTextAttributes(
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardBodyMedium,
        NSAttributedString.Key.foregroundColor: UserInfoSceneTheme.mainColor,
        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
        NSAttributedString.Key.underlineColor: UserInfoSceneTheme.mainColor
      ]
    )

    self.editProfileImageButton.setAttributedTitle(attributedTitle, for: UIControl.State.normal)
  }
}

// MARK: - Set Subviews Layout

extension UserInfoSceneViewController {
  private func setupSubviewsLayout() {
    self.setupProfileImageViewLayout()
    self.setupEditProfileImageButtonLayout()
    self.setupProfileInfoCollectionViewLayout()
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

  private func setupEditProfileImageButtonLayout() {
    self.view.addSubview(self.editProfileImageButton)
    self.editProfileImageButton.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.editProfileImageButton.topAnchor.constraint(
          equalTo: self.profileImageView.bottomAnchor,
          constant: Constant.EditProfileImageButton.topMargin
        ),
        self.editProfileImageButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
      ]
    )
  }

  private func setupProfileInfoCollectionViewLayout() {
    self.view.addSubview(self.profileInfoCollectionView)
    self.profileInfoCollectionView.usingAutolayout()

    let constant = Constant.ProfileInfoCollectionView.self
    NSLayoutConstraint.activate(
      [
        self.profileInfoCollectionView.topAnchor.constraint(
          equalTo: self.editProfileImageButton.bottomAnchor,
          constant: constant.topMargin
        ),
        self.profileInfoCollectionView.leadingAnchor.constraint(
          equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,
          constant: constant.leadingMargin
        ),
        self.profileInfoCollectionView.trailingAnchor.constraint(
          equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
          constant: constant.trailingMargin
        ),
        self.profileInfoCollectionView.heightAnchor.constraint(
          equalToConstant: self.profileInfoCollectionView.contentSize.height
        )
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
