import UIKit

class LoadingVC: UIViewController, HealthStatusResponse {
    @IBOutlet private weak var spinnerView: UIActivityIndicatorView!
    @IBOutlet private weak var retryButton: UIButton!
    @IBOutlet private weak var messageLabel: UILabel!
    
    var healthRequest: HealthStatusRequest!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retryButton.titleLabel?.text = L10n.retry
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onTapRetry(self)
    }
    
    @IBAction func onTapRetry(_ sender: Any) {
        retryButton.isHidden = true
        healthRequest.getHealthStatus(self)
        spinnerView.startAnimating()
        messageLabel.text = L10n.checkingConnection
    }
    
    func responseHealthStatus(result: Result<HealthStatusMV, NoError>) {
        spinnerView.stopAnimating()
        
        switch result {
        case .success(let healthStatusMV):
            retryButton.isHidden = healthStatusMV.isSuccess
            messageLabel.text = healthStatusMV.message
            if healthStatusMV.isSuccess {
                startFadeTransition()
            }
            
        case .failure:
            retryButton.isHidden = false
            messageLabel.text = L10n.unexepectedError
        }
    }
    
    func startFadeTransition() {
        
        let newRootVC = App.context.router.rootVC
        let window = App.context.window
        window.rootViewController = newRootVC
        
        UIView.transition(with: window,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
                            window.rootViewController = newRootVC
                            
        }, completion: { completion in
            if completion {
                App.context.router.checkLink()
            }
        })
    }
}
