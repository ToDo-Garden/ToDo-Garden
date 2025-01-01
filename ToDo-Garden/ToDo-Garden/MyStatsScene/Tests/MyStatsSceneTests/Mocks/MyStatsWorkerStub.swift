//
//  MyStatsWorkerMock.swift
//
//
//  Created by SONG on 11/28/24.
//

import Foundation

import HTTPClientAPI
import MyStatsSceneAPI
import MyStatsSceneEntity

struct MyStatsWorkerStub {
  private var profileViewData: MyStats.FetchedProfileViewData?
  private var longestRecordViewData: MyStats.FetchedLongestRecordViewData?
  private var summaryViewData: MyStats.FetchedSummaryViewData?
  private var error: HTTPClientError?
  
  mutating func setProfileViewData(_ data: MyStats.FetchedProfileViewData) {
    self.profileViewData = data
  }
  
  mutating func setLongestRecordViewData(_ data: MyStats.FetchedLongestRecordViewData) {
    self.longestRecordViewData = data
  }
  
  mutating func setSummaryViewData(_ data: MyStats.FetchedSummaryViewData) {
    self.summaryViewData = data
  }
  
  mutating func setError(_ error: HTTPClientError) {
    self.error = error
  }
}

extension MyStatsWorkerStub: MyStatsWorkable {
  func fetchProfileViewData() async throws -> MyStats.FetchedProfileViewData {
    if let error = self.error {
      throw error
    }

    if let profileViewData = self.profileViewData {
      return profileViewData
    }

    throw NSError(domain: "Test Unknown Error", code: -1)
  }
  
  func fetchLongestRecordsViewData() async throws -> MyStats.FetchedLongestRecordViewData {
    if let error = self.error {
      throw error
    }

    if let longestRecordViewData = self.longestRecordViewData {
      return longestRecordViewData
    }

    throw NSError(domain: "Test Unknown Error", code: -1)
  }
  
  func fetchSummaryViewData() async throws -> MyStats.FetchedSummaryViewData {
    if let error = self.error {
      throw error
    }

    if let summaryViewData = self.summaryViewData {
      return summaryViewData
    }

    throw NSError(domain: "Test Unknown Error", code: -1)
  }
}
