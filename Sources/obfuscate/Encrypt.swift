import Foundation
import ArgumentParser
import Obfuscator

extension Obfuscate {
    struct Encrypt: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Obfuscates a string.",
            discussion: """
            Generates a cipher from the provided string, along with a key that can be used to decrypt the cipher,
            and reveal the original value.
            """
        )

        @Argument var string: String

        mutating func run() {
            do {
                let (cipher, key) = try Obfuscator.encrypt(string)
                print("cipher: \(cipher)")
                print("key: \(key)")
            } catch {
                Self.exit(withError: error)
            }
        }
    }
}
