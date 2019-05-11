//
//  SSActivityIndicatorView.swift
//  SSForms
//
//  Created by Suraj on 5/11/19.
//  Copyright © 2019 Suraj. All rights reserved.
//

import Foundation
import UIKit

public class SSActivityIndicatorView: UIView {
    let vwwdth:CGFloat = 4
    let ofstY:CGFloat = 2
    let dotsCount = 5
    var offsetY: CGFloat = 0.0
    var animationExists: Bool = false
    let eImgHeaderFooterTag = 2255
    let eviewHeaderFooterLoadingTag = 100
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
   private func commonInit() {
        self.isHidden = true
        backgroundColor = UIColor.white
        offsetY = (frame.size.height - vwwdth) / 2
        createSubviews()
    }
    /**
     Perform action to create animation dot views.
     @param nil
     @return nil
     */
    func createSubviews() {
        for subview in subviews {
            if subview.tag != eImgHeaderFooterTag {
                subview.layer.removeAllAnimations()
                subview.removeFromSuperview()
            }
        }
        let frame = CGRect(x: superview?.frame.origin.x ?? 320.0 - vwwdth,
                           y: CGFloat(offsetY),
                           width: vwwdth,
                           height: vwwdth)
        for i in 0..<dotsCount {
            let dot = UIView(frame: frame)
            dot.backgroundColor = dotColor()
            dot.layer.cornerRadius = 2
            addSubview(dot)
        }
    }
    
    func startAnimating(withUserInteration interation: Bool) {
        if !animationExists {
            createSubviews()
            self.isHidden = false
            animationExists = true
            showFirstAnimation()
        }
        let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
        appDelegate.window?.isUserInteractionEnabled = interation
    }
    
    /**
     Perform first animation. Show incoming animation of dots from left
     @param nil
     @return nil
     */
    @objc func showFirstAnimation() {
        var i: Int = 0
        for dot in subviews {
            if dot.tag != eImgHeaderFooterTag {
                let delay: Float = Float(0.2 * Double(i))
                UIView.animate(withDuration: 0.5,
                               delay: TimeInterval(delay),
                               options: .curveEaseIn,
                               animations: {
                                let xAxis = self.superview?.frame.size.width ?? 10.0
                                let offSet = (xAxis / self.ofstY)
                                let xPosition = offSet - CGFloat((i * 10))
                    dot.frame = CGRect(x: xPosition,
                                       y: CGFloat(self.offsetY),
                                       width: self.vwwdth,
                                       height: self.vwwdth)
                    
                }) { finished in
                    if self.subviews.index(of: dot) == self.subviews.count - 1 && (self.superview != nil) && self.animationExists {
                        self.perform(#selector(self.secondAnimation), with: nil, afterDelay: 0.1)
                    }
                }
                i += 1
            }
        }
    }
    
    /**
     Perform second animation. Show outgoing animation of dots to right
     @param nil
     @return nil
     */
    @objc func secondAnimation() {
        var i: Int = 0
        for dot in subviews {
            if animationExists {
                if dot.tag != eImgHeaderFooterTag {
                    let delay: Float = Float(0.2 * Double(i))
                    UIView.animate(withDuration: 0.5, delay: TimeInterval(delay), options: .curveEaseOut, animations: {
                        dot.frame = CGRect(x: self.superview?.frame.size.width ?? 0.0 + 10,
                                           y: CGFloat(self.offsetY),
                                           width: self.vwwdth,
                                           height: self.vwwdth)
                    }) { finished in
                        dot.frame = CGRect(x: self.superview?.frame.origin.x ?? 0.0 - self.vwwdth,
                                           y: CGFloat(self.offsetY),
                                           width: self.vwwdth,
                                           height: self.vwwdth)
                        if self.subviews.index(of: dot) == self.subviews.count - 1 && (self.superview != nil) && self.animationExists {
                            self.perform(#selector(self.showFirstAnimation), with: nil, afterDelay: 0.1)
                        }
                    }
                    i += 1
                }
            }
        }
    }

    func stopAnimating() {
        if tag != eviewHeaderFooterLoadingTag {
            self.isHidden = true
        }
        let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
        appDelegate.window?.isUserInteractionEnabled = true
        animationExists = false
        for subview in subviews {
            if subview.tag != eImgHeaderFooterTag {
                subview.layer.removeAllAnimations()
                subview.removeFromSuperview()
            }
        }
    }

    private func dotColor() -> UIColor {
        let colors: [UIColor] = [getColor(42, 112, 199),
                                               getColor(228, 9, 9),
                                               getColor(53, 228, 9),
                                               getColor(184, 9, 228),
                                               getColor(203, 203, 49)
                                              ]
        let randomCount = arc4random() % UInt32(colors.count)
        return colors[Int(randomCount)]
    }
    private func getColor(_ aRed: CGFloat,_ aGreen: CGFloat,_ aBlue: CGFloat) -> UIColor {
        return UIColor(red: aRed/255.0, green: aGreen/255.0, blue: aBlue/255.0, alpha: 1.0)
    }
}


