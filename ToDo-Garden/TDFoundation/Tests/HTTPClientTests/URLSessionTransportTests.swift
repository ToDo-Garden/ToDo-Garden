//
//  URLSessionTransportTests.swift
//  TDFoundation
//
//  Created by Noah on 11/15/24.
//
// swiftlint:disable function_body_length

import Foundation
import Testing

import HTTPClient
import HTTPClientAPI

@Suite(ParallelizationTrait.serialized)
struct URLSessionTransportTests {
  private let sut: URLSessionTransport
  
  init() {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [URLProtocolMock.self]
    self.sut = URLSessionTransport(urlSession: URLSession(configuration: configuration))
  }
  
  @Test("URLSession에서 HTTPURLResponse를 수신받았을 때 올바른 HTTPResponse를 반환하는가")
  private func returnCorrectHTTPResponse() async throws {
    // Given
    let testURL = try #require(URL(string: "test url"))
    let queryItems = ["name": "noah"]
    let request = HTTPRequest(
      method: HTTPMethod.get,
      endPoint: testURL,
      header: ["test": "header"],
      queryItems: queryItems
    )
    let expectedResponse = HTTPResponse(
      statusCode: 200,
      header: ["test": "header"],
      body: Data()
    )
    var urlComponents = URLComponents(url: testURL, resolvingAgainstBaseURL: true)
    urlComponents?.queryItems = [URLQueryItem(name: "name", value: "noah")]
    let expectedURL = try #require(urlComponents?.url)
    let expectedHTTPURLResponse = try #require(
      HTTPURLResponse(
        url: expectedURL,
        statusCode: expectedResponse.statusCode,
        httpVersion: nil,
        headerFields: expectedResponse.header
      )
    )
    let expectedResponseData = try #require(expectedResponse.body)
    URLProtocolMock.requestHandler = {
      return (expectedHTTPURLResponse, expectedResponseData)
    }
    
    // When
    let response = try await self.sut.send(request: request)
    
    // Then
    #expect(response == expectedResponse)
  }
}

// swiftlint:enable function_body_length
