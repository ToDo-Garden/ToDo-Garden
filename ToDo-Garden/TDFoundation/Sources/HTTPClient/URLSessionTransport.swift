//
//  URLSessionTransport.swift
//  TDFoundation
//
//  Created by Noah on 11/11/24.
//

import Foundation

import HTTPClientAPI

public struct URLSessionTransport: Sendable, ClientTransport {
  private let urlSession: URLSession
  
  public init(urlSession: URLSession) {
    self.urlSession = urlSession
  }
  
  /// HTTPRequest를 보내고 결과로 받은 HTTP 응답을 반환합니다.
  ///
  /// - Parameter request: `HTTPRequest`
  /// - Returns: 통신의 결과로 `HTTPResponse`를 반환합니다.
  /// - Throws: HTTP 요청 수행 중 오류가 발생한 경우 오류를 throw 합니다.
  public func send(request: HTTPRequest) async throws -> HTTPResponse {
    let (urlRequest, httpBody) = try URLRequestBuilder(request: request).build()
    let (data, response): (Data, URLResponse)
    
    try Task.checkCancellation()
    if let httpBody {
      (data, response) = try await self.urlSession.upload(for: urlRequest, from: httpBody)
    } else {
      (data, response) = try await self.urlSession.data(for: urlRequest)
    }
    try Task.checkCancellation()
    
    guard let httpResponse = response as? HTTPURLResponse
    else {
      throw HTTPClientError.notHTTPResponse(response)
    }
    
    var responseHeader: [String: String] = [:]
    
    for (headerKey, headerValue) in httpResponse.allHeaderFields {
      guard let key = headerKey as? String,
        let value = headerValue as? String
      else { continue }
      
      responseHeader[key] = value
    }
    
    return HTTPResponse(
      statusCode: httpResponse.statusCode,
      header: responseHeader,
      body: data
    )
  }
}

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
