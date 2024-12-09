//
//  LoginViewController.swift
//
//
//  Created by SONG on 10/2/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import AuthenticationServices
import OSLog
import UIKit

import TDFoundation
import ToDoGardenUIComponent

public final class LoginViewController: UIViewController {
  typealias Constant = LoginViewControllerConstant
  private var appleLoginManager: AppleLoginManager?
  private let appleLoginButton: AppleLoginButton
  private let dimmingView: UIView
  private let termAgreementView: TermsAgreementView
  
  private let loger = Logger()
  // MARK: - Object lifecycle
  
  public init() {
    self.appleLoginButton = AppleLoginButton()
    self.dimmingView = UIView()
    self.termAgreementView = TermsAgreementView()
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View lifecycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.setAppleLoginManager()
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
  
  private func setAppleLoginManager() {
    self.appleLoginManager = AppleLoginManager(presentationContextProvider: self)
    self.appleLoginManager?.delegate = self
  }
  
  private func showTermAgreementView() {
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
  public func appleLoginDidComplete(with result: Result<ASAuthorizationAppleIDCredential, Error>) {
    switch result {
    case .success(let credential):
      do {
        try KeychainManager.shared.saveLoginData(
          identifier: credential.user,
          identifyToken: credential.identityToken ?? Data(),
          email: credential.email
        )
        
        // TODO: 신규회원인지 기존회원인지 판별
        self.showTermAgreementView()
      } catch {
        self.loger.log("Keychain에 저장 실패: \(error)")
      }
      
    case .failure(let error):
      self.loger.log("Apple Login 실패: \(error)")
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
    do {
      if let loginData = try KeychainManager.shared.getLoginData() {
        //        self.router?.routeToSignUpScene(
        //          userIdentifier: loginData.identifier,
        //          userEmailAddress: loginData.email,
        //          agreeOptionalCondition: isEventAndPromotionalInformationAgreed
        //        )
        // try KeychainManager.shared.clearLoginData()
      }
    } catch {
      self.loger.log("Keychain에 저장된 데이터 뽑아오기 실패: \(error)")
    }
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let view = LoginViewController()
  return view
}
#endif
