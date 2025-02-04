//
//  StaticObjects.swift
//  AppCore
//
//  Created by SONG on 2/4/25.
//

import Foundation

import HTTPClient
import TDFoundation

extension HTTPClient {
  static let live = HTTPClient(
    transport: URLSessionTransport(urlSession: URLSession.shared),
    middlewares: [
      AuthenticationMiddleWare(),
      CommonHeaderMiddleware(),
      RefreshMiddleware(accessTokenManager: AccessTokenManager.live)
    ]
  )
}

extension AccessTokenManager {
  static let live = AccessTokenManager(
    httpClient: HTTPClient(
      transport: URLSessionTransport(urlSession: URLSession.shared),
      middlewares: [
        AuthenticationMiddleWare(),
        CommonHeaderMiddleware()
      ]
    )
  )
}
