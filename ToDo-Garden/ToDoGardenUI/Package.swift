// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ToDoGardenUI",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "ToDoGardenUIAPI",
      targets: ["ToDoGardenUIAPI"]
    ),
    .library(
      name: "ToDoGardenUIComponent",
      targets: ["ToDoGardenUIComponent"]
    ),
    .library(
      name: "ToDoGardenUIResource",
      targets: ["ToDoGardenUIResource"]
    ),
    .library(
      name: "ToDoGardenUIConstant",
      targets: ["ToDoGardenUIConstant"]
    )
  ],
  dependencies: [
    .package(path: "./TDUtility"),
    .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.5.0")
  ],
  targets: [
    .target(
      name: "ToDoGardenUIAPI",
      dependencies: [
        "ToDoGardenUIConstant"
      ]
    ),
    .target(
      name: "ToDoGardenUIComponent",
      dependencies: [
        "ToDoGardenUIResource",
        "ToDoGardenUIConstant",
        "CombineExtension",
        "FoundationExtension",
        "ToDoGardenUIAPI",
        .product(name: "TDUtility", package: "TDUtility"),
        .product(name: "Lottie", package: "lottie-ios")
      ]
    ),
    .target(
      name: "ToDoGardenUIResource",
      resources: [
        .process("Fonts")
      ]
    ),
    .target(name: "ToDoGardenUIConstant"),
    .target(name: "CombineExtension"),
    .target(name: "FoundationExtension"),
    .testTarget(
      name: "ToDoGardenUITests",
      dependencies: ["ToDoGardenUIComponent"]
    )
  ]
)
