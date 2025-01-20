// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "EditUserIntroductionScene",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "EditUserIntroductionSceneAPI",
      targets: ["EditUserIntroductionSceneAPI"]
    ),
    .library(
      name: "EditUserIntroductionSceneEntity",
      targets: ["EditUserIntroductionSceneEntity"]
    ),
    .library(
      name: "EditUserIntroductionScene",
      targets: ["EditUserIntroductionScene"]
    )
  ],
  dependencies: [
    .package(name: "ToDoGardenUI", path: "../ToDoGardenUI"),
    .package(name: "TDFoundation", path: "../TDFoundation")
  ],
  targets: [
    .target(
      name: "EditUserIntroductionSceneAPI",
      dependencies: [
        .product(name: "ToDoGardenUIAPI", package: "ToDoGardenUI")
      ]
    ),
    .target(
      name: "EditUserIntroductionSceneEntity"
    ),
    .target(
      name: "EditUserIntroductionScene",
      dependencies: [
        "EditUserIntroductionSceneAPI",
        "EditUserIntroductionSceneEntity",
        .product(name: "ToDoGardenUIAPI", package: "ToDoGardenUI"),
        .product(name: "ToDoGardenUIComponent", package: "ToDoGardenUI"),
        .product(name: "ToDoGardenUIResource", package: "ToDoGardenUI"),
        .product(name: "TDFoundation", package: "TDFoundation")
      ]
    )
  ]
)
