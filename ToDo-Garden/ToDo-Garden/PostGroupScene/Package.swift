// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "PostGroupScene",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "PostGroupSceneAPI",
      targets: ["PostGroupSceneAPI"]
    ),
    .library(
      name: "PostGroupSceneEntity",
      targets: ["PostGroupSceneEntity"]
    ),
    .library(
      name: "PostGroupScene",
      targets: ["PostGroupScene"]
    )
  ],
  dependencies: [
    .package(name: "ToDoGardenUI", path: "../ToDoGardenUI")
  ],
  targets: [
    .target(
      name: "PostGroupSceneAPI",
      dependencies: [
        .product(name: "ToDoGardenUIAPI", package: "ToDoGardenUI")
      ]
    ),
    .target(
      name: "PostGroupSceneEntity"
    ),
    .target(
      name: "PostGroupScene",
      dependencies: [
        "PostGroupSceneAPI",
        "PostGroupSceneEntity"
      ]
    ),
    .testTarget(
      name: "PostGroupSceneSceneTests",
      dependencies: ["PostGroupScene"]
    )
  ]
)
