import Foundation
import CodeTemplate
import SwiftFormat

final class Writer {
    init(
        definitions: Definitions,
        formatter: SwiftFormatter,
        file: URL
    ) {
        self.definitions = definitions
        self.formatter = formatter
        self.file = file
    }

    let definitions: Definitions
    let formatter: SwiftFormatter
    let file: URL

    static let keywords = [
        "var"
    ]

    func paramLabel(_ string: String) -> String {
        if Self.keywords.contains(string) {
            return escape(string)
        } else {
            return string
        }
    }

    func escape(_ string: String) -> String {
        return "`" + string + "`"
    }

    func withTemplate(_ body: (inout Template) throws -> Void) throws {
        var t = try readAsTemplate()
        try body(&t)
        try write(template: t)
    }

    func readAsTemplate() throws -> Template {
        try Template(file: file)
    }

    func write(template: Template) throws {
        let source = template.description
        var formatted = ""
        do {
            try formatter.format(
                source: source,
                assumingFileURL: file,
                to: &formatted
            )
        } catch {
            print(source)
            throw error
        }
        let data = formatted.data(using: .utf8)!
        let old = try Data(contentsOf: file)
        guard old != data else { return }
        try data.write(to: file)
        print("update: \(file.relativePath)")
    }
}
