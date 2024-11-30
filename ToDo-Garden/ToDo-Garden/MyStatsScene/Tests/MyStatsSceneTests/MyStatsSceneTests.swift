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
      myName: "테스트유저",
      myImage: UIImage.defaultProfileImage,
      myGarden: PomodoroRecordCollection(
        pomodoroRecords: [
          PomodoroRecord(date: Date.distantPast, pomodoroCount: 33)
        ]
      )
    )
    
    self.worker.setProfileViewData(
      .init(
        continuousRecordCount: 10,
        continuousRecordStartDate: Date.distantPast,
        continuousRecordEndDate: Date.distantFuture
      )
    )
    self.worker.setSummaryViewData(
      .init(
        concentratedTime: 7200,
        completedCount: 5.5
      )
    )
    self.worker.setLongestRecordViewData(
      .init(
        concentratedRecordGroupName: "테스트그룹",
        concentratedRecordCount: 15,
        concentratedRecordDate: Date.distantPast,
        longestContinuousRecordCount: 7,
        longestContinuousRecordStartDate: Date.distantPast,
        longestContinuousRecordEndDate: Date.distantFuture
      )
    )
    
    let viewController = MyStatsViewController()
    let interactor = MyStatsInteractor(myStatsWorker: self.worker)
    let presenter = MyStatsPresenter()
    let mockDisplayLogic = MyStatsDisplayLogicMock()
    
    viewController.interactor = interactor
    interactor.presenter = presenter
    interactor.myName = mockPayload.myName
    interactor.myImage = mockPayload.myImage
    interactor.myGarden = mockPayload.myGarden
    
    presenter.viewController = mockDisplayLogic
    
    // 테스트결과 판별에 사용할 데이터
    let expectedViewModel = MyStats.LoadMyStatsViewData.ViewModel(
      profileViewModel: MyStats.ProfileViewModel(
        myName: "테스트유저",
        myImage: UIImage.defaultProfileImage,
        continuousRecordCount: 10,
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
        concentratedRecordGroupName: "테스트그룹",
        concentratedRecordCount: 15,
        concentratedRecordDate: Date.distantPast.toStringDefaultFormat(),
        longestContinuousRecordCount: 7,
        longestContinuousRecordStartDate: Date.distantPast.toStringDefaultFormat(),
        longestContinuousRecordEndDate: Date.distantFuture.toStringDefaultFormat()
      ),
      summaryViewModel: MyStats.SummaryViewModel(
        concentratedTime: "2시간",
        completedCount: "5.5개 목표"
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
    let expectedProfileData = MyStats.FetchedProfileViewData(
      continuousRecordCount: 42,
      continuousRecordStartDate: Date.distantPast,
      continuousRecordEndDate: Date.distantFuture
    )
    
    self.worker.setProfileViewData(expectedProfileData)
    
    let profileData = try await self.worker.fetchProfileViewData()
    
    #expect(profileData.continuousRecordCount == 42)
    #expect(profileData.continuousRecordStartDate == Date.distantPast)
    #expect(profileData.continuousRecordEndDate == Date.distantFuture)
  }
  
  @Test func testSuccessfulLongestRecordsViewDataFetch() async throws {
    self.resetWorker()
    let expectedLongestRecordData = MyStats.FetchedLongestRecordViewData(
      concentratedRecordGroupName: "테스트그룹",
      concentratedRecordCount: 15,
      concentratedRecordDate: Date.distantPast,
      longestContinuousRecordCount: 7,
      longestContinuousRecordStartDate: Date.distantPast,
      longestContinuousRecordEndDate: Date.distantFuture
    )
    
    self.worker.setLongestRecordViewData(expectedLongestRecordData)
    
    let longestRecordData = try await self.worker.fetchLongestRecordsViewData()
    
    #expect(longestRecordData.concentratedRecordGroupName == "테스트그룹")
    #expect(longestRecordData.concentratedRecordCount == 15)
    #expect(longestRecordData.concentratedRecordDate == Date.distantPast)
    #expect(longestRecordData.longestContinuousRecordCount == 7)
    #expect(longestRecordData.longestContinuousRecordStartDate == Date.distantPast)
    #expect(longestRecordData.longestContinuousRecordEndDate == Date.distantFuture)
  }
  
  @Test func testSuccessfulSummaryViewDataFetch() async throws {
    self.resetWorker()
    let expectedSummaryData = MyStats.FetchedSummaryViewData(
      concentratedTime: 7200,
      completedCount: 5.5
    )
    
    self.worker.setSummaryViewData(expectedSummaryData)
    
    let summaryData = try await self.worker.fetchSummaryViewData()
    
    #expect(summaryData.concentratedTime == 7200)
    #expect(summaryData.completedCount == 5.5)
  }
  
  @Test func testFailedDataFetch() async {
    self.resetWorker()
    self.worker.setError(HTTPClientError.badURL("SomeBadURL"))
    
    do {
      _ = try await self.worker.fetchProfileViewData()
    } catch let error {
      #expect(error is HTTPClientError)
    }
    
    do {
      _ = try await self.worker.fetchLongestRecordsViewData()
    } catch let error {
      #expect(error is HTTPClientError)
    }
    
    do {
      _ = try await self.worker.fetchSummaryViewData()
    } catch let error {
      #expect(error is HTTPClientError)
    }
  }
}

extension MyStatsViewSceneTests {
  private func resetWorker() {
    self.worker = MyStatsWorkerStub()
  }
}
// swiftlint:enable all
