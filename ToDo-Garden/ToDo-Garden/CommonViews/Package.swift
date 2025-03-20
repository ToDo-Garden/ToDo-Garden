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
    .package(name: "ManageGroupScene", path: "./ManageGroupScene"),
    .package(name: "ShareGardenScene", path: "./ShareGardenScene"),
    .package(name: "EditToDoScene", path: "./EditToDoScene"),
    .package(name: "HomeScene", path: "./HomeScene")
  ],
  targets: [
    .target(
      name: "CommonViews",
      dependencies: [
        .product(name: "ToDoGardenUIComponent", package: "ToDoGardenUI"),
        .product(name: "ManageGroupScene", package: "ManageGroupScene"),
        .product(name: "ShareGardenScene", package: "ShareGardenScene"),
        .product(name: "EditToDoScene", package: "EditToDoScene"),
        .product(name: "HomeScene", package: "HomeScene")
      ]
    )
  ]
)
