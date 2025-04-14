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
import UserInfoScene

import SharingGRDB

extension AppCore {
  public struct Dependency {
    @MainActor
    public static let live: Dependency = {
      let httpClient = HTTPClient.live
      let sceneBuilder = AppRouter.SceneBuilder(
        home: HomeSceneBuilder(dependency: .live),
        signup: SignUpSceneBuilder(
          dependency: SignUpSceneBuilder.Dependency(
            signUpWorker: SignUpWorker(httpClient: httpClient)
          )
        ),
        shareGarden: ShareGardenSceneBuilder(dependency: .live),
        setting: nil
      )
      let router = AppRouter(
        httpClient: httpClient,
        sceneBuilder: sceneBuilder
      )
      
      let setting = SettingSceneBuilder(
        dependency: SettingSceneBuilder.Dependency(
          settingWorker: SettingWorker(httpClient: HTTPClient.live),
          appServiceWorker: ApplicationServiceWorker(),
          userInfoSceneBuilder: UserInfoSceneSceneBuilder.live { [weak router] in
            router?.switchTo(.login(false))
            try? KeychainManager.shared.clearLoginData()
            try? KeychainManager.shared.clearAccessToken()
          }
        )
      )
      router.sceneBuilder.setting = setting
      
      return Dependency(
        router: router,
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
