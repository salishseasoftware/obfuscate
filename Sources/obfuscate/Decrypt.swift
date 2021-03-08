import Foundation
import ArgumentParser
import Obfuscator

extension Obfuscate {
    struct Decrypt: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Reveals an obfuscated string.",
            discussion: "Decrypts the provided token using the key to reveal the original value."
        )

        @Option(name: .shortAndLong, help: "The obfuscated string")
        var token: String

        @Option(name: .shortAndLong, help: "Secret key")
        var key: String

        mutating func run() {
            do {
                let result = try Obfuscator.decrypt(token: token, key: key)
                print(result)
            } catch {
                Self.exit(withError: error)
            }
        }
    }
}
