//
//  SettingViewController.swift
//  
//
//  Created by Wood on 8/5/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import SettingSceneAPI
import SettingSceneEntity
import ToDoGardenUIComponent

protocol SettingDisplayLogic: AnyObject {
  func displaySomething(viewModel: Setting.Something.ViewModel)
}

final class SettingViewController: UIViewController, SettingViewControllable {
  private let settingLabel: UILabel
  private let profileRow: Styled.Row
  private let userGuideButton: UserGuideButton
  private let settingCollectionView: UICollectionView
  private let versionInfoView: VersionInfoView

  var interactor: SettingBusinessLogic?
  var router: (SettingRoutingLogic & SettingDataPassing)?
  
  // MARK: - Object lifecycle
  
  init() {
    self.settingLabel = UILabel()
    // TODO: 프로필 UI를 확인하기 위해 "울버린" 사용자명을 임시로 추가했으며, VIP 로직 구현 이후에 삭제할 예정입니다.
    self.profileRow = Styled.Row(
      configuration: Styled.Row.Configuration.profile(
        Styled.Row.Configuration.ProfileModel.primary(
          title: "울버린",
          description: SettingSceneTheme.StringLiteral.ProfileRow.description
        )
      )
    )
    self.userGuideButton = UserGuideButton()
    self.settingCollectionView = UICollectionView(
      frame: CGRect.zero,
      collectionViewLayout: UICollectionViewLayout()
    )
    self.versionInfoView = VersionInfoView()
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupUI()
    // TODO: VersionInfoView의 UI를 확인하기 위해 임시로 추가한 로직으로, VIP 로직 구현 이후에 삭제할 예정입니다.
    self.versionInfoView.updateToPriorVersion("v 0.1.2")
  }
}

// MARK: - Confirm display logic protocol

extension SettingViewController: SettingDisplayLogic {
  func displaySomething(viewModel: Setting.Something.ViewModel) {
    // self.nameTextField.text = viewModel.name
  }
}

// MARK: - Request to interactor

extension SettingViewController {
  func doSomething() {
    let request = Setting.Something.Request()
    self.interactor?.doSomething(request: request)
  }
}

// MARK: Private Functions

extension SettingViewController {
  private func setupUI() {
    self.setupSettingLabel()
    self.setupProfileRowUI()
    self.setupSubviewsLayout()
  }

  private func setupSettingLabel() {
    self.settingLabel.text = SettingSceneTheme.StringLiteral.SettingLabel.text
    self.settingLabel.font = UIFont.pretendardHeadBold
    self.settingLabel.textColor = SettingSceneTheme.mainColor
  }

  private func setupProfileRowUI() {
    self.profileRow.layer.cornerRadius = Constant.ProfileRow.Layer.cornerRadius
    self.profileRow.layer.borderWidth = Constant.ProfileRow.Layer.borderWidth
    self.profileRow.layer.borderColor = UIColor.toDoGardenGreenBackground.cgColor
  }
}

// MARK: Auto Layout

extension SettingViewController {
  private func setupSubviewsLayout() {
    self.setupSettingLabelLayout()
    self.setupProfileRowLayout()
    self.setupUserGuideButtonLayout()
    self.setupSettingButtonTableViewLayout()
    self.setupVersionInfoViewLayout()
  }

  private func setupSettingLabelLayout() {
    self.view.addSubview(self.settingLabel)
    self.settingLabel.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.settingLabel.topAnchor.constraint(
          equalTo: self.view.safeAreaLayoutGuide.topAnchor,
          constant: Constant.SettingLabel.topMargin
        ),
        self.settingLabel.leadingAnchor.constraint(
          equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,
          constant: Constant.SettingLabel.leadingMargin
        )
      ]
    )
  }

  private func setupProfileRowLayout() {
    self.view.addSubview(self.profileRow)
    self.profileRow.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.profileRow.topAnchor.constraint(
          equalTo: self.settingLabel.bottomAnchor,
          constant: Constant.ProfileRow.topMargin
        ),
        self.profileRow.leadingAnchor.constraint(equalTo: self.settingLabel.leadingAnchor),
        self.profileRow.trailingAnchor.constraint(
          equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
          constant: -Constant.ProfileRow.trailingMargin
        )
      ]
    )
  }

  private func setupUserGuideButtonLayout() {
    self.view.addSubview(self.userGuideButton)
    self.userGuideButton.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.userGuideButton.topAnchor.constraint(
          equalTo: self.profileRow.bottomAnchor,
          constant: Constant.UserGuideButton.topMargin
        ),
        self.userGuideButton.leadingAnchor.constraint(equalTo: self.profileRow.leadingAnchor),
        self.userGuideButton.trailingAnchor.constraint(equalTo: self.profileRow.trailingAnchor),
        self.userGuideButton.heightAnchor.constraint(equalToConstant: Constant.UserGuideButton.height)
      ]
    )
  }

  private func setupSettingButtonTableViewLayout() {
    self.view.addSubview(self.settingCollectionView)
    self.settingCollectionView.usingAutolayout()

    let layout = SettingViewController.Constant.SettingCollectionView.self
    NSLayoutConstraint.activate(
      [
        self.settingCollectionView.topAnchor.constraint(
          equalTo: self.userGuideButton.bottomAnchor,
          constant: layout.topMargin
        ),
        self.settingCollectionView.leadingAnchor.constraint(equalTo: self.userGuideButton.leadingAnchor),
        self.settingCollectionView.trailingAnchor.constraint(equalTo: self.userGuideButton.trailingAnchor),
        self.settingCollectionView.heightAnchor.constraint(equalToConstant: layout.height)
      ]
    )
  }

  private func setupVersionInfoViewLayout() {
    self.view.addSubview(self.versionInfoView)
    self.versionInfoView.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.versionInfoView.topAnchor.constraint(
          equalTo: self.settingCollectionView.bottomAnchor,
          constant: Constant.VersionInfoView.topMargin
        ),
        self.versionInfoView.leadingAnchor.constraint(
          equalTo: settingCollectionView.leadingAnchor,
          constant: -Constant.VersionInfoView.leadingMargin
        ),
        self.versionInfoView.trailingAnchor.constraint(equalTo: settingCollectionView.trailingAnchor),
        self.versionInfoView.heightAnchor.constraint(equalToConstant: Constant.VersionInfoView.height)
      ]
    )
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  return SettingViewController()
}
#endif
