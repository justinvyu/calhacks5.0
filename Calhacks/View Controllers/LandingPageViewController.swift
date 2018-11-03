//
//  LandingPageViewController.swift
//  Calhacks
//
//  Created by Justin Yu on 11/3/18.
//  Copyright © 2018 Justin Yu. All rights reserved.
//

import UIKit
import Firebase

class LandingPageViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let topLeft = UIColor(red: 116/255, green: 185/255, blue: 1, alpha: 1).cgColor
        let middle = UIColor(red: 9/255, green: 132/255, blue: 227/255, alpha: 1).cgColor
        let bottomRight = UIColor(red: 162/255, green: 155/255, blue: 254/255, alpha: 1).cgColor
        self.view.gradientLayer.colors = [topLeft, bottomRight]
        self.view.gradientLayer.gradient = GradientPoint.topLeftBottomRight.draw()
    }

}
