// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
internal enum L10n {
  /// Checking connection
  internal static let checkingConnection = L10n.tr("Localizable", "checking_connection")
  /// Connection failed
  internal static let connectionFailed = L10n.tr("Localizable", "connection_failed")
  /// You didn't responde
  internal static let noAnswear = L10n.tr("Localizable", "no_answear")
  /// To use the app, please ensure that you are connected via wifi or cellular
  internal static let noConnectionMessage = L10n.tr("Localizable", "no_connection_message")
  /// Ups, you lost connection
  internal static let noConnectionTitle = L10n.tr("Localizable", "no_connection_title")
  /// Question: #%@
  internal static func questionIdentifier(_ p1: String) -> String {
    return L10n.tr("Localizable", "question_identifier", p1)
  }
  /// Retry
  internal static let retry = L10n.tr("Localizable", "retry")
  /// Strange errors happens ¯\_(ツ)_/¯
  internal static let unexepectedError = L10n.tr("Localizable", "unexepected_error")
  /// Your answer: %@
  internal static func yourAnswear(_ p1: String) -> String {
    return L10n.tr("Localizable", "your_answear", p1)
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
