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
        .package(url: "https://github.com/omochi/CodeTemplate", from: "1.0.1")
    ],
    targets: [
        .executableTarget(
            name: "codegen",
            dependencies: [
                .product(name: "CodeTemplate", package: "CodeTemplate")
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
