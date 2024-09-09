//
//  AppServiceWorker.swift
//
//
//  Created by Wood on 9/7/24.
//

import UIKit

import UserInfoSceneAPI

public struct AppServiceWorker: AppServiceWorkable {
  public init() {}

  public func openSettingApp() {
    let settingAppURL = URL(string: UIApplication.openSettingsURLString)
    if let settingAppURL, UIApplication.shared.canOpenURL(settingAppURL) {
      UIApplication.shared.open(settingAppURL)
    }
  }
}
