//
//  IntroOnBoardingViewController.swift
//
//
//  Created by SONG on 11/9/24.
//

import UIKit

import ToDoGardenUIComponent
import ToDoGardenUIResource

public final class IntroOnBoardingViewController: UIViewController {
  // private let mainImageView: AnimationImageView
  private let mainImageView: UIImageView
  private let stackView: LeafLabelStackView
  private let startButton: ToDoGardenBoxButton
  
  public init() {
    // self.mainImageView = AnimationImageView(jsonURL: URL.onBoardingURL)
    self.mainImageView = UIImageView(image: UIImage.onBoarding)
    self.stackView = LeafLabelStackView()
    self.startButton = ToDoGardenBoxButton(
      title: Constant.StringLiteral.buttonTitle,
      buttonType: ToDoGardenBoxButton.Configuration.primaryRoundRectButton
    )
    super.init(nibName: nil, bundle: nil)
    self.view.backgroundColor = UIColor.toDoGardenBeige
    self.setupViews()
    self.setupConstraints()
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = true
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension IntroOnBoardingViewController {
  private func setupViews() {
    self.addMainImageView()
    self.addStackView()
    self.addStartButton()
  }
  
  private func addMainImageView() {
    self.view.addSubview(self.mainImageView)
  }
  
  private func addStackView() {
    self.view.addSubview(self.stackView)
  }
  
  private func addStartButton() {
    self.view.addSubview(self.startButton)
  }
  
  private func setupConstraints() {
    self.setupMainImageViewConstraints()
    self.setupStackViewConstraints()
    self.setupStartButtonConstraints()
  }
  
  private func setupMainImageViewConstraints() {
    self.mainImageView.usingAutolayout()
    let multiplier = Constant.Layout.multiplier
    let aspectRatio = Constant.Layout.aspectRatio
    
    NSLayoutConstraint.activate([
      self.mainImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      self.mainImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      self.mainImageView.heightAnchor.constraint(equalTo: self.mainImageView.widthAnchor, multiplier: aspectRatio),
      self.mainImageView.centerYAnchor.constraint(
        equalTo: self.view.centerYAnchor,
        constant: -self.view.bounds.height * multiplier
      )
    ])
  }
  
  private func setupStackViewConstraints() {
    self.stackView.usingAutolayout()
    
    NSLayoutConstraint.activate([
      self.stackView.centerYAnchor.constraint(
        equalTo: self.view.centerYAnchor,
        constant: self.view.bounds.height * Constant.Layout.multiplier
      ),
      self.stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
    ])
  }
  
  private func setupStartButtonConstraints() {
    self.startButton.usingAutolayout()
    
    NSLayoutConstraint.activate([
      self.startButton.bottomAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
        constant: -Constant.Layout.space
      ),
      self.startButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
    ])
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let viewController = IntroOnBoardingViewController()
  let navi = UINavigationController(rootViewController: viewController)
  return navi
}
#endif
