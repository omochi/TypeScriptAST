import XCTest
import TypeScriptAST

final class PrintTypeTests: PrintTestsBase {
    func testNamed() throws {
        assertPrint(TSIdentType(name: "A"), "A")

        assertPrint(
            TSIdentType(
                name: "A",
                genericArgs: [TSIdentType(name: "T"), TSIdentType(name: "U")]
            ),
            "A<T, U>"
        )

        assertPrint(
            TSIdentType(
                name: "S",
                genericArgs: [
                    TSArrayType(element: TSUnionType([
                        TSIdentType(name: "A"),
                        TSIdentType(name: "B"),
                        TSIdentType(name: "C"),
                        TSIdentType(name: "D")
                    ])),
                    TSIdentType(name: "U")
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
                TSIdentType(name: "A"),
                TSIdentType(name: "B")
            ]),
            "A | B"
        )

        assertPrint(
            TSUnionType([
                TSIdentType(name: "A"),
                TSIdentType(name: "B"),
                TSIdentType(name: "C")
            ]),
            "A | B | C"
        )
        assertPrint(
            TSUnionType([
                TSIdentType(name: "A"),
                TSIdentType(name: "B"),
                TSIdentType(name: "C"),
                TSIdentType(name: "D")
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
                        .init(name: "x", type: TSIdentType.number)
                    ]))
                ]),
                TSRecordType([
                    .init(name: "kind", type: TSStringLiteralType("b")),
                    .init(name: "b", type: TSRecordType([
                        .init(name: "x", type: TSIdentType.string)
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
        assertPrint(TSArrayType(element: TSIdentType.number), "number[]")

        assertPrint(
            TSArrayType(element: TSUnionType([TSIdentType.number, TSIdentType.null])),
            "(number | null)[]"
        )

        assertPrint(
            TSArrayType(element: TSUnionType([
                TSIdentType(name: "A"),
                TSIdentType(name: "B"),
                TSIdentType(name: "C"),
                TSIdentType(name: "D")
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

    func testMember() throws {
        assertPrint(
            TSMemberType(
                base: TSIdentType(name: "A"),
                name: TSIdentType(name: "B")
            ),
            "A.B"
        )

        assertPrint(
            TSMemberType(
                base: TSMemberType(
                    base: TSIdentType(name: "A"),
                    name: TSIdentType(name: "B")
                ),
                name: TSIdentType(name: "C", genericArgs: [TSIdentType(name: "T")])
            ),
            "A.B.C<T>"
        )
    }

    func testDictionary() throws {
        assertPrint(
            TSDictionaryType(value: TSIdentType(name: "A")),
            "{ [key: string]: A; }"
        )
    }

    func testRecord() throws {
        assertPrint(TSRecordType([]), "{}")

        assertPrint(
            TSRecordType([
                .init(name: "a", type: TSIdentType(name: "A")),
                .init(name: "b", type: TSIdentType(name: "B"), isOptional: true)
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
        assertPrint(TSFunctionType(params: [], result: TSIdentType.void), "() => void")

        assertPrint(
            TSFunctionType(
                params: [
                    .init(name: "a", type: TSIdentType(name: "A")),
                    .init(name: "b", type: TSIdentType(name: "B"))
                ],
                result: TSIdentType.void
            ),
            "(a: A, b: B) => void"
        )

        assertPrint(
            TSFunctionType(
                params: [
                    .init(name: "a", type: TSIdentType(name: "A")),
                    .init(name: "b", type: TSIdentType(name: "B")),
                    .init(name: "c", type: TSIdentType(name: "C")),
                    .init(name: "d", type: TSIdentType(name: "D"))
                ],
                result: TSIdentType.void
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

    func testCustom() throws {
        assertPrint(
            TSCustomType(text: "aaa", symbols: []),
            "aaa"
        )
    }
}
