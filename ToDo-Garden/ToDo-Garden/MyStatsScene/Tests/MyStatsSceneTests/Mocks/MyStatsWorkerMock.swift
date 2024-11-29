//
//  MyStatsWorkerMock.swift
//
//
//  Created by SONG on 11/28/24.
//

import Foundation

import MyStatsSceneAPI
import MyStatsSceneEntity

actor MyStatsWorkerMock {
  private var isSuccessful: Bool = false
  private var profileViewData: MyStats.FetchedProfileViewData?
  private var longestRecordViewData: MyStats.FetchedLongestRecordViewData?
  private var summaryViewData: MyStats.FetchedSummaryViewData?
  
  func setProfileViewData(_ data: MyStats.FetchedProfileViewData) {
    self.profileViewData = data
  }
  
  func setLongestRecordViewData(_ data: MyStats.FetchedLongestRecordViewData) {
    self.longestRecordViewData = data
  }
  
  func setSummaryViewData(_ data: MyStats.FetchedSummaryViewData) {
    self.summaryViewData = data
  }
  
  func setIsSuccessful(_ isSuccessful: Bool) {
    self.isSuccessful = isSuccessful
  }
}

extension MyStatsWorkerMock: MyStatsWorkable {
  func fetchProfileViewData() async throws -> MyStats.FetchedProfileViewData {
    if self.isSuccessful {
      if let profileViewData = profileViewData {
        return profileViewData
      }
    }
    throw MyStats.MyStatsWorkerError.fetchProfileDataFailed
  }
  
  func fetchLongestRecordsViewData() async throws -> MyStats.FetchedLongestRecordViewData {
    if self.isSuccessful {
      if let longestRecordViewData = longestRecordViewData {
        return longestRecordViewData
      }
    }
    throw MyStats.MyStatsWorkerError.fetchLongestRecordDataFailed
  }
  
  func fetchSummaryViewData() async throws -> MyStats.FetchedSummaryViewData {
    if self.isSuccessful {
      if let summaryViewData = summaryViewData {
        return summaryViewData
      }
    }
    throw MyStats.MyStatsWorkerError.fetchSummaryDataFailed
  }
}
