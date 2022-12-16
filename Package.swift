// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "TypeScriptAST",
    products: [
        .library(
            name: "TypeScriptAST",
            targets: ["TypeScriptAST"]
        ),
        .executable(name: "codegen", targets: ["codegen"])
    ],
    dependencies: [
        .package(url: "https://github.com/omochi/CodeTemplate", from: "1.0.1")
    ],
    targets: [
        .executableTarget(
            name: "codegen",
            dependencies: [
                .product(name: "CodeTemplate", package: "CodeTemplate")
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
