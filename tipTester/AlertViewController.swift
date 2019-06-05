//
//  AlertViewController.swift
//  tipTester
//
//  Created by Marlon Raskin on 6/5/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		func alert() {
			let alert = UIAlertController(title: "Could not calculate the numbers entered", message: "Please try entering different numbers", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			self.present(alert, animated: true)
		}
    }
}
