import Foundation
import Alamofire
import CleanroomLogger

class HealthStatusProvider: HealthStatusRequest {
 
    func getHealthStatus(_ responder: HealthStatusResponse) {
        
        Alamofire.request(App.context.getURL(endpoint: "health")).responseJSON { response in
            
            if let json = response.result.value {
                Log.info?.message("JSON: \(json)") // serialized json response
            }
            
            switch response.result {
            case .success:
                let healthStatus = HealthStatusMV(isSuccess: true, message: nil)
                responder.responseHealthStatus(result: Result(value: healthStatus))
            case .failure:
                let healthStatus = HealthStatusMV(isSuccess: true, message: L10n.connectionFailed)
                responder.responseHealthStatus(result: Result(value: healthStatus))
            }
        }
    }
}
