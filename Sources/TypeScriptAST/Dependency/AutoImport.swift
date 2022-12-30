import Foundation

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
        symbolTable: SymbolTable,
        fileExtension: ImportFileExtension,
        defaultFile: String? = nil
    ) throws -> [TSImportDecl] {
        var symbolTable = symbolTable

        var fileToSymbols = FileToSymbols()

        for `import` in self.imports {
            for symbol in `import`.names {
                fileToSymbols.add(file: `import`.from, symbol: symbol)
                symbolTable.add(symbol: symbol, file: .file(`import`.from))
            }
        }

        let symbols = self.scanDependency()
        for symbol in symbols {
            if let file = symbolTable.find(symbol) {
                switch file {
                case .standardLibrary: break
                case .file(let file):
                    fileToSymbols.add(file: file, symbol: symbol)
                }
            } else {
                if let defaultFile {
                    fileToSymbols.add(file: defaultFile, symbol: symbol)
                    continue
                } else {
                    throw MessageError("unknown symbol: \(symbol)")
                }
            }
        }

        var imports: [TSImportDecl] = []

        for file in fileToSymbols.files.sorted() {
            let symbols = Set(fileToSymbols.symbols(for: file)).sorted()
            if symbols.isEmpty { continue }

            let file = modifyTSExtension(file: file, extension: fileExtension)

            imports.append(
                TSImportDecl(names: symbols, from: file)
            )
        }

        return imports
    }
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
