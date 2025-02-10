// swiftlint:disable all
import Testing
import Foundation

@testable import SignUpScene
import SignUpSceneAPI
import SignUpSceneEntity

@MainActor
final class SignUpSceneTests {
  private let worker: SignUpWorkerStub
  private let viewController: SignUpViewController
  private let interactor: SignUpInteractor
  private let presenter: SignUpPresenter
  private let destination: SignUpDisplayLogicStub
  
  init() {
    self.worker = SignUpWorkerStub()
    self.viewController = SignUpViewController()
    self.interactor = SignUpInteractor(signUpWorker: self.worker)
    self.presenter = SignUpPresenter()
    self.destination = SignUpDisplayLogicStub()
    self.configureVIP()
  }
  
  @Test func testStringValidation_ValidID() {
    self.reset()
    let id = SignUp.CheckStringValidation.Request(
      text: "ValidID",
      currentPageIndex: 0
    )
    self.interactor.checkStringValidation(request: id)
    #expect(self.destination.isValidString == true)
  }
  
  @Test func testStringValidation_ValidIntro() {
    self.reset()
    let introduction = SignUp.CheckStringValidation.Request(
      text: "Introduction",
      currentPageIndex: 1
    )
    self.interactor.checkStringValidation(request: introduction)
    #expect(self.destination.isValidString == true)
  }
  
  @Test func testStringValidation_ValidIntro_Blank() {
    self.reset()
    let introduction = SignUp.CheckStringValidation.Request(
      text: "",
      currentPageIndex: 1
    )
    self.interactor.checkStringValidation(request: introduction)
    #expect(self.destination.isValidString == true)
  }
  
  @Test func testStringValidation_ValidNickname() {
    self.reset()
    let introduction = SignUp.CheckStringValidation.Request(
      text: "Nickname",
      currentPageIndex: 2
    )
    self.interactor.checkStringValidation(request: introduction)
    #expect(self.destination.isValidString == true)
  }
  
  @Test func testStringValidation_InvalidID() {
    self.reset()
    let id = SignUp.CheckStringValidation.Request(
      text: "!@",
      currentPageIndex: 0
    )
    self.interactor.checkStringValidation(request: id)
    #expect(self.destination.isValidString == false)
  }
  
  @Test func testStringValidation_InalidIntro() {
    self.reset()
    let introduction = SignUp.CheckStringValidation.Request(
      text: "Too looooooooooooooooooooooooooooooooong Introduction",
      currentPageIndex: 1
    )
    self.interactor.checkStringValidation(request: introduction)
    #expect(self.destination.isValidString == false)
  }
  
  @Test func testStringValidation_InvalidNickname() {
    self.reset()
    let introduction = SignUp.CheckStringValidation.Request(
      text: "Too looooooooooooooooooooooooooooooooong Nickname",
      currentPageIndex: 2
    )
    self.interactor.checkStringValidation(request: introduction)
    #expect(self.destination.isValidString == false)
  }
  
  @Test func testUserRegistration_Success() async {
    self.reset()
    let userInfo = SignUp.RegisterUser.Request(
      customId: "CustomID",
      nickname: "Nickname",
      introduction: nil
    )
    
    self.interactor.registerUser(request: userInfo)
    await self.wait()
    #expect(self.destination.isRegistrationSuccess == true)
  }
  
  @Test func testUserRegistration_Fail_ExistingID() async {
    self.reset()
    let userInfo = SignUp.RegisterUser.Request(
      customId: "ExistingID",
      nickname: "Nickname",
      introduction: nil
    )
    self.worker.setErrorAboutExistingID()
    self.interactor.registerUser(request: userInfo)
    await self.wait()
    #expect(self.destination.isRegistrationSuccess == false)
    #expect(self.destination.catchedError is SignUp.SignUpError)
  }
  
  @Test func testUserRegistration_Fail_UnknownError() async {
    self.reset()
    let userInfo = SignUp.RegisterUser.Request(
      customId: "CustomID",
      nickname: "Nickname",
      introduction: nil
    )
    self.worker.setError()
    self.interactor.registerUser(request: userInfo)
    await self.wait()
    #expect(self.destination.isRegistrationSuccess == false)
  }
}

extension SignUpSceneTests {
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
      try await Task.sleep(nanoseconds: 40000000)
    } catch {
      return
    }
  }
}
// swiftlint:enable all
