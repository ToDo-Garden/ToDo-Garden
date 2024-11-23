//
//  MyStatsViewController.swift
//  
//
//  Created by SONG on 11/13/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import MyStatsSceneAPI
import MyStatsSceneEntity

protocol MyStatsDisplayLogic: AnyObject {
  func displayMyStatsView(viewModel: MyStats.LoadMyStatsViewData.ViewModel)
}

class MyStatsViewController: UIViewController, MyStatsViewControllable {
  
  // MARK: - VIP Properties
  
  var interactor: MyStatsBusinessLogic?
  var router: (MyStatsRoutingLogic & MyStatsDataPassing)?
  
  var myStatsView: MyStatsView
  
  // MARK: - Object lifecycle
  
  init() {
    self.myStatsView = MyStatsView()
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.white
    self.title = "나의 가든"
    self.setupMyStatsView()
  }
}

// MARK: - Confirm display logic protocol

extension MyStatsViewController: MyStatsDisplayLogic {
  func displayMyStatsView(viewModel: MyStats.LoadMyStatsViewData.ViewModel) {
    // self.nameTextField.text = viewModel.name
  }
}

// MARK: - Request to interactor

extension MyStatsViewController {
  func loadMyStatsViewData() {
    self.myStatsView.startShimmering()
    let request = MyStats.LoadMyStatsViewData.Request()
  }
}

extension MyStatsViewController {
  private func setupMyStatsView() {
    self.view.addSubview(self.myStatsView)
    self.setupConstraints()
  }
  
  private func setupConstraints() {
    self.myStatsView.usingAutolayout()
    
    NSLayoutConstraint.activate(
      [
        self.myStatsView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
        self.myStatsView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        self.myStatsView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15.0),
        self.myStatsView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
      ]
    )
  }
}
