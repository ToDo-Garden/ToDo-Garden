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
      fetchedData: response.profileViewData
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
    fetchedData: MyStats.FetchedProfileViewData
  ) -> MyStats.ProfileViewModel {
    var image: UIImage
    if let imageData = fetchedData.profileImage, let profielImage = UIImage(data: imageData) {
      image = profielImage
    } else {
      image = UIImage.defaultProfileImage
    }
    
    let viewModel = MyStats.ProfileViewModel(
      myName: fetchedData.nickname,
      myImage: image,
      continuousRecordCount: fetchedData.continuousRecordCount,
      continuousRecordStartDate:
        fetchedData.continuousRecordStartDate.replacingOccurrences(of: "-", with: "."),
      continuousRecordEndDate:
        fetchedData.continuousRecordEndDate.replacingOccurrences(of: "-", with: ".")
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
    let convertedDate = fetchedData.maxPomodoroRecord.recordDate.toDateISO8601Format().toStringDefaultFormat()
    let viewModel = MyStats.LongestRecordViewModel(
      concentratedRecordGroupName: fetchedData.maxPomodoroRecord.groupName,
      concentratedRecordCount: fetchedData.maxPomodoroRecord.maxPomodoroCount,
      concentratedRecordDate: convertedDate,
      longestContinuousRecordCount: fetchedData.maxContinuousDays?.maxCount ?? 0,
      longestContinuousRecordStartDate: fetchedData.maxContinuousDays?.startDate ?? "",
      longestContinuousRecordEndDate: fetchedData.maxContinuousDays?.endDate ?? ""
    )
    return viewModel
  }
  
  private func makeSummaryViewModel(fetchedData: MyStats.FetchedSummaryViewData) -> MyStats.SummaryViewModel {
    let viewModel = MyStats.SummaryViewModel(
      concentratedTime: "\(fetchedData.weeklyAverageFocusTime) 단위몰라",
      completedCount: "\(fetchedData.weeklyAveragePomodoroCount) 개 목표"
    )
    return viewModel
  }
}
