//
//  CustomSlider.swift
//  HeartRateSocial
//
//  Created by Gyan Routray on 09/10/17.
//  Copyright © 2017 Gyan. All rights reserved.
//

import Foundation
import UIKit
 @IBDesignable class CustomSlider: UIView{
    private var gradiantBar = CustomGradientBar()
    private var knob = UIView()
    let barHeight: CGFloat = 7
    var knobRadious: CGFloat = 15
    
    let minValue: Float = 0
    @IBInspectable var maxValue: CGFloat = 1
    private var value: CGFloat = 0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    var getContineousValue = true
    var delegate : GRSliderDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    func setCurrentValue(_ val: CGFloat){
        if val >= 0 && val <= maxValue{
            let percentage = val/maxValue
            value = gradiantBar.bounds.size.width * percentage
            knob.center = CGPoint(x: value, y: knob.center.y)
            gradiantBar.gradientEndPont = value
            delegate?.sliderDidChangeValue(to: Float(val))
        }
    }
    
    func currentValue() -> CGFloat{
        let pointX = knob.center.x
        guard let fullWidth = knob.superview?.bounds.size.width else{
            return 0
        }
        let percentage = pointX / fullWidth
        return maxValue * percentage
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    func setup(){
        gradiantBar.frame = CGRect(x: 0, y: (bounds.size.height - barHeight)/2, width: bounds.size.width, height: barHeight)
        gradiantBar.layer.cornerRadius = barHeight * (50/100)
        gradiantBar.layer.borderColor = UIColor.black.cgColor
        gradiantBar.layer.borderWidth = 0.5
        gradiantBar.layer.masksToBounds = true
        addSubview(gradiantBar)
        
        knob.frame = CGRect(x: 0, y: (frame.size.height/2) - knobRadious, width: knobRadious * 2, height: knobRadious * 2)
        knob.backgroundColor = UIColor(red: 250/255, green: 161/255, blue: 57/255, alpha: 1.0)
        knob.layer.cornerRadius = knobRadious
        knob.layer.borderColor = UIColor.gray.cgColor
        knob.layer.borderWidth = 0.5
        knob.layer.borderColor = UIColor.lightGray.cgColor
        knob.layer.masksToBounds = true
        addSubview(knob)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        knob.addGestureRecognizer(panGesture)
        value = CGFloat(maxValue / 2)
    }
    
    override func draw(_ rect: CGRect) {
        gradiantBar.frame = CGRect(x: 0, y: (bounds.size.height - barHeight)/2, width: bounds.size.width, height: barHeight)
        let xValue = max(0, value - knobRadious)
        knob.frame = CGRect(x: xValue, y: (frame.size.height/2) - knobRadious, width: knobRadious * 2, height: knobRadious * 2)
    }
    
    @objc func panGestureAction(_ gesture: UIPanGestureRecognizer){
        let max = gradiantBar.bounds.size.width
        let point = gesture.location(in: gesture.view?.superview)
        switch (gesture.state) {
        case .began:
            print("Beginning point: \(point.x)")
            break;
        case .changed:
            if getContineousValue{
                if case 0...max = point.x{
                    setAndSendValue(withPoint: point, maxValue: max)
                }
            }
        case .ended:
            if point.x > max{
                knob.center = CGPoint(x: max, y: knob.center.y)
                delegate?.sliderDidChangeValue(to: Float(maxValue))
            }else if point.x < 0{
                knob.center = CGPoint(x: 0, y: knob.center.y)
                delegate?.sliderDidChangeValue(to: minValue)
            }else{
                setAndSendValue(withPoint: point, maxValue: max)
            }
        default:
            break;
        }
    }
    
    func setAndSendValue(withPoint point: CGPoint, maxValue max:CGFloat){
        knob.center = CGPoint(x: point.x, y: knob.center.y)
        gradiantBar.gradientEndPont = point.x
        let percentage = point.x / max
        let value = maxValue * percentage
        delegate?.sliderDidChangeValue(to: Float(value))
    }
}

protocol GRSliderDelegate {
    func sliderDidChangeValue(to value: Float)
}

class CustomGradientBar: UIView{
    var gradientEndPont: CGFloat = 0{
        didSet{
            setNeedsDisplay()
        }
    }
    let gradientLayer = CAGradientLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
   
    func setup(){
        backgroundColor = UIColor.lightGray
        let colorTop =  UIColor(red: 250/255, green: 101/255, blue: 69/255, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 250/255, green: 161/255, blue: 57/255, alpha: 1.0).cgColor
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.6, y: 0.5)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: gradientEndPont, height: bounds.size.height)
        layer.addSublayer(gradientLayer)
    }
    
    override func draw(_ rect: CGRect) {
        gradientLayer.frame = CGRect(x: 0, y: 0, width: gradientEndPont, height: bounds.size.height)
    }
}

class gradientLayer: CAGradientLayer{
    
}
