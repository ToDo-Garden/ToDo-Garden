//
//  HTTPResponse.swift
//  TDFoundation
//
//  Created by Noah on 11/11/24.
//

import Foundation


/// HTTP 응답을 표현하는 구조체입니다.
/// 상태코드, 응답 헤더, 본문을 가질 수 있습니다.
public struct HTTPResponse: Sendable {
  public let statusCode: Int
  public let header: [String: String]
  public let body: Data?
  
  public init(
    statusCode: Int,
    header: [String: String],
    body: Data?
  ) {
    self.statusCode = statusCode
    self.header = header
    self.body = body
  }
}
