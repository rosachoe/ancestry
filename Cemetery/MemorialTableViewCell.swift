//
//  MemorialTableViewCell.swift
//  Cemetery
//
//  Created by Rosa Choe on 4/11/17.
//  Copyright © 2017 Rosa Choe. All rights reserved.
//

import UIKit

class MemorialTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dob: UILabel!
    var id: String?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
