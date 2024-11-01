//
//# Author:    Tran Ngoc Thien Kim
//# Email Id:   TRANY057
//# Description:  Big Things, IOS assignment 2
//# This is my own work as defined by the University's Academic Misconduct policy.

import UIKit

import UIKit

class BigThingDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    private let bigThingsRepository: BigThingsRepositoryType = BigThingsRepository(apiService: .shared)
    var bigThing : BigThing?
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        loadImage()
        setupContent()
    }
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
        activityIndicator.startAnimating()
    }
    
    private func loadImage() {
        guard let bigThing = bigThing else { return }
        bigThingsRepository.getImageBigThing(nameImage: bigThing.image) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            switch result {
            case .success(let imageData):
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: imageData)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.showAlert(title: "ERROR", message: "No data response")
                }
            }
        }
    }
    
    private func setupContent() {
        guard let bigThing = bigThing else { return }
        nameLabel.text = bigThing.name
        locationLabel.text = bigThing.location
        statusLabel.text = bigThing.status
        voteLabel.text = "\(bigThing.votes) votes"
        ratingLabel.text = "\(bigThing.rating) rating"
        updateLabel.text = bigThing.updated
        yearLabel.text = bigThing.year
    }
    
    @IBAction func descriptionButtonTapped(_ sender: Any) {
    }

}
