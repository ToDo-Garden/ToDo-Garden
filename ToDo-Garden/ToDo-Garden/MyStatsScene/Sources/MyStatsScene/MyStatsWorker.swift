//
//  MyStatsWorker.swift
//
//
//  Created by SONG on 11/13/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import MyStatsSceneAPI
import MyStatsSceneEntity

public struct MyStatsWorker: MyStatsWorkable {
  public init() {}
  
  public func fetchProfileViewData() async -> MyStats.FetchedProfileViewData {
    return MyStats.FetchedProfileViewData(
      continuousRecordCount: 99,
      continuousRecordStartDate: Date.distantPast,
      continuousRecordEndDate: Date.distantFuture
    )
  }
  
  public func fetchLongestRecordsViewData() async -> MyStats.FetchedLongestRecordViewData {
    return MyStats.FetchedLongestRecordViewData(
      concentratedRecordGroupName: "킹왕짱그룹",
      concentratedRecordCount: 99,
      concentratedRecordDate: Date.now,
      longestContinuousRecordCount: 10,
      longestContinuousRecordStartDate: Date.distantPast,
      longestContinuousRecordEndDate: Date.distantFuture
    )
  }
  
  public func fetchSummaryViewData() async -> MyStats.FetchedSummaryViewData {
    return MyStats.FetchedSummaryViewData(
      concentratedTime: 3660,
      completedCount: 3.5
    )
  }
}
