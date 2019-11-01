//
//  AlertTint+UIAlertController.swift
//  LambdaTimeline
//
//  Created by Marlon Raskin on 9/30/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.tintColor = .darkTurquoise
    }
}
