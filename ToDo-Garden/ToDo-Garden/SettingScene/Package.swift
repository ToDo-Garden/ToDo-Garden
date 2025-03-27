// swift-tools-version: 5.10

import PackageDescription

let package = Package(
  name: "SettingScene",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "SettingSceneAPI",
      targets: ["SettingSceneAPI"]
    ),
    .library(
      name: "SettingSceneEntity",
      targets: ["SettingSceneEntity"]
    ),
    .library(
      name: "SettingScene",
      targets: ["SettingScene"]
    )
  ],
  dependencies: [
    .package(name: "TDFoundation", path: "../TDFoundation"),
    .package(name: "ToDoGardenUI", path: "../ToDoGardenUI"),
    .package(name: "GuideScene", path: "../GuideScene"),
    Package.Dependency.package(
      url: "https://github.com/pointfreeco/sharing-grdb",
      from: "0.1.0"
    ),
    .package(name: "UserInfoScene", path: "../UserInfoScene")
  ],
  targets: [
    .target(
      name: "SettingSceneAPI",
      dependencies: [
        .product(name: "ToDoGardenUIAPI", package: "ToDoGardenUI")
      ]
    ),
    .target(name: "SettingSceneEntity"),
    .target(
      name: "SettingScene",
      dependencies: [
        Target.Dependency.product(
          name: "SharingGRDB",
          package: "sharing-grdb"
        ),
        "SettingSceneAPI",
        "SettingSceneEntity",
        .product(name: "TDFoundation", package: "TDFoundation"),
        .product(name: "ToDoGardenUIAPI", package: "ToDoGardenUI"),
        .product(name: "ToDoGardenUIComponent", package: "ToDoGardenUI"),
        .product(name: "ToDoGardenUIResource", package: "ToDoGardenUI"),
        .product(name: "UserInfoSceneAPI", package: "UserInfoScene"),
        .product(name: "GuideScene", package: "GuideScene")
      ]
    ),
    .testTarget(
      name: "SettingSceneTests",
      dependencies: ["SettingScene"]
    )
  ]
)
