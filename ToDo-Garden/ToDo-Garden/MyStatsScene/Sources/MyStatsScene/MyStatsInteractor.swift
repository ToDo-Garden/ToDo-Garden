//
//  MyStatsInteractor.swift
//  
//
//  Created by SONG on 11/13/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

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
}

class MyStatsInteractor: MyStatsDataStore {
  var myName: String
  var myImage: UIImage
  var myGarden: ToDoGardenUIComponent.PomodoroRecordCollection
  
  var presenter: MyStatsPresentationLogic?
  private let myStatsWorker: MyStatsWorkable
  
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
    Task {
      self.myGarden = .init(pomodoroRecords: self.makeRandomPomodoroRecords())
      // TODO: ↑ 페이로드 세팅이후 제거예정
      
      let payload = MyStats.Payload(
        myName: self.myName,
        myImage: self.myImage,
        myGarden: self.myGarden
      )
      
      async let profileViewData = self.myStatsWorker.fetchProfileViewData()
      async let longestRecordViewData = self.myStatsWorker.fetchLongestRecordsViewData()
      async let summaryViewData = self.myStatsWorker.fetchSummaryViewData()

      let response = MyStats.LoadMyStatsViewData.Response(
        profileViewData: await profileViewData,
        longestRecordViewData: await longestRecordViewData,
        summaryViewData: await summaryViewData
      )
      
      self.presenter?.presentMyStatsViewData(response: response, with: payload)
    }
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
