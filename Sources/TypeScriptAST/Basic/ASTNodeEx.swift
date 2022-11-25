extension ASTNode {
    public func print() -> String {
        let printer = ASTPrinter()
        return printer.print(self)
    }
}
