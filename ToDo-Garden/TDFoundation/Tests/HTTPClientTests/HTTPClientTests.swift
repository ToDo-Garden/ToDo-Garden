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
  
  @Test("serializer error throw test")
  private func serializerErrorThrowTest() async throws {
    // Given
    let expectedError = HTTPClientErrorContext(
      underlyingError: HTTPClientError.serializationError
    )
    
    // Then
    await #expect(
      throws: expectedError,
      "serialization error를 throw 해야합니다."
    ) {
      // when
      try await self.sut.send(
        input: Void(),
        serializer: { _ in
          throw NSError(domain: "Error thrown by the serializer", code: 99999)
        },
        deserializer: { _ in
          return Void()
        }
      )
    }
  }
  
  @Test("deserializer error throw test")
  private func deserializerErrorThrowTest() async throws {
    // Given
    let givenURL = try #require(URL(string: "test url"))
    let expectedRequest: HTTPRequest = HTTPRequest(
      method: HTTPMethod.get,
      endPoint: givenURL,
      header: [:],
      queryItems: [:],
      body: nil
    )
    let expectedResponse: HTTPResponse = HTTPResponse(statusCode: 200)
    self.transportMock.expectedResponse = expectedResponse
    let expectedError = HTTPClientErrorContext(
      request: expectedRequest,
      response: expectedResponse,
      underlyingError: HTTPClientError.deserializationError
    )
    
    // Then
    await #expect(
      throws: expectedError,
      "deserialization error를 throw 해야합니다."
    ) {
      // when
      try await self.sut.send(
        input: Void(),
        serializer: { _ in
          return expectedRequest
        },
        deserializer: { _ in
          throw NSError(domain: "Error thrown by the deserializer", code: 99999)
        }
      )
    }
  }
}

// swiftlint:enable function_body_length
