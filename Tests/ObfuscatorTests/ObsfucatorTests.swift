import XCTest
@testable import Obfuscator

final class ObfuscatorTests: XCTestCase {

    let sekret = "super duper top sekret 💩!"

    func testEncrypt() throws {
        let (cipher, key) = try Obfuscator.encrypt(sekret)
        XCTAssertFalse(cipher.isEmpty)
        XCTAssertFalse(key.isEmpty)
        XCTAssertNotEqual(cipher, key)
        XCTAssertNotEqual(sekret, key)
    }

    func testDecrypt() throws {
        let (cipher, key) = try Obfuscator.encrypt(sekret)
        let decrypted = try Obfuscator.decrypt(cipher: cipher, key: key)
        XCTAssertNotNil(decrypted)
        XCTAssertEqual(sekret, decrypted)
    }

    func testDecryptInvalidKey() throws {
        let (cipher, _) = try Obfuscator.encrypt(sekret)
        XCTAssertThrowsError(try Obfuscator.decrypt(cipher: cipher, key: "INVALID")) { (errorThrown) in
            XCTAssertEqual(errorThrown as? Obfuscator.ObfuscatorError, Obfuscator.ObfuscatorError.decryptionFailure)
        }
    }

    func testDecryptInvalidSalt() throws {
        let (_, key) = try Obfuscator.encrypt(sekret)
        XCTAssertThrowsError(try Obfuscator.decrypt(cipher: "INVALID", key: key)) { (errorThrown) in
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
