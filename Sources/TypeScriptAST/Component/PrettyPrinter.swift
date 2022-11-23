public final class PrettyPrinter {
    public init() {}

    public private(set) var output: String = ""
    public private(set) var isStartOfLine: Bool = true
    public private(set) var line: Int = 1
    private var depth: Int = 0

    public func write(space: String? = nil, _ text: String, newline: Bool = false) {
        if let space {
            write(space: space)
        }

        write(text)

        if newline {
            writeNewline()
        }
    }

    public func write(space: String) {
        if !isStartOfLine {
            write(space)
        }
    }

    public func write(_ text: String) {
        if text.isEmpty { return }

        if isStartOfLine {
            writeIndent()
        }

        output += text
    }

    public func writeNewline() {
        output += "\n"
        isStartOfLine = true
        line += 1
    }

    public func push(newline: Bool = true) {
        writeNewline()
        depth += 1
    }

    public func pop(newline: Bool = true) {
        writeNewline()
        depth -= 1
    }

    public func nest<R>(_ f: () throws -> R) rethrows -> R {
        push()
        defer { pop() }
        return try f()
    }

    private func writeIndent() {
        output += String(repeating: "    ", count: depth)
        isStartOfLine = false
    }
}
