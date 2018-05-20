import CleanroomLogger
import Foundation

public struct AppLogFormatter: LogFormatter {
    
    public static func stringRepresentationOfSeverity(severity: LogSeverity) -> String {
        switch severity {
        case .verbose:
            return "📖"
        case .debug:
            return "🔍"
        case .info:
            return "⚽"
        case .warning:
            return "🚧"
        case .error:
            return "❌"
        }
    }
    
    public static func stringRepresentationForCallingFile(filePath: String, line: Int, function: String) -> String {
        let filename = NSURL(fileURLWithPath: filePath).lastPathComponent ?? "(unknown)"
        
        return "(\(filename):\(line))[\(function)]"
    }
    
    public static func formatLogMessageWithSeverity(severity: String, caller: String,
                                                    message: String, timestamp: String?, threadID: String?) -> String {
        var fmt = "\(severity) "
        
        if let timestamp = timestamp {
            fmt += "\(timestamp) "
        }
        
        if let threadID = threadID {
            fmt += "\(threadID) "
        }
        
        fmt += "\(caller)\n \(message)"
        
        return fmt
    }
    
    public func format(_ entry: CleanroomLogger.LogEntry) -> String? {
        let severity = AppLogFormatter.stringRepresentationOfSeverity(severity: entry.severity)
        
        let caller = AppLogFormatter.stringRepresentationForCallingFile(filePath: entry.callingFilePath,
                                                                        line: entry.callingFileLine,
                                                                        function: entry.callingStackFrame)
        
        return AppLogFormatter.formatLogMessageWithSeverity(severity: severity,
                                                            caller: caller,
                                                            message: PayloadLogFormatter().format(entry)!,
                                                            timestamp: TimestampLogFormatter().format(entry),
                                                            threadID: nil)
    }
}
