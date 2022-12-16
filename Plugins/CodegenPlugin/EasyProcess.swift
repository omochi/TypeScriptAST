import Foundation

struct EasyProcess {
    init(
        path: URL,
        args: [String],
        outSink: ((Data) -> Void)? = nil,
        errorSink: ((Data) -> Void)? = nil
    ) {
        self.path = path
        self.args = args
        self.outSink = outSink ?? Self.defaultOutSink
        self.errorSink = errorSink ?? Self.defaultErrorSink
    }

    var path: URL
    var args: [String]
    var outSink: (Data) -> Void
    var errorSink: (Data) -> Void

    static func makeFileHandleSink(fileHandle: FileHandle) -> (Data) -> Void {
        return { (data) in
            try? fileHandle.write(contentsOf: data)
        }
    }

    static var defaultOutSink: (Data) -> Void {
        makeFileHandleSink(fileHandle: .standardOutput)
    }

    static var defaultErrorSink: (Data) -> Void {
        makeFileHandleSink(fileHandle: .standardError)
    }

    @discardableResult
    func run() throws -> Int32 {
        let queue = DispatchQueue(label: "EasyProcess.run")

        let p = Process()
        p.executableURL = path
        p.arguments = args

        let outPipe = Pipe()
        p.standardOutput = outPipe

        outPipe.fileHandleForReading.readabilityHandler = { (h) in
            queue.sync {
                outSink(h.availableData)
            }
        }

        let errPipe = Pipe()
        p.standardError = errPipe

        errPipe.fileHandleForReading.readabilityHandler = { (h) in
            queue.sync {
                errorSink(h.availableData)
            }
        }

        try p.run()

        p.waitUntilExit()

        outPipe.fileHandleForReading.readabilityHandler = nil
        errPipe.fileHandleForReading.readabilityHandler = nil

        try queue.sync {
            if let d = try outPipe.fileHandleForReading.readToEnd() {
                outSink(d)
            }
            if let d = try errPipe.fileHandleForReading.readToEnd() {
                errorSink(d)
            }
        }

        return p.terminationStatus
    }
}
