// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "TypeScriptAST",
    platforms: [.macOS(.v12)],
    products: [
        .library(name: "TypeScriptAST", targets: ["TypeScriptAST"]),
        .library(name: "TypeScriptASTExtensions", targets: ["TypeScriptASTExtensions"])
    ],
    dependencies: [
        .package(url: "https://github.com/omochi/CodegenKit", from: "1.3.0")
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
        .target(name: "TypeScriptASTExtensions"),
        .target(
            name: "TypeScriptAST",
            dependencies: [
                .target(name: "ASTNodeModule"),
                .target(name: "TypeScriptASTExtensions")
            ]
        ),
        .testTarget(
            name: "TypeScriptASTTests",
            dependencies: ["TypeScriptAST"]
        ),
    ]
)
