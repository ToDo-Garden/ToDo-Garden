//
//  SettingRouter.swift
//  
//
//  Created by Wood on 8/5/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import SettingSceneAPI
import ToDoGardenUIComponent
import ToDoGardenUIConstant
import UserInfoSceneAPI

protocol SettingRoutingLogic {
  func routeToNotice()
  func routeToTermsOfService()
  func routeToPrivacyPolicy()
  func routeToSendingFeedback()
  func routeToGuideScene()
}

protocol SettingDataPassing {
	var dataStore: SettingDataStore? { get }
}

class SettingRouter: SettingDataPassing {
	weak var viewController: SettingViewController?
	var dataStore: SettingDataStore?
  let termsTextView: TermsTextViewController = TermsTextViewController(title: "", text: "")
  let enterGuideSceneViewController: EnterGuideSceneViewController = EnterGuideSceneViewController()

  private let userInfoSceneBuilder: UserInfoSceneSceneBuildable

  public init(userInfoSceneBuilder: UserInfoSceneSceneBuildable) {
    self.userInfoSceneBuilder = userInfoSceneBuilder
  }
}

// MARK: - Routing

extension SettingRouter: SettingRoutingLogic {
  func routeToNotice() {
    self.termsTextView.update(
      title: Constant.TermsTextView.noticeTitle,
      text: Constant.TermsTextView.noticeContent
    )
    
    self.viewController?.navigationController?.pushViewController(self.termsTextView, animated: true)
  }
  
  func routeToTermsOfService() {
    self.termsTextView.update(
      title: Constant.TermsTextView.termsOfServiceTitle,
      text: Constant.TermsTextView.termsOfServiceContent
    )
    
    self.viewController?.navigationController?.pushViewController(self.termsTextView, animated: true)
  }
  
  func routeToPrivacyPolicy() {
    self.termsTextView.update(
      title: Constant.TermsTextView.privacyPolicyTitle,
      text: Constant.TermsTextView.privacyPolicyContent
    )
    
    self.viewController?.navigationController?.pushViewController(self.termsTextView, animated: true)
  }
  
  func routeToSendingFeedback() {
    self.viewController?.showToast(message: "준비중인 기능입니다. 앱스토어 리뷰를 이용해주세요.")
  }
  
  func routeToGuideScene() {
    let guideSceneViewController = self.enterGuideSceneViewController
    guideSceneViewController.modalPresentationStyle = .fullScreen
    self.viewController?.navigationController?.pushViewController(guideSceneViewController, animated: true)
  }
}

// MARK: - Declare Payload for scene

extension SettingRouter {
}
