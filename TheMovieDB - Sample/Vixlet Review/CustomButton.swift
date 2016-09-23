//
//  CustomButton.swift
//  TheMovieDB-Sample
//
//  Created by Sri Mouli Puttege on 9/18/16.
//  Copyright © 2016 Orange Matrix. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    override func awakeFromNib() {
        setupView()
    }

    
    // Customize the appearance of the button
    private func setupView(){
        self.alpha = 0.5
        self.layer.cornerRadius = self.frame.width/2
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSizeMake(0.0, 2.0)
        self.layer.shadowColor = floatingButtonShadowColor.CGColor
        self.setImage(UIImage(named: upImageName), forState: .Normal)
        self.setImage(UIImage(named: upImageName), forState: .Selected)
        self.setImage(UIImage(named: upImageName), forState: .Highlighted)
        
        
        // Animations when touched and released.
        self.addTarget(self, action: #selector(CustomButton.touchDownAnimate), forControlEvents: .TouchDown)
        self.addTarget(self, action: #selector(CustomButton.touchDragExitAnimate), forControlEvents: .TouchUpInside)
        self.addTarget(self, action: #selector(CustomButton.touchDragExitAnimate), forControlEvents: .TouchDragExit)
    }
    
    
    // Make the button full opaque when touched
    @objc private func touchDownAnimate(){
        self.alpha = 1.0
    }
    // Restore to translucent when released
    @objc private func touchDragExitAnimate(){
        self.alpha = 0.5
    }
}
