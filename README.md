# Obfuscate

[Security through obscurity](https://en.wikipedia.org/wiki/Security_through_obscurity) for iOS apps.

Inspired by [twenty3/Obfuscator](https://github.com/twenty3/Obfuscator), and these articles:


* [Secret Management on iOS - NSHipster](https://nshipster.com/secrets/)
* [Managing secrets within an iOS app | Lord Codes](https://www.lordcodes.com/articles/managing-secrets-within-an-ios-app)
* [Secure Secrets in iOS app. How do we store our secrets on the… | by Shahrukh Alam | Swift India | Medium](https://medium.com/swift-india/secure-secrets-in-ios-app-9f66085800b4)
* [Protecting Million-User iOS Apps with Obfuscation: Motivations, Pitfalls, and Experience - IEEE Conference Publication](https://ieeexplore.ieee.org/abstract/document/8449256)


This package contains both a library and command line tool.

Use the `obfuscate` command line tool to encrypt your secret token. It generates both a token and a key (A.K.A. salt) you can use to reveal the original value.

Include the library in your application to decode the value at runtime.


## obfuscate - command line tool

### Installation

#### With [`Mint`](https://github.com/yonaskolb/Mint)

```sh
$ mint install salishseasoftware/obfuscate
```

#### Manually

Clone the repo then:

```sh
$ make install
```

Or using swift itself:

```
$ swift build -c release
$ cp .build/release/obfuscate /usr/local/bin/obfuscate
```

#### With Xcode

Generate the Xcode project:

```
$ swift package generate-xcodeproj
$ open ./obfuscate.xcodeproj
```

In Xcode:

1. Product > Archive
1. Distribute Content
1. Built Products
1. copy `random-word` executable to `/usr/local/bin/` or wherever you prefer.


### Usage


```
OVERVIEW: Security through obscurity

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

USAGE: obfuscate <subcommand>

OPTIONS:
  -h, --help              Show help information.

SUBCOMMANDS:
  encrypt (default)       Obfuscates a string.
  decrypt                 Reveals an obfuscated string.

  See 'obfuscate help <subcommand>' for detailed help.

```

#### Encrypt

```
OVERVIEW: Obfuscates a string.

Generates a token from the provided string, along with a key that can 
be used to decrypt the token, and reveal the original value.

USAGE: obfuscate encrypt <string>

ARGUMENTS:
  <string>

OPTIONS:
  -h, --help              Show help information.
```

#### Decrypt

```
OVERVIEW: Reveals an obfuscated string.

Decrypts the provided token using the key to reveal the original value.

USAGE: obfuscate decrypt --token <token> --key <key>

OPTIONS:
  -t, --token <token>   The obfuscated string 
  -k, --key <key>         Secret key 
  -h, --help              Show help information.
```

## Obfuscator Library

The Obfuscator library provides just two functions:

### encrypt

`encrypt(_:)`

Encrypt a string

__Parameters__

- secret: The secret you want to encrypt.	
__Throws__

An error or type `ObfuscatorError.encryptionFailure` if the encryption fails.

__Returns__

A `(String, String)` tuple consisting of the obfuscated string (token) and a randomly generated salt (key) used to perform the encryption.

### decrypt

`decrypt(token:,key:)`

 Reveals the original value of an encrypted string.

__Parameters__

- `token:` The encrypted string.
- `key:` The salt used to encrypt the string.

__Throws__

An error or type `ObfuscatorError.decryptionFailure` if the decryption fails.

__Returns__

The original string.

### Installation

Add the package as a dependency in your Package.swift file

```swift
let package = Package(
    // name, platforms, products, etc.
    dependencies: [
        .package(url: "https://github.com/salishseasoftware/obfuscate", from: "0.1.0"),
        // other dependencies
    ],
    targets: [
        .target(name: "<a-target>", dependencies: [
            .product(name: "Obfuscator", package: "obfuscate"),
        ]),
        // other targets
    ]
)
```

