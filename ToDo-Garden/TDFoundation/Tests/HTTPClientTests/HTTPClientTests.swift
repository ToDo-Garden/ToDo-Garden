//
//  HTTPClientTests.swift
//  TDFoundation
//
//  Created by Noah on 11/13/24.
//
// swiftlint:disable function_body_length

import Foundation
import Testing

import HTTPClient
import HTTPClientAPI

struct HTTPClientTests {
  private let sut: HTTPClient
  private let transportMock: ClientTransportMock
  private let middlewareMock: ClientMiddlewareMock
  
  init() {
    self.transportMock = ClientTransportMock()
    self.middlewareMock = ClientMiddlewareMock()
    self.sut = HTTPClient(
      transport: self.transportMock,
      middlewares: [self.middlewareMock]
    )
  }
  
  @Test("is middleware intercepting request")
  private func middlewareInterceptRequest() async throws {
    // Given
    let givenURL = try #require(URL(string: "test url"))
    let expectedInterceptedRequest: HTTPRequest = HTTPRequest(
      method: HTTPMethod.get,
      endPoint: givenURL,
      header: [:],
      queryItems: [:],
      body: nil
    )
    
    // When
    try await self.sut.send(
      input: Void(),
      serializer: { _ in
        return expectedInterceptedRequest
      },
      deserializer: { _ in
        return
      }
    )
    
    // Then
    #expect(self.middlewareMock.isIntercepterCalled)
    #expect(self.middlewareMock.interceptedRequest == expectedInterceptedRequest)
  }
}

// swiftlint:enable function_body_length
