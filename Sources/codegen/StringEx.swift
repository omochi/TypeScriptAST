extension String {
    var pascal: String {
        guard var head = self.first else { return self }
        var tail = self
        tail.removeFirst()
        return head.uppercased() + tail
    }
}
