//
//  LoginViewController.swift
//  
//
//  Created by SONG on 10/2/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import LoginSceneAPI
import LoginSceneEntity
import ToDoGardenUIComponent

protocol LoginDisplayLogic: AnyObject {
  func displaySomething(viewModel: Login.Something.ViewModel)
}

protocol AppleLoginBottomSheetDelegate: AnyObject {
  func bottomSheetWillDisappear()
  func bottomSheetWillAppear()
}

final class LoginViewController: UIViewController, LoginViewControllable {
  
  // MARK: - VIP Properties
  
  var interactor: LoginBusinessLogic?
  var router: (LoginRoutingLogic & LoginDataPassing)?
  
  private let appleLoginButton: AppleLoginButton
  private let dimmingView: UIView
  
  // MARK: - Object lifecycle
  
  init() {
    self.appleLoginButton = AppleLoginButton()
    self.dimmingView = UIView()
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
  
  private func appleLoginButtonTapped() {
    let bottomSheetVC = AppleLoginBottomSheetViewController()
    bottomSheetVC.delegate = self
    bottomSheetVC.modalPresentationStyle = UIModalPresentationStyle.pageSheet
    
    if let sheet = bottomSheetVC.sheetPresentationController {
      if #available(iOS 16.0, *) {
        sheet.detents = [UISheetPresentationController.Detent.custom { _ in
          return self.view.bounds.height * Constant.AppleLoginBottomSheet.heightMultiplier
        }]
      } else {
        sheet.detents = [UISheetPresentationController.Detent.medium()]
      }
      sheet.prefersGrabberVisible = true
    }
    
    self.present(bottomSheetVC, animated: true, completion: nil)
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
  func bottomSheetWillDisappear() {
    UIView.animate(withDuration: Constant.DimmingView.animateDuration) {
      self.dimmingView.alpha = 0
    } completion: { _ in
      self.dimmingView.isHidden = true
    }
  }
  
  func bottomSheetWillAppear() {
    self.dimmingView.isHidden = false
    UIView.animate(withDuration: Constant.DimmingView.animateDuration) {
      self.dimmingView.alpha = 1
    }
  }
}
