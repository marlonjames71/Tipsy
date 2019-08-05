//
//  SettingsViewController.swift
//  tipTester
//
//  Created by Marlon Raskin on 8/4/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.isNavigationBarHidden = false
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		setupLightUI()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

	private func setupLightUI() {
		navigationController?.navigationBar.tintColor = .turquoiseTwo
		view.backgroundColor = .wildSand
	}

}
