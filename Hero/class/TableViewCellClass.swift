//
//  TableViewCellClass.swift
//  Hero
//
//  Created by Jesus Alberto Berlanga Reyes on 6/25/19.
//  Copyright © 2019 Jesus Alberto Berlanga Reyes. All rights reserved.
//

import UIKit

class TableViewCellClass: UITableViewCell {

    @IBOutlet weak var lblMove: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
