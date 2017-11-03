//
//  HorizontalViewController.swift
//  StarRating
//
//  Created by TCS-Manish on 03/11/2017.
//  Copyright © 2017 Manish. All rights reserved.
//

import UIKit

class HorizontalViewController: StarViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func numberStarValueChanged(_ sender: UISlider) {
        ratingView?.maxRating = UInt(round(sender.value))
        sliderView?.maximumValue = round(sender.value)
        sliderView?.value = Float(ratingView?.rating ?? 0)
        
        ratingView?.reloadRating()
    }
}
