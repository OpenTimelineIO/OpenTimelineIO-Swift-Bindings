// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
// SPDX-License-Identifier: Apache-2.0
// Copyright Contributors to the OpenTimelineIO project

import PackageDescription

let package = Package(
    name: "otio_examples",
    platforms: [.macOS(.v10_13)],
    dependencies: [
    .package(name: "OpenTimelineIO", url: "https://github.com/meshula/OpenTimelineIO-Swift-Bindings.git", .branch("main"))
    ],
    targets: [
	.target(name: "cxx_opentime_example",
                dependencies: [
                    .product(name: "OpenTime_CXX", package: "OpenTimelineIO")]),
	.target(name: "cxx_example",
                dependencies: [
                    .product(name: "OpenTimelineIO_CXX", package: "OpenTimelineIO")]),
	.target(name: "swift_example",
                dependencies: ["OpenTimelineIO"])
    ],
    cxxLanguageStandard: CXXLanguageStandard.cxx11    
)
