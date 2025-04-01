import Foundation

import HomeScene
import HomeSceneAPI
import HTTPClient
import OnBoardingScene
import SettingScene
import ShareGardenScene
import SignUpScene
import SignUpSceneAPI
import TDFoundation

import SharingGRDB

extension AppCore {
  public struct Dependency {
    @MainActor
    public static let live: Dependency = {
      let httpClient = HTTPClient.live
      
      return Dependency(
        router: AppRouter(
          httpClient: httpClient,
          sceneBuilder: AppRouter.SceneBuilder(
            home: HomeSceneBuilder(dependency: .live),
            signup: SignUpSceneBuilder(
              dependency: SignUpSceneBuilder.Dependency(
                signUpWorker: SignUpWorker(httpClient: httpClient)
              )
            ),
            shareGarden: ShareGardenSceneBuilder(dependency: .live),
            setting: SettingSceneBuilder(
              dependency: SettingSceneBuilder.Dependency(
                settingWorker: SettingWorker(httpClient: HTTPClient.live),
                appServiceWorker: ApplicationServiceWorker()
              )
            )
          )
        ),
        userDefaults: UserDefaultsClient.live,
        httpClient: httpClient,
        isLoggedIn: {
          let manager = KeychainManager.shared
          let accessToken = try? manager.load(forKey: KeychainManager.KeychainKey.accessToken)
          let refreshToken = try? manager.load(forKey: KeychainManager.KeychainKey.refreshToken)
          return accessToken != nil && refreshToken != nil
        },
        scheduledAlertClient: ScheduledAlertClient.live,
        notificationManager: NotificationManager.shared
      )
    }()
    public let router: AppRouter
    public let userDefaults: UserDefaultsClient
    public let httpClient: HTTPClient
    public let isLoggedIn: () -> Bool
    public let scheduledAlertClient: ScheduledAlertClient
    public let notificationManager: NotificationManager
  }
}
