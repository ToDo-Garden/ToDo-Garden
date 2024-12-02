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
    Package.Dependency.package(path: "../ToDoGardenUI"),
    Package.Dependency.package(path: "../TDFoundation")
  ],
  targets: [
    .target(
      name: "OnBoardingScene",
      dependencies: [
        Target.Dependency.product(
          name: "TDFoundation",
          package: "TDFoundation"
        ),
        Target.Dependency.product(
          name: "ToDoGardenUIComponent",
          package: "ToDoGardenUI"
        ),
        Target.Dependency.product(
          name: "ToDoGardenUIResource",
          package: "ToDoGardenUI"
        )
      ]
    )
  ]
)
