//
//  ClientTransport.swift
//  TDFoundation
//
//  Created by Noah on 11/11/24.
//

import Foundation

public protocol ClientTransport: Sendable {
  func send(request: HTTPRequest) async throws -> HTTPResponse
}
