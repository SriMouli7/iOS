//
//  ViewController.swift
//  SpiningLayers
//
//  Created by Sri Mouli Puttege on 9/8/16.
//  Copyright © 2016 Orange Matrix. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // get a stack layer with required number of items
    let layer = SpinningLayer(numberOfItems: 6)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.lightGrayColor()
        view.layer.addSublayer(layer)
        // set the base color
        layer.color = UIColor(rgba: "#ff8126")
        //start spinning
        spin(nil)
        
    }
    
    @IBAction func spin(sender: AnyObject?) {
        layer.startAnimating()
    }
    
    @IBAction func halt(sender: AnyObject) {
        layer.stopAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

