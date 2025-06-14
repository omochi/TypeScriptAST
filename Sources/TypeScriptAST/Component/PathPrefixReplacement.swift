import Foundation

public struct PathPrefixReplacement {
    public init(
        path: URL,
        replacement: String
    ) {
        self.path = path
        self.replacement = replacement
    }

    public var path: URL
    public var replacement: String

    public func replace(path: URL) -> URL? {
        let base = self.path.absoluteURL.standardized.pathComponents
        let full = path.absoluteURL.standardized.pathComponents

        guard full.starts(with: base) else {
            return nil
        }

        let delta = full[base.count...]

        return URL(fileURLWithPath: replacement)
            .appendingPathComponent(delta.joined(separator: "/"))
    }
}

public typealias PathPrefixReplacements = [PathPrefixReplacement]

extension PathPrefixReplacements {
    public func replace(path: URL) -> URL? {
        for x in self {
            if let new = x.replace(path: path) {
                return new
            }
        }
        return nil
    }
}
