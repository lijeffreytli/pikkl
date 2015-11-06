//
//  SubmitViewController.swift
//  pikkl
//
//  Created by Julio Correa on 10/25/15.
//  Copyright © 2015 CS378. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Parse
import ParseFacebookUtilsV4
import CoreData


class SubmitViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var lblBattleTitle: UILabel!
    @IBOutlet weak var imgSubmit: UIImageView!
    let imagePicker = UIImagePickerController()
    var battleTitle:String = ""
    var imgUploaded:Bool = false;
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imgSubmit.image = UIImage(named: "cameraIcon")
        lblBattleTitle.text = battleTitle
    }
    
    override func shouldAutorotate() -> Bool {
        if (UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.Unknown) {
                return false;
        }
        else {
            return true;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgSubmit.contentMode = .ScaleAspectFill
            imgSubmit.image = pickedImage
            imgUploaded = true;
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func imgTapSubmit(sender: AnyObject) {
        //open camera for image upload
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func btnCreateBattleEntry(sender: AnyObject) {
        //check is a little hacky, couldn't find more elegant way to check for this.
        if(imgUploaded) {
            createEntry()
        } else {
            print("can't create entry without image!")
        }
    }
    
    func createEntry() -> Void {
        // create battle object
        let entry = PFObject(className:"BattleEntry")
        //saving as JPEG becase png was too large
        let imageData = UIImageJPEGRepresentation(imgSubmit.image!, 1.0)
        let imageFile = PFFile(name:"image.jpg", data:imageData!)
        entry["image"] = imageFile
        entry["owner"] = PFUser.currentUser()
        entry["score"] = 0
        
        entry.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                sleep(1)
            } else {
                // There was a problem, check error.description
            }
        }
    }

    
    
    
}