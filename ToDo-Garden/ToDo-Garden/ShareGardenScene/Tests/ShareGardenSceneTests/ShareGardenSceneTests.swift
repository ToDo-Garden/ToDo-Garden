//
//  ShareGardenSceneTests.swift
//  ShareGardenScene
//
//  Created by Noah on 10/8/24.
//

import Testing
import UIKit

import ToDoGardenUIComponent

@testable import ShareGardenScene
import ShareGardenSceneAPI
import ShareGardenSceneEntity

@MainActor
final class ShareGardenSceneTests {
  private let window: UIWindow
  private let shareGardenScene: ShareGardenSceneViewController
  private let shareGardenSceneWorkerMock: ShareGardenSceneWorkerMock
  private let interactor: ShareGardenSceneInteractor
  private let presenter: ShareGardenScenePresenter
  
  private let sut: ShareGardenSceneViewControllerStub
  
  init() {
    self.window = UIWindow()
    self.shareGardenSceneWorkerMock = ShareGardenSceneWorkerMock()
    self.interactor = ShareGardenSceneInteractor(shareGardenSceneWorker: self.shareGardenSceneWorkerMock)
    self.shareGardenScene = ShareGardenSceneViewController(friendsGardenStore: self.interactor)
    self.presenter = ShareGardenScenePresenter()
    self.sut = ShareGardenSceneViewControllerStub()
    self.configureUnitTestVIPCycle()
  }
}

// swiftlint:disable function_body_length
extension ShareGardenSceneTests {
  @Test(arguments: [true, false])
  private func myGardenRequest(isSuccessful: Bool) async {
    // Given
    await self.shareGardenSceneWorkerMock.setIsSuccessful(isSuccessful)
    let pomodoroRecords = [PomodoroRecord(date: Date(), pomodoroCount: 0)]
    let expectedMyGarden = ShareGardenScene.MyGarden(
      nickname: UUID().uuidString,
      description: UUID().uuidString,
      pomodoroRecords: PomodoroRecordCollection(pomodoroRecords: pomodoroRecords)
    )
    await self.shareGardenSceneWorkerMock.setMyGarden(expectedMyGarden)
    
    // When
    self.loadView()
    
    // Then
    await withTaskGroup(of: Void.self) { group in
      group.addTask {
        for await viewModel in self.sut.myGardenStream {
          guard isSuccessful else { fatalError("성공 시나리오에 대한 테스트입니다.") }
          #expect(viewModel.nickname == expectedMyGarden.nickname)
          #expect(viewModel.description == expectedMyGarden.description)
          #expect(viewModel.pomodoroRecords == expectedMyGarden.pomodoroRecords)
          #expect(isSuccessful)
          return
        }
      }
      
      group.addTask {
        for await _ in self.sut.myGardenRequestErrorStream {
          guard isSuccessful == false else { fatalError("실패 시나리오에 대한 테스트입니다.") }
          
          #expect(isSuccessful == false)
          return
        }
      }
      
      await group.next()
      group.cancelAll()
    }
  }
  
  @Test(arguments: [true, false])
  private func friendsGardenListRequest(isSuccessful: Bool) async {
    // Given
    await self.shareGardenSceneWorkerMock.setIsSuccessful(isSuccessful)
    let pomodoroRecords = [PomodoroRecord(date: Date(), pomodoroCount: 0)]
    let expectedFriendsGardenList = [
      ShareGardenScene.FriendsGarden(
        nickname: UUID().uuidString,
        focusStreakDays: Int.random(
          in: 0..<100
        ),
        pomodoroRecords: PomodoroRecordCollection(
          pomodoroRecords: pomodoroRecords
        )
      ),
      ShareGardenScene.FriendsGarden(
        nickname: UUID().uuidString,
        focusStreakDays: Int.random(
          in: 0..<100
        ),
        pomodoroRecords: PomodoroRecordCollection(
          pomodoroRecords: pomodoroRecords
        )
      ),
      ShareGardenScene.FriendsGarden(
        nickname: UUID().uuidString,
        focusStreakDays: Int.random(in: 0..<100),
        pomodoroRecords: PomodoroRecordCollection(pomodoroRecords: pomodoroRecords)
      )
    ]
    await self.shareGardenSceneWorkerMock.setFriendsGardenList(expectedFriendsGardenList)
    
    // When
    self.loadView()
    
    // Then
    await withTaskGroup(of: Void.self) { group in
      group.addTask {
        var isShimmeringStopped = false
        for await _ in self.sut.shimmeringStopStream {
          isShimmeringStopped = true
          self.sut.shimmeringStopStreamContinuation.finish()
        }
        
        for await viewModel in self.sut.friendsGardenListStream {
          guard isSuccessful else { fatalError("성공 시나리오에 대한 테스트 입니다.") }
          
          #expect(isShimmeringStopped)
          #expect(viewModel.identifiers == expectedFriendsGardenList.map { $0.id })
          #expect(isSuccessful)
          return
        }
      }
      
      group.addTask {
        for await _ in self.sut.friendsGardenListRequestErrorStream {
          guard isSuccessful == false else { fatalError("실패 시나리오에 대한 테스트 입니다.") }
          #expect(isSuccessful == false)
          return
        }
      }
      
      await group.next()
      group.cancelAll()
    }
  }
  
  @Test(arguments: [true, false])
  private func deleteFriendsGarden(isSuccessful: Bool) async {
    // Given
    let pomodoroRecords = [PomodoroRecord(date: Date(), pomodoroCount: 0)]
    let sourceFriendsGardenList = [
      ShareGardenScene.FriendsGarden(
        nickname: UUID().uuidString,
        focusStreakDays: Int.random(
          in: 0..<100
        ),
        pomodoroRecords: PomodoroRecordCollection(
          pomodoroRecords: pomodoroRecords
        )
      ),
      ShareGardenScene.FriendsGarden(
        nickname: UUID().uuidString,
        focusStreakDays: Int.random(
          in: 0..<100
        ),
        pomodoroRecords: PomodoroRecordCollection(
          pomodoroRecords: pomodoroRecords
        )
      ),
      ShareGardenScene
        .FriendsGarden(
          nickname: UUID().uuidString,
          focusStreakDays: Int.random(
            in: 0..<100
          ),
          pomodoroRecords: PomodoroRecordCollection(
            pomodoroRecords: pomodoroRecords
          )
        )
    ]
    await self.shareGardenSceneWorkerMock.setFriendsGardenList(sourceFriendsGardenList)
    await self.shareGardenSceneWorkerMock.setIsSuccessful(true)
    let deleteTargetFriendsGarden = sourceFriendsGardenList[0]
    let expectedDeleteResult: [UUID] = sourceFriendsGardenList
      .filter { $0.id != deleteTargetFriendsGarden.id }
      .map { $0.id }
    
    self.loadView()
    
    /// 삭제 요청이 진행되었는지 여부를 나타내는 변수입니다.
    var isDeleteExecuted = false
    /// 롤백 요청이 진행되었는지 여부를 나타내는 변수입니다.
    var isRollbackExecuted = false
    
    for await viewModel in self.sut.friendsGardenListStream {
      if isDeleteExecuted == false {
        await self.shareGardenSceneWorkerMock.setIsSuccessful(isSuccessful)
        // When
        self.interactor.delete(by: deleteTargetFriendsGarden.id)
        isDeleteExecuted = true
        continue
      }
      
      if isDeleteExecuted {
        // Then
        if isSuccessful {
          // 삭제에 성공했을 경우, 삭제 기대값과 같아야합니다.
          #expect(viewModel.identifiers == expectedDeleteResult)
          self.sut.friendsGardenListStreamContinuation.finish()
        }
        
        if isSuccessful == false {
          if isRollbackExecuted == false {
            // 먼저 사용자에게 삭제가 반영된 친구 목록 리스트를 표시합니다.
            #expect(viewModel.identifiers == expectedDeleteResult)
            isRollbackExecuted = true
            continue
          }
          
          // 삭제에 실패했을 경우, 삭제 이전의 친구 목록 리스트를 표시합니다.
          #expect(viewModel.identifiers == sourceFriendsGardenList.map { $0.id })
          self.sut.friendsGardenListStreamContinuation.finish()
        }
      }
    }
  }
}
// swiftlint:enable function_body_length

extension ShareGardenSceneTests {
  private func configureUnitTestVIPCycle() {
    self.shareGardenScene.interactor = self.interactor
    self.interactor.presenter = self.presenter
    self.presenter.viewController = self.sut
    self.sut.viewController = self.shareGardenScene
  }
  
  private func loadView() {
    self.window.addSubview(self.shareGardenScene.view)
  }
}
