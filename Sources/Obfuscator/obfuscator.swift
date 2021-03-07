import Foundation

public class Obfuscator {

    public enum ObfuscatorError: Error, LocalizedError {
        case encryptionFailure
        case decryptionFailure
    }

    /// Encrypt a string
    /// - Parameter secret: The secret you want to encrypt
    /// - Throws: A ObfuscatorError.encryptionFailure if the encryption fails.
    /// - Returns: A tuple consisting of the encrypted string (cipher) and a
    ///     randomly generated salt (key) used to perform the encryption.
    public static func encrypt(_ secret: String) throws -> (cipher: String, key: String) {
        let key = randomString(length: secret.lengthOfBytes(using: .utf8))
        let salt = [UInt8](key.utf8)
        let bytes = [UInt8](secret.utf8)

        // make sure salt and secret are the same length
        guard bytes.count == salt.count else { throw ObfuscatorError.encryptionFailure }

        let encrypted = zip(bytes, salt)
            .map { $0 ^ $1 }
            .map { String(describing: $0) }
            .joined(separator: delimiter)
            .data(using: .utf8)?
            .base64EncodedString()

        guard let cipher = encrypted else { throw ObfuscatorError.encryptionFailure }

        return (cipher, key)
    }


    /// Reveals the original value of an encrypted string
    /// - Parameters:
    ///   - cipher: The encrytped string.
    ///   - key: The key (A.K.A. salt) used to encrypt the orignal.
    /// - Throws: An ObfuscatorError.decryptionFailure if the decryption fails.
    /// - Returns: The original value.
    public static func decrypt(cipher: String, key: String) throws -> String {
        guard
            let data = Data.init(base64Encoded: cipher),
            let byteString = String.init(bytes: data, encoding: .utf8)
        else {
            throw ObfuscatorError.decryptionFailure
        }

        let salt = [UInt8](key.utf8)
        let bytes = byteString.components(separatedBy: delimiter).compactMap { UInt8($0) }

        // make sure salt and byte array are the same length
        guard salt.count == bytes.count else { throw ObfuscatorError.decryptionFailure }

        let decrypted = zip(salt, bytes).map { $0 ^ $1 }

        guard let value = String(bytes: decrypted, encoding: .utf8) else { throw ObfuscatorError.decryptionFailure }

        return value
    }

    private static let delimiter = "-"

    private static func randomString(length: Int) -> String {
        let allowed = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let chars = (0 ..< length).map({ _ in allowed.randomElement()! }).shuffled()
        return String(chars)
    }
}
