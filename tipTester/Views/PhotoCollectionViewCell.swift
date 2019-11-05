//
//  PhotoCollectionViewCell.swift
//  tipTester
//
//  Created by Marlon Raskin on 11/1/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var imageView: UIImageView!

	override func awakeFromNib() {
		super.awakeFromNib()
		containerView.layer.cornerRadius = 12
		containerView.layer.cornerCurve = .continuous
		containerView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFit
	}
}
