//
//  EditUserNameSceneDelegate.swift
//
//
//  Created by Wood on 10/22/24.
//

import Foundation

public protocol EditUserNameSceneDelegate: AnyObject {
  /// 닉네임 수정 요청 성공시, Delegate를 채택한 객체에 수정된 닉네임을 전달합니다.
  /// - Parameter userName: 수정된 닉네임 문자열 값입니다.
  func userNameDidEdited(_ userName: String)
}
