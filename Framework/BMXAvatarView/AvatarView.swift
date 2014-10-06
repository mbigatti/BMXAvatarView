//
//  BMXAvatarView.swift
//  BMXAvatarView
//  https://github.com/mbigatti/BMXAvatarView
//
//  Copyright (c) 2014 Massimiliano Bigatti. All rights reserved.
//

import Foundation

/**
    A rounded avatar UIImageView, with optional border and vibrance effect.
*/
@IBDesignable public class AvatarView : UIView {
    
    
    // MARK: - Private Properties
    
    /// backing image view used to display image
    private var imageView = UIImageView()
    
    /// activity indicator displayed while the image is updated
    private let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    
    
    // MARK: - Public Properties
    
    /// avatar border width, default 2px
    @IBInspectable public var borderWidth : CGFloat = 2 {
    didSet {
        self.layer.borderWidth = borderWidth
    }
    }
    
    /// avatar border color, default clear
    @IBInspectable public var borderColor : UIColor = UIColor.clearColor() {
    didSet {
        self.layer.borderColor = borderColor.CGColor
        self.imageView.layer.borderColor = borderColor.CGColor
    }
    }
    
    /// avatar image
    @IBInspectable public var avatarImage : UIImage? {
    didSet {
        applyFilter()
    }
    }
    
    /// avatar vibrance effect amount
    @IBInspectable public var vibranceAmount : CGFloat = 0 {
    didSet {
        applyFilter()
    }
    }
    
    
    // MARK: - Initializers
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    /**
        Common initializer
     */
    private func commonInit() {
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
    
    /**
        Apply vibrancy effect filter showing the activity indicator if required
     */
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
