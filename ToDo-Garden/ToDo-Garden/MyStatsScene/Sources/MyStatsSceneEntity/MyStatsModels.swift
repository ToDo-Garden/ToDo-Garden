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
  
  public struct Payload {
    public let myName: String
    public let myImage: UIImage
    public let myGarden: PomodoroRecordCollection
    
    public init(myName: String, myImage: UIImage, myGarden: PomodoroRecordCollection) {
      self.myName = myName
      self.myImage = myImage
      self.myGarden = myGarden
    }
  }
}

// MARK: Data Models

extension MyStats {
  public struct FetchedProfileViewData: Sendable {
    public let continuousRecordCount: Int
    public let continuousRecordStartDate: Date
    public let continuousRecordEndDate: Date
    
    public init(
      continuousRecordCount: Int,
      continuousRecordStartDate: Date,
      continuousRecordEndDate: Date
    ) {
      self.continuousRecordCount = continuousRecordCount
      self.continuousRecordStartDate = continuousRecordStartDate
      self.continuousRecordEndDate = continuousRecordEndDate
    }
  }
  
  public struct FetchedLongestRecordViewData: Sendable {
    public let concentratedRecordGroupName: String
    public let concentratedRecordCount: Int
    public let concentratedRecordDate: Date
    
    public let longestContinuousRecordCount: Int
    public let longestContinuousRecordStartDate: Date
    public let longestContinuousRecordEndDate: Date
    
    public init(
      concentratedRecordGroupName: String,
      concentratedRecordCount: Int,
      concentratedRecordDate: Date,
      longestContinuousRecordCount: Int,
      longestContinuousRecordStartDate: Date,
      longestContinuousRecordEndDate: Date
    ) {
      self.concentratedRecordGroupName = concentratedRecordGroupName
      self.concentratedRecordCount = concentratedRecordCount
      self.concentratedRecordDate = concentratedRecordDate
      self.longestContinuousRecordCount = longestContinuousRecordCount
      self.longestContinuousRecordStartDate = longestContinuousRecordStartDate
      self.longestContinuousRecordEndDate = longestContinuousRecordEndDate
    }
  }
  
  public struct FetchedSummaryViewData: Sendable {
    public let concentratedTime: Int
    public let completedCount: Double
    
    public init(
      concentratedTime: Int,
      completedCount: Double
    ) {
      self.concentratedTime = concentratedTime
      self.completedCount = completedCount
    }
  }
}

extension MyStats {
  public enum MyStatsWorkerError: Error {
    case fetchProfileDataFailed
    case fetchLongestRecordDataFailed
    case fetchSummaryDataFailed
  }
}
