//
//  StaticObjects.swift
//  AppCore
//
//  Created by SONG on 1/27/25.
//

import Foundation

import HTTPClient
import TDFoundation
import TimerScene

extension HTTPClient {
  public static let live = Self(
    transport: URLSessionTransport(urlSession: URLSession.shared),
    middlewares: [
      AuthenticationMiddleWare(),
      CommonHeaderMiddleware(),
      RefreshMiddleware(accessTokenManager: AccessTokenManager.live)
    ]
  )
  
  static let sub = Self(
    transport: URLSessionTransport(urlSession: URLSession.shared),
    middlewares: [
      AuthenticationMiddleWare(),
      CommonHeaderMiddleware()
    ]
  )
}

extension AccessTokenManager {
  static let live = AccessTokenManager(httpClient: HTTPClient.sub)
}
