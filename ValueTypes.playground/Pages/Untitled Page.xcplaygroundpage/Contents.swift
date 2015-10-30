//: Playground - noun: a place where people can play

import UIKit
import CoreGraphics

var str = "Hello, playground"

protocol Drawable{
    func draw()
}

struct Circle: Equatable{
    var center: CGPoint
    var radius: CGFloat
    
    init(center: CGPoint, radius: CGFloat){
        self.center = center
        self.radius = radius
    }
}

extension Circle: Drawable{
    func draw() {
        let ctx = UIGraphicsGetCurrentContext()
        let arc = CGPathCreateMutable()
        CGPathAddArc(arc, nil, center.x, center.y, radius, 0, 2*CGFloat(M_PI), true)
        CGContextAddPath(ctx, arc)
        CGContextSetStrokeColorWithColor(ctx, UIColor.blueColor().CGColor)
        CGContextSetLineWidth(ctx, 4);
        CGContextStrokePath(ctx)
    }
}

func ==(lhs: Circle, rhs: Circle) -> Bool{
    return lhs.center == rhs.center && lhs.radius == rhs.radius
}

struct Polygon: Equatable{
    var corners: [CGPoint]
    
    init(corners: [CGPoint]){
        self.corners = corners
    }
}

extension Polygon: Drawable{
    func draw() {
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(ctx, UIColor.blueColor().CGColor)
        CGContextSetLineWidth(ctx, 4);
        CGContextMoveToPoint(ctx, corners.last!.x, corners.last!.y)
        for point in corners{
            CGContextAddLineToPoint(ctx, point.x, point.y)
        }
        CGContextClosePath(ctx)
        CGContextStrokePath(ctx)
    }
}

func ==(lhs: Polygon, rhs: Polygon) -> Bool{
    return lhs.corners == rhs.corners
}

struct Diagram: Drawable {
    var items: [Drawable] = []
    
    mutating func addItem(item: Drawable){
        items.append(item)
    }
    
    func draw(){
        for item in items {
            item.draw()
        }
    }
}

class MyView : UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        var doc = Diagram()
        doc.addItem(Polygon(corners: [self.center, CGPointMake(0, self.center.y), CGPointMake(self.center.x, 0), CGPointMake(self.bounds.width, self.center.y)]))
        doc.addItem(Circle(center: self.center, radius: 100))
        
        doc.draw()
    }
}

var myView : MyView = MyView(frame: CGRectMake(0,0,500,500))



