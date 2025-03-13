// swift-tools-version: 5.10
import PackageDescription

let package = Package(
  name: "AppCore",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "AppCore",
      targets: ["AppCore"]
    )
  ],
  dependencies: [
    Package.Dependency.package(
      name: "TDFoundation",
      path: "../TDFoundation"
    ),
    Package.Dependency.package(
      name: "OnBoardingScene",
      path: "../OnBoardingScene"
    ),
    Package.Dependency.package(
      name: "SignUpScene",
      path: "../SignUpScene"
    ),
    Package.Dependency.package(
      name: "TimerScene",
      path: "../TimerScene"
    ),
    Package.Dependency.package(
      name: "ShareGardenScene",
      path: "../ShareGardenScene"
    ),
    Package.Dependency.package(
      name: "HomeScene",
      path: "../HomeScene"
    ),
    Package.Dependency.package(
      name: "RootTabBar",
      path: "../RootTabBar"
    ),
    Package.Dependency.package(
      name: "SettingScene",
      path: "../SettingScene"
    ),
    Package.Dependency.package(
      name: "PostGroupScene",
      path: "../PostGroupScene"
    )
  ],
  targets: [
    .target(
      name: "AppCore",
      dependencies: [
        Target.Dependency.product(
          name: "TDFoundation",
          package: "TDFoundation"
        ),
        Target.Dependency.product(
          name: "OnBoardingScene",
          package: "OnBoardingScene"
        ),
        Target.Dependency.product(
          name: "HTTPClient",
          package: "TDFoundation"
        ),
        Target.Dependency.product(
          name: "SignUpScene",
          package: "SignUpScene"
        ),
        Target.Dependency.product(
          name: "TimerScene",
          package: "TimerScene"
        ),
        Target.Dependency.product(
          name: "ShareGardenScene",
          package: "ShareGardenScene"
        ),
        Target.Dependency.product(
          name: "HomeScene",
          package: "HomeScene"
        ),
        Target.Dependency.product(
          name: "RootTabBar",
          package: "RootTabBar"
        ),
        Target.Dependency.product(
          name: "SettingScene",
          package: "SettingScene"
        ),
        Target.Dependency.product(
          name: "PostGroupScene",
          package: "PostGroupScene"
        )
      ]
    ),
    .testTarget(
      name: "AppCoreTests",
      dependencies: ["AppCore"]
    )
  ]
)
