//
//  BMXAvatarView.swift
//  BMXAvatarView
//
//  Created by Massimiliano Bigatti on 08/07/14.
//  Copyright (c) 2014 Massimiliano Bigatti. All rights reserved.
//

import Foundation

@IBDesignable class AvatarView : UIImageView {
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        bmx_commonInit()
    }
    
    init(frame: CGRect) {
        super.init(frame: frame)
        bmx_commonInit()
    }
    
    init(image: UIImage!)  {
        super.init(image: image)
        bmx_commonInit()
    }
    
    init(image: UIImage!, highlightedImage: UIImage!) {
        super.init(image: image, highlightedImage: highlightedImage)
        bmx_commonInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        bmx_commonInit()
    }
    
    func bmx_commonInit() {
        self.backgroundColor = UIColor.clearColor()
        self.layer.masksToBounds = true
    }
    
    @IBInspectable var borderWidth : CGFloat = 2 {
    didSet {
        self.layer.borderWidth = borderWidth
    }
    }
    
    @IBInspectable var borderColor : UIColor = UIColor.clearColor() {
    didSet {
        self.layer.borderColor = borderColor.CGColor
    }
    }
    
    override var frame : CGRect {
    didSet {
        self.layer.cornerRadius = max(frame.size.width, frame.size.height) / 2
    }
    }
    
    @IBInspectable var avatarImage : UIImage? {
    didSet {
        applyFilter()
    }
    }
    
    @IBInspectable var vibranceAmount : CGFloat = 0 {
    didSet {
        applyFilter()
    }
    }

    func applyFilter() {
        if !avatarImage {
            return
        }
        
        let context = CIContext(options: nil)
        let filter = CIFilter(name: "CIVibrance")
        let img = CIImage(image: avatarImage)
        filter.setValue(img, forKey: "inputImage")
        filter.setValue(vibranceAmount, forKey: "inputAmount")
        image = UIImage(CIImage: filter.outputImage)
    }
    
    /*
    override func prepareForInterfaceBuilder() {
        let bundle = NSBundle(forClass: nil)
        let imagePath = bundle.pathForResource("Avatar", ofType: "jpg")
        self.image = UIImage(contentsOfFile: imagePath)
    }
    */
}