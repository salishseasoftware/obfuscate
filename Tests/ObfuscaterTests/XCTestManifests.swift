import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ObfuscaterTests.allTests),
    ]
}
#endif
