//
//  BMXAvatarView.swift
//  BMXAvatarView
//
//  Created by Massimiliano Bigatti on 08/07/14.
//  Copyright (c) 2014 Massimiliano Bigatti. All rights reserved.
//

import Foundation

@IBDesignable public class AvatarView : UIView {
    
    // MARK: - Private Properties
    
    private var imageView = UIImageView()
    private let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    
    
    // MARK: - Public Properties
    
    @IBInspectable public var borderWidth : CGFloat = 2 {
    didSet {
        self.layer.borderWidth = borderWidth
    }
    }
    
    @IBInspectable public var borderColor : UIColor = UIColor.clearColor() {
    didSet {
        self.layer.borderColor = borderColor.CGColor
        self.imageView.layer.borderColor = borderColor.CGColor
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
    
    
    // MARK: - Initializers
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        bmx_initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bmx_initialize()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        bmx_initialize()
    }
    
    private func bmx_initialize() {
        self.backgroundColor = UIColor.clearColor()
        self.layer.masksToBounds = true
        
        imageView.layer.masksToBounds = true
        addSubview(imageView)
        
        activityIndicatorView.hidden = true
        addSubview(activityIndicatorView)
    }
    
    
    // MARK: - UIView
    
    public override func layoutSubviews() {
        self.layer.cornerRadius = max(frame.size.width, frame.size.height) / 2
        imageView.layer.cornerRadius = self.layer.cornerRadius
        
        imageView.frame = self.bounds
        activityIndicatorView.frame = self.bounds
    }

    
    // MARK: - Privates
    
    private func applyFilter() {
        if (avatarImage == nil) {
            return
        }
        
        if vibranceAmount == 0 {
            imageView.image = avatarImage
            return
        }
        
        self.imageView.hidden = true
        self.activityIndicatorView.startAnimating()
        
        dispatch_async(dispatch_queue_create("", nil), {            
            let context = CIContext(options: nil)
            let filter = CIFilter(name: "CIVibrance")
            let img = CIImage(image: self.avatarImage)
            filter.setValue(img, forKey: "inputImage")
            filter.setValue(self.vibranceAmount, forKey: "inputAmount")
            
            dispatch_async(dispatch_get_main_queue(), {
                self.activityIndicatorView.stopAnimating()
                
                self.imageView.hidden = false
                self.imageView.image = UIImage(CIImage: filter.outputImage)
            })
        })
    }
    
    
    // MARK: - Interface Builder
    
    public override func prepareForInterfaceBuilder() {
        let processInfo = NSProcessInfo.processInfo()
        let environment = processInfo.environment
        let projectSourceDirectories : AnyObject = environment["IB_PROJECT_SOURCE_DIRECTORIES"]!
        let directories = projectSourceDirectories.componentsSeparatedByString(":")
        
        if directories.count != 0 {
            let firstPath = directories[0] as String
            let imagePath = firstPath.stringByAppendingPathComponent("BMXAvatarView/Sample-Avatar.jpg")
            
            let image = UIImage(contentsOfFile: imagePath)
            self.imageView.image = image
        }
    }
}
