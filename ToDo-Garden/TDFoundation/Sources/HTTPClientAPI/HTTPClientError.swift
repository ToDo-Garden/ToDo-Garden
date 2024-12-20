//
//  HTTPClientError.swift
//  TDFoundation
//
//  Created by Noah on 11/11/24.
//

import Foundation

/// HTTPClient 작업 중 발생할 수 있는 오류를 나타냅니다.
public enum HTTPClientError: Error, Sendable {
  case deserializationError
  case serializationError
  case badURL(String)
  case notHTTPResponse(URLResponse)
  case transportFailed(any Error)
  case middlewareFailed(middlewareType: Any.Type, any Error)
  case badStatusCode(Int)
  
  public var underlyingError: (any Error)? {
    switch self {
    case HTTPClientError.transportFailed(let error):
      return error
    case HTTPClientError.middlewareFailed(_, let error):
      if let error = error as? HTTPClientErrorContext {
        return error.underlyingError
      }
      
      return error
    default: return nil
    }
  }
}

/// HTTP 클라이언트 오류와 관련된 컨텍스트 정보를 포함하는 구조체입니다.
public struct HTTPClientErrorContext: Error {
  public var request: HTTPRequest?
  public var response: HTTPResponse?
  /// 작업 실패의 원인이 된 기본 오류입니다.
  public var underlyingError: any Error
  
  public init(
    request: HTTPRequest? = nil,
    response: HTTPResponse? = nil,
    underlyingError: any Error
  ) {
    self.request = request
    self.response = response
    self.underlyingError = underlyingError
  }
}
