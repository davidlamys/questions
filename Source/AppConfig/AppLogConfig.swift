import Foundation
import CleanroomLogger

public struct AppLogConfiguration: LogConfiguration {
    public let minimumSeverity: LogSeverity
    
    public let filters: [LogFilter]
    
    public let recorders: [LogRecorder]
    
    public let synchronousMode: Bool
    
    public init(minimumSeverity: LogSeverity = .info) {
        self.minimumSeverity = minimumSeverity
        self.filters = []
        self.recorders = [StandardStreamsLogRecorder(formatters: [AppLogFormatter()])]
        self.synchronousMode = false
    }
}
