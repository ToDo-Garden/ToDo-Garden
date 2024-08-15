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
  private(set) var profileRow: Styled.Row
  private(set) var versionInfoView: VersionInfoView

  var interactor: SettingBusinessLogic?
  var router: (SettingRoutingLogic & SettingDataPassing)?
  
  // MARK: - Object lifecycle
  
  init() {
    // TODO: 프로필 UI를 확인하기 위해 "울버린" 사용자명을 임시로 추가했으며, VIP 로직 구현 이후에 삭제할 예정입니다.
    self.profileRow = Styled.Row(
      configuration: Styled.Row.Configuration.profile(
        Styled.Row.Configuration.ProfileModel.primary(
          title: "울버린",
          description: SettingSceneTheme.StringLiteral.ProfileRow.description
        )
      )
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
    self.doSomething()
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

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  return SettingViewController()
}
#endif
