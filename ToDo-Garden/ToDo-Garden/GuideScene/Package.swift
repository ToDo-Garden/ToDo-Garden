// swift-tools-version: 5.10
import PackageDescription

let package = Package(
  name: "GuideScene",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "GuideScene",
      targets: ["GuideScene"])
  ],
  dependencies: [
    .package(path: "../ToDoGardenUI"),
    .package(path: "../CommonViews")
  ],
  targets: [
    .target(
      name: "GuideScene",
      dependencies: [
        .product(name: "ToDoGardenUIAPI", package: "ToDoGardenUI"),
        .product(name: "CommonViews", package: "CommonViews")
      ]
    ),
    .testTarget(
      name: "GuideSceneTests",
      dependencies: ["GuideScene"]
    )
  ]
)
