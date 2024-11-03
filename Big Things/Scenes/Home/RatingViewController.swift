//
//# Author:    Tran Ngoc Thien Kim
//# Email Id:   TRANY057
//# Description:  Big Things, IOS assignment 2
//# This is my own work as defined by the University's Academic Misconduct policy.

import UIKit
import Cosmos

protocol RatingViewControllerDelegate: AnyObject {
    func didSubmitRating(_ data: Submit)
}

class RatingViewController: UIViewController {
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var bigThing: BigThing?
    var submitData: Submit?
    private var ratingValue = 0.0
    private let bigThingsRepository: BigThingsRepositoryType = BigThingsRepository(apiService: .shared, coreDataService: .shared)

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    weak var delegate: RatingViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRatingView()
        getRatingValue()
        setupActivityIndicator()
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupRatingView() {
        guard let bigThing = bigThing else { return }
        
        nameLabel.text = bigThing.name
        ratingView.settings.fillMode = .full
    }
    
    private func getRatingValue() {
        ratingView.didFinishTouchingCosmos = { rating in
            self.ratingValue = rating
        }
    }
    
    private func requestSubmit() {
        guard let bigThing = bigThing else { return }
        activityIndicator.startAnimating()
        bigThingsRepository.submitRatingBigThing(id: Int(bigThing.id) ?? 0, rating: Int(ratingValue)) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            
            switch result {
            case .success(let data):
                submitData = data
                DispatchQueue.main.async {
                    self.showAlert(title: data.result.capitalizedFirstLetter(),
                                   message: (data.message ?? "Your rating is recorded").capitalizedFirstLetter()) { action in
                        if let _ = data.message {} else {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            case .failure(let error):
                let errorDescription = String(describing: error)
                DispatchQueue.main.async {
                    self.showAlert(title: "ERROR", message: errorDescription)
                }
            }
        }
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        requestSubmit()
        if let submitData = submitData {
            self.delegate?.didSubmitRating(submitData)
        }
    }
}
