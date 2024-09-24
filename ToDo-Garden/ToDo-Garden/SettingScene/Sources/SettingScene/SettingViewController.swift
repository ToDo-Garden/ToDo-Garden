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
  func displayFetchedUserNickname(viewModel: Setting.FetchUserNickName.ViewModel)
  func displayFetchedUserProfileImage(viewModel: Setting.FetchUserProfileImage.ViewModel)
  func displayFetchedAppVersion(viewModel: Setting.FetchAppVersion.ViewModel)
}

final class SettingViewController: UIViewController, SettingViewControllable {
  private let settingLabel: UILabel
  private let profileRow: Styled.Row
  private let userGuideButton: UserGuideButton
  private let settingCollectionView: UICollectionView
  private var settingCollectionViewDataSource: UICollectionViewDiffableDataSource<Section, Item>?
  private let versionInfoView: VersionInfoView

  var interactor: SettingBusinessLogic?
  var router: (SettingRoutingLogic & SettingDataPassing)?

  // MARK: - Object lifecycle

  init() {
    self.settingLabel = UILabel()
    let rowConfiguration = Styled.Row.Configuration.self
    self.profileRow = Styled.Row(
      configuration: rowConfiguration.profile(
        rowConfiguration.ProfileModel(
          style: rowConfiguration.ProfileModel.Style.setting,
          title: " ",
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
  }

  override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    self.prepareSettingSceneData()
  }
}

// MARK: - Request to Interactor

extension SettingViewController {
  private func prepareSettingSceneData() {
    self.interactor?.fetchUserNickname()
    self.interactor?.fetchUserProfileImage()
    self.interactor?.fetchAppVersion()
  }
}

// MARK: - Confirm display logic protocol

extension SettingViewController: SettingDisplayLogic {
  func displayFetchedUserNickname(viewModel: Setting.FetchUserNickName.ViewModel) {
    let rowConfiguration = Styled.Row.Configuration.self
    self.profileRow.configuration = rowConfiguration.profile(
      rowConfiguration.ProfileModel(
        style: rowConfiguration.ProfileModel.Style.setting,
        title: viewModel.nickName,
        description: SettingSceneTheme.StringLiteral.ProfileRow.description
      )
    )
  }

  func displayFetchedUserProfileImage(viewModel: Setting.FetchUserProfileImage.ViewModel) {
    let imageData = viewModel.imageData
    self.profileRow.iconImage = UIImage(data: imageData)
  }

  func displayFetchedAppVersion(viewModel: Setting.FetchAppVersion.ViewModel) {
    switch viewModel.appVersionStatus {
    case Setting.AppVersionStatus.outdated:
      self.versionInfoView.updateToPriorVersion(viewModel.versionNumber)
    case Setting.AppVersionStatus.latest:
      self.versionInfoView.updateToLatestVersion(viewModel.versionNumber)
    }
  }
}

// MARK: Subviews Delegate Functions

extension SettingViewController: VersionInfoViewDelegate {
  func didSelectUpdateButton() {
    self.interactor?.openAppStore()
  }
}

// MARK: Private Functions

extension SettingViewController {
  private func setupUI() {
    self.view.backgroundColor = UIColor.toDoGardenWhite
    self.setupSettingLabel()
    self.setupProfileRowUI()
    self.setupSubviewDeleagte()
    self.setupSettingCollectionView()
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

  private func setupSubviewDeleagte() {
    self.versionInfoView.delegate = self
  }

  private func setupSettingCollectionView() {
    self.setupSettingCollectionViewRegistration()
    self.settingCollectionView.isScrollEnabled = false
    self.settingCollectionViewDataSource = self.makeDiffableDataSource(with: self.settingCollectionView)
    self.settingCollectionView.dataSource = self.settingCollectionViewDataSource
    self.settingCollectionView.collectionViewLayout = self.makeCompositionalLayout()
    self.loadSettingCollectionViewData()
  }

  private func setupSettingCollectionViewRegistration() {
    self.settingCollectionView.register(
      SettingCollectionViewCell.self,
      forCellWithReuseIdentifier: SettingCollectionViewCell.identifier
    )
    self.settingCollectionView.register(
      SectionHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: SectionHeaderView.identifier
    )
  }

  private func loadSettingCollectionViewData() {
    guard var snapshot = self.settingCollectionViewDataSource?.snapshot()
    else { return }

    snapshot.appendSections(self.makeSections())

    snapshot.sectionIdentifiers.forEach { (section: Section) in
      snapshot.appendItems(section.items, toSection: section)
    }

    self.settingCollectionViewDataSource?.apply(snapshot)
  }

  private func makeSections() -> [Section] {
    let sectionTitle = SettingSceneTheme.StringLiteral.SettingCollectionView.Section.self
    let itemTitle = SettingSceneTheme.StringLiteral.SettingCollectionView.Item.self

    let userSettingSection = Section(
      image: UIImage.alarmImage.withTintColor(SettingSceneTheme.mainColor),
      title: sectionTitle.userSetting,
      items: [
        Item(title: itemTitle.alarmSetting, isShowingModal: false, position: SettingCollectionViewCell.Position.top),
        Item(title: itemTitle.remindSetting, isShowingModal: false, position: SettingCollectionViewCell.Position.bottom)
      ]
    )

    let appSupportSection = Section(
      image: UIImage.leafImage,
      title: sectionTitle.appSupport,
      items: [
        Item(title: itemTitle.announcement, isShowingModal: false, position: SettingCollectionViewCell.Position.top),
        Item(title: itemTitle.privacyPolicy, isShowingModal: true, position: SettingCollectionViewCell.Position.middle),
        Item(title: itemTitle.termsOfUse, isShowingModal: true, position: SettingCollectionViewCell.Position.middle),
        Item(title: itemTitle.sendFeedback, isShowingModal: true, position: SettingCollectionViewCell.Position.bottom)
      ]
    )

    return [userSettingSection, appSupportSection]
  }
}

// MARK: Auto Layout

extension SettingViewController {
  private func setupSubviewsLayout() {
    self.setupSettingLabelLayout()
    self.setupProfileRowLayout()
    self.setupUserGuideButtonLayout()
    self.setupSettingCollectionViewLayout()
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

  private func setupSettingCollectionViewLayout() {
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

extension SettingViewController {
  struct SomePayload: SettingScenePayloadable {}
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  return SettingSceneBuilder(
    dependency: SettingSceneBuilder.Dependency(
      settingWorker: SettingWorker(),
      appServiceWorker: ApplicationServiceWorker()
    )
  ).build(with: SettingViewController.SomePayload())
}
#endif
