import XCTest
import class Foundation.Bundle

final class obfuscatorTests: XCTestCase {

    private let sekret = "Top secret 💩!"

    override func setUpWithError() throws {
        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return
        }
    }

    func testEncrypt() {
        let result = encrypt(args: ["encrypt", sekret])

        switch result {
        case .success(let (cipher, key)):
            XCTAssertFalse(cipher.isEmpty)
            XCTAssertFalse(key.isEmpty)

            XCTAssertNotEqual(cipher, key)

            XCTAssertNotEqual(sekret, cipher)
            XCTAssertNotEqual(sekret, key)

        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    /*
    func testEncyptSeparator() {
        let separatorArg = option(name: "separator", value: "-")
        let result = encrypt(args: ["encrypt", separatorArg, sekret])

        switch result {
        case .success(let (cipher, _)):
            let components = cipher.components(separatedBy: "-")
            XCTAssertFalse(components.isEmpty)
            XCTAssertEqual(sekret.lengthOfBytes(using: .utf8), components.count)

        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }
    */

    func testDecrypt() throws {
        let encryptResult = encrypt(args: ["encrypt", sekret])

        switch encryptResult {
        case .success(let (cipher, key)):

            let decryptResult = decrypt(args: ["decrypt"], cipher: cipher, key: key)

            switch decryptResult {
            case .success(let decrypted):
                XCTAssertEqual(sekret, decrypted)

            case .failure(let error):
                XCTFail(error.localizedDescription)
            }

        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func testDecryptInvalidKey() throws {
        let encryptResult = encrypt(args: ["encrypt", sekret])

        switch encryptResult {
        case .success(let (cipher, _)):

            let decryptResult = decrypt(args: ["decrypt"], cipher: cipher, key: "Invalid Key")

            switch decryptResult {
            case .success(let decrypted):
                XCTFail("Expected decrypt to fail, got '\(decrypted)'")

            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertFalse(error.localizedDescription.isEmpty)
            }

        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    /*
    func testDecryptSeparator() throws {
        let separatorArg = option(name: "separator", value: "-")
        let encryptResult = encrypt(args: ["encrypt", separatorArg, sekret])

        switch encryptResult {
        case .success(let (cipher, key)):

            // Decrypt using custom separator
            
            let decryptResultWithSeparator = decrypt(args: ["decrypt", separatorArg], cipher: cipher, key: key)

            switch decryptResultWithSeparator {
            case .success(let decrypted):
                XCTAssertEqual(sekret, decrypted)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }

            // Decrypt without using custom separator

            let decryptResultWithoutSeparator = decrypt(args: ["decrypt"], cipher: cipher, key: key)

            switch decryptResultWithoutSeparator {
            case .success:
                XCTFail("Expected decrypt to fail")
            case .failure(let error):
                XCTAssertEqual("Error: decryptionFailure", error.localizedDescription)
            }

        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }
    */

    private func runProcess(args: [String]) -> Result<String, Error> {
        let bin = productsDirectory.appendingPathComponent("obfuscate")
        let process = Process()
        process.executableURL = bin

        process.arguments = args

        let stdout = Pipe()
        process.standardOutput = stdout

        let stderr = Pipe()
        process.standardError = stderr

        do {
            try process.run()
            process.waitUntilExit()

            let data = stdout.fileHandleForReading.readDataToEndOfFile()

            let errData = stderr.fileHandleForReading.readDataToEndOfFile()

            if let errMssg = String(data: errData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) {
                guard errMssg.isEmpty else { throw(errMssg) }
            }

            guard let output = String(data: data, encoding: .utf8) else {
                throw("Output is nil")
            }

            return .success(output)

        } catch {
            return .failure(error)
        }
    }

    private func encrypt(args: [String]) -> Result<(cipher: String, key: String), Error> {
        let result = runProcess(args: args)

        switch result {
        case .success(let output):
            let lines = output.components(separatedBy: .newlines)

            let cipherPrefix = "cipher:"
            guard let cipher = lines.first(where: { $0.hasPrefix(cipherPrefix) })?
                .deletingPrefix(cipherPrefix)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            else {
                return .failure("Could not find 'cipher' in result")
            }

            let keyPrefix = "key:"
            guard let key = lines.first(where: { $0.hasPrefix(keyPrefix) })?
                .deletingPrefix(keyPrefix)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            else {
                return .failure("Could not find 'key' in result")
            }

            return .success((cipher, key))

        case .failure(let error):
            return .failure(error)
        }
    }

    private func decrypt(args: [String], cipher: String, key: String) -> Result<String, Error> {
        var allArgs = args
        allArgs.append(option(name: "cipher", value: cipher))
        allArgs.append(option(name: "key", value: key))

        let result = runProcess(args: allArgs)

        switch result {
        case .success(let output):
            return .success(output.trimmingCharacters(in: .whitespacesAndNewlines))
        case .failure(let error):
            return .failure(error)
        }
    }

    private enum OptionStyle {
        case short, long
    }

    private func option(name: String, value: String, style: OptionStyle = .long) -> String {
        switch style {
        case .short:
            let initial = name.first ?? Character("")
            return "-\(initial) \(value)"
        case .long:
            return "--\(name)=\(value)"
        }
    }

    /// Returns path to the built products directory.
    private var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    static var allTests = [
        ("testEncrypt", testEncrypt),
        ("testDecrypt", testDecrypt),
        ("testDecryptInvalidKey", testDecryptInvalidKey),
//        ("testEncyptSeparator", testEncyptSeparator),
//        ("testDecryptSeparator", testDecryptSeparator)
    ]
}

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}

extension String: Error, LocalizedError {
    public var errorDescription: String? { return self }
}
