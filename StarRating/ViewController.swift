//
//  ViewController.swift
//  StarRating
//
//  Created by TCS-Manish on 21/10/2017.
//  Copyright © 2017 Manish. All rights reserved.
//

import UIKit

enum SegmentType: Int {
    case verticle = 0, horizontal = 1
}

class ViewController: UIViewController {
    
    weak var pageController: UIPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        setCoontroller(type: SegmentType.init(rawValue: sender.selectedSegmentIndex)!)
    }
    
    func setCoontroller(type: SegmentType) {
        
        var vc: UIViewController
        var direction: UIPageViewControllerNavigationDirection = .forward
        if type == .verticle {
            vc = self.storyboard!.instantiateViewController(withIdentifier: "VerticleViewController")
            direction = .reverse
        } else {
            vc = self.storyboard!.instantiateViewController(withIdentifier: "HorizontalViewController")
        }
        pageController?.setViewControllers([vc], direction: direction, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "PageController" {
            pageController = segue.destination as? UIPageViewController
            setCoontroller(type: .verticle)
        }
    }
    
    func starRating(view: MBStarRatingView, didSelectRating: Double) {
        
    }
}

