//
//  URLProtocolMock.swift
//  TDFoundation
//
//  Created by Noah on 11/18/24.
//

import Foundation
import Testing

final class URLProtocolMock: URLProtocol, @unchecked Sendable {
  nonisolated(unsafe) static var requestHandler: (
    @Sendable () throws -> (URLResponse, Data)
  )?
  
  override class func canInit(with request: URLRequest) -> Bool {
    return true
  }
  
  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }
  
  override func startLoading() {
    #expect(throws: Never.self) {
      let requestHandler = try #require(Self.requestHandler)
      let (expectedResponse, expectedResponseData) = try requestHandler()
      self.client?.urlProtocol(
        self,
        didReceive: expectedResponse,
        cacheStoragePolicy: URLCache.StoragePolicy.notAllowed
      )
      self.client?.urlProtocol(self, didLoad: expectedResponseData)
      self.client?.urlProtocolDidFinishLoading(self)
    }
  }
  
  override func stopLoading() {
  }
}
