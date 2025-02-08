// swiftlint:disable all
import Testing
import UIKit

import HTTPClientAPI
@testable import MyStatsScene
import MyStatsSceneAPI
import MyStatsSceneEntity
import ToDoGardenUIComponent // TODO: - PomodoroRecordCollection 이관 예정
import ToDoGardenUIResource

@MainActor
private final class MyStatsViewSceneTests {
  private var worker: MyStatsWorkerStub
  
  init() {
    self.worker = MyStatsWorkerStub()
  }

  @Test func testLoadMyStatsViewData() async {
    self.resetWorker()
    let mockPayload = MyStats.Payload(
      myGarden: PomodoroRecordCollection(
        pomodoroRecords: [
          PomodoroRecord(date: Date.distantPast, pomodoroCount: 33)
        ]
      )
    )
    
    self.worker.setProfileViewData(
      .init(
        nickname: "TestNickname",
        profileImage: nil,
        continuousRecordCount: 100,
        continuousRecordStartDate: Date.distantPast.toStringDefaultFormat(),
        continuousRecordEndDate: Date.distantFuture.toStringDefaultFormat()
      )
    )
    
    self.worker.setSummaryViewData(
      .init(
        dailyAverageFocusTime: 4000,
        weeklyAverageFocusTime: 4100,
        monthlyAverageFocusTime: 4200,
        dailyAveragePomodoroCount: 43,
        weeklyAveragePomodoroCount: 44,
        monthlyAveragePomodoroCount: 45
      )
    )
    
    self.worker.setLongestRecordViewData(
      .init(
        maxPomodoroRecord: .init(
          groupName: "TestGroupName",
          recordDate: Date.distantPast.toStringDefaultFormatWithSpace(),
          maxPomodoroCount: 16
        ),
        maxContinuousDays: .init(
          startDate: Date.distantPast.toStringDefaultFormatWithSpace(),
          endDate: Date.distantFuture.toStringDefaultFormatWithSpace(),
          maxCount: 17
        )
      )
    )
    
    let viewController = MyStatsViewController()
    let interactor = MyStatsInteractor(myStatsWorker: self.worker)
    let presenter = MyStatsPresenter()
    let mockDisplayLogic = MyStatsDisplayLogicMock()
    
    viewController.interactor = interactor
    interactor.presenter = presenter
    interactor.myGarden = mockPayload.myGarden
    
    presenter.viewController = mockDisplayLogic
    
    // 테스트결과 판별에 사용할 데이터
    let expectedViewModel = MyStats.LoadMyStatsViewData.ViewModel(
      profileViewModel: MyStats.ProfileViewModel(
        myName: "TestNickname",
        myImage: UIImage.defaultProfileImage,
        continuousRecordCount: 100,
        continuousRecordStartDate: Date.distantPast.toStringDefaultFormat(),
        continuousRecordEndDate: Date.distantFuture.toStringDefaultFormat()
      ),
      gardenViewModel: MyStats.GardenViewModel(
        pomodoroCollection: PomodoroRecordCollection(
          pomodoroRecords: [
            PomodoroRecord(date: Date.distantPast, pomodoroCount: 33)
          ]
        )
      ),
      longestRecordViewModel: MyStats.LongestRecordViewModel(
        concentratedRecordGroupName: "TestGroupName",
        concentratedRecordCount: 16,
        concentratedRecordDate: Date().toStringDefaultFormat(),
        longestContinuousRecordCount: 17,
        longestContinuousRecordStartDate: Date.distantPast.toStringDefaultFormatWithSpace(),
        longestContinuousRecordEndDate: Date.distantFuture.toStringDefaultFormatWithSpace()
      ),
      summaryViewModel: MyStats.SummaryViewModel(
        concentratedTime: "1시간 8분",
        completedCount: "44개 목표"
      )
    )
    viewController.loadMyStatsViewData()
    do {
      try await Task.sleep(nanoseconds: 500000000)
    } catch { return }
    
    #expect(mockDisplayLogic.result!.profileViewModel == expectedViewModel.profileViewModel)
    #expect(mockDisplayLogic.result!.gardenViewModel == expectedViewModel.gardenViewModel)
    #expect(mockDisplayLogic.result!.longestRecordViewModel == expectedViewModel.longestRecordViewModel)
    #expect(mockDisplayLogic.result!.summaryViewModel == expectedViewModel.summaryViewModel)
  }
}

// MockWorker Test
extension MyStatsViewSceneTests {
  @Test func testSuccessfulProfileViewDataFetch() async throws {
    self.resetWorker()
    let expectedProfileData: MyStats.FetchedProfileViewData = .init(
      nickname: "TestNickname",
      profileImage: nil,
      continuousRecordCount: 100,
      continuousRecordStartDate: Date.distantPast.toStringDefaultFormatWithSpace(),
      continuousRecordEndDate: Date.distantFuture.toStringDefaultFormatWithSpace()
    )
    
    self.worker.setProfileViewData(expectedProfileData)
    
    let profileData = try await self.worker.fetchProfileViewData()
    
    #expect(profileData.continuousRecordCount == expectedProfileData.continuousRecordCount)
    #expect(profileData.continuousRecordStartDate == expectedProfileData.continuousRecordStartDate)
    #expect(profileData.continuousRecordEndDate == expectedProfileData.continuousRecordEndDate)
  }
  
  @Test func testSuccessfulLongestRecordsViewDataFetch() async throws {
    self.resetWorker()
    let expectedLongestRecordData: MyStats.FetchedLongestRecordViewData = .init(
      maxPomodoroRecord: .init(
        groupName: "TestGroupName",
        recordDate: Date.distantPast.toStringDefaultFormatWithSpace(),
        maxPomodoroCount: 16
      ),
      maxContinuousDays: .init(
        startDate: Date.distantPast.toStringDefaultFormatWithSpace(),
        endDate: Date.distantFuture.toStringDefaultFormatWithSpace(),
        maxCount: 17
      )
    )
    
    self.worker.setLongestRecordViewData(expectedLongestRecordData)
    
    let longestRecordData = try await self.worker.fetchLongestRecordsViewData()
    
    #expect(longestRecordData.maxContinuousDays?.endDate == expectedLongestRecordData.maxContinuousDays?.endDate)
    #expect(longestRecordData.maxContinuousDays?.maxCount == expectedLongestRecordData.maxContinuousDays?.maxCount)
    #expect(longestRecordData.maxContinuousDays?.startDate == expectedLongestRecordData.maxContinuousDays?.startDate)
    #expect(longestRecordData.maxPomodoroRecord.maxPomodoroCount == expectedLongestRecordData.maxPomodoroRecord.maxPomodoroCount)
    #expect(longestRecordData.maxPomodoroRecord.groupName == expectedLongestRecordData.maxPomodoroRecord.groupName)
    #expect(longestRecordData.maxPomodoroRecord.recordDate == expectedLongestRecordData.maxPomodoroRecord.recordDate)
  }
  
  @Test func testSuccessfulSummaryViewDataFetch() async throws {
    self.resetWorker()
    let expectedSummaryData: MyStats.FetchedSummaryViewData =
      .init(
        dailyAverageFocusTime: 10,
        weeklyAverageFocusTime: 11,
        monthlyAverageFocusTime: 12,
        dailyAveragePomodoroCount: 13,
        weeklyAveragePomodoroCount: 14,
        monthlyAveragePomodoroCount: 15
      )
    
    self.worker.setSummaryViewData(expectedSummaryData)
    
    let summaryData = try await self.worker.fetchSummaryViewData()
    
    #expect(summaryData.dailyAverageFocusTime == expectedSummaryData.dailyAverageFocusTime)
    #expect(summaryData.weeklyAverageFocusTime == expectedSummaryData.weeklyAverageFocusTime)
    #expect(summaryData.monthlyAverageFocusTime == expectedSummaryData.monthlyAverageFocusTime)
    #expect(summaryData.dailyAveragePomodoroCount == expectedSummaryData.dailyAveragePomodoroCount)
    #expect(summaryData.weeklyAveragePomodoroCount == expectedSummaryData.weeklyAveragePomodoroCount)
    #expect(summaryData.monthlyAveragePomodoroCount == expectedSummaryData.monthlyAveragePomodoroCount)
  }
  
  @Test func testFailedDataFetchByBadURL() async {
    self.resetWorker()
    self.worker.setError(HTTPClientError.badURL("SomeBadURL"))
    
    do {
      _ = try await self.worker.fetchProfileViewData()
    } catch let error as HTTPClientError{
      switch error {
      case .badURL(let urlString):
        #expect(urlString == "SomeBadURL")
      default:
        Issue.record("Unexpected error: \(error)")
      }
    } catch let error {
      Issue.record("Unexpected error: \(error)")
    }
    
    do {
      _ = try await self.worker.fetchLongestRecordsViewData()
    } catch let error as HTTPClientError{
      switch error {
      case .badURL(let urlString):
        #expect(urlString == "SomeBadURL")
      default:
        Issue.record("Unexpected error: \(error)")
      }
    } catch let error {
      Issue.record("Unexpected error: \(error)")
    }
    
    do {
      _ = try await self.worker.fetchSummaryViewData()
    } catch let error as HTTPClientError{
      switch error {
      case .badURL(let urlString):
        #expect(urlString == "SomeBadURL")
      default:
        Issue.record("Unexpected error: \(error)")
      }
    } catch let error {
      Issue.record("Unexpected error: \(error)")
    }
  }
  
  @Test func testFailedDataFetchByDeserializationError() async {
    self.resetWorker()
    self.worker.setError(HTTPClientError.deserializationError)
    
    do {
      _ = try await self.worker.fetchProfileViewData()
    } catch let error as HTTPClientError{
      switch error {
      case .deserializationError:
        #expect(true)
      default:
        Issue.record("Unexpected error: \(error)")
      }
    } catch let error {
      Issue.record("Unexpected error: \(error)")
    }
    
    do {
      _ = try await self.worker.fetchLongestRecordsViewData()
    } catch let error as HTTPClientError{
      switch error {
      case .deserializationError:
        #expect(true)
      default:
        Issue.record("Unexpected error: \(error)")
      }
    } catch let error {
      Issue.record("Unexpected error: \(error)")
    }
    
    do {
      _ = try await self.worker.fetchSummaryViewData()
    } catch let error as HTTPClientError{
      switch error {
      case .deserializationError:
        #expect(true)
      default:
        Issue.record("Unexpected error: \(error)")
      }
    } catch let error {
      Issue.record("Unexpected error: \(error)")
    }
  }
}

extension MyStatsViewSceneTests {
  private func resetWorker() {
    self.worker = MyStatsWorkerStub()
  }
}
// swiftlint:enable all
