//
//  HTTPResponse.swift
//  TDFoundation
//
//  Created by Noah on 11/11/24.
//

import Foundation

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
