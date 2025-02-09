//
//  ManageGroupTableViewDelegateTest.swift
//  ManageGroupScene
//
//  Created by SONG on 2/9/25.
//

// swiftlint:disable all
import Testing
import UIKit

@testable import ManageGroupScene
import ManageGroupSceneEntity
import ManageGroupSceneAPI
import ToDoGardenUIComponent

@MainActor
final class ManageGroupTableViewDelegateTests {
  var delegateObject: ManageGroupTableViewDelegate!
  var mockTableView: UITableView!
  var mockGroups: [ManageGroup.ToDoGroup]!
  
  init() {
    self.mockGroups = [
      ManageGroup.ToDoGroup(groupID: UUID(), groupName: "Test1", progressColor: .red, progressRate: 0.5)
    ]
    self.delegateObject = ManageGroupTableViewDelegate(displayedGroups: self.mockGroups, footerView: UIView())
    self.mockTableView = UITableView()
    self.mockTableView.register(MockManageGroupTableViewCell.self, forCellReuseIdentifier: ManageGroupTableViewCell.identifier)
  }
  
  @Test
  func testOnDeleteGroupIsCalled() {
    var callCount = 0
    var receivedID: UUID?
    var receivedIndex: Int?
    
    self.delegateObject.setOnDeleteGroup { id, index in
      callCount += 1
      receivedID = id
      receivedIndex = index
    }
    
    let indexPath = IndexPath(row: 0, section: 0)
    self.delegateObject.tableView(mockTableView, commit: .delete, forRowAt: indexPath)
    
    #expect(callCount == 1)
    #expect(receivedID == self.delegateObject.displayedGroups[0].groupID)
    #expect(receivedIndex == 0)
  }
}

// MARK: - Mock Objects
class MockManageGroupTableViewCell: UITableViewCell {
  var rightButtonAction: ((UUID, String, UIColor) -> Void)?
  
  func rightButtonTapped(id: UUID, name: String, color: UIColor) {
    self.rightButtonAction?(id, name, color)
  }
}
// swiftlint:enable all
