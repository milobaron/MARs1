//
//  HourlyTableViewCell.swift
//  MARRs1
//
//  Created by Mike Veson on 5/18/21.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static let identifier = "HourlyTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "HourlyTableViewCell", bundle: nil)
    }
}
