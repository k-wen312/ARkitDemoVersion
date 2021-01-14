//
//  CenterView.swift
//  ARkitDemoVersion
//
//  Created by 黃湛仁 on 2020/12/7.
//

import UIKit

@IBDesignable
class CenterView : UIView {
    
    
    var centerPoint: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    @IBInspectable
    var lineWidth: CGFloat{
        return 5
    }
    
    @IBInspectable
    var lineColor: UIColor = UIColor.black.withAlphaComponent(0.5)
    
    func createLine() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.midX - 10, y: bounds.midY))
        path.addLine(to: CGPoint(x: bounds.midX + 10, y: bounds.midY))
        path.move(to: CGPoint(x: bounds.midX, y: bounds.midY - 10))
        path.addLine(to: CGPoint(x: bounds.midX, y: bounds.midY + 10))
        return path
    }
    
    override func draw(_ rect: CGRect){
        let centerLine = createLine()
        centerLine.lineWidth = lineWidth
        lineColor.setStroke()
        centerLine.stroke()
        
    }
}
