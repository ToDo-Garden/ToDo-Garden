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
  func myGardenRequest(isSuccessful: Bool) async {
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
  func friendsGardenListRequest(isSuccessful: Bool) async {
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
