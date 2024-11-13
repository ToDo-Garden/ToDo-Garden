//
//  URLSessionTransport.swift
//  TDFoundation
//
//  Created by Noah on 11/11/24.
//

import Foundation

import HTTPClientAPI

private final class URLRequestBuilder {
  private let request: HTTPRequest
  private var urlComponents: URLComponents?
  typealias HTTPBody = Data
  
  init(request: HTTPRequest) {
    self.request = request
    self.urlComponents = URLComponents(
      url: self.request.endPoint,
      resolvingAgainstBaseURL: true
    )
  }
  
  /// 주어진 `HTTPRequest`를 기반으로 `URLRequest`와 요청 본문을 생성합니다.
  /// - Returns: 생성된 `URLRequest`와 요청 본문을 튜플 형태로 반환합니다.
  func build() throws -> (URLRequest, HTTPBody?) {
    if self.request.queryItems.isEmpty == false {
      self.urlComponents?.queryItems = self.request.queryItems.map {
        URLQueryItem(name: $0.key, value: String(describing: $0.value))
      }
    }
    
    return try self.makeURLRequest()
  }
}

extension URLRequestBuilder {
  private func makeURLRequest() throws -> (URLRequest, HTTPBody?) {
    guard let url = self.urlComponents?.url
    else {
      throw HTTPClientError.badURL(
        self.urlComponents?.url?.absoluteString ?? self.request.endPoint.absoluteString
      )
    }
    
    var urlRequest = URLRequest(url: url)
    self.request.header.forEach {
      urlRequest.setValue($0.value, forHTTPHeaderField: $0.key)
    }
    urlRequest.httpMethod = self.request.method.rawValue
    
    return (urlRequest, request.body)
  }
}
