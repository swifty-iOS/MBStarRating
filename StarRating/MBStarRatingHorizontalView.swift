//
//  MBStarRatingHorizontalView.swift
//  StarRating
//
//  Created by TCS-Manish on 03/11/2017.
//  Copyright © 2017 Manish. All rights reserved.
//

import Foundation

public class MBStarRatingHorizontalView: MBStarRatingView {
    
    override var _direction: MBStarBezierPath.Direction {
        return .horizontal
    }
}
