//
//  PostGroupDisplayLogicStub.swift
//  PostGroupScene
//
//  Created by SONG on 2/10/25.
//

// swiftlint:disable all
import UIKit

@testable import PostGroupScene
import PostGroupSceneAPI
import PostGroupSceneEntity

final class PostGroupDisplayLogicStub: PostGroupDisplayLogic {
  var groupColor: UIColor = UIColor.white
  var currentGroup: PostGroupSceneEntity.PostGroup.ToDoGroup? = nil
  var currentTitle: String? = nil
  var isCalledAfterTouchingDoneButton: Bool = false
  
  func displayChangedColor(viewModel: PostGroupSceneEntity.PostGroup.ChangeColor.ViewModel) {
    self.groupColor = viewModel.groupColor
  }
  
  func displayPayload(viewModel: PostGroupSceneEntity.PostGroup.LoadGroupData.ViewModel) {
    self.currentGroup = .init(
      groupID: UUID(),
      groupName: viewModel.groupName,
      groupColor: viewModel.groupColor ?? UIColor.toDoGardenGrassNone
    )
    self.currentTitle = viewModel.sceneTitle
  }
  
  func displayAfterTouchingDoneButton(viewModel: PostGroupSceneEntity.PostGroup.TouchDoneButton.ViewModel) {
    self.isCalledAfterTouchingDoneButton = true
  }
  
  func reset() {
    self.groupColor = UIColor.white
    self.currentGroup = nil
    self.currentTitle = nil
    self.isCalledAfterTouchingDoneButton = false
  }
}
// swiftlint:enable all
