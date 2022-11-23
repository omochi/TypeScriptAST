import XCTest
import TypeScriptAST

final class PrintTypeTests: XCTestCase {
    func testNamed() throws {
        assertPrint(TSNamedType(name: "A"), "A")

        assertPrint(
            TSNamedType(
                name: "A",
                genericArgs: [TSNamedType(name: "T"), TSNamedType(name: "U")]
            ),
            "A<T, U>"
        )

        assertPrint(
            TSNamedType(
                name: "S",
                genericArgs: [
                    TSArrayType(element: TSUnionType([
                        TSNamedType(name: "A"),
                        TSNamedType(name: "B"),
                        TSNamedType(name: "C"),
                        TSNamedType(name: "D")
                    ])),
                    TSNamedType(name: "U")
                ]
            ),
            """
            S<(
                A |
                B |
                C |
                D
            )[], U>
            """
        )
    }

    func testUnion() throws {
        assertPrint(
            TSUnionType([
                TSNamedType(name: "A"),
                TSNamedType(name: "B")
            ]),
            "A | B"
        )

        assertPrint(
            TSUnionType([
                TSNamedType(name: "A"),
                TSNamedType(name: "B"),
                TSNamedType(name: "C")
            ]),
            "A | B | C"
        )
        assertPrint(
            TSUnionType([
                TSNamedType(name: "A"),
                TSNamedType(name: "B"),
                TSNamedType(name: "C"),
                TSNamedType(name: "D")
            ]),
            """
            A |
            B |
            C |
            D
            """
        )

        assertPrint(
            TSUnionType([
                TSRecordType([
                    .init(name: "kind", type: TSStringLiteralType("a")),
                    .init(name: "a", type: TSRecordType([
                        .init(name: "x", type: TSNamedType.number)
                    ]))
                ]),
                TSRecordType([
                    .init(name: "kind", type: TSStringLiteralType("b")),
                    .init(name: "b", type: TSRecordType([
                        .init(name: "x", type: TSNamedType.string)
                    ]))
                ])
            ]),
            """
            {
                kind: "a";
                a: {
                    x: number;
                };
            } | {
                kind: "b";
                b: {
                    x: string;
                };
            }
            """
        )

    }

    func testArray() throws {
        assertPrint(TSArrayType(element: TSNamedType.number), "number[]")

        assertPrint(
            TSArrayType(element: TSNamedType.number.orNull),
            "(number | null)[]"
        )

        assertPrint(
            TSArrayType(element: TSUnionType([
                TSNamedType(name: "A"),
                TSNamedType(name: "B"),
                TSNamedType(name: "C"),
                TSNamedType(name: "D")
            ])),
            """
            (
                A |
                B |
                C |
                D
            )[]
            """
        )
    }

    func testStringLiteral() throws {
        assertPrint(TSStringLiteralType("aaa"),
            """
            "aaa"
            """
        )
    }

    func testNested() throws {
        assertPrint(
            TSNestedType(namespace: "A", type: TSNamedType(name: "B")),
            "A.B"
        )
    }

    func testDictionary() throws {
        assertPrint(
            TSDictionaryType(value: TSNamedType(name: "A")),
            "{ [key: string]: A; }"
        )
    }

    func testRecord() throws {
        assertPrint(TSRecordType([]), "{}")

        assertPrint(
            TSRecordType([
                .init(name: "a", type: TSNamedType(name: "A")),
                .init(name: "b", type: TSNamedType(name: "B"), isOptional: true)
            ]),
            """
            {
                a: A;
                b?: B;
            }
            """
        )
    }

    func testFunction() throws {
        assertPrint(TSFunctionType(params: [], result: TSNamedType.void), "() => void")

        assertPrint(
            TSFunctionType(
                params: [
                    .init(name: "a", type: TSNamedType(name: "A")),
                    .init(name: "b", type: TSNamedType(name: "B"))
                ],
                result: TSNamedType.void
            ),
            "(a: A, b: B) => void"
        )

        assertPrint(
            TSFunctionType(
                params: [
                    .init(name: "a", type: TSNamedType(name: "A")),
                    .init(name: "b", type: TSNamedType(name: "B")),
                    .init(name: "c", type: TSNamedType(name: "C")),
                    .init(name: "d", type: TSNamedType(name: "D"))
                ],
                result: TSNamedType.void
            ),
            """
            (
                a: A,
                b: B,
                c: C,
                d: D
            ) => void
            """
        )

    }

    func assertPrint(
        _ node: any ASTNode,
        _ expected: String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(node.print(), expected, file: file, line: line)
    }
}
