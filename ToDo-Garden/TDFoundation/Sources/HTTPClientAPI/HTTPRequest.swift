//
//  HTTPRequest.swift
//  TDFoundation
//
//  Created by Noah on 11/11/24.
//

import Foundation

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
