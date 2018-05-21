import Foundation

class HealthStatusDummyProvider: HealthStatusRequest {
    
    func getHealthStatus(_ responder: HealthStatusResponse) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let healthStatus = HealthStatusMV(isSuccess: true, message: L10n.connectionFailed)
            responder.responseHealthStatus(result: Result(value: healthStatus))
        }
    }
}
