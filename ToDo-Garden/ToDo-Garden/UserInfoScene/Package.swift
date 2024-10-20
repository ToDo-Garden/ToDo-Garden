// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "UserInfoScene",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "UserInfoSceneAPI",
      targets: ["UserInfoSceneAPI"]
    ),
    .library(
      name: "UserInfoSceneEntity",
      targets: ["UserInfoSceneEntity"]
    ),
    .library(
      name: "UserInfoScene",
      targets: ["UserInfoScene"]
    )
  ],
  dependencies: [
    .package(name: "ToDoGardenUI", path: "../ToDoGardenUI"),
    .package(name: "EditUserIntroductionScene", path: "EditUserIntroductionScene"),
    .package(name: "EditUserNameScene", path: "EditUserNameScene")
  ],
  targets: [
    .target(
      name: "UserInfoSceneAPI",
      dependencies: [
        .product(name: "ToDoGardenUIAPI", package: "ToDoGardenUI")
      ]
    ),
    .target(
      name: "UserInfoSceneEntity"
    ),
    .target(
      name: "UserInfoScene",
      dependencies: [
        "UserInfoSceneAPI",
        "UserInfoSceneEntity",
        .product(name: "EditUserIntroductionSceneAPI", package: "EditUserIntroductionScene"),
        .product(name: "EditUserNameSceneAPI", package: "EditUserNameScene"),
        .product(name: "ToDoGardenUIAPI", package: "ToDoGardenUI"),
        .product(name: "ToDoGardenUIComponent", package: "ToDoGardenUI"),
        .product(name: "ToDoGardenUIResource", package: "ToDoGardenUI")
      ]
    )
  ]
)
