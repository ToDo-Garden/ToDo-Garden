// swift-tools-version: 5.10
import PackageDescription

let package = Package(
  name: "CommonViews",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "CommonViews",
      targets: ["CommonViews"]
    )
  ],
  dependencies: [
    .package(path: "../ToDoGardenUI"),
    .package(name: "ManageGroupScene", path: "./ManageGroupScene")
  ],
  targets: [
    .target(
      name: "CommonViews",
      dependencies: [
        .product(name: "ToDoGardenUIComponent", package: "ToDoGardenUI"),
        .product(name: "ManageGroupScene", package: "ManageGroupScene")
      ]
    )
  ]
)
