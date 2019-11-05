//
//  NeverSelectedTableViewCell.swift
//  tipTester
//
//  Created by Marlon Raskin on 10/31/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class NeverSelectedTableViewCell: UITableViewCell {

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
}
