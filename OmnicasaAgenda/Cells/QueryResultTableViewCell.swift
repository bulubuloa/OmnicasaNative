//
//  QueryResultTableViewCell.swift
//  OmnicasaAgenda
//
//  Created by Omnimobile on 12/31/21.
//

import UIKit

class QueryResultTableViewCell: UITableViewCell {

    @IBOutlet weak var txtDescription: UILabel!
    
    @IBOutlet weak var txtName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
