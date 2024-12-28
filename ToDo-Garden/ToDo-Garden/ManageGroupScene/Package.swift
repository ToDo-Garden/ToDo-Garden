// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ManageGroupScene",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "ManageGroupSceneAPI",
      targets: ["ManageGroupSceneAPI"]
    ),
    .library(
      name: "ManageGroupSceneEntity",
      targets: ["ManageGroupSceneEntity"]
    ),
    .library(
      name: "ManageGroupScene",
      targets: ["ManageGroupScene"]
    )
  ],
  dependencies: [
    .package(name: "ToDoGardenUI", path: "../ToDoGardenUI"),
    .package(name: "PostGroupScene", path: "./PostGroupScene"),
    .package(path: "../TDUtility"),
    .package(path: "../TDFoundation")
  ],
  targets: [
    .target(
      name: "ManageGroupSceneAPI",
      dependencies: [
        "ManageGroupSceneEntity",
        .product(name: "ToDoGardenUIAPI", package: "ToDoGardenUI")
      ]
    ),
    .target(
      name: "ManageGroupSceneEntity"
    ),
    .target(
      name: "ManageGroupScene",
      dependencies: [
        .product(name: "ToDoGardenUIComponent", package: "ToDoGardenUI"),
        .product(name: "PostGroupSceneAPI", package: "PostGroupScene"),
        "ManageGroupSceneAPI",
        "ManageGroupSceneEntity",
        .product(name: "TDUtility", package: "TDUtility"),
        .product(name: "TDFoundation", package: "TDFoundation")
      ]
    ),
    .testTarget(
      name: "ManageGroupSceneTests",
      dependencies: ["ManageGroupScene"]
    )
  ]
)
