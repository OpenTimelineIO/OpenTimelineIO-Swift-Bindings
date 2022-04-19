// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OpenTimelineIO",
    platforms: [.macOS(.v10_13),
        .iOS(.v11)],
    products: [
        .library(name: "any", targets: ["any"]),
        .library(name: "OpenTime_CXX", targets: ["OpenTime_CXX"]),
        .library(name: "OpenTimelineIO_CXX", targets: ["OpenTimelineIO_CXX"]),
        .library(name: "OpenTimelineIO", targets: ["OpenTimelineIO"])
    ],

    dependencies: [],
    targets: [
        .target(name: "any",
            path: ".",
            exclude: [
                "CONTRIBUTORS.md", "NOTICE.txt", "CONTRIBUTING.md", "LICENSE.txt", "CODE_OF_CONDUCT.md",
                "OTIO_CLA_Corporate.pdf", "OTIO_CLA_Individual.pdf",
                "README.md", "Sources/shims/optionallite-shim.cpp", "Sources/shims/otio_header_root-shim.cpp",
                "Examples", "OpenTimelineIO", "Tests", "Sources/objc", "Sources/swift"],
            sources: ["Sources/shims/any-shim.cpp"],
            publicHeadersPath:"OpenTimelineIO/src/deps"),

        .target(name: "optionallite",
            path: ".",
            exclude: [
                "CONTRIBUTORS.md", "NOTICE.txt", "CONTRIBUTING.md", "LICENSE.txt", "CODE_OF_CONDUCT.md",
                "OTIO_CLA_Corporate.pdf", "OTIO_CLA_Individual.pdf",
                "README.md", "Sources/shims/any-shim.cpp", "Sources/shims/otio_header_root-shim.cpp",
                "Examples", "OpenTimelineIO", "Tests", "Sources/objc", "Sources/swift"],
            sources: ["Sources/shims/optionallite-shim.cpp"],
            publicHeadersPath:"OpenTimelineIO/src/deps/optional-lite/include"),

        .target(name: "otio_header_root",
            path: ".",
            exclude: [
                "CONTRIBUTORS.md", "NOTICE.txt", "CONTRIBUTING.md", "LICENSE.txt", "CODE_OF_CONDUCT.md",
                "OTIO_CLA_Corporate.pdf", "OTIO_CLA_Individual.pdf",
                "README.md", "Sources/shims/any-shim.cpp", "Sources/shims/optionallite-shim.cpp",
                "Examples", "OpenTimelineIO", "Tests", "Sources/objc", "Sources/swift"],
            sources: ["Sources/shims/otio_header_root-shim.cpp"],
            publicHeadersPath:"OpenTimelineIO/src"),

        .target(name: "OpenTime_CXX",
            dependencies: ["otio_header_root"],
            path: "OpenTimelineIO/src/opentime",
            exclude: [ "CMakeLists.txt" ],
            sources: ["."],
            publicHeadersPath: ".",
            cxxSettings: [ .headerSearchPath(".")]),

        .target(name: "OpenTimelineIO_CXX",
            dependencies: ["OpenTime_CXX", "any", "optionallite"],
            path: "OpenTimelineIO/src/OpenTimelineIO",
            exclude: [ "CMakeLists.txt" ],
            sources: ["."],
            publicHeadersPath: ".",
            cxxSettings: [
                .headerSearchPath("."),
                .headerSearchPath("../deps/Imath/src/Imath"),
                .headerSearchPath("../../../Sources/cpp"),
                .headerSearchPath("../deps/rapidjson/include")]),

        .target(name: "OpenTimelineIO_objc",
            dependencies: ["OpenTimelineIO_CXX"],
            path: "Sources",
            exclude: ["swift", "shims"],
            sources: ["objc"],
            publicHeadersPath: "objc/include",
            cxxSettings: [
                .headerSearchPath("../OpenTimelineIO/src/deps/Imath/src/Imath"),
                .headerSearchPath("../Sources/cpp"),
                .headerSearchPath("objc/include")]),

        // public target
        .target(name: "OpenTimelineIO",
            dependencies: ["OpenTimelineIO_objc"],
            path: "Sources",
            exclude: ["objc", "shims"],
            sources: ["swift"]),

        .testTarget(name: "OpenTimelineIOTests",
            dependencies: ["OpenTimelineIO"],
            path: "Tests",
            sources: ["OpenTimelineIOTests"],
            resources: [ .copy("data") ])
    ],
    cxxLanguageStandard: CXXLanguageStandard.cxx14
)
