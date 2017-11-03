//
//  MBStarRatingView.swift
//  StarRating
//
//  Created by TCS-Manish on 21/10/2017.
//  Copyright © 2017 Manish. All rights reserved.
//

import UIKit

protocol MBStarRatingViewDelegate: class {
    func starRating(view: MBStarRatingView, didSelectRating rating: Double)
}

@IBDesignable
public class MBStarRatingView: UIView {
    
    private weak var _starCollectionView: UICollectionView?
    
    /// Set max allowed rating <Shoule be more than or equal 0...>
    @IBInspectable
    var maxRating: UInt = 5
    
    /// Set rating value <Should be less than max allowed rating>
    var rating: Double = 3.5 {
        didSet {
            if oldValue <= rating {
                reloadStar(from: floor(oldValue).int, to: ceil(rating).int)
            } else {
                reloadStar(from: floor(rating).int, to: ceil(oldValue).int)
            }
        }
    }
    
    private func reloadStar(from: Int, to: Int) {
     
        var reloadIndexes: [IndexPath] = []
        for item in from-1..<to {
            reloadIndexes.append(IndexPath(item: item, section: 0))
        }
        _starCollectionView?.reloadItems(at: reloadIndexes)
    }
    
    /// Make outer of start as Circle
    @IBInspectable
    var makeCircular: Bool = true
    
    /// Set extra paddig to outer circle and star
    var padding: CGFloat = 5
    
    fileprivate var _direction: UICollectionViewScrollDirection {
        return direction
    }
    /// Set direction of star
    var direction: UICollectionViewScrollDirection = .horizontal
    
    /// Set star color for actcive/ ainctive and outwe circle color
    @IBInspectable
    var activeColor: UIColor = StarView.Colors.deafultActiveColor
    @IBInspectable
    var incativeColor: UIColor = StarView.Colors.defaultInactiveColor
    @IBInspectable
    var circleColor: UIColor = UIColor.blue
    
    /// Set delegate get selection callback
    weak var delegate: MBStarRatingViewDelegate?
    
    private var validRating: Double {
        return min(maxRating.double , max(0, rating))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setNeedsDisplay()
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public func reloadRating() {
        (_starCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = _direction
        _starCollectionView?.reloadData()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    /// Setup collection view at once
    private func setup() {
        clipsToBounds = true
        let flowLayout =  UICollectionViewFlowLayout()
        flowLayout.scrollDirection = _direction
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = .zero
        let collectionView = UICollectionView.init(frame: bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        _starCollectionView = collectionView
        collectionView.bounces = false
        collectionView.register(StarCollectionViewCell.self, forCellWithReuseIdentifier: "StarCollectionViewCell")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        _starCollectionView?.frame = bounds
        reloadRating()
    }
    
    private func startColor() -> StarView.Colors {
        var color = StarView.Colors()
        color.activeColor = activeColor
        color.inactiveColor = incativeColor
        color.circleColor = circleColor
        return color
    }
    
}

public class MBStarRatingVerticleView: MBStarRatingView {
    
    override var _direction: UICollectionViewScrollDirection { return .vertical }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}

public class MBStarRatingHorizontalView: MBStarRatingView {
    
    override var _direction: UICollectionViewScrollDirection { return .horizontal }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}



extension MBStarRatingView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxRating.int
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StarCollectionViewCell", for: indexPath) as? StarCollectionViewCell
        cell?.startView?.makeCircular = makeCircular
        cell?.startView?.padding = padding
        cell?.startView?.color = startColor()
        cell?.startView?.rating = max(0,min(validRating - indexPath.item.double,1))
        cell?.startView?.update()
        return cell ?? UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 0
        if _direction == .horizontal {
            width = collectionView.bounds.height
        } else {
            width =  collectionView.bounds.width
        }
        return CGSize(width: width, height: width)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if delegate != nil {
            rating = (indexPath.item+1).double
        }
        delegate?.starRating(view: self, didSelectRating: rating)
    }
}

private class StarCollectionViewCell: UICollectionViewCell {
    
    weak var startView: StarView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        let star = StarView(frame: bounds)
        addSubview(star)
        startView = star
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let xyPos = startView?.validPading ?? 0
        let width = bounds.height - (xyPos * 2)
        let newFrame = CGRect(x: xyPos, y: xyPos, width: width, height: width)
        startView?.frame = newFrame
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}



private class StarView: UIView {
    
    var rating: Double = 0 // <Must be 0...1>
    var color = Colors()
    var makeCircular: Bool = true
    var padding: CGFloat = 0
    var validPading: CGFloat {
        return  min(padding, (bounds.width/2)-5)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
    }
    
    func update() {
        layer.setNeedsDisplay(bounds)
    }
    
    override func draw(_ rect: CGRect) {
        clipsToBounds = true
        layer.cornerRadius = makeCircular ? rect.height/2 : 0
        color.activeColor.setFill()
        let activePath = UIBezierPath.activeFillInnerPath(rect: rect, scale: rating, padding: validPading)
        activePath.fill()
        
        color.inactiveColor.setFill()
        let inactivePath = UIBezierPath.inactiveFillInnerPath(rect: rect, scale: rating, padding: validPading)
        inactivePath.fill()
        
        // Circle color should not be clear
        if color.circleColor == UIColor.clear {
            UIColor.black.setFill()
        } else {
            color.circleColor.setFill()
        }
        let outerPath = UIBezierPath(rect: rect)
        outerPath.append(UIBezierPath.starOuterPath(rect: rect, padding: validPading))
        outerPath.usesEvenOddFillRule = true
        outerPath.fill()
    }
    
}

extension StarView {
    
    struct Colors {
        var activeColor = deafultActiveColor
        var inactiveColor = defaultInactiveColor
        var circleColor = UIColor.black
        static var deafultActiveColor: UIColor { return UIColor(red: 254/255.0, green: 204/255.0, blue: 57/255.0, alpha: 1) }
        static var defaultInactiveColor: UIColor { return UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1) }
        
    }
}

private struct StarBezierPath {
    
    enum Direction {
        case verticle, horizontal
    }
    
    var scale:Double = 0
    var padding: CGFloat = 0
    var direction: StarBezierPath.Direction
    
    init(scale: Double, padding: CGFloat, direction: StarBezierPath.Direction) {
        self.scale = scale
        self.padding = padding
        self.direction = direction
    }
    
 func activeFillInnerPath(rect: CGRect) -> UIBezierPath {
        let yPos = ((rect.width - padding*2) * CGFloat(scale)) + padding
        let path = UIBezierPath()
        path.move(to: CGPoint(x: padding, y: padding))
        path.addLine(to: CGPoint(x: yPos, y: padding))
        path.addLine(to: CGPoint(x: yPos, y: rect.height - padding))
        path.addLine(to: CGPoint(x: padding, y: rect.height - padding))
        path.addLine(to: CGPoint(x: padding, y: padding))
        return path
    }
    
    func inactiveFillInnerPath(rect: CGRect) -> UIBezierPath {
        let xPos = ((rect.width - padding*2) * CGFloat(scale)) + padding
        let path = UIBezierPath()
        path.move(to: CGPoint(x: xPos, y: padding))
        path.addLine(to: CGPoint(x: rect.width - padding, y: padding))
        path.addLine(to: CGPoint(x: rect.width - padding, y: rect.height - padding))
        path.addLine(to: CGPoint(x: xPos, y: rect.height - padding))
        path.addLine(to: CGPoint(x: xPos, y: padding))
        return path
    }
    
    func starPath(rect: CGRect) -> UIBezierPath {
        let angle = 144.0
        let center = CGPoint(x: rect.width/2, y: rect.height/2)
        let radius = (center.x-padding) * -1
        var line = CGPoint(x: center.x, y: 0)
        let path = UIBezierPath()
        path.move(to: line)
        for i in 1...5 {
            var newAngle = (angle * i.double)
            newAngle = (Double.pi)/(180/newAngle)
            line =  CGPoint(x: center.x+(radius*(sin(newAngle).cgFloat)), y: center.y+(radius*(cos(newAngle).cgFloat)))
            path.addLine(to: line)
        }
        return path
    }
    
     func starOuterPath(rect: CGRect) -> UIBezierPath {
        
        let angle = 36.0
        let center = CGPoint(x: rect.width/2, y: rect.height/2)
        let radius = (center.x - padding) * -1
        var line = CGPoint(x: center.x, y: padding)
        let path = UIBezierPath()
        path.move(to: line)
        for i in 1...10 {
            var newAngle = (angle * i.double)
            newAngle = (Double.pi)/(180/newAngle)
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

private extension UIBezierPath {
    
    static func activeFillInnerPath(rect: CGRect, scale: Double, padding: CGFloat) -> UIBezierPath {
        let yPos = ((rect.width - padding*2) * CGFloat(scale)) + padding
        let path = UIBezierPath()
        path.move(to: CGPoint(x: padding, y: padding))
        path.addLine(to: CGPoint(x: yPos, y: padding))
        path.addLine(to: CGPoint(x: yPos, y: rect.height - padding))
        path.addLine(to: CGPoint(x: padding, y: rect.height - padding))
        path.addLine(to: CGPoint(x: padding, y: padding))
        return path
    }
    
    static func inactiveFillInnerPath(rect: CGRect, scale: Double, padding: CGFloat) -> UIBezierPath {
        let xPos = ((rect.width - padding*2) * CGFloat(scale)) + padding
        let path = UIBezierPath()
        path.move(to: CGPoint(x: xPos, y: padding))
        path.addLine(to: CGPoint(x: rect.width - padding, y: padding))
        path.addLine(to: CGPoint(x: rect.width - padding, y: rect.height - padding))
        path.addLine(to: CGPoint(x: xPos, y: rect.height - padding))
        path.addLine(to: CGPoint(x: xPos, y: padding))
        return path
    }
    
    static func starPath(rect: CGRect, padding: CGFloat) -> UIBezierPath {
        let angle = 144.0
        let center = CGPoint(x: rect.width/2, y: rect.height/2)
        let radius = (center.x-padding) * -1
        var line = CGPoint(x: center.x, y: 0)
        let path = UIBezierPath()
        path.move(to: line)
        for i in 1...5 {
            var newAngle = (angle * i.double)
            newAngle = (Double.pi)/(180/newAngle)
            line =  CGPoint(x: center.x+(radius*(sin(newAngle).cgFloat)), y: center.y+(radius*(cos(newAngle).cgFloat)))
            path.addLine(to: line)
        }
        return path
    }
    
    static func starOuterPath(rect: CGRect, padding: CGFloat) -> UIBezierPath {
        
        let angle = 36.0
        let center = CGPoint(x: rect.width/2, y: rect.height/2)
        let radius = (center.x - padding) * -1
        var line = CGPoint(x: center.x, y: padding)
        let path = UIBezierPath()
        path.move(to: line)
        for i in 1...10 {
            var newAngle = (angle * i.double)
            newAngle = (Double.pi)/(180/newAngle)
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

extension Double {
    var cgFloat: CGFloat { return CGFloat(self) }
    var int: Int { return Int(self) }
}

extension Int { var double: Double { return Double(self) } }
extension UInt {
    var double: Double { return Double(self) }
    var int: Int { return Int(self) }
    
}
