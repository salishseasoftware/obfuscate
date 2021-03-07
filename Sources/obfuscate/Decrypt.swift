import Foundation
import ArgumentParser
import Obfuscator

extension Obfuscate {
    struct Decrypt: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Reveals an obfuscated string.",
            discussion: "Decrypts the provided cipher using the key to reveal the original value."
        )

        @Option(name: .shortAndLong, help: "The obfuscated string")
        var cipher: String

        @Option(name: .shortAndLong, help: "Secret key")
        var key: String

        mutating func run() {
            do {
                let result = try Obfuscator.decrypt(cipher: cipher, key: key)
                print(result)
            } catch {
                Self.exit(withError: error)
            }
        }
    }
}
