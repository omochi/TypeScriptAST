public import Foundation

public struct PathAliasTable {
    public init(_ entries: [Entry] = []) {
        self.entries = entries
    }

    public struct Entry {
        public init(alias: String, path: URL) {
            self.alias = alias
            self.path = path
        }

        public var alias: String
        public var path: URL

        public func mapToAlias(path: URL) -> (path: URL, updated: Bool) {
            let base = self.path.absoluteURL.standardized.pathComponents
            let full = path.absoluteURL.standardized.pathComponents

            guard full.starts(with: base) else {
                return (path, false)
            }

            let delta = full[base.count...]

            let mapped = URL(fileURLWithPath: alias)
                .appendingPathComponent(delta.joined(separator: "/"))
            return (mapped, true)
        }
    }

    public var entries: [Entry]

    public func mapToAlias(path: URL) -> (path: URL, updated: Bool) {
        for entry in entries {
            let (path, updated) = entry.mapToAlias(path: path)
            if updated {
                return (path, true)
            }
        }

        return (path, false)
    }
}
