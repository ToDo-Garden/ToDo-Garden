// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "HomeScene",
  platforms: [
    SupportedPlatform.iOS(SupportedPlatform.IOSVersion.v15)
  ],
  products: [
    Product.library(
      name: "HomeScene",
      targets: ["HomeScene"]
    ),
    Product.library(
      name: "HomeSceneAPI",
      targets: ["HomeSceneAPI"]
    )
  ],
  dependencies: [
    Package.Dependency.package(path: "../ToDoGardenUI"),
    Package.Dependency.package(path: "../TDUtility"),
    Package.Dependency.package(path: "../ManageGroupScene"),
    Package.Dependency.package(path: "../EditToDoScene"),
    Package.Dependency.package(path: "../TimerScene")
  ],
  targets: [
    Target.target(
      name: "HomeSceneEntity"
    ),
    Target.target(
      name: "HomeSceneAPI",
      dependencies: [
        Target.Dependency.product(
          name: "ToDoGardenUIAPI",
          package: "ToDoGardenUI"
        )
      ]
    ),
    Target.target(
      name: "HomeScene",
      dependencies: [
        "HomeSceneEntity",
        "HomeSceneAPI",
        Target.Dependency.product(
          name: "ToDoGardenUIAPI",
          package: "ToDoGardenUI"
        ),
        Target.Dependency.product(
          name: "ToDoGardenUIComponent",
          package: "ToDoGardenUI"
        ),
        Target.Dependency.product(
          name: "TDUtility",
          package: "TDUtility"
        ),
        Target.Dependency.product(
          name: "ToDoGardenUIResource",
          package: "ToDoGardenUI"
        ),
        Target.Dependency.product(
          name: "ManageGroupScene",
          package: "ManageGroupScene"
        ),
        Target.Dependency.product(
          name: "EditToDoScene",
          package: "EditToDoScene"
        ),
        Target.Dependency.product(
          name: "TimerScene",
          package: "TimerScene"
        )
      ]
    )
  ]
)
