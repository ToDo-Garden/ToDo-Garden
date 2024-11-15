//
//  ClientTransportMock.swift
//  TDFoundation
//
//  Created by Noah on 11/15/24.
//

import Foundation

import HTTPClientAPI

final class ClientTransportMock: ClientTransport {
  nonisolated(unsafe) var isThrowError: Bool = false
  nonisolated(unsafe) var expectedResponse: HTTPResponse?
  nonisolated(unsafe) var defaultResponse: HTTPResponse = HTTPResponse(
    statusCode: 0,
    header: [:],
    body: nil
  )
  let error = NSError(domain: "Error thrown by the client transport mock", code: 99999)
  
  func send(request: HTTPRequest) async throws -> HTTPResponse {
    guard isThrowError == false
    else { throw self.error }
  
    guard let expectedResponse
    else {
      return self.defaultResponse
    }
    
    return expectedResponse
  }
}
