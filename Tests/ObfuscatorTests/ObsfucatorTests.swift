import XCTest
@testable import Obfuscator

final class ObfuscatorTests: XCTestCase {

    let sekret = "super duper top sekret 💩!"

    func testEncrypt() throws {
        let (token, key) = try Obfuscator.encrypt(sekret)
        XCTAssertFalse(token.isEmpty)
        XCTAssertFalse(key.isEmpty)
        XCTAssertNotEqual(token, key)
        XCTAssertNotEqual(sekret, key)
    }

    func testDecrypt() throws {
        let (token, key) = try Obfuscator.encrypt(sekret)
        let decrypted = try Obfuscator.decrypt(token: token, key: key)
        XCTAssertNotNil(decrypted)
        XCTAssertEqual(sekret, decrypted)
    }

    func testDecryptInvalidKey() throws {
        let (token, _) = try Obfuscator.encrypt(sekret)
        XCTAssertThrowsError(try Obfuscator.decrypt(token: token, key: "INVALID")) { (errorThrown) in
            XCTAssertEqual(errorThrown as? Obfuscator.ObfuscatorError, Obfuscator.ObfuscatorError.decryptionFailure)
        }
    }

    func testDecryptInvalidSalt() throws {
        let (_, key) = try Obfuscator.encrypt(sekret)
        XCTAssertThrowsError(try Obfuscator.decrypt(token: "INVALID", key: key)) { (errorThrown) in
            XCTAssertEqual(errorThrown as? Obfuscator.ObfuscatorError, Obfuscator.ObfuscatorError.decryptionFailure)
        }
    }

    static var allTests = [
        ("testEncrypt", testEncrypt),
        ("testDecrypt", testDecrypt),
        ("testDecryptInvalidKey", testDecryptInvalidKey),
        ("testDecryptInvalidSalt", testDecryptInvalidSalt)
    ]
}
