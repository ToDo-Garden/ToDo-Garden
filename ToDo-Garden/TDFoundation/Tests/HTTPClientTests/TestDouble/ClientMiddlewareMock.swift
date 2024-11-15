//
//  ClientMiddlewareMock.swift
//  TDFoundation
//
//  Created by Noah on 11/15/24.
//

import Foundation

import HTTPClientAPI

final class ClientMiddlewareMock: ClientMiddleware {
  nonisolated(unsafe) var isIntercepterCalled: Bool = false
  nonisolated(unsafe) var interceptedRequest: HTTPRequest?
  nonisolated(unsafe) var isThrowError: Bool = false
  let error = NSError(domain: "Error thrown by the client middleware mock", code: 99999)
  
  func intercept(
    request: HTTPRequest,
    next: (HTTPRequest) async throws -> HTTPResponse
  ) async throws -> HTTPResponse {
    guard isThrowError == false
    else { throw self.error }
    
    self.interceptedRequest = request
    self.isIntercepterCalled = true
    
    return try await next(request)
  }
}
