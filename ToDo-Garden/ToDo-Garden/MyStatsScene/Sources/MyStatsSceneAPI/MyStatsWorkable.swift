//
//  MyStatsWorkable.swift
//  
//
//  Created by SONG on 11/13/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import MyStatsSceneEntity

public protocol MyStatsWorkable {
  func fetchProfileViewData() async throws -> MyStats.FetchedProfileViewData 
  func fetchLongestRecordsViewData() async throws -> MyStats.FetchedLongestRecordViewData
  func fetchSummaryViewData() async throws -> MyStats.FetchedSummaryViewData
}
