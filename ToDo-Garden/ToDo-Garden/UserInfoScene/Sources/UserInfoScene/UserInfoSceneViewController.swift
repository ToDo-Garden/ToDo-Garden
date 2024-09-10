//
//  UserInfoSceneViewController.swift
//  
//
//  Created by Wood on 8/28/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import PhotosUI
import UIKit

import ToDoGardenUIAPI
import ToDoGardenUIComponent
import ToDoGardenUIConstant
import ToDoGardenUIResource
import UserInfoSceneAPI
import UserInfoSceneEntity

protocol UserInfoSceneDisplayLogic: AnyObject {
  func displayUserPhotoAccess(viewModel: UserInfoScene.FetchUserPhotoAccess.ViewModel)
  func displayChangedProfileImage(viewModel: UserInfoScene.ChangeProfileImage.ViewModel)
}

final class UserInfoSceneViewController: UIViewController, UserInfoSceneViewControllable {
  private let profileInfoView: ProfileInfoView
  private let userInfoCollectionView: UICollectionView
  private var userInfoCollectionViewDataSource: DiffableDataSource?
  private let manageAccountView: ManageAccountView
  private let photoPicker: PHPickerViewController

  // MARK: - VIP Properties
  
  var interactor: UserInfoSceneBusinessLogic?
  var router: (UserInfoSceneRoutingLogic & UserInfoSceneDataPassing)?
  
  // MARK: - Object lifecycle
  
  init(photoPicker: PHPickerViewController) {
    self.profileInfoView = ProfileInfoView()
    self.userInfoCollectionView = UICollectionView(
      frame: CGRect.zero,
      collectionViewLayout: UICollectionViewLayout()
    )
    self.manageAccountView = ManageAccountView()
    self.photoPicker = photoPicker
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
  }
}

// MARK: - Confirm display logic protocol

extension UserInfoSceneViewController: UserInfoSceneDisplayLogic {
  func displayUserPhotoAccess(viewModel: UserInfoScene.FetchUserPhotoAccess.ViewModel) {
    if viewModel.isPhotoAccessible {
      self.present(self.photoPicker, animated: true)
      self.interactor?.changeUserProfileImage()
    } else {
      self.showMovingToSettingAppAlert()
    }
  }

  func displayChangedProfileImage(viewModel: UserInfoScene.ChangeProfileImage.ViewModel) {
    switch viewModel.changeResult {
    case .success(let changedProfileImage):
      self.profileInfoView.updateImage(changedProfileImage)
    case .failure(let error):
      // TODO: - 에러 내용이 명시된 ToDoGardenAlert을 띄울 예정이며, 해당 알럿 컴포넌트 제작 후에 반영할 예정입니다.
      return
    }
  }
}

// MARK: - Request to interactor

extension UserInfoSceneViewController {
  func didSelectEditProfileButton() {
    self.interactor?.fetchUserPhotoAccess()
  }
}

// MARK: Alert Actions

extension UserInfoSceneViewController: ToDoGardenAlertControllerDelegate {
  func handleButtonAction(
    _ buttonType: ToDoGardenUIConstant.Constant.ToDoGardenAlertView.Content.ButtonActionType
  ) {
    self.closeAlert()
    switch buttonType {
    case ToDoGardenUIConstant.Constant.ToDoGardenAlertView.Content.ButtonActionType.logout:
      // TODO: 로그아웃 Interactor 메서드 호출 예정
      return
    case ToDoGardenUIConstant.Constant.ToDoGardenAlertView.Content.ButtonActionType.unsubscribe:
      // TODO: 회원 탈퇴 Interactor 메서드 호출 예정
      return
    default:
      break
    }
  }

  private func showAlertController(for type: ToDoGardenAlertView.Configuration) {
    let alert = ToDoGardenAlertController(for: type)
    alert.delegate = self
    self.showAlert(alert)
  }
}

// MARK: Subviews Delegate Functions

extension UserInfoSceneViewController: ManageAccountViewDelegate, ProfileInfoViewDelegate {
  func didSelectLogOutButton() {
    self.showAlertController(for: ToDoGardenAlertView.Configuration.askToLogout)
  }
  
  func didSelectWithdrawMembershipButton() {
    self.showAlertController(for: ToDoGardenAlertView.Configuration.askToUnsubscribe)
  }
}

// MARK: User Image Handling Functions

extension UserInfoSceneViewController {
  @MainActor
  private func showMovingToSettingAppAlert() {
    let stringLiteral = UserInfoSceneTheme.StringLiteral.SettingAppAlert.self
    let alert = UIAlertController(
      title: nil,
      message: stringLiteral.message,
      preferredStyle: UIAlertController.Style.alert
    )

    alert.addAction(self.makeCancelAction())
    alert.addAction(self.makeMovingToSettingAppAction())

    self.present(alert, animated: true)
  }

  private func makeCancelAction() -> UIAlertAction {
    return UIAlertAction(
      title: UserInfoSceneTheme.StringLiteral.SettingAppAlert.leftActionTitle,
      style: UIAlertAction.Style.cancel
    ) { _ in
      self.closeAlert()
    }
  }

  private func makeMovingToSettingAppAction() -> UIAlertAction {
    return UIAlertAction(
      title: UserInfoSceneTheme.StringLiteral.SettingAppAlert.rightActionTitle,
      style: UIAlertAction.Style.default
    ) { _ in
      self.interactor?.openSettingApp()
    }
  }
}

// MARK: - Private Functions

extension UserInfoSceneViewController {
  private func setup() {
    self.setupMainUI()
    self.setupSubviewsDelegate()
    self.setupUserInfoCollectionView()
    self.loadUserInfoCollectionViewData()
    self.setupSubviewsLayout()
  }

  private func setupMainUI() {
    self.title = UserInfoSceneTheme.StringLiteral.title
    self.view.backgroundColor = UIColor.toDoGardenWhite
  }

  private func setupSubviewsDelegate() {
    self.profileInfoView.delegate = self
    self.manageAccountView.delegate = self
  }

  private func setupUserInfoCollectionView() {
    self.userInfoCollectionView.isScrollEnabled = false
    self.userInfoCollectionView.register(
      SettingCollectionViewCell.self,
      forCellWithReuseIdentifier: SettingCollectionViewCell.identifier
    )
    self.userInfoCollectionView.register(
      SectionHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: SectionHeaderView.identifier
    )
    self.userInfoCollectionViewDataSource = self.makeDiffableDataSource(with: self.userInfoCollectionView)
    self.userInfoCollectionView.dataSource = self.userInfoCollectionViewDataSource
    self.userInfoCollectionView.collectionViewLayout = self.makeCompositionalLayout()
  }

  private func loadUserInfoCollectionViewData() {
    var snapshot = NSDiffableDataSourceSnapshot<UserInfoSection, UserInfoItem>()
    snapshot.appendSections(self.makeSections())

    snapshot.sectionIdentifiers.forEach { (section: UserInfoSection) in
      snapshot.appendItems(section.items, toSection: section)
    }

    self.userInfoCollectionViewDataSource?.apply(snapshot)
  }

  private func makeSections() -> [UserInfoSection] {
    let sectionTitle = UserInfoSceneTheme.StringLiteral.UserInfoCollectionView.Section.self
    let itemTitle = UserInfoSceneTheme.StringLiteral.UserInfoCollectionView.Item.self
    let position = SettingCollectionViewCell.Position.self

    let profileSettingSection = UserInfoSection(
      title: sectionTitle.profileSetting,
      items: [
        UserInfoItem(title: itemTitle.nickName, isRightImageExisted: true, position: position.top),
        UserInfoItem(title: itemTitle.introduction, isRightImageExisted: true, position: position.bottom)
      ]
    )

    let accountSettingSection = UserInfoSection(
      title: sectionTitle.accountSetting,
      items: [
        UserInfoItem(title: itemTitle.id, isRightImageExisted: true, position: position.top),
        UserInfoItem(title: itemTitle.email, isRightImageExisted: false, position: position.bottom)
      ]
    )

    return [profileSettingSection, accountSettingSection]
  }
}

// MARK: - Set Subviews Layout

extension UserInfoSceneViewController {
  private func setupSubviewsLayout() {
    self.setupProfileInfoViewLayout()
    self.setupUserInfoCollectionViewLayout()
    self.setupManageAccountViewLayout()
  }

  private func setupProfileInfoViewLayout() {
    self.view.addSubview(self.profileInfoView)
    self.profileInfoView.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.profileInfoView.topAnchor.constraint(
          equalTo: self.view.safeAreaLayoutGuide.topAnchor,
          constant: Constant.ProfileInfoView.topMargin
        ),
        self.profileInfoView.widthAnchor.constraint(
          equalToConstant: Constant.ProfileInfoView.size.width
        ),
        self.profileInfoView.heightAnchor.constraint(
          equalToConstant: Constant.ProfileInfoView.size.height
        ),
        self.profileInfoView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
      ]
    )
  }

  private func setupUserInfoCollectionViewLayout() {
    self.view.addSubview(self.userInfoCollectionView)
    self.userInfoCollectionView.usingAutolayout()

    let constant = Constant.UserInfoCollectionView.self
    NSLayoutConstraint.activate(
      [
        self.userInfoCollectionView.topAnchor.constraint(
          equalTo: self.profileInfoView.bottomAnchor,
          constant: constant.topMargin
        ),
        self.userInfoCollectionView.leadingAnchor.constraint(
          equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,
          constant: constant.leadingMargin
        ),
        self.userInfoCollectionView.trailingAnchor.constraint(
          equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
          constant: -constant.trailingMargin
        ),
        self.userInfoCollectionView.heightAnchor.constraint(
          equalToConstant: constant.height
        )
      ]
    )
  }

  private func setupManageAccountViewLayout() {
    self.view.addSubview(self.manageAccountView)
    self.manageAccountView.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.manageAccountView.topAnchor.constraint(
          equalTo: self.userInfoCollectionView.bottomAnchor,
          constant: Constant.ManageAccountView.topMargin
        ),
        self.manageAccountView.leadingAnchor.constraint(
          equalTo: self.userInfoCollectionView.leadingAnchor
        ),
        self.manageAccountView.trailingAnchor.constraint(
          equalTo: self.userInfoCollectionView.trailingAnchor
        ),
        self.manageAccountView.heightAnchor.constraint(
          equalToConstant: Constant.ManageAccountView.height
        )
      ]
    )
  }
}

//  #if DEBUG
//  @available(iOS 17.0, *)
//  #Preview {
//    return UINavigationController(
//      rootViewController: UserInfoSceneViewController(
//        photoPickerViewController: PHPickerViewController(configuration: PHPickerConfiguration()),
//        application: UIApplication.shared,
//        openSettingsURLString: UIApplication.openSettingsURLString
//      )
//    )
//  }
//  #endif
