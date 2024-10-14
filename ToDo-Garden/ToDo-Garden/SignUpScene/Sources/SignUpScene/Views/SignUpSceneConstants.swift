//
//  SignUpSceneConstants.swift
//
//
//  Created by SONG on 10/11/24.
//

import Foundation

enum Constant {
  enum ScrollView {
    static let topMargin: CGFloat = 40.0
    static let heightMultiplier: CGFloat = 0.25
    
    enum SignUpInputView {
      enum StringLiteral {
        static let idFirstTitle: String = "환영해요!"
        static let idSecondTitle: String = "아이디를 정해볼까요?"
        static let idThirdTitle: String = "아이디로 친구의 가든을 찾을 수 있어요"
        static let idTextFieldTitle: String = "아이디"
        static let idPlaceholderText: String = "아이디를 입력해주세요"
        
        static let introductionFirstTitle: String = "멋진 아이디에요!"
        static let introductionSecondTitle: String = "당신을 한 줄로 소개해주세요!"
        static let introductionThirdTitle: String = "소개는 언제든지 변경할 수 있어요"
        static let introductionTextFieldTitle: String = "소개"
        static let introductionPlaceholderText: String = "당신을 소개해주세요."
        
        static let nicknameFirstTitle: String = "마지막으로,"
        static let nicknameSecondTitle: String = "당신의 이름을 알려주세요!"
        static let nicknameThirdTitle: String = "별명도 사용 가능해요"
        static let nicknameTextFieldTitle: String = "이름"
        static let nicknamePlaceholderText: String = "이름을 입력해주세요."
        
        static let conditionsForIDGenerationWarning: String = "아이디는 5~12자 내외 띄어쓰기 없이\n영문, 숫자만 사용 가능합니다"
        static let inUseIDAlreadyWarning: String = "이미 사용중인 아이디 입니다"
      }
    }
  }
  
  enum BottomButton {
    static let centerYOffset: CGFloat = 100.0
    
    enum StringLiteral {
      static let done: String = "완료"
      static let doItLater: String = "나중에 할래요."
    }
  }
  
  enum Animation {
    static let duration: CGFloat = 0.3
  }
}
