//
//# Author:    Tran Ngoc Thien Kim
//# Email Id:   TRANY057
//# Description:  Big Things, IOS assignment 2
//# This is my own work as defined by the University's Academic Misconduct policy.

import UIKit
import Cosmos

class BigThingDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var seenButton: UIButton!
    @IBOutlet weak var yourRatingLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    private let bigThingsRepository: BigThingsRepositoryType = BigThingsRepository(apiService: .shared, coreDataService: .shared)
    var bigThing : BigThing?
    
    private var blurEffectView: UIVisualEffectView?
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var isMarked = false
    private var isSaved = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        loadImage()
        setupContent()
        setStatusMarkButton()
        setupSavedRatingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        seenButton.isEnabled = true
        setupSavedRatingView()
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
    
    // load image from sever
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
    
    private func setStatusMarkButton() {
        guard let bigThing = bigThing else { return }
        bigThingsRepository.getSavedBigThing(byId: bigThing.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let isSaved):
                self.isMarked = isSaved
                self.isSaved = isSaved
                DispatchQueue.main.async {
                    let buttonImage = self.isMarked ? UIImage(named: "check")?.resized(to: CGSize(width: 32, height: 32))
                                                    : UIImage(named: "unCheck")?.resized(to: CGSize(width: 32, height: 32))
                    self.seenButton.setImage(buttonImage, for: .normal)
                }
            case .failure(_):
                return
            }
        }
    }
    
    private func setupSavedRatingView() {
        ratingView.settings.fillMode = .full
        ratingView.isUserInteractionEnabled = false
        ratingView.isHidden = true
        yourRatingLabel.isHidden = true

        guard let bigThing = bigThing else { return }

        // get state of rating from coredata
        bigThingsRepository.getSavedRating(byId: bigThing.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let myRating):
                DispatchQueue.main.async {
                    if myRating != 0 {
                        self.ratingView.isHidden = false
                        self.yourRatingLabel.isHidden = false
                        self.ratingView.rating = Double(myRating)
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.ratingView.isHidden = true
                    self.yourRatingLabel.isHidden = true
                }
            }
        }
    }
}

extension BigThingDetailViewController {
    
    // show decription of big thing
    @IBAction func descriptionButtonTapped(_ sender: Any) {
        guard let bigThing = bigThing else { return }

        let blurEffect = UIBlurEffect(style: .systemChromeMaterialDark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        if let tabBarHeight = tabBarController?.tabBar.frame.height {
            blurEffectView?.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - tabBarHeight)
        } else {
            blurEffectView?.frame = view.bounds
        }

        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let blurEffectView = blurEffectView {
            view.addSubview(blurEffectView)
        }

        let dialog = CustomDialogView(frame: CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 400))
        dialog.configure(text: bigThing.description)
        dialog.center = view.center

        view.addSubview(dialog)
        
        dialog.onClose = { [weak self] in
            self?.blurEffectView?.removeFromSuperview()
            self?.blurEffectView = nil
        }
    }
    
    @IBAction func markButtonTapped(_ sender: Any) {
        isMarked.toggle()
        let buttonImage = isMarked ? UIImage(named: "check")?.resized(to: CGSize(width: 32, height: 32))
                                   : UIImage(named: "unCheck")?.resized(to: CGSize(width: 32, height: 32))
        seenButton.setImage(buttonImage, for: .normal)
        
        if isMarked == true {
            seenButton.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) {
                self.performSegue(withIdentifier: "toRatingView", sender: nil)
            }
            if isSaved == false {
                guard let bigThing = bigThing else { return }
                bigThingsRepository.saveBigThing(bigThing) { result in
                    switch result {
                    case .success():
                        print("Save success")
                    case .failure(_):
                        print("Save error")
                    }
                }
            }
        }
    }
    
    @IBAction func mapButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toMapView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapView",
           let locationViewController = segue.destination as? LocationViewController {
            locationViewController.bigThing = bigThing
        } else if segue.identifier == "toRatingView",
           let ratingViewController = segue.destination as? RatingViewController {
            ratingViewController.bigThing = bigThing
            ratingViewController.delegate = self
        }
    }
}

extension BigThingDetailViewController: RatingViewControllerDelegate {
    func didSubmitRating(_ data: Submit) {
        DispatchQueue.main.async {
            self.voteLabel.text = "\(data.votes ?? "") votes"
            self.ratingLabel.text = "\(data.rating ?? "") rating"
        }
    }
}
