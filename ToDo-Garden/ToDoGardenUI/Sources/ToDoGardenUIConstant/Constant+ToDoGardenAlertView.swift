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
}
