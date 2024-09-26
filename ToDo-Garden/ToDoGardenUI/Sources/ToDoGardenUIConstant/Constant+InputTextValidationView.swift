//
//  Constant+InputTextValidationView.swift
//
//
//  Created by Wood on 9/26/24.
//

import Foundation

public extension Constant.InputTextValidationView {
  enum StringLiteral {}
}

public extension Constant.InputTextValidationView.StringLiteral {
  enum ValidationText {
    public static let invalidID = "아이디는 5~12자 내외 띄어쓰기 없이\n영문, 숫자만 사용 가능합니다"
    public static let existedID = "이미 사용중인 아이디입니다"
    public static let invalidNickname = "닉네임은 5~12자 내외\n띄어쓰기, 특수기호 없이 사용 가능합니다"
    public static let invalidIntroduction = "한줄소개는 최대 15글자까지 사용 가능합니다"
  }
}
