//
//  IntroOnBoardingViewController.swift
//
//
//  Created by SONG on 11/9/24.
//

import UIKit

import ToDoGardenUIComponent
import ToDoGardenUIResource

public class IntroOnBoardingViewController: UIViewController {
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
