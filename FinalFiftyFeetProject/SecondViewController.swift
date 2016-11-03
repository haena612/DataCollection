//
//  SecondViewController.swift
//  FinalFiftyFeetProject
//
//  Created by Haena Kim on 10/15/16.
//  Copyright © 2016 Haena Kim. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

protocol SecondViewControllerDelegate {
    
    func didFinishViewController(
        viewController:SecondViewController, didSave:Bool)
    
}

class SecondViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    var image: UIImage?  //store image that picked
    var currentImage: Int! //store the index of current image picker
    var counter = 0
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var mapView2: UIView!
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    
    @IBOutlet weak var TakePhotoView1: UIView!
    @IBOutlet weak var pickedImage1: UIImageView!
    
    
    @IBOutlet weak var TakePhotoView2: UIView!
    @IBOutlet weak var pickedImage2: UIImageView!
    
    
    
    @IBOutlet weak var TakePhotoView3: UIView!
    @IBOutlet weak var pickedImage3: UIImageView!
    
    
    @IBOutlet weak var photo1button: UIButton!
    @IBOutlet weak var photo2button: UIButton!
    @IBOutlet weak var photo3button: UIButton!
    
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    
    @IBOutlet weak var MapButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var currentLocation:Location?
    
    var workEntry: Work! {
        didSet {
            self.configureView()
        }
    }
    
    var context: NSManagedObjectContext!
    var delegate: SecondViewControllerDelegate?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let value = WorkList.sharedInstance.currentlocationWorkList
        currentLocation = value
        
        if WorkList.sharedInstance.counter == 2{
        if currentLocation == nil{
            longLabel.text = "-"
            latLabel.text = "-"
        }
            else{
//
        let tempLong = currentLocation!.longitude
        let tempLat = currentLocation!.latitude
        self.workEntry!.latLocation = "\(tempLong!)"
        self.workEntry!.longLocation = "\(tempLat!)"
        longLabel.text = "\(tempLong!)"
        latLabel.text = "\(tempLat!)"
            
//        }
        }
        }
    }
    
    //view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
                nameTextField.delegate = self
                dateTextField.delegate = self
                costTextField.delegate = self
        
        self.configureView()
    
    }
        //      self.scrollView.contentSize = CGSizeMake(320, 1500)
        //        scrollView.contentSize = CGSize(width: 320, height: 1500)
        
        //
        //        MapButton.backgroundColor = UIColor.clearColor()
//        MapButton.layer.cornerRadius = 15
        //        MapButton.layer.borderWidth = 3
        //        MapButton.layer.borderColor = UIColor.cyanColor().CGColor
        //        TakePhotoView2.hidden = true
        //        TakePhotoView3.hidden = true
        
        // Do any additional setup after loading the view.
    
    func configureView() {
        
        if let textField = nameTextField {
            if let value = workEntry.name {
                textField.text = value
            }
        }
        
        if let textField = dateTextField {
            if let value = workEntry.date {
                textField.text = value
            }
        }
        
        if let textField = costTextField {
            if let value = workEntry.cost {
                textField.text = value
            }
        }
        
        if WorkList.sharedInstance.counter == 1 {
        
            if let longitude = longLabel{
                if let value = workEntry.longLocation{
                    longitude.text  = value
                }
            }
        
            if let latitude = latLabel{
                if let value = workEntry.latLocation{
                    latitude.text  = value
                }
            }
        
        }
        
    }
    
    
//    func updateworkEntry() {
//
//        if let entry = workEntry {
//            entry.date = dateTextField.text
//            entry.name = nameTextField.text
//            entry.cost = costTextField.text
//            entry.longLocation = longLabel.text
//            entry.latLocation = latLabel.text
//        }
//    }
    
    @IBAction func saveAction(sender: AnyObject) {
        
        if nameTextField.text == nil {
            postAlertforEmptyText(nameTextField.text!)
        }else if dateTextField.text == nil {
            postAlertforEmptyText(dateTextField.text!)
        }else if costTextField.text == nil {
            postAlertforEmptyText(costTextField.text!)
        }else if latLabel.text == nil {
            postAlertforEmptyText(latLabel.text!)
        }else if longLabel.text == nil {
            postAlertforEmptyText(longLabel.text!)
        }else{
        WorkList.sharedInstance.addWorkListwithName(nameTextField.text!, date: dateTextField.text!, cost: costTextField.text!, latLocation:latLabel.text!, longLocation:longLabel.text!)
//        updateworkEntry()
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func postAlertforEmptyText (textField:String){
        let alertController = UIAlertController(title:"Please Fill all of the required fields", message: "\(textField) is empty", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    // Picture Feature--------
    
    @IBAction func takePicture(sender: AnyObject) {
        
        if(UIImagePickerController.isSourceTypeAvailable(.Camera)){
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil{
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .Camera
                imagePicker.cameraCaptureMode = .Photo
                presentViewController(imagePicker, animated: true, completion: {})
                
            }else{
                postAlertforCamera("Rear Camera doesn't exist")
            }
        }else{
            postAlertforCamera("Camera inaccessable")
        }
        
    }
    
    func postAlertforCamera(variable: String){
        let alertController = UIAlertController(title:variable, message: "Application cannot access the camera.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    //    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    //        print("Got an image")
    //    }
    
    @IBAction func photoLibraryAction(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //keyboard goes away
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //date picker shows up
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == dateTextField {
            let datePicker = UIDatePicker()
            textField.inputView = datePicker
            datePicker.addTarget(self, action: #selector(SecondViewController.datePickerChanged(_:)), forControlEvents: .ValueChanged)
        } else {
            textField.text = ""
        }
    }
    
        func textFieldDidEndEditing(textField: UITextField) {
            if textField == nameTextField{
                if textField.text != nil {
                    self.workEntry!.name = nameTextField.text
                }
            }
            if textField == dateTextField{
                if textField.text != nil{
                    self.workEntry!.date = dateTextField.text
                }
            }
            if textField == costTextField{
                if textField.text != nil{
                    self.workEntry!.cost = costTextField.text
                }
            }
    
    
        }
    
    func datePickerChanged(sender: UIDatePicker){
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        dateTextField.text = formatter.stringFromDate(sender.date)
    }
    
    //touch events
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    func setupPhotoView(view: UIView) {
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.clearColor()
    }
    
    
    @IBAction func photo1(sender: AnyObject) {
        pickPhotoTakingMethod()
        counter = 1
    }
    
    @IBAction func photo2(sender: AnyObject) {
        pickPhotoTakingMethod()
        counter = 2
    }
    
    @IBAction func photo3(sender: AnyObject) {
        pickPhotoTakingMethod()
        counter = 3
    }
    
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .Camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func pickPhotoTakingMethod() {
        //check id camera is availabel, if yes then aske user to choose between taking a photo and choose in library
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            showPhotoMenu()
        } else {
            //if camera isn't available. let user choose from library
            choosePhotoFromLibrary()
        }
    }
    
    //promt a message asking user to choose to take photo from camera or choose from library
    func showPhotoMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .Default) { _ in
            self.takePhotoWithCamera()
        }
        let chooseFromLibraryAction = UIAlertAction(title: "Choose From Library", style: .Default) { _ in
            self.choosePhotoFromLibrary()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(takePhotoAction)
        alert.addAction(chooseFromLibraryAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        if let image = image {
            showImage(image)
        }
        
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showImage(image: UIImage){
        if counter == 1{
            let image1Data = UIImageJPEGRepresentation(image, 1)
            pickedImage1.image = image
            
            
            //                PinGoClient.uploadImage((self.newTicket?.imageOne)!, image: image, uploadType: "ticket") ////upload image to server to save it on server
            //                pickedImageView1HeightConstraint.constant = takePhotoView2HeightConstraint.constant
            
            TakePhotoView2.hidden = false //make the second photo picker visible when the first one is already picked
        }
        if counter == 2{
            pickedImage2.image = image
            ////                PinGoClient.uploadImage((self.newTicket?.imageTwo)!, image: image, uploadType: "ticket")  ////upload image to server to save it on server
            TakePhotoView3.hidden = false
            //make the third photo picker visible when the second one is already picked
            ////                pickedImageView2HeightConstraint.constant = takePhotoView2HeightConstraint.constant
            //                break
        }
        if counter == 3{
            //            case 3:
            pickedImage3.image = image
            //                TakePhotoView2.hidden = false
            ////                PinGoClient.uploadImage((self.newTicket?.imageThree)!, image: image, uploadType: "ticket") //upload image to server to save it on server
            ////                pickedImageView3HeightConstraint.constant = takePhotoView2HeightConstraint.constant
            //                break
            //            default:
            //                break
            //            }
        }
    }
}