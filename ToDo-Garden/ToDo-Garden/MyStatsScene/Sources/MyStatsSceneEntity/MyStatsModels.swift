//
//  MyStatsModels.swift
//
//
//  Created by SONG on 11/13/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import ToDoGardenUIComponent // TODO: - PomodoroRecordCollection 이관 예정

public enum MyStats {
  
  // MARK: Use cases
  
  public enum LoadMyStatsViewData {
    public struct Request {
      public init() { }
    }
    
    public struct Response: Sendable {
      public let profileViewData: FetchedProfileViewData
      public let longestRecordViewData: FetchedLongestRecordViewData
      public let summaryViewData: FetchedSummaryViewData
      
      public init(
        profileViewData: FetchedProfileViewData,
        longestRecordViewData: FetchedLongestRecordViewData,
        summaryViewData: FetchedSummaryViewData
      ) {
        self.profileViewData = profileViewData
        self.longestRecordViewData = longestRecordViewData
        self.summaryViewData = summaryViewData
      }
    }
    
    public struct ViewModel {
      public let profileViewModel: ProfileViewModel
      public let gardenViewModel: GardenViewModel
      public let longestRecordViewModel: LongestRecordViewModel
      public let summaryViewModel: SummaryViewModel
      
      public init(
        profileViewModel: ProfileViewModel,
        gardenViewModel: GardenViewModel,
        longestRecordViewModel: LongestRecordViewModel,
        summaryViewModel: SummaryViewModel
      ) {
        self.profileViewModel = profileViewModel
        self.gardenViewModel = gardenViewModel
        self.longestRecordViewModel = longestRecordViewModel
        self.summaryViewModel = summaryViewModel
      }
    }
  }
}

extension MyStats {
  public struct ProfileViewModel: Sendable, Equatable {
    public let myName: String
    public let myImage: UIImage
    public let continuousRecordCount: Int
    public let continuousRecordStartDate: String
    public let continuousRecordEndDate: String
    
    public init(
      myName: String,
      myImage: UIImage,
      continuousRecordCount: Int,
      continuousRecordStartDate: String,
      continuousRecordEndDate: String
    ) {
      self.myName = myName
      self.myImage = myImage
      self.continuousRecordCount = continuousRecordCount
      self.continuousRecordStartDate = continuousRecordStartDate
      self.continuousRecordEndDate = continuousRecordEndDate
    }
  }
  
  public struct GardenViewModel: Sendable, Equatable {
    public let pomodoroCollection: PomodoroRecordCollection
    
    public init(pomodoroCollection: PomodoroRecordCollection) {
      self.pomodoroCollection = pomodoroCollection
    }
  }
  
  public struct LongestRecordViewModel: Sendable, Equatable {
    public let concentratedRecordGroupName: String
    public let concentratedRecordCount: Int
    public let concentratedRecordDate: String
    
    public let longestContinuousRecordCount: Int
    public let longestContinuousRecordStartDate: String
    public let longestContinuousRecordEndDate: String
    
    public init(
      concentratedRecordGroupName: String,
      concentratedRecordCount: Int,
      concentratedRecordDate: String,
      longestContinuousRecordCount: Int,
      longestContinuousRecordStartDate: String,
      longestContinuousRecordEndDate: String
    ) {
      self.concentratedRecordGroupName = concentratedRecordGroupName
      self.concentratedRecordCount = concentratedRecordCount
      self.concentratedRecordDate = concentratedRecordDate
      self.longestContinuousRecordCount = longestContinuousRecordCount
      self.longestContinuousRecordStartDate = longestContinuousRecordStartDate
      self.longestContinuousRecordEndDate = longestContinuousRecordEndDate
    }
  }
  
  public struct SummaryViewModel: Sendable, Equatable {
    public let concentratedTime: String
    public let completedCount: String
    
    public init(
      concentratedTime: String,
      completedCount: String
    ) {
      self.concentratedTime = concentratedTime
      self.completedCount = completedCount
    }
  }
}

// MARK: Data Models

extension MyStats {
  public struct FetchedProfileViewData: Sendable {
    public let nickname: String
    public let profileImage: UIImage?
    public let continuousRecordCount: Int
    public let continuousRecordStartDate: String
    public let continuousRecordEndDate: String
    
    public init(
      nickname: String,
      profileImage: UIImage?,
      continuousRecordCount: Int,
      continuousRecordStartDate: String,
      continuousRecordEndDate: String
    ) {
      self.nickname = nickname
      self.profileImage = profileImage
      self.continuousRecordCount = continuousRecordCount
      self.continuousRecordStartDate = continuousRecordStartDate
      self.continuousRecordEndDate = continuousRecordEndDate
    }
  }
  
  public struct FetchedLongestRecordViewData: Sendable, Codable {
    public let maxPomodoroRecord: MaxPomodoroRecordDTO?
    public let maxContinuousDays: MaxContinuousDaysDTO?
    
    public init(
      maxPomodoroRecord: MaxPomodoroRecordDTO?,
      maxContinuousDays: MaxContinuousDaysDTO?
    ) {
      self.maxPomodoroRecord = maxPomodoroRecord
      self.maxContinuousDays = maxContinuousDays
    }
  }
  
  public struct FetchedSummaryViewData: Sendable, Codable {
    public let dailyAverageFocusTime: Int
    public let weeklyAverageFocusTime: Int
    public let monthlyAverageFocusTime: Int
    
    public let dailyAveragePomodoroCount: Int
    public let weeklyAveragePomodoroCount: Int
    public let monthlyAveragePomodoroCount: Int
    
    public init(
      dailyAverageFocusTime: Int,
      weeklyAverageFocusTime: Int,
      monthlyAverageFocusTime: Int,
      dailyAveragePomodoroCount: Int,
      weeklyAveragePomodoroCount: Int,
      monthlyAveragePomodoroCount: Int
    ) {
      self.dailyAverageFocusTime = dailyAverageFocusTime
      self.weeklyAverageFocusTime = weeklyAverageFocusTime
      self.monthlyAverageFocusTime = monthlyAverageFocusTime
      self.dailyAveragePomodoroCount = dailyAveragePomodoroCount
      self.weeklyAveragePomodoroCount = weeklyAveragePomodoroCount
      self.monthlyAveragePomodoroCount = monthlyAveragePomodoroCount
    }
  }
}

extension MyStats {
  public enum MyStatsWorkerError: Error {
    case fetchProfileDataFailed
    case fetchLongestRecordDataFailed
    case fetchSummaryDataFailed
  }
  
  public struct ProfileViewDataDTO: Sendable, Codable {
    public let nickname: String
    public let imageUrl: String?
    public let continuousRecordStartDate: String
    public let continuousRecordEndDate: String
    public let continuousRecordCount: Int
    
    public init(
      nickname: String,
      imageUrl: String?,
      continuousRecordStartDate: String,
      continuousRecordEndDate: String,
      continuousRecordCount: Int
    ) {
      self.nickname = nickname
      self.imageUrl = imageUrl
      self.continuousRecordStartDate = continuousRecordStartDate
      self.continuousRecordEndDate = continuousRecordEndDate
      self.continuousRecordCount = continuousRecordCount
    }
  }
  
  public struct MaxPomodoroRecordDTO: Sendable, Codable {
    public let groupName: String
    public let recordDate: String
    public let maxPomodoroCount: Int
    
    public init(groupName: String, recordDate: String, maxPomodoroCount: Int) {
      self.groupName = groupName
      self.recordDate = recordDate
      self.maxPomodoroCount = maxPomodoroCount
    }
  }
  
  public struct MaxContinuousDaysDTO: Sendable, Codable {
    public let startDate: String
    public let endDate: String
    public let maxCount: Int
    
    public init(startDate: String, endDate: String, maxCount: Int) {
      self.startDate = startDate
      self.endDate = endDate
      self.maxCount = maxCount
    }
  }
}
