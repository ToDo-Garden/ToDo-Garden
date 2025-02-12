// swiftlint:disable all
import Testing
import UIKit

@testable import PostGroupScene
import PostGroupSceneAPI
import PostGroupSceneEntity

@MainActor
final class PostGroupSceneTests {
  private var delegate: PostGroupSceneDelegateStub
  private var viewController: PostGroupViewController
  private var interactor: PostGroupInteractor
  private var presenter: PostGroupPresenter
  private var desitantion: PostGroupDisplayLogicStub
  
  init() {
    self.delegate = PostGroupSceneDelegateStub()
    self.viewController = PostGroupViewController()
    self.interactor = PostGroupInteractor(postGroupWorker: PostGroupWorker())
    self.presenter = PostGroupPresenter()
    self.desitantion = PostGroupDisplayLogicStub()
    self.configuraVIP()
  }
  
  @Test func testPayload() {
    self.reset()
    let builder = PostGroupSceneBuilder(dependency: .init(postGroupWorker: PostGroupWorker()))
    let expectedGroupID = UUID()
    let expectedGroupName = expectedGroupID.uuidString
    let expectedGroupColor: UIColor = .red
    let payload = PayloadMock(group: .init(groupID: expectedGroupID, groupName: expectedGroupName, groupColor: expectedGroupColor))
    guard let viewController = builder.build(with: payload, delegate: self.delegate) as? PostGroupViewController,
    let interactor = viewController.interactor as? PostGroupInteractor else {
      fatalError()
    }
    #expect(interactor.currentGroup?.groupID == expectedGroupID)
    #expect(interactor.currentGroup?.groupName == expectedGroupName)
    #expect(interactor.currentGroup?.groupColor == expectedGroupColor)
  }
  
  @Test func testEditGroup() {
    self.reset()
    let expectedGroupID = UUID()
    let expectedGroupName = "TestEditGroup"
    let expectedGroupColor: UIColor = .red
    let expectedGroup = PostGroup.TouchDoneButton.Request(
      groupName: expectedGroupName,
      groupColor: expectedGroupColor
    )
    self.interactor.currentGroup = .init(
      groupID: expectedGroupID,
      groupName: "mustBeChanged",
      groupColor: UIColor.white
    )
    
    self.interactor.touchDoneButton(request: expectedGroup)
    #expect(self.delegate.editedGroup?.groupID == expectedGroupID)
    #expect(self.delegate.editedGroup?.groupColor == expectedGroupColor)
    #expect(self.delegate.editedGroup?.groupName == expectedGroupName)
    #expect(self.delegate.addedGroup == nil)
    #expect(self.desitantion.isCalledAfterTouchingDoneButton == true)
  }
  
  @Test func testAddGroup() {
    self.reset()
    let expectedGroupID: UUID? = nil
    let expectedGroupName = "TestAddGroup"
    let expectedGroupColor: UIColor = .red
    let expectedGroup = PostGroup.TouchDoneButton.Request(
      groupName: expectedGroupName,
      groupColor: expectedGroupColor
    )
    self.interactor.currentGroup = .init(
      groupID: expectedGroupID,
      groupName: "mustBeChanged",
      groupColor: UIColor.white
    )
    
    self.interactor.touchDoneButton(request: expectedGroup)
    #expect(self.delegate.addedGroup?.groupID == expectedGroupID)
    #expect(self.delegate.addedGroup?.groupColor == expectedGroupColor)
    #expect(self.delegate.addedGroup?.groupName == expectedGroupName)
    #expect(self.delegate.editedGroup == nil)
    #expect(self.desitantion.isCalledAfterTouchingDoneButton == true)
  }
  
  @Test func testChangeColor() {
    self.reset()
    let expectedColor = UIColor.blue
    self.interactor.changeColor(request: PostGroup.ChangeColor.Request.init(groupColor: expectedColor))
    
    #expect(self.desitantion.groupColor == expectedColor)
  }
  
  @Test func testLoadGroupData() {
    self.reset()
    self.viewController.loadGroupData()
    #expect(self.desitantion.currentGroup != nil)
    #expect(self.desitantion.currentTitle != nil)
  }
}

extension PostGroupSceneTests {
  private func reset() {
    self.delegate.reset()
    self.desitantion.reset()
  }
  
  private func configuraVIP() {
    self.viewController.interactor = self.interactor
    self.interactor.presenter = self.presenter
    self.interactor.delegate = self.delegate
    self.presenter.viewController = self.desitantion
  }
}
// swiftlint:enable all
