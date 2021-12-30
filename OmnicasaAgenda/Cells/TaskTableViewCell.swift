//
//  TaskTableViewCell.swift
//  OmnicasaAgenda
//
//  Created by Omnimobile on 12/30/21.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var txtType: UILabel!
    @IBOutlet weak var txtComment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
