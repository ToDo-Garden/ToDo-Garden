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
    case deleteToDoRepeat
    case askToStop
    case fullyCharged
    case askToDeleteToDo
    case askToDeleteGroup
    case askToUnsubscribe
    case askToLogout
    case askToStopResting
    case failToFetchToDo
    case errorOccurred(String)
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
    
    init(text: String, topMargin: CGFloat, numberOfLines: Int = 3) {
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
    case deleteEntireToDoRepeat
    case deleteUncompletedToDoRepeat
    case unsubscribe
    case logout
    case stopConcentration
    case retry
  }
  
  private struct Layout {
    static let commonWidth: CGFloat = 273.0
    static let cornerRadius: CGFloat = 20.0
    
    static let heightForVertical: CGFloat = 246.0
    static let titleTopMarginForVertical: CGFloat = 24.0
    static let descriptionTopMarginForVertical: CGFloat = 61.0
    static let stackviewHeightForVertical: CGFloat = 43.0
    
    static let heightForHorizontal: CGFloat = 206.0
    static let titleTopMarginForHorizontal: CGFloat = 42.0
    static let descriptionTopMarginForHorizontal: CGFloat = 84.0
    static let stackviewHeightForHorizontal: CGFloat = 51.0
  }

  public var viewState: ViewState {
    let layoutConstant = Constant.ToDoGardenAlertView.Content.Layout.self
    
    switch self {
    case .deleteToDoRepeat:
      return ViewState(
        backPlane: BackPlaneState(
          width: layoutConstant.commonWidth,
          height: layoutConstant.heightForVertical,
          cornerRadius: layoutConstant.cornerRadius
        ),
        title: TitleViewState(text: "반복을 삭제할까요?", topMargin: layoutConstant.titleTopMarginForVertical),
        description: DescriptionViewState(
          text: "반복을 삭제할 때, \n 반복과 관련된 투두를 삭제할까요?",
          topMargin: layoutConstant.descriptionTopMarginForVertical
        ),
        buttons: [
          ButtonLabelState(text: "삭제하기", isRed: false, buttonActionType: ButtonActionType.deleteEntireToDoRepeat),
          ButtonLabelState(
            text: "미완료 투두만 삭제하기",
            isRed: false,
            buttonActionType: ButtonActionType.deleteUncompletedToDoRepeat
          ),
          ButtonLabelState(text: "취소", isRed: true, buttonActionType: ButtonActionType.cancel)
        ],
        stackView: StackViewState(isHorizontal: false, height: layoutConstant.stackviewHeightForVertical)
      )
    case .welldone:
      return ViewState(
        backPlane: BackPlaneState(
          width: layoutConstant.commonWidth,
          height: layoutConstant.heightForVertical,
          cornerRadius: layoutConstant.cornerRadius
        ),
        title: TitleViewState(text: "수고했어요!", topMargin: layoutConstant.titleTopMarginForVertical),
        description: DescriptionViewState(
          text: "오늘도 열심히 집중한 당신!\n이제 조금 쉬어볼까요?",
          topMargin: layoutConstant.descriptionTopMarginForVertical
        ),
        buttons: [
          ButtonLabelState(text: "휴식하기", isRed: false, buttonActionType: ButtonActionType.stopConcentration),
          ButtonLabelState(text: "더 집중하기", isRed: false, buttonActionType: ButtonActionType.keepConcentration),
          ButtonLabelState(text: "홈으로", isRed: true, buttonActionType: ButtonActionType.goHome)
        ],
        stackView: StackViewState(isHorizontal: false, height: layoutConstant.stackviewHeightForVertical)
      )
      
    case .askToStop:
      return ViewState(
        backPlane: BackPlaneState(
          width: layoutConstant.commonWidth,
          height: layoutConstant.heightForHorizontal,
          cornerRadius: layoutConstant.cornerRadius
        ),
        title: TitleViewState(text: "그만할까요?", topMargin: layoutConstant.titleTopMarginForHorizontal),
        description: DescriptionViewState(
          text: "그만하면\n기록으로 돌아갈 수 있어요.",
          topMargin: layoutConstant.descriptionTopMarginForHorizontal
        ),
        buttons: [
          ButtonLabelState(text: "포기하기", isRed: true, buttonActionType: ButtonActionType.stopConcentration),
          ButtonLabelState(text: "집중하기", isRed: false, buttonActionType: ButtonActionType.cancel)
        ],
        stackView: StackViewState(isHorizontal: true, height: layoutConstant.stackviewHeightForHorizontal)
      )
      
    case .fullyCharged:
      return ViewState(
        backPlane: BackPlaneState(
          width: layoutConstant.commonWidth,
          height: layoutConstant.heightForHorizontal,
          cornerRadius: layoutConstant.cornerRadius),
        title: TitleViewState(text: "충전완료!", topMargin: layoutConstant.titleTopMarginForHorizontal),
        description: DescriptionViewState(
          text: "이제 다시 열심히\n힘을 내볼까요?",
          topMargin: layoutConstant.descriptionTopMarginForHorizontal
        ),
        buttons: [
          ButtonLabelState(text: "홈으로", isRed: true, buttonActionType: ButtonActionType.goHome),
          ButtonLabelState(text: "집중하기", isRed: false, buttonActionType: ButtonActionType.keepConcentration)
        ],
        stackView: StackViewState(isHorizontal: true, height: layoutConstant.stackviewHeightForHorizontal)
      )
      
    case .askToDeleteToDo:
      return ViewState(
        backPlane: BackPlaneState(
          width: layoutConstant.commonWidth,
          height: layoutConstant.heightForHorizontal,
          cornerRadius: layoutConstant.cornerRadius
        ),
        title: TitleViewState(text: "삭제할까요?", topMargin: layoutConstant.titleTopMarginForHorizontal),
        description: DescriptionViewState(
          text: "한 번 삭제하면 되돌릴 수 없어요.",
          topMargin: layoutConstant.descriptionTopMarginForHorizontal
        ),
        buttons: [
          ButtonLabelState(text: "취소하기", isRed: false, buttonActionType: ButtonActionType.cancel),
          ButtonLabelState(text: "삭제하기", isRed: true, buttonActionType: ButtonActionType.delete)
        ],
        stackView: StackViewState(isHorizontal: true, height: layoutConstant.stackviewHeightForHorizontal)
      )
      
    case .askToDeleteGroup:
      return ViewState(
        backPlane: BackPlaneState(
          width: layoutConstant.commonWidth,
          height: layoutConstant.heightForHorizontal,
          cornerRadius: layoutConstant.cornerRadius
        ),
        title: TitleViewState(text: "그룹을 삭제하시겠습니까?", topMargin: layoutConstant.titleTopMarginForHorizontal),
        description: DescriptionViewState(
          text: "그룹에 포함되어 있던\n투두들은 모두 삭제됩니다",
          topMargin: layoutConstant.descriptionTopMarginForHorizontal
        ),
        buttons: [
          ButtonLabelState(text: "취소", isRed: false, buttonActionType: ButtonActionType.cancel),
          ButtonLabelState(text: "삭제하기", isRed: true, buttonActionType: ButtonActionType.delete)
        ],
        stackView: StackViewState(isHorizontal: true, height: layoutConstant.stackviewHeightForHorizontal)
      )
      
    case .askToUnsubscribe:
      return ViewState(
        backPlane: BackPlaneState(
          width: layoutConstant.commonWidth,
          height: layoutConstant.heightForHorizontal,
          cornerRadius: layoutConstant.cornerRadius
        ),
        title: TitleViewState(text: "서비스 탈퇴", topMargin: layoutConstant.titleTopMarginForHorizontal),
        description: DescriptionViewState(
          text: "정말로 탈퇴하시겠습니까?\n회원 탈퇴 시 모든 정보는\n복구할 수 없습니다.",
          topMargin: layoutConstant.descriptionTopMarginForHorizontal
        ),
        buttons: [
          ButtonLabelState(text: "탈퇴하기", isRed: true, buttonActionType: ButtonActionType.unsubscribe),
          ButtonLabelState(text: "취소", isRed: false, buttonActionType: ButtonActionType.cancel)
        ],
        stackView: StackViewState(isHorizontal: true, height: layoutConstant.stackviewHeightForHorizontal)
      )
      
    case .askToLogout:
      return ViewState(
        backPlane: BackPlaneState(
          width: layoutConstant.commonWidth,
          height: layoutConstant.heightForHorizontal,
          cornerRadius: layoutConstant.cornerRadius
        ),
        title: TitleViewState(text: "로그아웃", topMargin: layoutConstant.titleTopMarginForHorizontal),
        description: DescriptionViewState(
          text: "정말 로그아웃 하시겠습니까?",
          topMargin: layoutConstant.descriptionTopMarginForHorizontal
        ),
        buttons: [
          ButtonLabelState(text: "로그아웃", isRed: true, buttonActionType: ButtonActionType.logout),
          ButtonLabelState(text: "취소", isRed: false, buttonActionType: ButtonActionType.cancel)
        ],
        stackView: StackViewState(isHorizontal: true, height: layoutConstant.stackviewHeightForHorizontal)
      )
      
    case .askToStopResting:
      return ViewState(
        backPlane: BackPlaneState(
          width: layoutConstant.commonWidth,
          height: layoutConstant.heightForHorizontal,
          cornerRadius: layoutConstant.cornerRadius
        ),
        title: TitleViewState(text: "그만 쉴까요?", topMargin: layoutConstant.titleTopMarginForHorizontal),
        description: DescriptionViewState(
          text: "이제 다시 열심히\n힘을 내볼까요?",
          topMargin: layoutConstant.descriptionTopMarginForHorizontal
        ),
        buttons: [
          ButtonLabelState(text: "홈으로", isRed: true, buttonActionType: ButtonActionType.goHome),
          ButtonLabelState(text: "집중하기", isRed: false, buttonActionType: ButtonActionType.keepConcentration)
        ],
        stackView: StackViewState(isHorizontal: true, height: layoutConstant.stackviewHeightForHorizontal)
      )
    
    case .failToFetchToDo:
      return ViewState(
        backPlane: BackPlaneState(
          width: layoutConstant.commonWidth,
          height: layoutConstant.heightForHorizontal,
          cornerRadius: layoutConstant.cornerRadius
        ),
        title: TitleViewState(text: "투두 조회 실패", topMargin: layoutConstant.titleTopMarginForHorizontal),
        description: DescriptionViewState(
          text: "투두 정보를\n받아오지 못 했어요.",
          topMargin: layoutConstant.descriptionTopMarginForHorizontal
        ),
        buttons: [
          ButtonLabelState(text: "재시도", isRed: false, buttonActionType: ButtonActionType.retry),
          ButtonLabelState(text: "홈으로", isRed: true, buttonActionType: ButtonActionType.goHome)
        ],
        stackView: StackViewState(isHorizontal: true, height: layoutConstant.stackviewHeightForHorizontal)
      )

    case .errorOccurred(let errorDescription):
      return ViewState(
        backPlane: BackPlaneState(
          width: layoutConstant.commonWidth,
          height: layoutConstant.heightForHorizontal,
          cornerRadius: layoutConstant.cornerRadius
        ),
        title: TitleViewState(text: "오류 발생", topMargin: layoutConstant.titleTopMarginForHorizontal),
        description: DescriptionViewState(
          text: errorDescription,
          topMargin: layoutConstant.descriptionTopMarginForHorizontal
        ),
        buttons: [
          ButtonLabelState(text: "확인했어요", isRed: false, buttonActionType: ButtonActionType.cancel),
          ButtonLabelState(text: "홈으로", isRed: true, buttonActionType: ButtonActionType.goHome)
        ],
        stackView: StackViewState(isHorizontal: true, height: layoutConstant.stackviewHeightForHorizontal)
      )
    }
  }
}
