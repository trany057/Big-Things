//
//# Author:    Tran Ngoc Thien Kim
//# Email Id:   TRANY057
//# Description:  Big Things, IOS assignment 2
//# This is my own work as defined by the University's Academic Misconduct policy.

import UIKit

class BigThingTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
        
    private func setupUI() {
        cellView.layer.cornerRadius = 15
        cellView.clipsToBounds = true
        cellView.layer.borderWidth = 2
        cellView.layer.borderColor = UIColor.boder.cgColor
    }
    
    func setContent(bigThing: BigThing) {
        nameLabel.text = bigThing.name
        locationLabel.text = bigThing.location
        voteLabel.text = "\(bigThing.votes) votes"
        ratingLabel.text = "\(bigThing.rating) rating"
    }
}
