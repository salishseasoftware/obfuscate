import Foundation
import ArgumentParser
import Obfuscater

extension Obfuscate {
    struct Encrypt: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Obfuscates a string.",
            discussion: """
            Generates a token from the provided string, along with a key that can be used to decrypt the token,
            and reveal the original value.
            """
        )

        @Argument var string: String

        mutating func run() {
            do {
                let (token, key) = try Obfuscater.encrypt(string)
                print("token: \(token)")
                print("key: \(key)")
            } catch {
                Self.exit(withError: error)
            }
        }
    }
}
