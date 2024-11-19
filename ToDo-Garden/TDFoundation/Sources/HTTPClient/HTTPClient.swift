//
//  HTTPClient.swift
//  TDFoundation
//
//  Created by Noah on 11/7/24.
//

import Foundation

import HTTPClientAPI

public struct HTTPClient: Sendable, HTTPClientAPI {
  public var transport: any ClientTransport
  public var middlewares: [any ClientMiddleware]
  
  public init(
    transport: any ClientTransport,
    middlewares: [any ClientMiddleware]
  ) {
    self.transport = transport
    self.middlewares = middlewares
  }
  
  // swiftlint:disable function_body_length identifier_name
  /// HTTP 작업을 수행합니다.
  ///
  /// 작업은 세 단계로 구성됩니다:
  /// 1. 입력을 `HTTPRequest`로 변환합니다.
  /// 2. 미들웨어로 감싼 `ClientTransport`를 호출하여 HTTP 호출을 수행합니다.
  /// 3. 수신받은 `HTTPResposne`를 출력으로 변환합니다.
  /// 발생한 모든 오류를 감싸고 적절한 컨텍스트(`HTTPClientErrorContext`)를 첨부합니다.
  ///
  /// - Parameters:
  ///   - input: 작업별 입력 값입니다.
  ///   - serializer: 제공된 입력 값에서 `HTTPRequest`를 새성합니다.
  ///   - deserializer: 제공된 `HTTPResponse`를 기반으로 출력 값을 생성합니다.
  /// - Returns: `deserializer`에서 생성된 출력 값을 반환합니다.
  /// - Throws: HTTP 작업 프로세스의 어느 부분이든 실패하면 `HTTPClientErrorContext` 오류가 발생합니다.
  public func send<Input, Output>(
    input: Input,
    serializer: @Sendable (Input) throws -> HTTPRequest,
    deserializer: @Sendable (HTTPResponse) throws -> Output
  ) async throws -> Output where Input: Sendable, Output: Sendable {
    let request: HTTPRequest = try await self.wrappingErrors {
      return try serializer(input)
    } mapError: { _ in
      return self.makeError(error: HTTPClientError.serializationError)
    }
    
    var next: @Sendable (HTTPRequest) async throws -> HTTPResponse = { _request in
      return try await self.wrappingErrors {
        return try await self.transport.send(request: _request)
      } mapError: { error in
        return self.makeError(
          request: request,
          error: HTTPClientError.transportFailed(error)
        )
      }
    }
    
    for middleWare in self.middlewares.reversed() {
      let temp = next
      next = { _request in
        return try await self.wrappingErrors {
          return try await middleWare.intercept(
            request: _request,
            next: temp
          )
        } mapError: { error in
          return self.makeError(
            request: request,
            error: HTTPClientError.middlewareFailed(
              middlewareType: type(of: middleWare),
              error
            )
          )
        }
      }
    }
    
    let response = try await next(request)
    
    return try await self.wrappingErrors {
      return try deserializer(response)
    } mapError: { _ in
      return self.makeError(
        request: request,
        response: response,
        error: HTTPClientError.deserializationError
      )
    }
  }
  // swiftlint:enable function_body_length identifier_name
}

extension HTTPClient {
  @Sendable private func wrappingErrors<Result>(
    work: () async throws -> Result,
    mapError: (any Error) -> HTTPClientErrorContext
  ) async throws -> Result {
    do {
      return try await work()
    } catch {
      throw mapError(error)
    }
  }
  
  @Sendable private func makeError(
    request: HTTPRequest? = nil,
    response: HTTPResponse? = nil,
    error: any Error
  ) -> HTTPClientErrorContext {
    let underlyingError: any Error
    
    if let clientError = error as? HTTPClientError,
      let unwrappedUnderlyingError = clientError.underlyingError {
      underlyingError = unwrappedUnderlyingError
    } else {
      underlyingError = error
    }
    
    return HTTPClientErrorContext(
      request: request,
      response: response,
      underlyingError: underlyingError
    )
  }
}
