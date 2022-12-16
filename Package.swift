// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "TypeScriptAST",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "TypeScriptAST",
            targets: ["TypeScriptAST"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/omochi/CodeTemplate", from: "1.0.2"),
        .package(url: "https://github.com/apple/swift-format", exact: "0.50700.1")
    ],
    targets: [
        .executableTarget(
            name: "codegen",
            dependencies: [
                .product(name: "CodeTemplate", package: "CodeTemplate"),
                .product(name: "SwiftFormat", package: "swift-format")
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
                "ASTNodeModule"
            ]
        ),
        .testTarget(
            name: "TypeScriptASTTests",
            dependencies: ["TypeScriptAST"]
        ),
    ]
)
