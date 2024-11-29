//
//  SearchGardenViewController.swift
//  
//
//  Created by SONG on 11/18/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import SearchGardenSceneAPI
import SearchGardenSceneEntity
import TDUtility
import ToDoGardenUIComponent
import ToDoGardenUIResource

protocol SearchGardenDisplayLogic: AnyObject {
  func displaySomething(viewModel: SearchGarden.Something.ViewModel)
}

class SearchGardenViewController: UIViewController, SearchGardenViewControllable {
  
  // MARK: - VIP Properties
  
  var interactor: SearchGardenBusinessLogic?
  var router: (SearchGardenRoutingLogic & SearchGardenDataPassing)?
  
  private let searchGardenView: SearchGardenView
  private let loadingIndicator: AnimationImageView
  private let addGardenView: AddGardenView
  private let customNavigationBar: DefaultModalNavigationBar
  
  // MARK: - Object lifecycle
  
  init() {
    self.searchGardenView = SearchGardenView()
    self.loadingIndicator = AnimationImageView(jsonURL: URL.loadingIndicatorURL)
    self.addGardenView = AddGardenView(
      userNickname: "",
      userIntroduction: "",
      userImage: nil,
      pomodoroCollection: PomodoroRecordCollection()
    )
    self.customNavigationBar = DefaultModalNavigationBar(
      title: Constant.NavigationBar.title,
      rightButtonTitle: Constant.NavigationBar.rightButtonTitle
    )
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
}

extension SearchGardenViewController {
  
  private func setupView() {
    self.setupNavigationBar()
    self.setupSearchGardenView()
  }
  
  private func setupNavigationBar() {
    self.view.addSubview(self.customNavigationBar)
    self.customNavigationBar.usingAutolayout()
    self.customNavigationBar.delegate = self
    
    NSLayoutConstraint.activate(
      [
        self.customNavigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        self.customNavigationBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
        self.customNavigationBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        self.customNavigationBar.heightAnchor.constraint(equalToConstant: Constant.NavigationBar.height)
      ]
    )
  }
  
  private func setupSearchGardenView() {
    self.searchGardenView.tableView.delegate = self
    self.searchGardenView.tableView.updateData(with: MockData.preview) // ← TODO: 제거예정
    self.view.addSubview(self.searchGardenView)
    self.searchGardenView.usingAutolayout()
    
    NSLayoutConstraint.activate(
      [
        self.searchGardenView.topAnchor.constraint(equalTo: self.customNavigationBar.bottomAnchor),
        self.searchGardenView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
        self.searchGardenView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        self.searchGardenView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
      ]
    )
  }
}

// MARK: - Confirm display logic protocol

extension SearchGardenViewController: SearchGardenDisplayLogic {
  func displaySomething(viewModel: SearchGarden.Something.ViewModel) {
    // self.nameTextField.text = viewModel.name
  }
}

// MARK: - Request to interactor

extension SearchGardenViewController {
  func doSomething() {
    let request = SearchGarden.Something.Request()
    self.interactor?.doSomething(request: request)
  }
}

extension SearchGardenViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Constant.SearchGardenView.cellHeight
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    guard let tableView = tableView as? SearchGardenTableView else {
//      return
//    }
    
//    let userData = tableView.userForCell(at: indexPath)
  }
}

extension SearchGardenViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
//    let input = textField.text
  }
}

extension SearchGardenViewController: DefaultModalNavigationBarDelegate {
  func didTapRightButton() {
    self.router?.dismissModal()
  }
}
