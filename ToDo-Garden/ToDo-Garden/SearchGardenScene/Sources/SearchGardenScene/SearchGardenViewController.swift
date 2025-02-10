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

import TDFoundation

@MainActor
protocol SearchGardenDisplayLogic: AnyObject {
  func displayFriendGarden(viewModel: SearchGarden.LoadFriendGarden.ViewModel)
  func displayAddGarden()
  func displaySearchedGarden(viewModel: SearchGarden.LoadSearchedGarden.ViewModel)
  func displayErrorInfoToast(error: Error)
}

final class SearchGardenViewController: UIViewController, SearchGardenViewControllable {
  
  // MARK: - VIP Properties
  
  var interactor: SearchGardenBusinessLogic?
  var router: (SearchGardenRoutingLogic & SearchGardenDataPassing)?
  
  private let searchGardenView: SearchGardenView
  private let loadingIndicator: AnimationImageView
  private let addGardenView: AddGardenView
  private let defaultModalNavigationBar: DefaultModalNavigationBar
  private let dimmingView: UIView
  
  // MARK: - Object lifecycle
  
  init() {
    self.searchGardenView = SearchGardenView()
    self.loadingIndicator = AnimationImageView(jsonURL: URL.loadingIndicatorURL)
    self.addGardenView = AddGardenView(
      userNickname: Constant.SearchGardenView.defaultUserNickName,
      userIntroduction: Constant.SearchGardenView.defaultUserIntroduction,
      userImage: nil,
      pomodoroCollection: PomodoroRecordCollection()
    )
    self.defaultModalNavigationBar = DefaultModalNavigationBar(
      title: Constant.NavigationBar.title,
      rightButtonTitle: Constant.NavigationBar.rightButtonTitle
    )
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
    self.setupView()
  }
}

extension SearchGardenViewController {
  
  private func setupView() {
    self.view.backgroundColor = UIColor.white
    self.setupNavigationBar()
    self.setupSearchGardenView()
    self.setupDimmingView()
    self.setupAddGardenView()
    self.setupLoadingIndicator()
  }
  
  // TODO: 모달로 올라오는 뷰컨에 대해서는 화면 상단부분을 디밍뷰가 커버하지 못함.
  private func setupDimmingView() {
    self.dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    self.dimmingView.frame = self.view.bounds
    self.dimmingView.isHidden = true
    self.dimmingView.alpha = CGFloat.zero
    self.view.addSubview(self.dimmingView)
  }
  
  private func setupNavigationBar() {
    self.view.addSubview(self.defaultModalNavigationBar)
    self.defaultModalNavigationBar.usingAutolayout()
    self.defaultModalNavigationBar.delegate = self
    
    NSLayoutConstraint.activate(
      [
        self.defaultModalNavigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        self.defaultModalNavigationBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
        self.defaultModalNavigationBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        self.defaultModalNavigationBar.heightAnchor.constraint(equalToConstant: Constant.NavigationBar.height)
      ]
    )
  }
  
  private func setupSearchGardenView() {
    self.searchGardenView.tableView.delegate = self
    self.searchGardenView.tableView.onEndReached = {
      self.interactor?.loadSearchedGardenContinue()
    }
    self.searchGardenView.tableView.prefetchDataSource = self
    self.searchGardenView.textField.delegate = self
    self.searchGardenView.textField.returnKeyType = .search
    self.view.addSubview(self.searchGardenView)
    self.searchGardenView.usingAutolayout()
    
    NSLayoutConstraint.activate(
      [
        self.searchGardenView.topAnchor.constraint(equalTo: self.defaultModalNavigationBar.bottomAnchor),
        self.searchGardenView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
        self.searchGardenView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        self.searchGardenView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
      ]
    )
  }
  
  private func setupAddGardenView() {
    self.addGardenView.isHidden = true
    self.addGardenView.alpha = CGFloat.zero
    self.view.addSubview(self.addGardenView)
    self.addGardenView.usingAutolayout()
    self.addGardenView.addButton.addAction(
      UIAction { [weak self] _ in
        self?.addGarden()
      },
      for: UIControl.Event.touchUpInside
    )
    self.addGardenView.cancelButton.addAction(
      UIAction { [weak self] _ in self?.hideAddGardenView() },
      for: UIControl.Event.touchUpInside
    )
    
    NSLayoutConstraint.activate(
      [
        self.addGardenView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        self.addGardenView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        self.addGardenView.widthAnchor.constraint(equalToConstant: Constant.AddGardenView.width),
        self.addGardenView.heightAnchor.constraint(equalToConstant: Constant.AddGardenView.height)
      ]
    )
  }
  
  private func setupLoadingIndicator() {
    self.loadingIndicator.isHidden = true
    self.loadingIndicator.pauseAnimation()
    self.view.addSubview(self.loadingIndicator)
    self.loadingIndicator.usingAutolayout()
    
    NSLayoutConstraint.activate(
      [
        self.loadingIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        self.loadingIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
      ]
    )
  }
  
  private func doneButtonTapped() {
    self.router?.dismissModal()
  }
  
  private func showAddGardenView() {
    self.dimmingView.isHidden = false
    UIView.animate(withDuration: Constant.AddGardenView.duration) {
      self.dimmingView.alpha = 1.0 
      self.addGardenView.isHidden = false
      self.addGardenView.alpha = 1.0
    }
  }
  
  private func hideAddGardenView() {
    UIView.animate(withDuration: Constant.AddGardenView.duration) {
      self.addGardenView.alpha = CGFloat.zero
      self.dimmingView.alpha = 0.0 
    } completion: { _ in
      self.addGardenView.isHidden = true
      self.dimmingView.isHidden = true
    }
  }
  
  private func convertToPomodoroRecord(from dtos: [SearchGarden.UserGarden]) -> [PomodoroRecord] {
    var records: [PomodoroRecord] = []
    for dto in dtos {
      records.append(PomodoroRecord(date: dto.date.toDateISO8601Format(), pomodoroCount: dto.pomodoroCount))
    }
    return records
  }
}

// MARK: - Confirm display logic protocol

extension SearchGardenViewController: SearchGardenDisplayLogic {
  func displayFriendGarden(viewModel: SearchGarden.LoadFriendGarden.ViewModel) {
    self.addGardenView.update(
      userNickname: viewModel.userNickname,
      userIntroduction: viewModel.userIntroduction ?? "",
      userImage: viewModel.userImage,
      pomodoroCollection: PomodoroRecordCollection(pomodoroRecords: viewModel.userGarden)
    )
    
    self.addGardenView.addButton.isEnabled = viewModel.isButtonEnable
    self.searchGardenView.textField.resignFirstResponder()
    self.showAddGardenView()
  }
  
  func displayAddGarden() {
    self.hideAddGardenView()
  }
  
  func displaySearchedGarden(viewModel: SearchGarden.LoadSearchedGarden.ViewModel) {
    self.searchGardenView.tableView.deletePlaceholderCell()
    self.loadingIndicator.isHidden = true
    self.loadingIndicator.pauseAnimation()
    self.searchGardenView.tableView.appendData(with: viewModel.fetchedData.searchedGardens)
    if !viewModel.fetchedData.isEndPage {
      self.searchGardenView.tableView.appendPlaceholderCell()
    }
    
    let users = viewModel.fetchedData.searchedGardens
    for user in users {
      guard let imageURL = user.userImageURL else { continue }
      Task {
        do {
          let image = try await ImageClient.live.execute(id: imageURL)
          let updatedUser = user
          updatedUser.userImage = image
          self.searchGardenView.tableView.updateData(of: [updatedUser])
        } catch {
          debugPrint("ImageDownload Failed")
        }
      }
    }
  }
  
  func displayErrorInfoToast(error: any Error) {
    self.showToast(message: error.localizedDescription)
  }
}

// MARK: - Request to interactor

extension SearchGardenViewController {
  func loadFriendGarden(userID: UUID, userImage: UIImage?) {
    let request = SearchGarden.LoadFriendGarden.Request(
      userID: userID,
      userImage: userImage
    )
    self.interactor?.loadFriendGarden(request: request)
  }
  
  func addGarden() {
    self.interactor?.addGarden()
  }
  
  func loadSearchedGarden(inputText: String) {
    self.searchGardenView.tableView.clearItemsInMainSection {
      self.loadingIndicator.isHidden = false
      self.loadingIndicator.startAnimation()
      let request = SearchGarden.LoadSearchedGarden.Request(inputText: inputText)
      self.interactor?.loadSearchedGarden(request: request, isContinuous: false)
    }
  }
}

extension SearchGardenViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Constant.SearchGardenView.cellHeight
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let tableView = tableView as? SearchGardenTableView,
    let userData = tableView.userForCell(at: indexPath) else {
      return
    }
    
    self.loadFriendGarden(
      userID: userData.id,
      userImage: userData.userImage
    )
  }
}

extension SearchGardenViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard let inputText = textField.text else {
      return false
    }
    self.interactor?.cancelTask(for: SearchGardenInteractor.TaskKey.loadSearchedGarden)
    self.searchGardenView.tableView.scrollToNearestSelectedRow(at: .none, animated: true)
    self.loadSearchedGarden(inputText: inputText)
    return true
  }
}

extension SearchGardenViewController: DefaultModalNavigationBarDelegate {
  func didTapRightButton() {
    self.router?.dismissModal()
  }
}

extension SearchGardenViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    let shouldLoadNextPage = indexPaths.contains { indexPath in
      guard let user = self.searchGardenView.tableView.userForCell(at: indexPath) else {
        return false
      }
      return user.isDummyData
    }
    
    if shouldLoadNextPage {
      self.interactor?.loadSearchedGardenContinue()
    }
  }
}
