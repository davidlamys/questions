import Foundation
import Alamofire
import CleanroomLogger

class HealthStatusProvider: HealthStatusRequest {
 
    func getHealthStatus(_ responder: HealthStatusResponse) {
        
        let request = Alamofire.request(App.context.getURL(endpoint: "health")).responseJSON { response in
            switch response.result {
            case .success:
                let healthStatus = HealthStatusMV(isSuccess: true, message: nil)
                responder.responseHealthStatus(result: Result(value: healthStatus))
            case .failure:
                Log.warning?.message("Error Result \n\(response.result)")
                let healthStatus = HealthStatusMV(isSuccess: false, message: L10n.connectionFailed)
                responder.responseHealthStatus(result: Result(value: healthStatus))
            }
        }
        Log.debug?.message("Request:\n\(String(describing: request))")
    }
}
