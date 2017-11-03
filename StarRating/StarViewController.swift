//
//  StarViewController.swift
//  StarRating
//
//  Created by TCS-Manish on 03/11/2017.
//  Copyright © 2017 Manish. All rights reserved.
//

import UIKit

class StarViewController: UIViewController, MBStarRatingViewDelegate {
    
    @IBOutlet weak var sliderView: UISlider?
    @IBOutlet weak var labelValue: UILabel?
    @IBOutlet weak var ratingView: MBStarRatingView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingView?.delegate = self
        sliderView?.maximumValue = Float(ratingView?.maxRating ?? 0)
        setupDefault()
        // Do any additional setup after loading the view.
    }
    
    func setupDefault() {
        ratingView?.rating = (Double(ratingView?.maxRating ?? 0))/2
        labelValue?.text = "Current value: \(ratingView?.rating ?? 0)"
        sliderView?.value = Float(ratingView?.rating ?? 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func valueChanged(_ sender: UISlider) {
        ratingView?.rating = Double(sender.value)
        labelValue?.text = "Slider value: \(ratingView?.rating ?? 0)"

    }
    
    func starRating(view: MBStarRatingView, didSelectRating rating: Double) {
        labelValue?.text = "Selected value: \(rating)"
        sliderView?.value = Float(rating)
    }
    
}
