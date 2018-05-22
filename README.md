# Questions & Answers

An iOS application that follows the Bliss Recruitment Requirements.<br>
Question & Answers allows the user to respond questions.

Built in Swift 4.1 for iOS 9.0 and above.

## Installation

```sh
$ brew update
$ brew bundle
```

Brew will install:
- 'carthage' for code dependency tool
- 'rome' for carthage-cache tool
- 'swiftlint'  to enforce swift style and convention
- 'swiftgen' for code generation

Install 'synx' to reorganize your Xcode project folder to match your Xcode groups.
```sh
$ gem install specific_instal
$ gem specific_install https://github.com/turekj/synx -b v0.3
```

## Dependencies

To resolve all dependencies, just run in project folder:
```sh
$ ./scripts/resolveDependencies.sh
```

## Other scripts

To check if all installations went smoothly:
```sh
$ ./scripts/testEnvironment.sh
```

To check for lint errors or even file structure errors:
```sh
$ ./scripts/validate.sh
```

## TODO

Missing from this project are:
- sharing questions
- search for questions
- more UI request feedback
- feedback for empty table view's
- store questions persistent (only memory)

## Sidenote

The app seems not working when answering a question. This is because is updating the question with server dummy data. To skip this step, you can search for App.swift and change to:
```swift
let shouldUpdateWithServerData: Bool = false
```
