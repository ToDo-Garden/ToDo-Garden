//
//  HomeSceneInteractor.swift
//  HomeScene
//
//  Created by Noah on 1/9/25.
//  Copyright (c) 2025 ToDoGarden. All rights reserved.

import Foundation

import HomeSceneAPI
import HomeSceneEntity

protocol HomeSceneDataStore {
}

@MainActor
protocol HomeSceneBusinessLogic {
  func fetchToDoList() async
  func createToDo() async
  func deleteToDo() async
  func setMonthlyData(_ monthlyData: [String: [HomeScene.TodoListGroup]]) async
  func loadDailyToDoList(date: String) async
}

@MainActor
final class HomeSceneInteractor: HomeSceneDataStore {
  var presenter: (any HomeScenePresentationLogic)?
  private var homeSceneWorker: HomeSceneWorkable
  private var monthlyData: [String: [HomeScene.TodoListGroup]]
  
  init(homeSceneWorker: HomeSceneWorkable) {
    self.homeSceneWorker = homeSceneWorker
    self.monthlyData = [:]
  }
}

// MARK: - Request to worker
extension HomeSceneInteractor: HomeSceneBusinessLogic {
  func fetchToDoList() async {
    do {
      let fetchedToDoList = try await self.homeSceneWorker.fetchToDoList()
      self.presenter?.presentFetchedToDoList(monthlyData: fetchedToDoList)
    } catch let error {
      self.handleErrors(error)
    }
  }
  
  func loadDailyToDoList(date: String) async {
    let dailyToDoList: [HomeScene.TodoListGroup] = self.monthlyData[date] ?? []
    self.presenter?.presentDailyToDoList(dailyData: dailyToDoList)
  }
  
  func createToDo() async {
    do {
      try await self.homeSceneWorker.createToDo()
      self.presenter?.presentCreateToDo()
    } catch let error {
      self.handleErrors(error)
    }
  }
  
  func deleteToDo() async {
    do {
      try await self.homeSceneWorker.deleteToDo()
      self.presenter?.presentDeleteToDo()
    } catch let error {
      self.handleErrors(error)
    }
  }
  
  func setMonthlyData(_ monthlyData: [String: [HomeScene.TodoListGroup]]) async {
    self.monthlyData = monthlyData
  }
}

// MARK: - HandleErrors

extension HomeSceneInteractor {
  private func handleErrors(_ error: Error) {
    switch error {
    default:
      break
    }
  }
}
