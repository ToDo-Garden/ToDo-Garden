//
//  UserInfoSceneViewController.swift
//  
//
//  Created by Wood on 8/28/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import PhotosUI
import UIKit

import EditUserIntroductionSceneAPI
import EditUserNameSceneAPI
import ToDoGardenUIAPI
import ToDoGardenUIComponent
import ToDoGardenUIConstant
import ToDoGardenUIResource
import UserInfoSceneAPI
import UserInfoSceneEntity

protocol UserInfoSceneDisplayLogic: AnyObject {
  func displayCollectionViewSections(viewModel: UserInfoScene.ConfigureCollectionView.ViewModel)
  func displayFetchedProfile(viewModel: UserInfoScene.FetchProfile.ViewModel)
  func displayUserPhotoAccess(viewModel: UserInfoScene.FetchUserPhotoAccess.ViewModel)
  func displayChangedProfileImage(viewModel: UserInfoScene.ChangeProfileImage.ViewModel)
  func displayWithdrawResult(viewModel: UserInfoScene.WithdrawMembership.ViewModel)
  func displaySignOutResult(viewModel: UserInfoScene.SignOut.ViewModel)
  func displayChangedUserIntroduction(_ introduction: String)
  func displayEmptyUserIntroduction(_ placeholderText: String)
  func displayChangedUserName(_ userName: String)
}

final class UserInfoSceneViewController: UIViewController, UserInfoSceneViewControllable {
  private let profileInfoView: ProfileInfoView
  private let userInfoCollectionView: UICollectionView
  private var userInfoCollectionViewDataSource: DiffableDataSource?
  private let manageAccountView: ManageAccountView
  private let photoPicker: PHPickerViewController

  // MARK: - VIP Properties
  
  var interactor: (UserInfoSceneBusinessLogic & UserInfoLoadable)?
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
    self.interactor?.configureCollectionView()
  }
}

// MARK: - Confirm display logic protocol

extension UserInfoSceneViewController: UserInfoSceneDisplayLogic {
  typealias UserInfoSection = UserInfoScene.UserInfoSection
  typealias UserInfoItem = UserInfoScene.UserInfoItem

  func displayCollectionViewSections(viewModel: UserInfoScene.ConfigureCollectionView.ViewModel) {
    var snapshot = NSDiffableDataSourceSnapshot<UserInfoSection, UserInfoItem>()
    snapshot.appendSections(viewModel.userInfoSections)

    snapshot.sectionIdentifiers.forEach { (section: UserInfoSection) in
      snapshot.appendItems(section.items, toSection: section)
    }

    self.userInfoCollectionViewDataSource?.apply(snapshot)
  }

  func displayFetchedProfile(viewModel: UserInfoScene.FetchProfile.ViewModel) {
    guard let indexPath = self.userInfoCollectionViewDataSource?.indexPath(for: viewModel.item)
    else { return }

    let cell = self.userInfoCollectionView.cellForItem(at: indexPath) as? SettingCollectionViewCell
    let description = viewModel.description
    cell?.updateDescription(description)
  }

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
    case .failure:
      // TODO: - 에러 내용이 명시된 ToDoGardenAlert을 띄울 예정이며, 해당 알럿 컴포넌트 제작 후에 반영할 예정입니다.
      return
    }
  }

  func displayWithdrawResult(viewModel: UserInfoScene.WithdrawMembership.ViewModel) {
    if viewModel.withdrawError == nil {
      self.router?.routeToLoginScene()
    }
  }

  func displaySignOutResult(viewModel: UserInfoScene.SignOut.ViewModel) {
    if viewModel.signOutError == nil {
      self.router?.routeToLoginScene()
    }
  }

  func displayChangedUserIntroduction(_ introduction: String) {
    self.updateReloadedUserInfo(introduction, isUserName: false)
  }

  func displayEmptyUserIntroduction(_ placeholderText: String) {
    self.updateReloadedUserInfo(placeholderText, isUserName: false)
  }

  func displayChangedUserName(_ userName: String) {
    self.updateReloadedUserInfo(userName, isUserName: true)
  }

  private func updateReloadedUserInfo(_ value: String, isUserName: Bool) {
    let row = isUserName ? 0 : 1
    let indexPath = IndexPath(row: row, section: 0)
    guard let cell = self.userInfoCollectionView.cellForItem(
      at: indexPath
    ) as? UserInfoCollectionViewCell else { return }

    cell.updateDescription(value)
  }
}

// MARK: - Request to interactor

extension UserInfoSceneViewController: EditUserIntroductionDelegate, EditUserNameDelegate {
  func userIntroductionDidEdited(_ introduction: String?) {
    self.interactor?.reloadUserIntroduction(introduction)
  }

  func userNameDidEdited(_ userName: String) {
    self.interactor?.reloadUserName(userName)
  }

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
      self.interactor?.signOut()
    case ToDoGardenUIConstant.Constant.ToDoGardenAlertView.Content.ButtonActionType.unsubscribe:
      self.interactor?.withdrawMembership()
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
    self.userInfoCollectionViewDataSource = self.makeDiffableDataSource(with: self.userInfoCollectionView)
    self.userInfoCollectionView.dataSource = self.userInfoCollectionViewDataSource
    self.userInfoCollectionView.collectionViewLayout = self.makeCompositionalLayout()
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

struct SomePayload: UserInfoSceneScenePayloadable {}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let userInfoScene = UserInfoSceneSceneBuilder(
    dependency: UserInfoSceneSceneBuilder.Dependency(
      photoPicker: PHPickerViewController(configuration: PHPickerConfiguration()),
      appServiceWorker: AppServiceWorker(),
      userPhotoWorker: UserPhotoWorker(),
      userInfoWorker: UserInfoSceneWorker(),
      editUserIntroductionSceneBuilder: nil,
      editUserNameSceneBuilder: nil
    )
  ).build(with: SomePayload())
  return userInfoScene
}
#endif
