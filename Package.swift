// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "TypeScriptAST",
    products: [
        .library(
            name: "TypeScriptAST",
            targets: ["TypeScriptAST"]
        ),
    ],
    dependencies: [
    ],
    targets: [
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
