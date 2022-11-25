import XCTest
import TypeScriptAST

final class PrintTypeTests: TestCaseBase {
    func testNamed() throws {
        assertPrint(TSIdentType("A"), "A")

        assertPrint(
            TSIdentType(
                "A",
                genericArgs: [TSIdentType("T"), TSIdentType("U")]
            ),
            "A<T, U>"
        )

        assertPrint(
            TSIdentType(
                "S",
                genericArgs: [
                    TSArrayType(TSUnionType([
                        TSIdentType("A"),
                        TSIdentType("B"),
                        TSIdentType("C"),
                        TSIdentType("D")
                    ])),
                    TSIdentType("U")
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
                TSIdentType("A"),
                TSIdentType("B")
            ]),
            "A | B"
        )

        assertPrint(
            TSUnionType([
                TSIdentType("A"),
                TSIdentType("B"),
                TSIdentType("C")
            ]),
            "A | B | C"
        )
        assertPrint(
            TSUnionType([
                TSIdentType("A"),
                TSIdentType("B"),
                TSIdentType("C"),
                TSIdentType("D")
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
                TSObjectType([
                    .init(name: "kind", type: TSStringLiteralType("a")),
                    .init(name: "a", type: TSObjectType([
                        .init(name: "x", type: TSIdentType.number)
                    ]))
                ]),
                TSObjectType([
                    .init(name: "kind", type: TSStringLiteralType("b")),
                    .init(name: "b", type: TSObjectType([
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
        assertPrint(TSArrayType(TSIdentType.number), "number[]")

        assertPrint(
            TSArrayType(TSUnionType([TSIdentType.number, TSIdentType.null])),
            "(number | null)[]"
        )

        assertPrint(
            TSArrayType(TSUnionType([
                TSIdentType("A"),
                TSIdentType("B"),
                TSIdentType("C"),
                TSIdentType("D")
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
                base: TSIdentType("A"),
                name: TSIdentType("B")
            ),
            "A.B"
        )

        assertPrint(
            TSMemberType(
                base: TSMemberType(
                    base: TSIdentType("A"),
                    name: TSIdentType("B")
                ),
                name: TSIdentType("C", genericArgs: [TSIdentType("T")])
            ),
            "A.B.C<T>"
        )
    }

    func testDictionary() throws {
        assertPrint(
            TSDictionaryType(TSIdentType("A")),
            "{ [key: string]: A; }"
        )
    }

    func testRecord() throws {
        assertPrint(TSObjectType([]), "{}")

        assertPrint(
            TSObjectType([
                .init(name: "a", type: TSIdentType("A")),
                .init(name: "b", isOptional: true, type: TSIdentType("B"))
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
                    .init(name: "a", type: TSIdentType("A")),
                    .init(name: "b", type: TSIdentType("B"))
                ],
                result: TSIdentType.void
            ),
            "(a: A, b: B) => void"
        )

        assertPrint(
            TSFunctionType(
                params: [
                    .init(name: "a", type: TSIdentType("A")),
                    .init(name: "b", type: TSIdentType("B")),
                    .init(name: "c", type: TSIdentType("C")),
                    .init(name: "d", type: TSIdentType("D"))
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
            TSCustomType(text: "aaa"),
            "aaa"
        )
    }

    func testTaggedUnion() throws {
        let e = TSUnionType([
            TSObjectType([
                .init(name: "kind", type: TSStringLiteralType("a")),
                .init(name: "a", type: TSObjectType([]))
            ]),
            TSObjectType([
                .init(name: "kind", type: TSStringLiteralType("b")),
                .init(name: "b", type: TSObjectType([]))
            ])
        ])

        assertPrint(
            e, """
            {
                kind: "a";
                a: {};
            } | {
                kind: "b";
                b: {};
            }
            """
        )
    }

    func testLinedUnion() throws {
        let e = TSUnionType([
            TSStringLiteralType("a"),
            TSStringLiteralType("b"),
            TSStringLiteralType("c")
        ])

        assertPrint(
            e, """
            "a" | "b" | "c"
            """
        )
    }
}
