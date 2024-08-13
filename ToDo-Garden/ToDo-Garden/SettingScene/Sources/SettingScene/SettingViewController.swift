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

  var interactor: SettingBusinessLogic?
  var router: (SettingRoutingLogic & SettingDataPassing)?
  
  // MARK: - Object lifecycle
  
  init() {
    self.profileRow = Styled.Row(
      configuration: Styled.Row.Configuration.profile(
        Styled.Row.Configuration.ProfileModel.primary(
          title: "",
          description: SettingSceneTheme.StringLiteral.ProfileRow.description
        )
      )
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
    self.doSomething()
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
