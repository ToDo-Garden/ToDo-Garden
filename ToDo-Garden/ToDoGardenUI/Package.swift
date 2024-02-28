// swift-tools-version: 5.9
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
			name: "ToDoGardenUIResource",
			targets: ["ToDoGardenUIResource"]
		)
	],
	targets: [
		.target(name: "ToDoGardenUIAPI"),
		.target(
			name: "ToDoGardenUIResource",
			resources: [
				.process("Fonts")
			]
		)
	]
)
