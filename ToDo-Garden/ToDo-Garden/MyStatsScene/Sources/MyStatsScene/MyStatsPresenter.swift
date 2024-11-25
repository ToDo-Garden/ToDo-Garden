//
//  MyStatsPresenter.swift
//  
//
//  Created by SONG on 11/13/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import MyStatsSceneEntity
import TDFoundationExtension
import ToDoGardenUIComponent // TODO: - PomodoroRecordCollection 이관 예정

protocol MyStatsPresentationLogic {
  func presentMyStatsViewData(response: MyStats.LoadMyStatsViewData.Response, with payload: MyStats.Payload)
}

class MyStatsPresenter {
  weak var viewController: MyStatsDisplayLogic?
}

// MARK: - Request to ViewController

extension MyStatsPresenter: MyStatsPresentationLogic {
  func presentMyStatsViewData(
    response: MyStats.LoadMyStatsViewData.Response,
    with payload: MyStats.Payload
  ) {
    let viewModel = self.makeViewModel(response: response, with: payload)
    
    Task { @MainActor in
      self.viewController?.displayMyStatsView(viewModel: viewModel)
    }
  }
}

// MARK: - Make ViewModels

extension MyStatsPresenter {
  private func makeViewModel(response: MyStats.LoadMyStatsViewData.Response, with payload: MyStats.Payload)
  -> MyStats.LoadMyStatsViewData.ViewModel {
    let profileViewModel = self.makeProfileViewModel(
      fetchedData: response.profileViewData,
      myName: payload.myName,
      myImage: payload.myImage
    )
    let gardenViewModel = self.makeGardenViewModel(myGarden: payload.myGarden)
    let longestRecordViewModel = self.makeLongestRecordViewModel(fetchedData: response.longestRecordViewData)
    let summaryViewModel = self.makeSummaryViewModel(fetchedData: response.summaryViewData)
    
    let myStatsViewModel = MyStats.LoadMyStatsViewData.ViewModel(
      profileViewModel: profileViewModel,
      gardenViewModel: gardenViewModel,
      longestRecordViewModel: longestRecordViewModel,
      summaryViewModel: summaryViewModel
    )
    return myStatsViewModel
  }
  
  private func makeProfileViewModel(
    fetchedData: MyStats.FetchedProfileViewData,
    myName: String,
    myImage: UIImage
  ) -> MyStats.ProfileViewModel {
    let viewModel = MyStats.ProfileViewModel(
      myName: myName,
      myImage: myImage,
      continuousRecordCount: fetchedData.continuousRecordCount,
      continuousRecordStartDate: fetchedData.continuousRecordStartDate.toStringDefaultFormat(),
      continuousRecordEndDate: fetchedData.continuousRecordEndDate.toStringDefaultFormat()
    )
    return viewModel
  }
  
  private func makeGardenViewModel(myGarden: PomodoroRecordCollection) -> MyStats.GardenViewModel {
    let viewModel = MyStats.GardenViewModel(pomodoroCollection: myGarden)
    return viewModel
  }
  
  private func makeLongestRecordViewModel(
    fetchedData: MyStats.FetchedLongestRecordViewData
  ) -> MyStats.LongestRecordViewModel {
    let viewModel = MyStats.LongestRecordViewModel(
      concentratedRecordGroupName: fetchedData.concentratedRecordGroupName,
      concentratedRecordCount: fetchedData.concentratedRecordCount,
      concentratedRecordDate: fetchedData.concentratedRecordDate.toStringDefaultFormat(),
      longestContinuousRecordCount: fetchedData.longestContinuousRecordCount,
      longestContinuousRecordStartDate: fetchedData.longestContinuousRecordStartDate.toStringDefaultFormat(),
      longestContinuousRecordEndDate: fetchedData.longestContinuousRecordEndDate.toStringDefaultFormat()
    )
    return viewModel
  }
  
  private func makeSummaryViewModel(fetchedData: MyStats.FetchedSummaryViewData) -> MyStats.SummaryViewModel {
    let viewModel = MyStats.SummaryViewModel(
      concentratedTime: fetchedData.concentratedTime.toTimeString(),
      completedCount: fetchedData.completedCount.toStringWithOneDecimal()
    )
    return viewModel
  }
}

// MARK: - 아래 코드는 API명세 / supaBase에서 어떤 데이터를 제공해 줄지에 따라 사용여부가 결정되므로, 일단 임시로 사용하고 있는 메서드입니다.

extension Double {
  func toStringWithOneDecimal() -> String {
    return String(format: "%.1f개 목표", self)
  }
}

extension Int {
  func toTimeString() -> String {
    let hours = self / 3600
    let minutes = (self % 3600) / 60
    var timeString = ""
    
    if hours > 0 {
      timeString += "\(hours)시간"
    }
    if minutes > 0 {
      timeString += " \(minutes)분"
    }
    
    return timeString.trimmingCharacters(in: CharacterSet.whitespaces)
  }
}
