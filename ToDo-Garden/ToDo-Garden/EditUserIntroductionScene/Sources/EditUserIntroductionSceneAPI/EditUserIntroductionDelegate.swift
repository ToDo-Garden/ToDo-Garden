//
//  EditUserIntroductionDelegate.swift
//
//
//  Created by Wood on 10/18/24.
//

import Foundation

public protocol EditUserIntroductionDelegate: AnyObject {
  /// 소개 수정 요청 성공시, Delegate를 채택한 객체에 수정된 소개를 전달합니다.
  /// - Parameter introduction: 수정된 소개 문자열 값입니다.
  /// - 유저가 소개를 빈 상태로 설정한 경우, nil을 전달합니다.
  func userIntroductionDidEdited(_ introduction: String?)
}
