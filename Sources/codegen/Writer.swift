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

    func withTemplate(_ body: (inout Template) throws -> Void) throws {
        var t = try readAsTemplate()
        try body(&t)
        try write(template: t)
    }

    func readAsTemplate() throws -> Template {
        try Template(file: file)
    }

    func write(template: Template) throws {
        var formatted = ""
        try formatter.format(
            source: template.description,
            assumingFileURL: file,
            to: &formatted
        )
        let data = formatted.data(using: .utf8)!
        let old = try Data(contentsOf: file)
        guard old != data else { return }
        try data.write(to: file)
        print("update: \(file.relativePath)")
    }
}
