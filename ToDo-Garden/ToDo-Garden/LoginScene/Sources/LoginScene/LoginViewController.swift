//
//  LoginViewController.swift
//
//
//  Created by SONG on 10/2/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import AuthenticationServices
import UIKit

import LoginSceneAPI
import LoginSceneEntity
import ToDoGardenUIComponent

protocol LoginDisplayLogic: AnyObject {
  func displaySomething(viewModel: Login.Something.ViewModel)
}

final class LoginViewController: UIViewController, LoginViewControllable {
  
  // MARK: - VIP Properties
  
  var interactor: LoginBusinessLogic?
  var router: (LoginRoutingLogic & LoginDataPassing)?
  
  private var appleLoginManager: AppleLoginManager?
  private let appleLoginButton: AppleLoginButton
  private let dimmingView: UIView
  private let termAgreementView: TermsAgreementView
  
  // MARK: - 임시 저장용 개인정보 / 인증정보 등 이후 PR에서 프로퍼티 제거 및 보안강화 처리 예정
  private var userIdentifier: String = ""
  private var userEmailAddress: String?
  private var agreeOptionalCondition: Bool = false
  
  // MARK: - Object lifecycle
  
  init() {
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setAppleLoginManager()
    self.setUI()
    self.doSomething()
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

// MARK: - Confirm display logic protocol

extension LoginViewController: LoginDisplayLogic {
  func displaySomething(viewModel: Login.Something.ViewModel) {
    // self.nameTextField.text = viewModel.name
  }
}

// MARK: - Request to interactor

extension LoginViewController {
  func doSomething() {
    let request = Login.Something.Request()
    self.interactor?.doSomething(request: request)
  }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
  public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window ?? UIWindow()
  }
}

// TODO: 린트관련 주석 지우기
// swiftlint:disable empty_enum_arguments
extension LoginViewController: AppleLoginManagerDelegate {
  func appleLoginDidComplete(with result: Result<ASAuthorizationAppleIDCredential, Error>) {
    switch result {
    case .success(_):
      //      let userIdentifier = appleIDCredential.user
      //      let fullName = appleIDCredential.fullName
      //      let email = appleIDCredential.email
      // TODO: 신규회원인지 기존회원인지 체크
      self.showTermAgreementView()
      
    case .failure(_): break
      // TODO: 에러처리
    }
  }
}
// swiftlint:enable empty_enum_arguments

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
    // TODO: 이벤트, 광고성 정보 안내 (선택)에 동의했을 때 / 안했을 때 동작 분기
    if isEventAndPromotionalInformationAgreed {
      self.agreeOptionalCondition = true
    } else {
      self.agreeOptionalCondition = false
    }
    self.router?.routeToSignUpScene(
      userIdentifier: self.userIdentifier,
      userEmailAddress: self.userEmailAddress,
      agreeOptionalCondition: self.agreeOptionalCondition
    )
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let view = LoginViewController()
  return view
}
#endif
