import Foundation

protocol HealthStatusRequest {
    
    func getHealthStatus(_ responder: HealthStatusResponse)
}

protocol HealthStatusResponse {
    
    func responseHealthStatus(result: Result<HealthStatusMV, NoError>)
}
