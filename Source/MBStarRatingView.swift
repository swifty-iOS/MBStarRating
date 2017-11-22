//
//  MBStarRatingView.swift
//  StarRating
//
//  Created by TCS-Manish on 21/10/2017.
//  Copyright © 2017 Manish. All rights reserved.
//

import UIKit

public protocol MBStarRatingViewDelegate: class {
    func starRating(view: MBStarRatingView, didSelectRating rating: Double)
}

public protocol MBStarDelegate: class {
    func starRating(view: MBStarRatingView, fillDirectionForStarAt index: Int) -> MBStarBezierPath.Direction
    func starRating(view: MBStarRatingView, fillColor index: Int) -> StarColor
}


@IBDesignable
public class MBStarRatingView: UIView {
    
    private weak var _starCollectionView: UICollectionView?
    
    /// Set max allowed rating <Shoule be more than or equal 0...>
    @IBInspectable
    public var maxRating: UInt = 0
    
    /// Set rating value <Should be less than max allowed rating>
    @IBInspectable
    public var rating: Double = 0 {
        didSet {
            let validOldValue = min(oldValue, maxRating.double)
            if validOldValue <= rating {
                reloadStar(from: floor(validOldValue).int, to: ceil(rating).int)
            } else {
                reloadStar(from: floor(rating).int, to: ceil(validOldValue).int)
            }
        }
    }
    
    private func reloadStar(from: Int, to: Int) {
        
        var reloadIndexes: [IndexPath] = []
        for item in max(0, from-1)..<to {
            if item < maxRating {
                reloadIndexes.append(IndexPath(item: item, section: 0))
            }
        }
        _starCollectionView?.reloadItems(at: reloadIndexes)
    }
    
    /// Make outer of start as Circle
    @IBInspectable
    public var makeCircular: Bool = true
    
    /// Set extra paddig to outer circle and star
    @IBInspectable
    public var padding: CGFloat = 5
    
    var _direction: MBStarBezierPath.Direction {
        return direction
    }
    /// Set direction of star
    public var direction: MBStarBezierPath.Direction = .horizontal
    
    /// Set star color for actcive/ ainctive and outwe circle color
    @IBInspectable
    public var activeColor: UIColor = StarColor.deafultActiveColor
    @IBInspectable
    public var incativeColor: UIColor = StarColor.defaultInactiveColor
    @IBInspectable
    public var circleColor: UIColor = UIColor.blue
    
    /// Set delegate get selection callback
    public weak var delegate: MBStarRatingViewDelegate?
    
    /// Set delegate get selection callback
    public weak var starDelegate: MBStarDelegate?
    
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
        (_starCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = _direction.scrollDirection
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
        flowLayout.scrollDirection = _direction.scrollDirection
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
    
    func startColor() -> StarColor {
        var color = StarColor()
        color.activeColor = activeColor
        color.inactiveColor = incativeColor
        color.circleColor = circleColor
        return color
    }
    
}

extension MBStarRatingView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxRating.int
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StarCollectionViewCell", for: indexPath) as? StarCollectionViewCell
        cell?.startView?.makeCircular = makeCircular
        cell?.startView?.bezierPath.padding = padding
        if let color = starDelegate?.starRating(view: self, fillColor: indexPath.item) {
            cell?.startView?.color = color
        } else {
            cell?.startView?.color = startColor()
        }
        cell?.startView?.rating = max(0,min(validRating - indexPath.item.double,1))
        if let direction = starDelegate?.starRating(view: self, fillDirectionForStarAt: indexPath.item+1) {
            cell?.startView?.bezierPath.direction = direction
        } else {
            cell?.startView?.bezierPath.direction = _direction == .vertical ? .vertical : .horizontal
        }
        cell?.startView?.update()
        return cell ?? UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 0
        if _direction == .horizontal { width = collectionView.bounds.height
        } else { width =  collectionView.bounds.width
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
        let xyPos = startView?.bezierPath.validPading ?? 0
        let width = bounds.height - (xyPos * 2)
        let newFrame = CGRect(x: xyPos, y: xyPos, width: width, height: width)
        startView?.frame = newFrame
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}



fileprivate class StarView: UIView {
    
    var bezierPath =  MBStarBezierPath()
    
    var rating: Double = 0 { didSet { bezierPath.scale = max(0, min(1, rating)) } }
    
    var color = StarColor()
    var makeCircular: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.bezierPath.size = frame.size
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
    }
    
    func update() {
        layer.setNeedsDisplay(bounds)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        bezierPath.size = rect.size
        clipsToBounds = true
        layer.cornerRadius = makeCircular ? rect.height/2 : 0
        color.activeColor.setFill()
        let activePath = bezierPath.activeFillInnerPath()
        activePath.fill()
        
        color.inactiveColor.setFill()
        let inactivePath = bezierPath.inactiveFillInnerPath()
        inactivePath.fill()
        
        // Circle color should not be clear
        if color.circleColor == UIColor.clear { UIColor.black.setFill()
        } else { color.circleColor.setFill()
        }
        
        let outerPath = UIBezierPath(rect: rect)
        outerPath.append(bezierPath.starOuterPath())
        outerPath.usesEvenOddFillRule = true
        outerPath.fill()
    }
}

public struct StarColor {
    var activeColor = deafultActiveColor
    var inactiveColor = defaultInactiveColor
    var circleColor = UIColor.black
    static var deafultActiveColor: UIColor { return UIColor(red: 254/255.0, green: 204/255.0, blue: 57/255.0, alpha: 1) }
    static var defaultInactiveColor: UIColor { return UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1) }
    
}


extension MBStarBezierPath.Direction {
    
    var scrollDirection: UICollectionViewScrollDirection {
        switch self {
        case .vertical: return .vertical
        default: return .horizontal
        }
    }
}

extension Double {
    var cgFloat: CGFloat { return CGFloat(self) }
    var int: Int { return Int(self) }
    var angle: Double { return (.pi*self)/180 }
}

extension Int { var double: Double { return Double(self) } }
extension UInt {
    var double: Double { return Double(self) }
    var int: Int { return Int(self) }
    
}

