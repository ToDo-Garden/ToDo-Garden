// swiftlint:disable all
import Foundation
import Testing

@testable import SearchGardenScene
import SearchGardenSceneAPI
import SearchGardenSceneEntity

@MainActor
final class SearchGardenSceneTests{
  private var worker: SearchGardenWorkerStub
  private let viewController: SearchGardenViewController
  private let interactor: SearchGardenInteractor
  private let presenter: SearchGardenPresenter
  private let destination: SearchGardenDisplayLogicStub
  
  init() {
    self.worker = SearchGardenWorkerStub()
    self.viewController = SearchGardenViewController()
    self.interactor = SearchGardenInteractor(searchGardenWorker: self.worker)
    self.presenter = SearchGardenPresenter()
    self.destination = SearchGardenDisplayLogicStub()
    self.configureVIP()
  }
  
  @Test func testSearchAllUser() async {
    self.reset()
    self.viewController.loadSearchedGarden(inputText: "")
    await self.wait()
    #expect(self.destination.currentList == AllUsersMock.filterUsers(by: ""))
  }
  
  @Test func testSearchSpecificUser() async {
    self.reset()
    self.viewController.loadSearchedGarden(inputText: "noah")
    await self.wait()
    #expect(self.destination.currentList == AllUsersMock.filterUsers(by: "noah"))
  }
  
  @Test func testLoadFriendGarden() async {
    self.reset()
    let expectedUserID = AllUsersMock.getRandomUserUUID()!
    let expectedUserDetail = AllUsersMock.getUserDetails(by: expectedUserID)
    self.worker.setLoadFriendGardenData(isFriend: true)
    self.viewController.loadFriendGarden(
      userID: expectedUserID,
      userImage: expectedUserDetail?.userImage
    )
    await self.wait()
    #expect(self.destination.currentFriendGarden?.isButtonEnable == false)
    #expect(self.destination.currentFriendGarden?.userImage == expectedUserDetail?.userImage)
    #expect(self.destination.currentFriendGarden?.userIntroduction == expectedUserDetail?.customId)
    #expect(self.destination.currentFriendGarden?.userNickname == expectedUserDetail?.nickname)
    #expect(self.destination.currentFriendGarden?.userGarden == [])
    
    self.reset()
    self.worker.setLoadFriendGardenData(isFriend: false)
    self.viewController.loadFriendGarden(
      userID: expectedUserID,
      userImage: expectedUserDetail?.userImage
    )
    await self.wait()
    #expect(self.destination.currentFriendGarden?.isButtonEnable == true)
  }
  
  @Test func testAddGarden() async {
    self.reset()
    let expectedUserID = AllUsersMock.getRandomUserUUID()!
    let expectedUserDetail = AllUsersMock.getUserDetails(by: expectedUserID)
    self.worker.setLoadFriendGardenData(isFriend: false)
    self.viewController.loadFriendGarden(userID: expectedUserID, userImage: expectedUserDetail?.userImage)
    await self.wait()
    
    self.viewController.addGarden()
    
    await self.wait()
    #expect(self.destination.isAddingDone == true)
    
    self.reset()
    self.worker.setLoadFriendGardenData(isFriend: false)
    self.viewController.loadFriendGarden(userID: expectedUserID, userImage: expectedUserDetail?.userImage)
    await self.wait()
    
    self.worker.setError(NSError())
    self.viewController.addGarden()
    await self.wait()
    #expect(self.destination.isAddingDone == false)
  }

  @Test func testBuilder() {
    self.reset()
    let builder = SearchGardenSceneBuilder(dependency: .init(searchGardenWorker: self.worker))
    let viewController = builder.build()
    #expect(viewController is SearchGardenViewController)
  }
}

extension SearchGardenSceneTests {
  private func reset() {
    self.worker.reset()
    self.destination.reset()
  }
  
  private func configureVIP() {
    self.viewController.interactor = self.interactor
    self.interactor.presenter = self.presenter
    self.presenter.viewController = self.destination
  }
  
  private func wait() async {
    do {
      try await Task.sleep(nanoseconds: 60000000)
    } catch {
      return
    }
  }
}

// swiftlint:enable all
