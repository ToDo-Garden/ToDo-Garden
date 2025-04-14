//
//  MyStatsInteractor.swift
//
//
//  Created by SONG on 11/13/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import HTTPClientAPI
import MyStatsSceneAPI
import MyStatsSceneEntity
import TDFoundationExtension
import ToDoGardenUIComponent // PomodoroRecordCollection 이관 예정

protocol MyStatsDataStore {
  var myGarden: PomodoroRecordCollection { get set }
}

protocol MyStatsBusinessLogic {
  func loadMyStatsViewData(request: MyStats.LoadMyStatsViewData.Request)
  func cancelLoadMyStatsViewData()
}

class MyStatsInteractor: MyStatsDataStore {
  var myGarden: ToDoGardenUIComponent.PomodoroRecordCollection
  
  var presenter: MyStatsPresentationLogic?
  private let myStatsWorker: MyStatsWorkable
  private var loadMyStatsViewDataTask: Task<Void, Never>?
  private var periodicState = PeriodicState.init(
    daily: (focusTime: Int.zero, pomodoroCount: Int.zero),
    weekly: (focusTime: Int.zero, pomodoroCount: Int.zero),
    monthly: (focusTime: Int.zero, pomodoroCount: Int.zero)
  )
  
  init(myStatsWorker: MyStatsWorkable) {
    self.myGarden = ToDoGardenUIComponent.PomodoroRecordCollection.init(pomodoroRecords: [])
    // TODO: ↑ 세 라인 페이로드로 세팅될 예정 지금은 임시로 이니셜라이저에서 할당
    self.myStatsWorker = myStatsWorker
  }
}

// MARK: - Request to worker

extension MyStatsInteractor: MyStatsBusinessLogic {
  func loadMyStatsViewData(request: MyStats.LoadMyStatsViewData.Request) {
    self.loadMyStatsViewDataTask = Task {
      defer { self.loadMyStatsViewDataTask = nil }
      
      do {
        try Task.checkCancellation()
        let response = try await self.fetchViewData()
        try Task.checkCancellation()
        self.savePeriodicState(with: response)
        self.presenter?.presentMyStatsViewData(response: response, with: self.myGarden)
      } catch let error {
        debugPrint(error)
      }
    }
  }
  
  private func fetchViewData() async throws -> MyStats.LoadMyStatsViewData.Response {
    async let profileViewData = self.myStatsWorker.fetchProfileViewData()
    async let longestRecordViewData = self.myStatsWorker.fetchLongestRecordsViewData()
    async let summaryViewData = self.myStatsWorker.fetchSummaryViewData()
    
    return MyStats.LoadMyStatsViewData.Response(
      profileViewData: try await profileViewData,
      longestRecordViewData: try await longestRecordViewData,
      summaryViewData: try await summaryViewData
    )
  }
  
  func cancelLoadMyStatsViewData() {
    self.loadMyStatsViewDataTask?.cancel()
    self.loadMyStatsViewDataTask = nil
  }
}

extension MyStatsInteractor {
  private struct PeriodicState {
    let daily: (focusTime: Int, pomodoroCount: Int)
    let weekly: (focusTime: Int, pomodoroCount: Int)
    let monthly: (focusTime: Int, pomodoroCount: Int)
    
    init(
      daily: (focusTime: Int, pomodoroCount: Int),
      weekly: (focusTime: Int, pomodoroCount: Int),
      monthly: (focusTime: Int, pomodoroCount: Int)
    ) {
      self.daily = daily
      self.weekly = weekly
      self.monthly = monthly
    }
  }
  
  private func savePeriodicState(with response: MyStats.LoadMyStatsViewData.Response) {
    let dataSet = response.summaryViewData
    self.periodicState = PeriodicState(
      daily: (
        focusTime: dataSet.dailyAverageFocusTime.roundedToInt(),
        pomodoroCount: dataSet.dailyAveragePomodoroCount.roundedToInt()
      ),
      weekly: (
        focusTime: dataSet.weeklyAverageFocusTime.roundedToInt(),
        pomodoroCount: dataSet.weeklyAveragePomodoroCount.roundedToInt()
      ),
      monthly: (
        focusTime: dataSet.monthlyAverageFocusTime.roundedToInt(),
        pomodoroCount: dataSet.monthlyAveragePomodoroCount.roundedToInt()
      )
    )
  }
}
