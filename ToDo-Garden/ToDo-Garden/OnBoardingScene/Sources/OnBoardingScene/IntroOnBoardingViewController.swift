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
  private let leafLabelStackView: LeafLabelStackView
  private let startButton: ToDoGardenBoxButton
  
  public var addAction: (() -> Void)?
  
  public init() {
    // self.mainImageView = AnimationImageView(jsonURL: URL.onBoardingURL)
    self.mainImageView = UIImageView(image: UIImage.onBoarding)
    self.leafLabelStackView = LeafLabelStackView()
    self.startButton = ToDoGardenBoxButton(
      title: Constant.StringLiteral.buttonTitle,
      buttonType: ToDoGardenBoxButton.Configuration.primaryRoundRectButton
    )
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    self.navigationController?.navigationBar.isHidden = true
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.toDoGardenBeige
    self.setupViews()
    self.setupConstraints()
  }
}

extension IntroOnBoardingViewController {
  private func setupViews() {
    self.addMainImageView()
    self.addStartButton()
    self.addStackView()
    self.setupButtonAction()
  }
  
  private func addMainImageView() {
    self.view.addSubview(self.mainImageView)
  }
  
  private func addStackView() {
    self.view.addSubview(self.leafLabelStackView)
  }
  
  private func addStartButton() {
    self.view.addSubview(self.startButton)
  }
  
  private func setupConstraints() {
    self.setupMainImageViewConstraints()
    self.setupStartButtonConstraints()
    self.setupStackViewConstraints()
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
    let dummyView = UIView()
    self.view.addSubview(dummyView)
    dummyView.usingAutolayout()
    
    NSLayoutConstraint.activate([
      dummyView.widthAnchor.constraint(
        equalToConstant: CGFloat.zero
      ),
      dummyView.topAnchor.constraint(
        equalTo: self.mainImageView.bottomAnchor
      ),
      dummyView.bottomAnchor.constraint(equalTo: self.startButton.topAnchor),
      dummyView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
    ])
    
    self.leafLabelStackView.usingAutolayout()
    
    NSLayoutConstraint.activate([
      self.leafLabelStackView.centerYAnchor.constraint(
        equalTo: dummyView.centerYAnchor,
        constant: -Constant.Layout.space / 2
      ),
      self.leafLabelStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
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
  
  private func setupButtonAction() {
    self.startButton.addAction(
      UIAction { [weak self] _ in
        self?.addAction?()
      },
      for: UIControl.Event.touchUpInside
    )
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
