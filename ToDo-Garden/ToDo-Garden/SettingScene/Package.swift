// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
    .package(path: "../TDFoundation"),
    .package(path: "../HTTPClient")
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
        "SettingSceneAPI",
        "SettingSceneEntity",
        .product(name: "HTTPClient", package: "TDFoundation"),
        .product(name: "TDFoundation", package: "TDFoundation"),
        .product(name: "ToDoGardenUIAPI", package: "ToDoGardenUI"),
        .product(name: "ToDoGardenUIComponent", package: "ToDoGardenUI"),
        .product(name: "ToDoGardenUIResource", package: "ToDoGardenUI"),
        .product(name: "GuideScene", package: "GuideScene"),
        .product(name: "TDFoundation", package: "TDFoundation"),
        .product(name: "HTTPClient", package: "HTTPClient")
      ]
    ),
    .testTarget(
      name: "SettingSceneTests",
      dependencies: ["SettingScene"]
    )
  ]
)
