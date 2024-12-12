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
import ToDoGardenUIComponent // PomodoroRecordCollection 이관 예정

protocol MyStatsDataStore {
  var myName: String { get set }
  var myImage: UIImage { get set }
  var myGarden: PomodoroRecordCollection { get set }
}

protocol MyStatsBusinessLogic {
  func loadMyStatsViewData(request: MyStats.LoadMyStatsViewData.Request)
  func cancelLoadMyStatsViewData()
}

class MyStatsInteractor: MyStatsDataStore {
  var myName: String
  var myImage: UIImage
  var myGarden: ToDoGardenUIComponent.PomodoroRecordCollection
  
  var presenter: MyStatsPresentationLogic?
  private let myStatsWorker: MyStatsWorkable
  private var loadMyStatsViewDataTask: Task<Void, Never>?
  
  init(myStatsWorker: MyStatsWorkable) {
    self.myName = "이인우"
    self.myImage = UIImage.defaultProfileImage
    self.myGarden = ToDoGardenUIComponent.PomodoroRecordCollection.init(pomodoroRecords: [])
    // TODO: ↑ 세 라인 페이로드로 세팅될 예정 지금은 임시로 이니셜라이저에서 할당
    self.myStatsWorker = myStatsWorker
  }
}

// MARK: - Request to worker

extension MyStatsInteractor: MyStatsBusinessLogic {
  func loadMyStatsViewData(request: MyStats.LoadMyStatsViewData.Request) {
    self.loadMyStatsViewDataTask = Task {
      do {
        try Task.checkCancellation()
        let payload = self.createPayload()
        let response = try await self.fetchViewData()
        try Task.checkCancellation()
        self.presenter?.presentMyStatsViewData(response: response, with: payload)
      } catch is CancellationError {
        // 취소된 경우의 처리
      } catch let error as HTTPClientError {
        // HTTPClientError case 별 처리
        switch error {
        default: break
        }
      } catch {
        // 기타 예상치 못한 에러 처리
      }
    }
  }
  
  private func createPayload() -> MyStats.Payload {
    return MyStats.Payload(
      myName: self.myName,
      myImage: self.myImage,
      myGarden: self.myGarden
    )
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

// swiftlint:disable all
// TODO: ↓ 제거예정
extension MyStatsInteractor {
  private func makeRandomPomodoroRecords() -> [PomodoroRecord] {
    var pomodoroRecords = [PomodoroRecord]()
    
    let calendar = Calendar.current
    
    let startDateComponents = DateComponents(year: 2024, month: 6, day: 14)
    let date = calendar.date(from: startDateComponents)!
    
    for i in 0..<140 {
      let currentDate = calendar.date(byAdding: .day, value: i, to: date)!
      let pomodoroCount = Int.random(in: 0...10) // Random pomodoro count between 0 and 10
      let formattedDate = calendar.date(
        from: DateComponents(
          year: calendar.component(.year, from: currentDate),
          month: calendar.component(.month, from: currentDate),
          day: calendar.component(.day, from: currentDate)
        )
      )!
      let pomodoroRecord = PomodoroRecord(date: formattedDate, pomodoroCount: pomodoroCount)
      pomodoroRecords.append(pomodoroRecord)
    }
    
    return pomodoroRecords
  }
}
// swiftlint:enable all
