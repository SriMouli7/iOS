//
//  SpinningLayer.swift
//  SpiningLayers
//
//  Created by Sri Mouli Puttege on 9/8/16.
//  Copyright © 2016 Orange Matrix. All rights reserved.
//

import UIKit

class SpinningLayer: CATransformLayer {
    
    // base color of the layers. If new Color set, then change colors of all of the sublayers with variants.
    var color: UIColor = UIColor.whiteColor(){
        didSet{
            guard let sublayers = sublayers where sublayers.count > 0 else {return};
            
            for (index, layer)in sublayers.enumerate(){
                (layer as? CAShapeLayer)?.fillColor = color.set(hueSaturationOrBrightness: .Brightness, percentage: 1.0 - (0.1 * CGFloat(index))).CGColor
            }
        }
    }
    
    // size of the layer. If set change the subsequent layers' size and also change their anchor point from the top left corner to the center of the layer.
    var size: CGSize = CGSize(width: 100, height: 100){
        didSet{
            sublayers?.forEach({
                
                ($0 as? CAShapeLayer)?.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: size.width/4).CGPath
                ($0 as? CAShapeLayer)?.frame = CGPathGetBoundingBox(($0 as? CAShapeLayer)?.path)
                setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y: 0.5), forLayer: $0)
            })
        }
    }
    
    // Init with number of layers in the stack.
    convenience init(numberOfItems itemCount: Int){
        self.init()
        masksToBounds = false
        
        for i in 0..<itemCount{
            let layer = generateLayer(withSize: size, withIndex: i)
            insertSublayer(layer, atIndex: 0)
            setZPosition(ofShape: layer, z: CGFloat(i))
        }
        
        // reverse to get the darkest layer at the bottom and brightest on top(since added in reverse order)
        sublayers = sublayers?.reverse()
        centerInSuperLayer()
        rotateParentLayer(toDegree: 60)
        
    }
    
    // generate each layer in the stack
    private func generateLayer(withSize size:CGSize, withIndex index: Int) -> CAShapeLayer{
        let squareLayer = CAShapeLayer()
        squareLayer.path = UIBezierPath(roundedRect: CGRect(x: 0,y: 0,width: size.width, height: size.height), cornerRadius: size.width/4).CGPath
        squareLayer.frame = CGPathGetBoundingBox(squareLayer.path)
        setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y: 0.5), forLayer: squareLayer)
        
        return squareLayer
    
    }
    
    
    
    // Move the anchor point of a layer from its default(0,0) to its center.
    private func setAnchorPoint(anchorPoint anchorPoint:CGPoint, forLayer layer: CALayer){
        var newPoint = CGPoint(x: layer.bounds.size.width * anchorPoint.x, y: layer.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: layer.bounds.size.width * layer.anchorPoint.x, y: layer.bounds.size.height * layer.anchorPoint.y)
        
        newPoint = CGPointApplyAffineTransform(newPoint, layer.affineTransform())
        oldPoint = CGPointApplyAffineTransform(oldPoint, layer.affineTransform())
        
        var position = layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position = position
        layer.anchorPoint = anchorPoint
    }
    
    // Specify Z - index of a layer.
    // Negative factor to reverse the z ordering.
    private func setZPosition(ofShape shape: CAShapeLayer, z: CGFloat) {
        shape.zPosition = z*(-20)
    }
    
    // Position layer at the center in Super layer
    private func centerInSuperLayer() {
        frame = CGRect(x: getX(), y: getY(), width: size.width, height: size.height)
    }
    
    // Get Center X Co-ordinate
    private func getX() -> CGFloat {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        return (screenWidth/2)-(size.width/2)
    }
    
    // Get Center Y Co-ordinate
    private func getY() -> CGFloat {
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        return (screenHeight/2)-(2*(size.height/2))
    }
    
    // It converts degrees into radians
    private func degreesToRadians(degrees: CGFloat) -> CGFloat {
        return ((CGFloat(M_PI) * degrees) / 180.0)
    }
 

}

extension SpinningLayer {
    // use to start the animation. 
    //
    func startAnimating() {
        var offsetTime = 0.0
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -500.0
        transform = CATransform3DRotate(transform, CGFloat(M_PI), 0, 0, 1)
        
        // bundle the animations of all the layers and submit as one.
        CATransaction.begin()
        sublayers?.forEach({
            let basic = getSpin(forTransform: transform)
            basic.beginTime = $0.convertTime(CACurrentMediaTime(), toLayer: nil) + offsetTime
            $0.addAnimation(basic, forKey: nil)
            offsetTime += 0.1
        })
        CATransaction.commit()
    }
    
    // use to stop the animation.
    func stopAnimating() {
        sublayers?.forEach({ $0.removeAllAnimations() })
    }
    
    // get the basic spin animation which is added to each layer.
    private func getSpin(forTransform transform: CATransform3D) -> CABasicAnimation {
        let basic = CABasicAnimation(keyPath: "transform")
        basic.toValue = NSValue(CATransform3D: transform)
        basic.duration = 1.0
        basic.fillMode = kCAFillModeForwards
        basic.repeatCount = HUGE
//        basic.autoreverses = true
        basic.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        basic.removedOnCompletion = false
        return basic
    }
    
    // Change the viewing angle(rotate the parent view)
    private func rotateParentLayer(toDegree degree: CGFloat) {
        var transform = CATransform3DIdentity
//        transform.m34 = 1.0 / -500.0
        transform = CATransform3DRotate(transform, degreesToRadians(degree), 1, 0, 0)
        self.transform = transform
    }

}
