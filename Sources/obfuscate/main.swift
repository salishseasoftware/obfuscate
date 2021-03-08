import Foundation
import ArgumentParser
import Obfuscator

struct Obfuscate: ParsableCommand {

    static var configuration = CommandConfiguration(
        abstract: "Security through obscurity",
        discussion: """
        A utility to obfuscate a string using a randomly generated salt, and reveal
        the original value using the obfuscates string and the salt.

        You can include the obfuscated string in your applications source code and provide the key
        through some type of configuration method (ENV, XCConfig file, etc).

        Then use the `Obfuscator` library to decrypt the token at runtime when needed.

        The important bit is that your original secret should not be present in your source code,
        config files, or your SCM system.

        It is recommended that your generated key not be checked into your SCM system either.

        Keep in mind however that it's likely you will need to include the generated key in your apps bundle,
        so it's far form a perfect solution.
        """,
        subcommands: [
            Encrypt.self,
            Decrypt.self,
        ],
        defaultSubcommand: Encrypt.self
    )
}

Obfuscate.main()
