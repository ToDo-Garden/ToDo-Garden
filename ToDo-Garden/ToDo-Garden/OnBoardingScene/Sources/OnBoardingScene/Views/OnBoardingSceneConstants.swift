//
//  OnBoardingSceneConstants.swift
//
//
//  Created by SONG on 11/10/24.
//

import Foundation

enum Constant {
  enum Layout {
    static let space: CGFloat = 26.0
    static let multiplier: CGFloat = 0.2
    static let aspectRatio: CGFloat = 456 / 375
    
    static let bubbleLabelMargin: CGFloat = 5.0
    static let leftBubbleLabelLeading: CGFloat = -44.0
    static let rightBubbleLabelTrailing: CGFloat = 39.0
  }
  enum StringLiteral {
    static let buttonTitle: String = "시작하기"
    
    static let firstLineTitle: String = "뽀모도로 타이머로 시간 측정하기"
    static let firstLineDescription: String = "뽀모도로 타이머를 이용해 집중력을 향상시킬 수 있어요"
    
    static let secondLineTitle: String = "완료한 투두 기록하기"
    static let secondLineDescription: String = "매일 투두를 완료하고 기록을 갱신해요"
    
    static let thirdLineTitle: String = "열정을 불태우기"
    static let thirdLineDescription: String = "투두가든을 통해 당신의 열정을 불태우세요!"
    
    static let leftBubbleTitle: String = "를 눌러 ToDo를 추가할 수 있어요"
    static let rightBubbleTitle: String = "뽀모도로 타이머를 이용하여\n집중력을 향상시킬 수 있어요"
    
    static let groupName: String = "그룹 1"
  }
}
