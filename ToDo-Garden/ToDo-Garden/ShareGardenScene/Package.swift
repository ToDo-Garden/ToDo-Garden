// swift-tools-version: 5.10

import PackageDescription

let package = Package(
  name: "ShareGardenScene",
  platforms: [
    SupportedPlatform.iOS(SupportedPlatform.IOSVersion.v15)
  ],
  products: [
    .library(
      name: "ShareGardenSceneEntity",
      targets: ["ShareGardenSceneEntity"]
    ),
    .library(
      name: "ShareGardenSceneAPI",
      targets: ["ShareGardenSceneAPI"]
    ),
    .library(
      name: "ShareGardenScene",
      targets: ["ShareGardenScene"]
    )
  ],
  dependencies: [
    Package.Dependency.package(path: "../ToDoGardenUI")
  ],
  targets: [
    .target(
      name: "ShareGardenSceneEntity"
    ),
    .target(
      name: "ShareGardenSceneAPI",
      dependencies: [
        Target.Dependency.product(
          name: "ToDoGardenUIAPI",
          package: "ToDoGardenUI"
        )
      ]
    ),
    .target(
      name: "ShareGardenScene",
      dependencies: [
        "ShareGardenSceneEntity",
        "ShareGardenSceneAPI",
        Target.Dependency.product(
          name: "ToDoGardenUIComponent",
          package: "ToDoGardenUI"
        )
      ]
    )
  ]
)
