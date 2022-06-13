import XCTest
@testable import Obfuscater

final class ObfuscaterTests: XCTestCase {

    let sekret = "super duper top sekret 💩!"

    func testEncrypt() throws {
        let (token, key) = try Obfuscater.encrypt(sekret)
        XCTAssertFalse(token.isEmpty)
        XCTAssertFalse(key.isEmpty)
        XCTAssertNotEqual(token, key)
        XCTAssertNotEqual(sekret, key)
    }

    func testDecrypt() throws {
        let (token, key) = try Obfuscater.encrypt(sekret)
        let decrypted = try Obfuscater.decrypt(token: token, key: key)
        XCTAssertNotNil(decrypted)
        XCTAssertEqual(sekret, decrypted)
    }

    func testDecryptInvalidKey() throws {
        let (token, _) = try Obfuscater.encrypt(sekret)
        XCTAssertThrowsError(try Obfuscater.decrypt(token: token, key: "INVALID")) { (errorThrown) in
            XCTAssertEqual(errorThrown as? Obfuscater.ObfuscaterError, Obfuscater.ObfuscaterError.decryptionFailure)
        }
    }

    func testDecryptInvalidSalt() throws {
        let (_, key) = try Obfuscater.encrypt(sekret)
        XCTAssertThrowsError(try Obfuscater.decrypt(token: "INVALID", key: key)) { (errorThrown) in
            XCTAssertEqual(errorThrown as? Obfuscater.ObfuscaterError, Obfuscater.ObfuscaterError.decryptionFailure)
        }
    }

    static var allTests = [
        ("testEncrypt", testEncrypt),
        ("testDecrypt", testDecrypt),
        ("testDecryptInvalidKey", testDecryptInvalidKey),
        ("testDecryptInvalidSalt", testDecryptInvalidSalt)
    ]
}
