//
//  ViewController.swift
//  AvatarViewTest
//
//  Created by Massimiliano Bigatti on 08/07/14.
//  Copyright (c) 2014 Massimiliano Bigatti. All rights reserved.
//

import UIKit
import BMXAvatarView

class ViewController: UIViewController {
                            
    @IBOutlet var avatarView: AvatarView
    @IBOutlet var vibranceSlider: UISlider
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarView.vibranceAmount = vibranceSlider.value
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    @IBAction func sliderValueChanged(sender: UISlider) {
        avatarView.vibranceAmount = sender.value
    }

}

