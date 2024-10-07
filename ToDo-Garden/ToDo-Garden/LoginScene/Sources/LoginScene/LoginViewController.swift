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
  
  private let appleLoginButton: AppleLoginButton
  private let dimmingView: UIView
  private let termAgreementView: TermsAgreementView
  
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
      self?.appleLoginButtonTapped()
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

extension LoginViewController: AppleLoginBottomSheetDelegate {
  public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window ?? UIWindow()
  }
}

extension LoginViewController: AppleLoginManagerDelegate {
  func appleLoginDidComplete(with result: Result<ASAuthorizationAppleIDCredential, Error>) {
    switch result {
    case .success(let appleIDCredential):
      //      let userIdentifier = appleIDCredential.user
      //      let fullName = appleIDCredential.fullName
      //      let email = appleIDCredential.email
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
