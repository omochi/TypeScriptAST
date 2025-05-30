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
        from: URL,
        symbolTable: SymbolTable,
        fileExtension: ImportFileExtension,
        pathAliasTable: PathAliasTable = .init(),
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
        var unknownSymbols: Set<String> = []
        for symbol in symbols {
            if originalSymbols.contains(symbol) {
                continue
            }

            if let file = symbolTable.find(symbol) {
                switch file {
                case .standardLibrary: break
                case .file(let file):
                    let path = resolveImportPath(from: from, file: file, extension: fileExtension)
                    fileToSymbols.add(
                        file: path.toImportFile(),
                        symbol: symbol
                    )
                }
                continue
            }

            if let defaultFile {
                fileToSymbols.add(file: defaultFile, symbol: symbol)
                continue
            } else {
                unknownSymbols.insert(symbol)
            }
        }
        if !unknownSymbols.isEmpty {
            throw MessageError("unknown symbols: \(unknownSymbols.sorted().joined(separator: ", "))")
        }

        var imports: [TSImportDecl] = []

        for file in fileToSymbols.files.sorted() {
            let symbols = Set(fileToSymbols.symbols(for: file)).sorted()
            if symbols.isEmpty { continue }

            var file = file
            let (newPath, updated) = pathAliasTable.mapToAlias(
                path: from.deletingLastPathComponent().appendingPathComponent(file)
            )
            if updated {
                file = newPath.relativePath
            }

            imports.append(
                TSImportDecl(names: symbols, from: file)
            )
        }

        return imports
    }
}

extension URL {
    fileprivate func toImportFile() -> String {
        if self.baseURL == nil { return self.path }

        var path = self.relativePath
        if !path.hasPrefix(".") {
            path = "./" + path
        }
        return path
    }
}

private func resolveImportPath(
    from: URL, file: URL, extension: ImportFileExtension
) -> URL {
    let file = modifyTSExtension(file: file, extension: `extension`)
    return URLs.relativePath(to: file, from: from.deletingLastPathComponent())
}

private func modifyTSExtension(file: URL, extension ext: ImportFileExtension) -> URL {
    func replace(to ext: String) -> URL {
        return URLs.replacingPathExtension(of: file, to: ext)
    }

    switch file.pathExtension {
    case "ts":
        return replace(to: ext.description)
    case "tsx":
        switch ext {
        case .ts: return replace(to: "tsx")
        case .js: return replace(to: "jsx")
        case .none: return replace(to: "")
        }
    default:
        return file
    }
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
