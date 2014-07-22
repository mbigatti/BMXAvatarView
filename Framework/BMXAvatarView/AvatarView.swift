//
//  BMXAvatarView.swift
//  BMXAvatarView
//
//  Created by Massimiliano Bigatti on 08/07/14.
//  Copyright (c) 2014 Massimiliano Bigatti. All rights reserved.
//

import Foundation

@IBDesignable public class AvatarView : UIImageView {
    
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

    public override func awakeFromNib() {
        super.awakeFromNib()
        bmx_commonInit()
    }
    
    private func bmx_commonInit() {
        self.backgroundColor = UIColor.clearColor()
        self.layer.masksToBounds = true
        
        activityIndicatorView.hidden = true
        addSubview(activityIndicatorView)
    }
    
    @IBInspectable public var borderWidth : CGFloat = 2 {
    didSet {
        self.layer.borderWidth = borderWidth
    }
    }
    
    @IBInspectable public var borderColor : UIColor = UIColor.clearColor() {
    didSet {
        self.layer.borderColor = borderColor.CGColor
    }
    }
    
    public override var frame : CGRect {
    didSet {
        self.layer.cornerRadius = max(frame.size.width, frame.size.height) / 2
        activityIndicatorView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
    }
    }
    
    @IBInspectable public var avatarImage : UIImage? {
    didSet {
        applyFilter()
    }
    }
    
    @IBInspectable public var vibranceAmount : CGFloat = 0 {
    didSet {
        applyFilter()
    }
    }
    
    private let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)

    private func applyFilter() {
        if !avatarImage {
            return
        }
        
        image = nil
        activityIndicatorView.startAnimating()
        
        dispatch_async(dispatch_queue_create("", nil), {            
            let context = CIContext(options: nil)
            let filter = CIFilter(name: "CIVibrance")
            let img = CIImage(image: self.avatarImage)
            filter.setValue(img, forKey: "inputImage")
            filter.setValue(self.vibranceAmount, forKey: "inputAmount")
            
            dispatch_async(dispatch_get_main_queue(), {
                self.activityIndicatorView.stopAnimating()
                self.image = UIImage(CIImage: filter.outputImage)
            })
        })
    }
    
    /*
    override func prepareForInterfaceBuilder() {
        let bundle = NSBundle(forClass: nil)
        let imagePath = bundle.pathForResource("Sample-Avatar", ofType: "jpg")
        self.image = UIImage(contentsOfFile: imagePath)
    }
    */
}