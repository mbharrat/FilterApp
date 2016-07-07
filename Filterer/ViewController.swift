//
//  ViewController.swift
//  Filterer
//
//  Created by Michael Bharrat on 6/27/16.
//  Copyright © 2016 Michael Bharrat. All rights reserved.
//TO DO: add functionality to slider

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //***********************************************************************
    // local variables to work with
    //***********************************************************************
    var avgRed = 0
    var avgGreen = 0
    var avgBlue = 0
    var count = 0
    var compareC = 0
    var gestureC = 0
    var filteredImage: UIImage?
    var image2: UIImage?
    var didFilter = false
    var imageC: UIImage?
    var filterC: UIImage?
    var isGreen = false
    var isBlue = false
    var isRed = false
    var isBW = false
    var isBright = false
    
    //***********************************************************************

    //var myRGBA = RGBAImage(image: imageView.image)!
    @IBOutlet var imageView: UIImageView!

    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var compareButton: UIButton!
    @IBOutlet var Edit: UIView!
    @IBOutlet var newImage: UIImageView! //make this transition nicer
    
    @IBOutlet weak var BW: UIButton!
    @IBOutlet weak var Bright: UIButton!
    @IBOutlet weak var Blue: UIButton!
    @IBOutlet weak var Red: UIButton!
    @IBOutlet weak var Green: UIButton!
    @IBOutlet weak var originalViewText: UILabel!//the text in the overlay

    @IBOutlet var originalView: UIView! //original overlay text
    
    @IBOutlet var secondaryMenu: UIView!//submenu
    @IBOutlet weak var filterButton: UIButton!//the actual button for filter

    
    @IBOutlet weak var bottomMenu: UIStackView!//the stackview of all buttons in bottom menu
    //***********************************************************************
    //two states allow two different images to displayed, if cliked with filter selected
    //display original, if let go, display filtered image
    //also works with compare button
    //  if compare clicked the gestureC counter set accordingly so the right image
    //  will appear when imageview is tapped
    //***********************************************************************
    func longPressAction(){
        if didFilter == true{
            if gestureC == 0{
                //original image
                hideSecondImage()
                //imageView.image = image2
                showOverlay()
                gestureC++
            }else{
                //imageView.image = filterC
                showSecondImage()
                hideOverlay()
                gestureC = 0
            }
        }
    }
    func longPressGesture(){
        let lpg = UILongPressGestureRecognizer(target: self, action:"longPressAction")
        lpg.minimumPressDuration = 0.1  //this makes instanteous change causing buggy state never to be reached
        
        imageView.addGestureRecognizer(lpg)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //***********************************************************************
        //TAP GESTURE
        //***********************************************************************
        longPressGesture()
       
        setButton()//this sets the picture image for the filter buttons

        //***********************************************************************
        //LETS ADD BACKGROUND COLOR TO MENU
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        originalView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        originalViewText.textColor = UIColor.blueColor()
        //edits color of text
        //this adds white color and with alpha component makes it a little see through
        
        //***********************************************************************
        //if you run into autolayout legacy warnings and problems add this line
        //***********************************************************************
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        originalView.translatesAutoresizingMaskIntoConstraints = false
        newImage.translatesAutoresizingMaskIntoConstraints = false
        Edit.translatesAutoresizingMaskIntoConstraints = false
        //***********************************************************************

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //*****************************************************************
    //edit filter button hit
    //*****************************************************************
    @IBAction func onEdit(sender: UIButton) {
        if didFilter == true{
            if(sender.selected == true){
                hideSlider()
                sender.selected = false
            }else{
                //hide all other menus and set selected to false
                filterButton.selected = false
                hideSecondaryMenu()
                compareButton.selected = false
                //call function to show menu
                showSlider()
                sender.selected = true
            }

            
            
        }else{
            alertComp()
        }
    }
    //*****************************************************************
    //compare button hit
    //*****************************************************************
    @IBAction func onCompare(sender: UIButton) {
        //tweak
        //always makes it nil when clicked
        if didFilter == true {
            if sender.selected == true{
                //switch back to filtered image
                //imageView.image = filterC
                
                showSecondImage()
                hideOverlay()
                //gestureC is for touch and compareC is for button and count is filter button
                compareC = 0
                gestureC = 0
                count = 1
                sender.selected = false
            }else{
                //if clicked first function is to switch to original
                hideSecondaryMenu()
                hideSlider()
                filterButton.selected = false
                editButton.selected = false
                hideSecondImage()
                //imageView.image = image2
                showOverlay()
                //gestureC is for touch and compareC is for button and count is filter button
                count = 0
                gestureC = 1
                compareC++
                sender.selected = true
            }
        }else{
            alertComp()
        }
}

            
    
    
    //*****************************************************************
    //slider moved
    //*****************************************************************
    
    @IBAction func onSlide(sender: UISlider) {
        let currentValue = Int(sender.value)
        let editImage = filterC
        let nRGBA = RGBAImage(image: editImage!)!
        var tester: UIImage?

        if isGreen == true{
            tester = makeGreener(nRGBA, intensity: currentValue)
        }
        if isBlue == true{
            tester = makeBluer(nRGBA, intensity: currentValue)
        }
        if isRed == true{
            tester = makeRedder(nRGBA, intensity: currentValue)
        }
        if isBright == true{
            tester = bright(nRGBA, intensity: currentValue)
        }
        if isBW == true{
            tester = bw(nRGBA, intensity: currentValue)
        }
        //print(currentValue)
        newImage.image = tester
        //very important to show image or nothing happens!
        showSecondImage()
        
    }
    
    //*****************************************************************
    //if filter button clicked
    //*****************************************************************
    @IBAction func onGreen(sender: UIButton) {
        
        let image = imageView.image
        //sender.setBackgroundImage(UIImage(named: "icon.jpg"), forState: UIControlState.Normal)
        let RGBA = RGBAImage(image: image!)!
                if count == 0{
                    isGreen = true
                    image2 = image
                    averages(RGBA)
                    let filteredImage = makeGreener(RGBA, intensity: 5)
                    newImage.image = filteredImage
                    showSecondImage()
                    //imageView.image = filteredImage
                    filterC = imageView.image
                    count++
                    didFilter = true
                    
        }else{
                    //mageView.image = image2
                    alert(image2!)
                    
                    //count = 0
        }
        
    }
    //red filter button clicked
    @IBAction func onRed(sender: UIButton) {
        let image = imageView.image
        let RGBA = RGBAImage(image: image!)!
        if count == 0{
            isRed = true
            image2 = image
            averages(RGBA)
            let filteredImage = makeRedder(RGBA, intensity: 5)
            newImage.image = filteredImage
            showSecondImage()
            //imageView.image = filteredImage
            filterC = imageView.image
            count++
            didFilter = true
        }else{
            alert(image2!)
        }

    }
    @IBAction func onBlue(sender: UIButton) {
        let image = imageView.image
        let RGBA = RGBAImage(image: image!)!
        if count == 0{
            isBlue = true
            image2 = image
            averages(RGBA)
            let filteredImage = makeBluer(RGBA, intensity: 5)
            newImage.image = filteredImage
            showSecondImage()
            //imageView.image = filteredImage
            filterC = imageView.image
            count++
            didFilter = true
        }else{
            alert(image2!)
        }
    }
    @IBAction func onBright(sender: UIButton) {
        let image = imageView.image
        let RGBA = RGBAImage(image: image!)!
        if count == 0{
            isBright = true
            image2 = image
            averages(RGBA)
            let filteredImage = bright(RGBA, intensity: 5)
            newImage.image = filteredImage
            showSecondImage()
            //imageView.image = filteredImage
            filterC = imageView.image
            count++
            didFilter = true
        }else{
            alert(image2!)
        }
    }
    @IBAction func onBW(sender: UIButton) {
        let image = imageView.image
        let RGBA = RGBAImage(image: image!)!
        if count == 0{
            isBW = true
            image2 = image
            averages(RGBA)
            let filteredImage = bw(RGBA, intensity: 5)
            newImage.image = filteredImage
            showSecondImage()
            //imageView.image = filteredImage
            filterC = imageView.image
            count++
            didFilter = true
        }else{
            alert(image2!)
        }
    }
    //*****************************************************************
    
    
    //*****************************************************************
    //action when share is clicked
    //bug fixed: since two views, which image is shared, newImage or imageView?
    //  used the didFilter boolean, if filter is on image then save approp. image
    @IBAction func onShare(sender: AnyObject) {
        //activityController: enables sharing to appication interface (PREMADE!)
        if didFilter == true{
        let activityController = UIActivityViewController(activityItems: [newImage.image!], applicationActivities: nil)
            //present view
             presentViewController(activityController, animated: true, completion: nil)
        }else{
            let activityController = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
            //present view
             presentViewController(activityController, animated: true, completion: nil)
        }
        
    }
    
    //option to show camera or camera roll
    @IBAction func onNewPhoto(sender: UIButton) {
        //creates upper tab which reads New Photo, has no message and action sheet style
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        //this adds a action to the actionsheet
        //adds camera option and inside brackets has whats happens when you click camera button
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        //same thing "" ""
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        //cancel option, but in handler, set to nil because it just closes the action sheet
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        //this presents the view controller and has it pop up
        self.presentViewController(actionSheet, animated: true, completion: nil)
    
    }

    @IBAction func onFilter(sender: UIButton) {   //actions for the filter button
        if(sender.selected == true){
            hideSecondaryMenu()
            sender.selected = false
        }else{
            //call function to show menu
            //setButton()
            editButton.selected = false
            compareButton.selected = false
            hideOverlay()
            showSecondImage()
            hideSlider()
            showSecondaryMenu()
            sender.selected = true
        }
    }
    func averages(image: RGBAImage){//simple function used in modules
        var Red = 0
        var Green = 0
        var Blue = 0
        for y in 0..<image.height{
            for x in 0..<image.width{
                let index = y * image.width + x
                var pixel = image.pixels[index]
                Red = Red + Int(pixel.red)
                Green = Green + Int(pixel.green)
                Blue = Blue + Int(pixel.blue)
            }
        }
        let counter = image.width * image.height
        self.avgRed = Red/counter
        self.avgBlue = Blue/counter
        self.avgGreen = Green/counter
    }
    func bw(var image: RGBAImage, intensity: Int) -> UIImage{
        for y in 0..<image.height {
            for x in 0..<image.width {
                let index = y * image.width + x
                var pixel = image.pixels[index]
                
                let mid = 0.299 * Double(pixel.red) + 0.587 * Double(pixel.green) + 0.114 * Double(pixel.blue)
                let gray = round(mid)
                
                pixel.green = UInt8(gray) //* UInt8(intensity)
                
                pixel.blue = UInt8(gray) //* UInt8(intensity)
                
                pixel.red = UInt8(gray) //* UInt8(intensity)
                
                image.pixels[index] = pixel
            }
        }
        let newImage2 = image.toUIImage()
        return newImage2!
    }

    func bright(var image: RGBAImage, intensity: Int) -> UIImage{//increase intensity by input
        let brightness = intensity
        for y in 0..<image.height {
            for x in 0..<image.width {
                let index = y * image.width + x
                var pixel = image.pixels[index]
                let G = round(Double(pixel.green) * Double(brightness)) //decrease done here
                
                let B = round(Double(pixel.blue) * Double(brightness)) //decrease done here
                
                let R = round(Double(pixel.red) * Double(brightness)) //decrease done here
                
                pixel.green = UInt8( max (0, min (255, G)))
                
                pixel.blue = UInt8( max (0, min (255, B)))
                
                pixel.red = UInt8( max (0, min (255, R)))
                image.pixels[index] = pixel
            }
        }
        let newImage2 = image.toUIImage()
        return newImage2!
    }

    func makeGreener(var image: RGBAImage, intensity: Int) -> UIImage{//filter to enhance green pixels by 5 times
        
        for y in 0..<image.height{
            for x in 0..<image.width{
                let index = y * image.width + x
                var pixel = image.pixels[index]
                let greenDiff = Int(pixel.green) - avgGreen
                if(greenDiff > 0){
                    pixel.green = UInt8( max(0,min(255,avgGreen + greenDiff*intensity ) ) )
                    image.pixels[index] = pixel
                   
                   
                }
                
            }
        }
        //print("YES")      check to see if function ran to completion
        let newImage2 = image.toUIImage()
        return newImage2!
    }
    func makeBluer(var image: RGBAImage, intensity: Int) -> UIImage{//filter to enhance blue pixels by 5 times
        for y in 0..<image.height{
            for x in 0..<image.width{
                let index = y * image.width + x
                var pixel = image.pixels[index]
                let blueDiff = Int(pixel.blue) - avgBlue
                if(blueDiff > 0){
                    pixel.blue = UInt8( max(0,min(255,avgBlue + blueDiff*intensity ) ) )
                    image.pixels[index] = pixel
                }
            }
        }
        let newImage2 = image.toUIImage()
        return newImage2!
    }

    func makeRedder(var image: RGBAImage, intensity: Int) -> UIImage {//filter to enhance red pixels by 5 times
        for y in 0..<image.height{
            for x in 0..<image.width{
                let index = y * image.width + x
                var pixel = image.pixels[index]
                let redDiff = Int(pixel.red) - avgRed
                if(redDiff > 0){
                    pixel.red = UInt8( max(0,min(255,avgRed + redDiff*intensity ) ) )
                    image.pixels[index] = pixel
                }
            }
        }
        let newImage2 = image.toUIImage()
        return newImage2!
    }

    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
    
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    //this is used when image is picked
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        //this removes the actionSheet from view
        dismissViewControllerAnimated(true, completion: nil)
        //if image is picked then set that image to the one viewed
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
        hideSecondImage()
        imageView.image = image
           count = 0
        
        }
    }
    //*****************************************************************
    // this is alert function if filter clicked twice
    //*****************************************************************
    func alert(image: UIImage){
        //create alert
        let alert = UIAlertController(title: "Oops!", message: "A filter is already applied", preferredStyle: UIAlertControllerStyle.Alert)
        //add button
        alert.addAction(UIAlertAction(title: "Revert to original",style: UIAlertActionStyle.Default, handler: { action in
            self.removeAllBool()
            self.hideSecondImage()
            self.count = 0
            self.didFilter = false
            //self.imageView.image = image
           // print("the code executes")
            
        }))
        //add cancel
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        
        
        self.presentViewController(alert, animated: true, completion: nil)

    }
    //*****************************************************************
    // this is alert function if NO filter clicked and compare clicked
    //*****************************************************************
    func alertComp(){
        //create alert
        let alert = UIAlertController(title: "Oops!", message: "No filter selected", preferredStyle: UIAlertControllerStyle.Alert)
        //add button
        //simple ok button
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
   
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        dismissViewControllerAnimated(true, completion: nil)
    }
    func showOverlay() {
        //mastered how to add overlay!!
        view.addSubview(originalView) //causes overlay to appear
        
        let leftConstraint = originalView.leftAnchor.constraintEqualToAnchor(imageView.leftAnchor)
        
        let topConstraint = originalView.topAnchor.constraintEqualToAnchor(imageView.topAnchor)
        
        let heightConstraint = originalView.heightAnchor.constraintEqualToConstant(44)
        
        NSLayoutConstraint.activateConstraints([leftConstraint, topConstraint, heightConstraint])
        
        view.layoutIfNeeded()
    }
    func hideOverlay() {
        //simple hide function no animation needed
        self.originalView.removeFromSuperview()
    }
    func showSecondaryMenu() {
        view.addSubview(secondaryMenu) //causes submenu to appear
        
        //add some constraints so secondary menu orientation looks nicer
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        //this constrains bottom of secondary menu to the top of the button menu on main menu
        
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        //bottomMenu.leftAnchor would work but view.leftAnchor is more specific
        
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        //height anchor or recommended size 44
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(44)
        
        //activate constraints
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        //tell veiw to relayout view
        view.layoutIfNeeded()
        
        //***********************************************************************
        //BASIC ANIMATIONS
        //***********************************************************************
       
        //fade in
        self.secondaryMenu.alpha = 0
        UIView.animateWithDuration(0.5){
            self.secondaryMenu.alpha = 1.0
        }



    }
    func hideSecondaryMenu(){
        //first block is actual animation second part is telling to wait for animation to complete then do removeFromSuperView
        UIView.animateWithDuration(0.4, animations: {
            self.secondaryMenu.alpha = 0
            }) { completed in                   //this completed in allows code to never enter buggy state
                if completed == true{           //where you can removeFromSuperview when calling show menu
                self.secondaryMenu.removeFromSuperview()
                }
        }
        

        
        
       
    
    }
    //***********************************************************************
    //elegant image transitions
    //***********************************************************************
    func showSecondImage(){
        view.addSubview(newImage)
        
        let leftConstraint = newImage.leftAnchor.constraintEqualToAnchor(imageView.leftAnchor)
        
        let rightConstraint = newImage.rightAnchor.constraintEqualToAnchor(imageView.rightAnchor)
        
        let bottomConstraint = newImage.bottomAnchor.constraintEqualToAnchor(imageView.bottomAnchor)
        let topConstraint = newImage.topAnchor.constraintEqualToAnchor(imageView.topAnchor)
        
        NSLayoutConstraint.activateConstraints([leftConstraint, rightConstraint, bottomConstraint, topConstraint])
        
        view.layoutIfNeeded()
        
        //***********************************************************************
        //BASIC ANIMATIONS
        //***********************************************************************
        
        self.newImage.alpha = 0
        UIView.animateWithDuration(0.5){
            self.newImage.alpha = 1.0
        }
        
        
    }
    func hideSecondImage(){
        UIView.animateWithDuration(0.4, animations: {
            self.newImage.alpha = 0
            }) { completed in                   //this completed in allows code to never enter buggy state
                if completed == true{           //where you can removeFromSuperview when calling show menu
                    self.newImage.removeFromSuperview()
                }
        }

    }

    //***********************************************************************
    //method to create filtered icons instead of text for submenu
    //doesnt generate when filter button is clicked because LONG calcualtion times
    //used BIG image but looks nice
    //doesnt call average function just uses pre found average pixel count to reduce
    //run time
    //***********************************************************************
    func setButton(){
        let icon = UIImage(named: "butterfly.jpg")
        let icon2 = RGBAImage(image: icon!)!
        
        avgBlue = 25
        avgGreen = 112
        avgRed = 124
        let green = makeGreener(icon2, intensity: 5)
        let red = makeRedder(icon2, intensity: 5)
        let blue = makeBluer(icon2, intensity: 5)
        let brighti = bright(icon2, intensity: 5)
        let bwi = bw(icon2, intensity: 5)
        Green.setBackgroundImage(green, forState: UIControlState.Normal)
        Blue.setBackgroundImage(blue, forState: UIControlState.Normal)
        Red.setBackgroundImage(red, forState: UIControlState.Normal)
        Bright.setBackgroundImage(brighti, forState: UIControlState.Normal)
        BW.setBackgroundImage(bwi, forState: UIControlState.Normal)
    }
    func showSlider(){
        view.addSubview(Edit)
        
        //add some constraints so secondary menu orientation looks nicer
        let bottomConstraint = Edit.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        //this constrains bottom of secondary menu to the top of the button menu on main menu
        
        let leftConstraint = Edit.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        //bottomMenu.leftAnchor would work but view.leftAnchor is more specific
        
        let rightConstraint = Edit.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        //height anchor or recommended size 44
        let heightConstraint = Edit.heightAnchor.constraintEqualToConstant(44)
        
        //activate constraints
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        //tell veiw to relayout view
        view.layoutIfNeeded()
        
        //***********************************************************************
        //BASIC ANIMATIONS
        //***********************************************************************
        
        //fade in
        self.Edit.alpha = 0
        UIView.animateWithDuration(0.5){
            self.Edit.alpha = 1.0
        }
 
    }
    func hideSlider(){
        UIView.animateWithDuration(0.4, animations: {
            self.Edit.alpha = 0
            }) { completed in                   //this completed in allows code to never enter buggy state
                if completed == true{           //where you can removeFromSuperview when calling show menu
                    self.Edit.removeFromSuperview()
                }
        }

    }
    func removeAllBool(){
        isGreen = false
        isBlue = false
        isRed = false
        isBW = false
        isBright = false
    }
}

