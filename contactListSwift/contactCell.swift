//
//  contactCell.swift
//  contactListSwift
//
//  Created by Anuran Ghosh on 17/05/18.
//  Copyright © 2018 Anuran Ghosh. All rights reserved.
//

import UIKit

class contactCell: UITableViewCell {
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblEmail:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
