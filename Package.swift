// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "TypeScriptAST",
    platforms: [.macOS(.v12)],
    products: [
        .library(name: "TypeScriptAST", targets: ["TypeScriptAST"])
    ],
    dependencies: [
        .package(url: "https://github.com/omochi/CodegenKit.git", from: "2.0.0")
    ],
    targets: [
        .executableTarget(
            name: "codegen",
            dependencies: [
                .product(name: "CodegenKit", package: "CodegenKit")
            ]
        ),
        .plugin(
            name: "CodegenPlugin",
            capability: .command(
                intent: .custom(verb: "codegen", description: "codegen"),
                permissions: [.writeToPackageDirectory(reason: "codegen")]
            ),
            dependencies: [
                .target(name: "codegen")
            ]
        ),
        .target(
            name: "ASTNodeModule"
        ),
        .target(
            name: "TypeScriptAST",
            dependencies: [
                .target(name: "ASTNodeModule")
            ]
        ),
        .testTarget(
            name: "TypeScriptASTTests",
            dependencies: ["TypeScriptAST"]
        ),
    ]
)
