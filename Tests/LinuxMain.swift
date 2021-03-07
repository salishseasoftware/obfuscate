import XCTest

import obsfucatinatorTests

var tests = [XCTestCaseEntry]()
tests += obsfucatinatorTests.allTests()
XCTMain(tests)
