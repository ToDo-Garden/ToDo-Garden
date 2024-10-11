//
//  SignUpViewController.swift
//  
//
//  Created by SONG on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import SignUpSceneAPI
import SignUpSceneEntity
import ToDoGardenUIComponent

protocol SignUpDisplayLogic: AnyObject {
  func displaySomething(viewModel: SignUp.Something.ViewModel)
}

final class SignUpViewController: UIViewController, SignUpViewControllable {
  
  // MARK: - VIP Properties
  
  var interactor: SignUpBusinessLogic?
  var router: (SignUpRoutingLogic & SignUpDataPassing)?
  
  private let signUpScrollView: SignUpScrollView
  private let bottomButton: ToDoGardenBoxButton
  
  // MARK: - Object lifecycle
  
  init() {
    self.signUpScrollView = SignUpScrollView()
    self.bottomButton = ToDoGardenBoxButton(
      title: Constant.BottomButton.StringLiteral.done,
      buttonType: ToDoGardenBoxButton.Configuration.rectangleButton
    )
    super.init(nibName: nil, bundle: nil)
    self.view.backgroundColor = UIColor.white
    self.setupNavigationBar()
    self.setupSignUpScrollView()
    self.setupBottomButton()
    self.setupTapRecognizer()
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
  
  // MARK: - Setups
  
  private func setupNavigationBar() {
    let backButton = UIBarButtonItem(
      image: UIImage.backwardButtonImage,
      style: UIBarButtonItem.Style.plain,
      target: self,
      action: #selector(self.backButtonTapped)
    )
    backButton.tintColor = UIColor.toDoGardenGreenDark
    self.navigationItem.setLeftBarButton(backButton, animated: true)
  }
  
  private func setupSignUpScrollView() {
    self.view.addSubview(self.signUpScrollView)
    self.signUpScrollView.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        self.signUpScrollView.topAnchor.constraint(
          equalTo: self.view.safeAreaLayoutGuide.topAnchor,
          constant: Constant.ScrollView.topMargin
        ),
        self.signUpScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
        self.signUpScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        self.signUpScrollView.heightAnchor.constraint(
          equalToConstant: self.view.bounds.height * Constant.ScrollView.heightMultiplier
        )
      ]
    )
  }
  
  private func setupBottomButton() {
    self.view.addSubview(self.bottomButton)
    self.bottomButton.usingAutolayout()
    self.bottomButton.addAction(UIAction { [weak self] _ in
      self?.signUpScrollView.goToNextPage()
    }, for: UIControl.Event.touchUpInside)
    
    NSLayoutConstraint.activate(
      [
        self.bottomButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        self.bottomButton.centerYAnchor.constraint(
          equalTo: self.view.centerYAnchor,
          constant: Constant.BottomButton.centerYOffset
        )
      ]
    )
  }
  
  private func setupTapRecognizer() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
    self.view.addGestureRecognizer(tapGesture)
  }
  
  private func exitSignUpFlow() {
    // TODO: Router
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc private func backButtonTapped() {
    if self.signUpScrollView.currentPageIndex == Int.zero {
      self.exitSignUpFlow()
    } else {
      self.signUpScrollView.goToPreviousPage()
    }
  }
  
  @objc private func handleTap() {
    self.signUpScrollView.cancelAnimation()
  }
}

// MARK: - Confirm display logic protocol

extension SignUpViewController: SignUpDisplayLogic {
  func displaySomething(viewModel: SignUp.Something.ViewModel) {
    // self.nameTextField.text = viewModel.name
  }
}

// MARK: - Request to interactor

extension SignUpViewController {
  func doSomething() {
    let request = SignUp.Something.Request()
    self.interactor?.doSomething(request: request)
  }
}
