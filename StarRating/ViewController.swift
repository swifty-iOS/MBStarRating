//
//  ViewController.swift
//  StarRating
//
//  Created by TCS-Manish on 21/10/2017.
//  Copyright © 2017 Manish. All rights reserved.
//

import UIKit

class ViewController: UIViewController, StarRatingViewDelegate {

    @IBOutlet weak var ratingView: MBStarRatingView!
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func valueChange(_ sender: UISlider) {
        label.text = "\(sender.value)"
        ratingView.rating = Double(sender.value)
        ratingView.reloadRating()
    }
 
    func starRating(view: MBStarRatingView, didSelectRating: Double) {
        
    }
}

