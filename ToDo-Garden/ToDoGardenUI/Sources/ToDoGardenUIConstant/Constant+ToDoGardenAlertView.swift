//
//  Constant+ToDoGardenAlertView.swift
//
//
//  Created by SONG on 4/30/24.
//

import Foundation

extension Constant.ToDoGardenAlertView {
  public enum Alpha {}
  
  public enum Content {
    case welldone
    case askToStop
    case fullyCharged
    case askToDeleteToDo
    case askToDeleteGroup
    case askToUnsubscribe
    case askToLogout
    case askToStopResting
  }
}

extension Constant.ToDoGardenAlertView.Alpha {
  public static let touchedAlpha = 0.7
  public static let normalAlpha = 1.0
}

extension Constant.ToDoGardenAlertView.Content {
  public struct ViewState {
    public let backPlane: BackPlaneState
    public let title: TitleViewState
    public let description: DescriptionViewState
    public let buttons: [ButtonLabelState]
    public let stackView: StackViewState
  }
  
  public struct BackPlaneState {
    public let width: CGFloat
    public let height: CGFloat
    public let cornerRadius: CGFloat
  }
  
  public struct TitleViewState {
    public let text: String
    public let topMargin: CGFloat
  }
  
  public struct DescriptionViewState {
    public let text: String
    public let topMargin: CGFloat
    public let numberOfLines: Int
    
    init(text: String, topMargin: CGFloat, numberOfLines: Int = 2) {
      self.text = text
      self.topMargin = topMargin
      self.numberOfLines = numberOfLines
    }
  }
  
  public struct ButtonLabelState {
    public let text: String
    public let isRed: Bool
    public let buttonActionType: ButtonActionType
  }
  
  public struct StackViewState {
    public let isHorizontal: Bool
    public let height: CGFloat
    public let dividerThickness: CGFloat
    
    init(isHorizontal: Bool, height: CGFloat, dividerThickness: CGFloat = 1.0) {
      self.isHorizontal = isHorizontal
      self.height = height
      self.dividerThickness = dividerThickness
    }
  }
  
  public enum ButtonActionType {
    case cancel
    case keepConcentration
    case goHome
    case delete
    case unsubscribe
    case logout
    case stopConcentration
  }
  
  public var viewState: ViewState {
    switch self {
    case .welldone:
      return ViewState(
        backPlane: BackPlaneState(width: 273.0, height: 246.0, cornerRadius: 20.0),
        title: TitleViewState(text: "수고했어요!", topMargin: 24.0),
        description: DescriptionViewState(text: "오늘도 열심히 집중한 당신!\n이제 조금 쉬어볼까요?", topMargin: 61.0),
        buttons: [
          ButtonLabelState(text: "휴식하기", isRed: false, buttonActionType: ButtonActionType.stopConcentration),
          ButtonLabelState(text: "더 집중하기", isRed: false, buttonActionType: ButtonActionType.keepConcentration),
          ButtonLabelState(text: "홈으로", isRed: true, buttonActionType: ButtonActionType.goHome)
        ],
        stackView: StackViewState(isHorizontal: false, height: 43.0)
      )
      
    case .askToStop:
      return ViewState(
        backPlane: BackPlaneState(width: 273.0, height: 206.0, cornerRadius: 20.0),
        title: TitleViewState(text: "그만할까요?", topMargin: 42.0),
        description: DescriptionViewState(text: "그만하면\n기록으로 돌아갈 수 있어요.", topMargin: 84.0),
        buttons: [
          ButtonLabelState(text: "포기하기", isRed: true, buttonActionType: ButtonActionType.stopConcentration),
          ButtonLabelState(text: "집중하기", isRed: false, buttonActionType: ButtonActionType.cancel)
        ],
        stackView: StackViewState(isHorizontal: true, height: 51.0)
      )
      
    case .fullyCharged:
      return ViewState(
        backPlane: BackPlaneState(width: 273.0, height: 206.0, cornerRadius: 20.0),
        title: TitleViewState(text: "충전완료!", topMargin: 42.0),
        description: DescriptionViewState(text: "이제 다시 열심히\n힘을 내볼까요?", topMargin: 84.0),
        buttons: [
          ButtonLabelState(text: "홈으로", isRed: true, buttonActionType: ButtonActionType.goHome),
          ButtonLabelState(text: "집중하기", isRed: false, buttonActionType: ButtonActionType.keepConcentration)
        ],
        stackView: StackViewState(isHorizontal: true, height: 51.0)
      )
      
    case .askToDeleteToDo:
      return ViewState(
        backPlane: BackPlaneState(width: 273.0, height: 206.0, cornerRadius: 20.0),
        title: TitleViewState(text: "삭제할까요?", topMargin: 42.0),
        description: DescriptionViewState(text: "한 번 삭제하면 되돌릴 수 없어요.", topMargin: 84.0),
        buttons: [
          ButtonLabelState(text: "취소하기", isRed: false, buttonActionType: ButtonActionType.cancel),
          ButtonLabelState(text: "삭제하기", isRed: true, buttonActionType: ButtonActionType.delete)
        ],
        stackView: StackViewState(isHorizontal: true, height: 51.0)
      )
      
    case .askToDeleteGroup:
      return ViewState(
        backPlane: BackPlaneState(width: 273.0, height: 206.0, cornerRadius: 20.0),
        title: TitleViewState(text: "그룹을 삭제하시겠습니까?", topMargin: 42.0),
        description: DescriptionViewState(text: "그룹에 포함되어 있던\n투두들은 모두 삭제됩니다", topMargin: 84.0),
        buttons: [
          ButtonLabelState(text: "취소", isRed: false, buttonActionType: ButtonActionType.cancel),
          ButtonLabelState(text: "삭제하기", isRed: true, buttonActionType: ButtonActionType.delete)
        ],
        stackView: StackViewState(isHorizontal: true, height: 51.0)
      )
      
    case .askToUnsubscribe:
      return ViewState(
        backPlane: BackPlaneState(width: 273.0, height: 206.0, cornerRadius: 20.0),
        title: TitleViewState(text: "서비스 탈퇴", topMargin: 42.0),
        description: DescriptionViewState(text: "정말로 탈퇴하시겠습니까?\n회원 탈퇴 시 모든 정보는\n복구할 수 없습니다.", topMargin: 84.0),
        buttons: [
          ButtonLabelState(text: "탈퇴하기", isRed: true, buttonActionType: ButtonActionType.unsubscribe),
          ButtonLabelState(text: "취소", isRed: false, buttonActionType: ButtonActionType.cancel)
        ],
        stackView: StackViewState(isHorizontal: true, height: 51.0)
      )
      
    case .askToLogout:
      return ViewState(
        backPlane: BackPlaneState(width: 273.0, height: 206.0, cornerRadius: 20.0),
        title: TitleViewState(text: "로그아웃", topMargin: 42.0),
        description: DescriptionViewState(text: "정말 로그아웃 하시겠습니까?", topMargin: 84.0),
        buttons: [
          ButtonLabelState(text: "로그아웃", isRed: true, buttonActionType: ButtonActionType.logout),
          ButtonLabelState(text: "취소", isRed: false, buttonActionType: ButtonActionType.cancel)
        ],
        stackView: StackViewState(isHorizontal: true, height: 51.0)
      )
      
    case .askToStopResting:
      return ViewState(
        backPlane: BackPlaneState(width: 273.0, height: 206.0, cornerRadius: 20.0),
        title: TitleViewState(text: "그만 쉴까요?", topMargin: 42.0),
        description: DescriptionViewState(text: "이제 다시 열심히\n힘을 내볼까요?", topMargin: 84.0),
        buttons: [
          ButtonLabelState(text: "홈으로", isRed: true, buttonActionType: ButtonActionType.goHome),
          ButtonLabelState(text: "집중하기", isRed: false, buttonActionType: ButtonActionType.keepConcentration)
        ],
        stackView: StackViewState(isHorizontal: true, height: 51.0)
      )
    }
  }
}
