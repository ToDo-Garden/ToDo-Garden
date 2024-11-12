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
  case badURL
  case notHTTPResponse
  case transportFailed(any Error)
  case middlewareFailed(middlewareType: Any.Type, any Error)
  
  public var underlyingError: (any Error)? {
    switch self {
    case HTTPClientError.transportFailed(let error), HTTPClientError.middlewareFailed(_, let error): return error
    default: return nil
    }
  }
}
