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
  func displayValid(viewModel: SignUp.CheckStringValidation.ViewModel)
  func displayInvalid(viewModel: SignUp.CheckStringValidation.ViewModel)
}

final class SignUpViewController: UIViewController, SignUpViewControllable {
  
  // MARK: - VIP Properties
  
  var interactor: SignUpBusinessLogic?
  var router: (SignUpRoutingLogic & SignUpDataPassing)?
  
  private let signUpScrollView: SignUpScrollView
  private let bottomButton: ToDoGardenBoxButton
  
  public var afterSignUpAction: (() -> Void)?
  // MARK: - Object lifecycle
  
  init() {
    self.signUpScrollView = SignUpScrollView()
    self.bottomButton = ToDoGardenBoxButton(
      title: Constant.BottomButton.StringLiteral.done,
      buttonType: ToDoGardenBoxButton.Configuration.rectangleButton
    )
    super.init(nibName: nil, bundle: nil)
    self.setup()
  }
  
  public override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    self.navigationController?.navigationBar.isHidden = false
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Setups
  
  private func setup() {
    self.view.backgroundColor = UIColor.white
    self.setupNavigationBar()
    self.setupSignUpScrollView()
    self.setupBottomButton()
    self.setupTapRecognizer()
    self.setupKeyboardObservers()
  }
  
  private func setupNavigationBar() {
    self.navigationController?.navigationBar.isHidden = false
    let backButton = UIBarButtonItem(
      image: UIImage.backwardButtonImage,
      primaryAction: UIAction { [weak self] _ in
        self?.backButtonTapped()
      }
    )
    backButton.tintColor = UIColor.toDoGardenGreenDark
    self.navigationItem.setLeftBarButton(backButton, animated: true)
  }
  
  private func setupSignUpScrollView() {
    self.signUpScrollView.changeButtonDelegate = self
    self.signUpScrollView.delegate = self
    let inputViews = self.signUpScrollView.inputViews
    for inputView in inputViews {
      inputView.textInputView.delegate = self
    }
    
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
    self.bottomButton.isEnabled = false
    self.bottomButton.usingAutolayout()
    self.bottomButton.addAction(UIAction { [weak self] _ in
      self?.signUpScrollView.goToNextPage()
    }, for: UIControl.Event.touchUpInside)
    
    NSLayoutConstraint.activate(
      [
        self.bottomButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        self.bottomButton.bottomAnchor.constraint(
          equalTo: self.view.safeAreaLayoutGuide.bottomAnchor
        )
      ]
    )
    self.hideBottomButton()
  }
  
  private func setupTapRecognizer() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
    self.view.addGestureRecognizer(tapGesture)
  }
  
  private func exitSignUpFlow() {
    // TODO: Router
    self.router?.exitSignUpScene()
  }
  
  private func backButtonTapped() {
    if self.signUpScrollView.currentPageIndex == Int.zero {
      self.exitSignUpFlow()
    } else {
      self.signUpScrollView.goToPreviousPage()
    }
  }
  
  @objc private func handleTap() {
    self.signUpScrollView.cancelAnimation()
  }
  
  // MARK: - Keyboard Observers
  
  private func setupKeyboardObservers() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.showKeyBoard),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.hideKeyBoard),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }
  
  @objc private func showKeyBoard(notification: Notification) {
    guard 
      let userInfo = notification.userInfo,
      let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    
    let keyboardHeight = keyboardFrame.cgRectValue.height
    UIView.animate(withDuration: Constant.Animation.duration) {
      self.showBottomButton()
      self.bottomButton.transform = CGAffineTransform(
        translationX: CGFloat.zero,
        y: -keyboardHeight + self.view.safeAreaInsets.bottom
      )
    }
  }
  
  @objc private func hideKeyBoard() {
    UIView.animate(withDuration: Constant.Animation.duration) {
      self.hideBottomButton()
      self.bottomButton.transform = CGAffineTransform.identity
    }
  }
  
  private func hideBottomButton() {
    self.bottomButton.isHidden = true
    self.bottomButton.alpha = CGFloat.zero
  }
  
  private func showBottomButton() {
    self.bottomButton.isHidden = false
    self.bottomButton.alpha = 1
  }
  
  private func changeButtonState(isEnabled: Bool) {
    self.bottomButton.isEnabled = isEnabled
  }
}

// MARK: - Confirm display logic protocol

extension SignUpViewController: SignUpDisplayLogic {
  func displayValid(viewModel: SignUp.CheckStringValidation.ViewModel) {
    guard self.signUpScrollView.currentPageIndex == viewModel.currentPageIndex else { return }
    
    self.changeButtonState(isEnabled: true)
    let textInputView = self.signUpScrollView.inputViews[viewModel.currentPageIndex].textInputView
    textInputView.hideValidationText()
  }
  
  func displayInvalid(viewModel: SignUp.CheckStringValidation.ViewModel) {
    guard self.signUpScrollView.currentPageIndex == viewModel.currentPageIndex else { return }
    
    self.changeButtonState(isEnabled: false)
    let textInputView = self.signUpScrollView.inputViews[viewModel.currentPageIndex].textInputView
    textInputView.changeValidationText(viewModel.warningText)
    textInputView.showValidationText()
  }
}

// MARK: - Request to interactor

extension SignUpViewController {
  func checkStringValidation(text: String?) {
    let request = SignUp.CheckStringValidation.Request(
      text: text,
      currentPageIndex: self.signUpScrollView.currentPageIndex
    )
    self.interactor?.checkStringValidation(request: request)
  }
}

extension SignUpViewController: ChangeButtonDelegate {
  func changeButtonTitle(pageIndex: Int) {
    let editingText = self.signUpScrollView.getEditingText()
    let isEditingTextEmpty: Bool = editingText?.isEmpty ?? true
    if pageIndex == 1 && isEditingTextEmpty {
      self.bottomButton.changeTitle(text: Constant.BottomButton.StringLiteral.doItLater)
    } else {
      self.bottomButton.changeTitle(text: Constant.BottomButton.StringLiteral.done)
    }
  }
}

extension SignUpViewController: InputTextValidationViewDelegate {
  public func inputTextDidChanged(_ text: String?) {
    self.checkStringValidation(text: text)
    self.changeButtonTitle(pageIndex: self.signUpScrollView.currentPageIndex)
  }
}

extension SignUpViewController: UIScrollViewDelegate {
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    self.checkStringValidation(text: self.signUpScrollView.getEditingText())
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let viewController = SignUpViewController()
  let navi = UINavigationController(rootViewController: viewController)
  return navi
}
#endif
