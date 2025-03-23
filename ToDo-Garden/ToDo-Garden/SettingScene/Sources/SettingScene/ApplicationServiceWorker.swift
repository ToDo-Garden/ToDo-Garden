//
//  ApplicationServiceWorker.swift
//
//
//  Created by Wood on 9/13/24.
//

import Foundation
import UIKit

import HTTPClient
import HTTPClientAPI
import TDFoundation

// 앱스토어 이동 및 Info.plist의 정보를 받아오는 Worker입니다.
// 해당 Domain Context Worker 구현이 완료되면 삭제될 예정입니다.
public struct ApplicationServiceWorker {
  public init() { }
  
  func currentAppVersion() -> String? {
    return Bundle.main.infoDictionary?[ApplicationServiceWorker.bundleVersionKey] as? String
  }
  
  func isUpdateAvailable() async throws -> Bool {
    return false
//    앱 출시 이후 확인하고 넣어주세요.
//    let response = try await HTTPClient(
//      transport: URLSessionTransport(urlSession: URLSession.shared),
//      middlewares: []
//    )
//    .send(
//      input: try KeyConstants.appBundleID,
//      serializer: {
//        .init(
//          method: .get,
//          endPoint: URLConstants.Itunes.lookup,
//          queryItems: ["bundleId": $0]
//        )
//      },
//      deserializer: { response in
//        guard let body = response.body else {
//          throw HTTPClientError.deserializationError
//        }
//        return try JSONDecoder().decode(Response.self, from: body)
//      }
//    )
//    
//    guard
//      let latestVersion = response.results.first?.version,
//      let currentVersion = self.currentAppVersion()
//    else { return false }
//    let comparisonResult = latestVersion.compare(currentVersion, options: .numeric)
//    return comparisonResult == ComparisonResult.orderedDescending
  }
  
  func openAppStore() {
    if UIApplication.shared.canOpenURL(URLConstants.Apps.appstore) {
      UIApplication.shared.open(URLConstants.Apps.appstore)
    }
  }
}

extension ApplicationServiceWorker {
  static let bundleVersionKey = "CFBundleShortVersionString"
  
  struct Response: Decodable {
    struct Info: Decodable {
      let version: String
    }
    let results: [Info]
  }
}
