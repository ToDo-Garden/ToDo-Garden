// swift-tools-version: 5.10
import PackageDescription

let package = Package(
  name: "OnBoardingScene",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "OnBoardingScene",
      targets: ["OnBoardingScene"])
  ],
  dependencies: [
    .package(path: "../ToDoGardenUI")
  ],
  targets: [
    .target(
      name: "OnBoardingScene",
      dependencies: [
        .product(name: "ToDoGardenUIComponent", package: "ToDoGardenUI"),
        .product(name: "ToDoGardenUIResource", package: "ToDoGardenUI")
      ]
    )
  ]
)
