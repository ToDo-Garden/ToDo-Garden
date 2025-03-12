//
//  LoginViewController.swift
//
//
//  Created by SONG on 10/2/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import AuthenticationServices
import UIKit

import HTTPClientAPI
import TDFoundation
import ToDoGardenUIComponent

public final class LoginViewController: UIViewController {
  typealias Constant = LoginViewControllerConstant
  private var appleLoginManager: AppleLoginManager?
  private let appleLoginButton: AppleLoginButton
  private let dimmingView: UIView
  private let termAgreementView: TermsAgreementView
  
  public var afterLoginAction: ((Bool) -> Void)?
  public var doneButtonAction: ((Bool) -> Void)?
  // MARK: - Object lifecycle
  
  public init(with httpClient: HTTPClientAPI) {
    self.appleLoginButton = AppleLoginButton()
    self.dimmingView = UIView()
    self.termAgreementView = TermsAgreementView()
    super.init(nibName: nil, bundle: nil)
    self.setAppleLoginManager(with: httpClient)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View lifecycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.setUI()
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = true
  }
}

extension LoginViewController {
  private func setUI() {
    self.setBackgroundImage()
    self.setAppleLoginButton()
    self.setupDimmingView()
    self.setupTermAgreementView()
  }
  
  private func setBackgroundImage() {
    let backgroundImageView = UIImageView(image: UIImage.loginBackground)
    backgroundImageView.contentMode = UIView.ContentMode.scaleAspectFill
    backgroundImageView.frame = self.view.bounds
    self.view.addSubview(backgroundImageView)
    self.view.sendSubviewToBack(backgroundImageView)
  }
  
  private func setAppleLoginButton() {
    self.view.addSubview(self.appleLoginButton)
    self.appleLoginButton.usingAutolayout()
    NSLayoutConstraint.activate([
      self.appleLoginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      self.appleLoginButton.centerYAnchor.constraint(
        equalTo: self.view.bottomAnchor,
        constant: self.view.bounds.height * Constant.AppleLoginButton.centerYMultiplier
      )
    ])
    
    self.appleLoginButton.addAction(UIAction { [weak self] _ in
      self?.appleLoginManager?.performAppleLogin()
    }, for: UIControl.Event.touchUpInside)
  }
  
  private func setupDimmingView() {
    self.dimmingView.backgroundColor = UIColor.black.withAlphaComponent(Constant.DimmingView.alpha)
    self.dimmingView.alpha = 0
    self.view.addSubview(self.dimmingView)
    self.dimmingView.frame = self.view.bounds
  }
  
  private func setupTermAgreementView() {
    self.termAgreementView.delegate = self
    self.view.addSubview(self.termAgreementView)
    self.termAgreementView.usingAutolayout()
    NSLayoutConstraint.activate([
      self.termAgreementView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      self.termAgreementView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
    ])
    self.termAgreementView.isHidden = true
    self.termAgreementView.alpha = 0
    self.termAgreementView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
  }
  
  private func setGuestLoginButon() {
    // TODO: 게스트 로그인
  }
  
  private func setAppleLoginManager(with httpClient: HTTPClientAPI) {
    self.appleLoginManager = AppleLoginManager(presentationContextProvider: self, httpClient: httpClient)
    self.appleLoginManager?.delegate = self
  }

  @MainActor
  public func showTermAgreementViewForRoutingToSignUpScene() {
    self.termAgreementView.isHidden = false
    UIView.animate(withDuration: 0.5) {
      self.dimmingView.alpha = 1
      self.termAgreementView.alpha = 1
      self.termAgreementView.transform = CGAffineTransform.identity
    }
  }
  
  private func hideTermAgreementView() {
    UIView.animate(
      withDuration: 0.5,
      animations: {
        self.dimmingView.alpha = 0
        self.termAgreementView.alpha = 0
        self.termAgreementView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
      }, completion: { _ in
        self.termAgreementView.isHidden = true
      })
  }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
  public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window ?? UIWindow()
  }
}

extension LoginViewController: AppleLoginManagerDelegate {
  public func appleLoginDidComplete(with result: Result<Bool, Error>) {
    switch result {
    case .success(let isMember):
      if isMember {
        self.afterLoginAction?(isMember)
      } else {
        self.showTermAgreementViewForRoutingToSignUpScene()
      }
    case .failure(let error):
      self.handleError(error)
    }
  }
}

extension LoginViewController: TermsAgreementViewDelegate {
  public func termsAgreementView(
    _ view: ToDoGardenUIComponent.TermsAgreementView,
    didTapTermsAndPoliciesAgreement: Void
  ) {
    // TODO: 약관 및 정책 열람 코드
  }
  
  public func termsAgreementView(
    _ view: ToDoGardenUIComponent.TermsAgreementView,
    didTapPrivacyPolicy: Void
  ) {
    // TODO: 개인정보 처리 방침 열람 코드
  }
  
  public func termsAgreementView(
    _ view: ToDoGardenUIComponent.TermsAgreementView,
    didTapEventAndPromotionalInformation: Void
  ) {
    // TODO: 이벤트, 광고성 정보 안내 (선택) 열람 코드
  }
  
  public func termsAgreementView(
    _ view: ToDoGardenUIComponent.TermsAgreementView,
    didTapDoneButton isEventAndPromotionalInformationAgreed: Bool
  ) {
    self.hideTermAgreementView()
    self.doneButtonAction?(isEventAndPromotionalInformationAgreed)
  }
}

extension LoginViewController {
  private func handleError(_ error: Error) {
    debugPrint("\(error) on LoginViewController")
    self.showToast(message: error.localizedDescription)
  }
}
