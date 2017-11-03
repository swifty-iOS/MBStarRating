//
//  VerticleViewController.swift
//  StarRating
//
//  Created by TCS-Manish on 03/11/2017.
//  Copyright © 2017 Manish. All rights reserved.
//

import UIKit

class VerticleViewController: StarViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func starRating(view: MBStarRatingView, fillDirectionForStarAt index: Int) -> MBStarBezierPath.Direction {
        return .vertical
    }

}
