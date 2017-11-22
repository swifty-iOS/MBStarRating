//
//  MBStarBezierPath.swift
//  StarRating
//
//  Created by TCS-Manish on 03/11/2017.
//  Copyright © 2017 Manish. All rights reserved.
//

import Foundation
import UIKit

public struct MBStarBezierPath {
    
    public enum Direction {
        case vertical, horizontal
        var path: FillPathProtocol {
            switch self {
            case .vertical: return VerticalFillPath()
            default: return HorizontalFillPath()
            }
        }
    }
    
    private var rect: CGRect = .zero
    var size: CGSize = .zero { didSet { rect =  CGRect(origin: .zero, size: size) } }
    var scale:Double = 0
    var padding: CGFloat = 0
    var direction: MBStarBezierPath.Direction = .horizontal
    var validPading: CGFloat { return  min(padding, (rect.width/2)-5) }
    
    func activeFillInnerPath() -> UIBezierPath {
        return direction.path.activePath(rect: rect, scale: CGFloat(scale), padding: validPading)
    }
    
    func inactiveFillInnerPath() -> UIBezierPath {
        return direction.path.inactivePath(rect: rect, scale: CGFloat(scale), padding: validPading)
    }
    
    func starPath() -> UIBezierPath {
        let angle = 144.0
        let center = CGPoint(x: rect.width/2, y: rect.height/2)
        let radius = (center.x-validPading) * -1
        var line = CGPoint(x: center.x, y: 0)
        let path = UIBezierPath()
        path.move(to: line)
        for i in 1...5 {
            var newAngle = (angle * i.double)
            newAngle = newAngle.angle
            line =  CGPoint(x: center.x+(radius*(sin(newAngle).cgFloat)), y: center.y+(radius*(cos(newAngle).cgFloat)))
            path.addLine(to: line)
        }
        return path
    }
    
    func starOuterPath() -> UIBezierPath {
        let angle = 36.0
        let center = CGPoint(x: rect.width/2, y: rect.height/2)
        let radius = (center.x - validPading) * -1
        var line = CGPoint(x: center.x, y: validPading)
        let path = UIBezierPath()
        path.move(to: line)
        for i in 1...10 {
            var newAngle = (angle * i.double)
            newAngle = newAngle.angle
            if i%2 == 0 {
                line =  CGPoint(x: center.x+(radius*(sin(newAngle).cgFloat)), y: center.y+(radius*(cos(newAngle).cgFloat)))
            } else {
                line =  CGPoint(x: center.x+(radius/3*(sin(newAngle).cgFloat)), y: center.y+(radius/3*(cos(newAngle).cgFloat)))
            }
            path.addLine(to: line)
        }
        return path
    }
}

protocol FillPathProtocol {
    func activePath(rect: CGRect, scale: CGFloat, padding: CGFloat) -> UIBezierPath
    func inactivePath(rect: CGRect, scale: CGFloat, padding: CGFloat) -> UIBezierPath
}

struct VerticalFillPath: FillPathProtocol {
    
    func activePath(rect: CGRect, scale: CGFloat, padding: CGFloat) -> UIBezierPath {
        let yPos = ((rect.height - padding*2) * scale) + padding
        let path = UIBezierPath()
        path.move(to: CGPoint(x: padding, y: padding))
        path.addLine(to: CGPoint(x: padding, y: yPos))
        path.addLine(to: CGPoint(x: rect.width - padding, y:  yPos ))
        path.addLine(to: CGPoint(x: rect.width - padding, y: padding))
        path.addLine(to: CGPoint(x: padding, y: padding))
        return path
    }
    
    func inactivePath(rect: CGRect, scale: CGFloat, padding: CGFloat) -> UIBezierPath {
        let xPos = ((rect.height - padding*2) * scale) + padding
        let path = UIBezierPath()
        path.move(to: CGPoint(x: padding, y: xPos))
        path.addLine(to: CGPoint(x: padding, y: rect.height-padding))
        path.addLine(to: CGPoint(x: rect.width-padding, y: rect.height-padding))
        path.addLine(to: CGPoint(x: rect.width-padding, y: xPos))
        path.addLine(to: CGPoint(x: padding, y: xPos))
        return path
    }
    
}

struct HorizontalFillPath: FillPathProtocol {
    
    func activePath(rect: CGRect, scale: CGFloat, padding: CGFloat) -> UIBezierPath {
        let yPos = ((rect.width - padding*2) * scale) + padding
        let path = UIBezierPath()
        path.move(to: CGPoint(x: padding, y: padding))
        path.addLine(to: CGPoint(x: yPos, y: padding))
        path.addLine(to: CGPoint(x: yPos, y: rect.height-padding))
        path.addLine(to: CGPoint(x: padding, y: rect.height-padding))
        path.addLine(to: CGPoint(x: padding, y: padding))
        return path
    }
    
    func inactivePath(rect: CGRect, scale: CGFloat, padding: CGFloat) -> UIBezierPath {
        let xPos = ((rect.width - padding*2) * scale) + padding
        let path = UIBezierPath()
        path.move(to: CGPoint(x: xPos, y: padding))
        path.addLine(to: CGPoint(x: rect.width-padding, y: padding))
        path.addLine(to: CGPoint(x: rect.width-padding, y: rect.height-padding))
        path.addLine(to: CGPoint(x: xPos, y: rect.height-padding))
        path.addLine(to: CGPoint(x: xPos, y: padding))
        return path
    }
    
}
