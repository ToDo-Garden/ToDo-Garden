//
//  HTTPRequest.swift
//  TDFoundation
//
//  Created by Noah on 11/11/24.
//

import Foundation


/// HTTP 요청 정보를 표현하는 HTTPRequest 구조체입니다.
/// HTTP request method, end point url, 요청 헤더, 쿼리 파라미터, 요청 본문을 가질 수 있습니다.
public struct HTTPRequest: Sendable {
  public let method: HTTPMethod
  public let endPoint: URL
  public let header: [String: String]
  public let queryItems: [String: String]
  public let body: Data?
  
  public init(
    method: HTTPMethod,
    endPoint: URL,
    header: [String: String],
    queryItems: [String: String],
    body: Data?
  ) {
    self.method = method
    self.endPoint = endPoint
    self.header = header
    self.queryItems = queryItems
    self.body = body
  }
}
