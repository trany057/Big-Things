//
//# Author:    Tran Ngoc Thien Kim
//# Email Id:   TRANY057
//# Description:  Big Things, IOS assignment 2
//# This is my own work as defined by the University's Academic Misconduct policy.

import UIKit

class SideSheetViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var updatesLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    var bigThing : BigThing?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContent()
    }
    
    private func setupContent() {
        guard let bigThing = bigThing else { return }
        nameLabel.text = bigThing.name
        locationLabel.text = bigThing.location
        statusLabel.text = bigThing.status
        votesLabel.text = "\(bigThing.votes) votes"
        ratingLabel.text = "\(bigThing.rating) rating"
        updatesLabel.text = bigThing.updated
        yearLabel.text = bigThing.year
    }
}
