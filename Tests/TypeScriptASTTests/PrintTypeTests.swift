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
            TSArrayType(TSIntersectionType([TSIdentType.number, TSIdentType.null])),
            "(number & null)[]"
        )

        assertPrint(
            TSArrayType(TSConditionalType(TSIdentType("A"), extends: TSIdentType("B"), true: TSIdentType("C"), false: TSIdentType("D"))),
            "(A extends B ? C : D)[]"
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

    func testNumberLiteral() throws {
        assertPrint(TSNumberLiteralType(0),
            """
            0
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
                name: "B"
            ),
            "A.B"
        )

        assertPrint(
            TSMemberType(
                base: TSMemberType(
                    base: TSIdentType("A"),
                    name: "B"
                ),
                name: "C",
                genericArgs: [TSIdentType("T")]
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

        assertPrint(TSFunctionType(genericParams: ["T"], params: [], result: TSIdentType("T")), "<T>() => T")
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

    func testIntersection() throws {
        let s = TSIntersectionType([
            TSIdentType.string,
            TSObjectType([
                .init(name: "S", type: TSIdentType.never)
            ])
        ])

        assertPrint(
            s, """
            string & {
                S: never;
            }
            """
        )
    }

    func testConditional() throws {
        let s = TSConditionalType(TSIdentType("A"), extends: TSIdentType("B"), true: TSIdentType("C"), false: TSIdentType("D"))

        assertPrint(
            s, """
            A extends B ? C : D
            """
        )
    }

    func testInfer() throws {
        let s = TSConditionalType(
            TSIdentType("T"),
            extends: TSArrayType(TSInferType(name: "I")),
            true: TSIdentType("I"),
            false: TSIdentType("T")
        )
        assertPrint(
            s, """
            T extends (infer I)[] ? I : T
            """
        )
    }
}
