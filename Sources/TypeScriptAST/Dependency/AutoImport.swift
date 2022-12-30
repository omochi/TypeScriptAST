import Foundation
import SwiftyRelativePath

extension TSSourceFile {
    public var imports: [TSImportDecl] {
        elements.compactMap { $0.asDecl?.asImport }
    }

    public func replaceImportDecls(_ imports: [TSImportDecl]) {
        var elements = self.elements
        elements.removeAll { $0 is TSImportDecl }
        elements.insert(contentsOf: imports, at: 0)
        self.elements = elements
    }

    public func buildAutoImportDecls(
        from: String,
        symbolTable: SymbolTable,
        fileExtension: ImportFileExtension,
        defaultFile: String? = nil
    ) throws -> [TSImportDecl] {
        var fileToSymbols = FileToSymbols()

        var originalSymbols: Set<String> = []
        for `import` in self.imports {
            for symbol in `import`.names {
                fileToSymbols.add(file: `import`.from, symbol: symbol)
                originalSymbols.insert(symbol)
            }
        }

        let symbols = self.scanDependency()
        for symbol in symbols {
            if originalSymbols.contains(symbol) {
                continue
            }

            if let file = symbolTable.find(symbol) {
                switch file {
                case .standardLibrary: break
                case .file(let file):
                    fileToSymbols.add(
                        file: resolveImportPath(from: from, file: file, extension: fileExtension),
                        symbol: symbol
                    )
                }
                continue
            }

            if let defaultFile {
                fileToSymbols.add(file: defaultFile, symbol: symbol)
                continue
            } else {
                throw MessageError("unknown symbol: \(symbol)")
            }
        }

        var imports: [TSImportDecl] = []

        for file in fileToSymbols.files.sorted() {
            let symbols = Set(fileToSymbols.symbols(for: file)).sorted()
            if symbols.isEmpty { continue }

            imports.append(
                TSImportDecl(names: symbols, from: file)
            )
        }

        return imports
    }
}

private func resolveImportPath(
    from: String, file: String, extension: ImportFileExtension
) -> String {
    let from = URL(
        fileURLWithPath: from, relativeTo: URL(fileURLWithPath: "/")
    ).absoluteURL
    let file = URL(
        fileURLWithPath: modifyTSExtension(file: file, extension: `extension`),
        relativeTo: URL(fileURLWithPath: "/")
    ).absoluteURL

    var path = file.relativePath(from: from.deletingLastPathComponent())!
    if !path.hasPrefix(".") {
        path = "./" + path
    }
    return path
}

private func modifyTSExtension(file: String, extension: ImportFileExtension) -> String {
    let dir = (file as NSString).deletingLastPathComponent

    var base = (file as NSString).lastPathComponent
    let stem = (base as NSString).deletingPathExtension

    guard (base as NSString).pathExtension == "ts" else {
        return file
    }

    switch `extension` {
    case .none: base = stem
    case .js: base = stem + ".js"
    }

    return (dir as NSString).appendingPathComponent(base)
}

private struct FileToSymbols {
    var map: [String: [String]] = [:]

    var files: [String] {
        Array(map.keys)
    }

    func symbols(for file: String) -> [String] {
        map[file] ?? []
    }

    mutating func add(file: String, symbol: String) {
        var symbols = map[file] ?? []
        symbols.append(symbol)
        map[file] = symbols
    }
}
