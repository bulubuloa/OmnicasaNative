//
//  AppointmentTableViewCell.swift
//  OmnicasaAgenda
//
//  Created by Omnimobile on 12/22/21.
//

import UIKit

class AppointmentTableViewCell: UITableViewCell {

    @IBOutlet weak var tfSub: UILabel!
    @IBOutlet weak var tfDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
