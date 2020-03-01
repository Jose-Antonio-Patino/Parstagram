//
//  CameraViewController.swift
//  Parstagram
//
//  Created by Jose Patino on 2/23/20.
//  Copyright © 2020 Jose Patino. All rights reserved.
//

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSubmitButton(_ sender: Any)
    {
        let posts = PFObject(className: "Posts")
        
        posts["caption"] = commentField.text
        posts["author"] = PFUser.current()!
        
        let imageData = pictureView.image!.pngData()
        let file = PFFileObject(name: "image.png", data: imageData!)
        
        posts["image"] = file
        
        posts.saveInBackground { (success, error) in
            if success
            {
                print("saved")
                self.dismiss(animated: true, completion: nil )
            }
            else
            {
                print("error: \(error?.localizedDescription)")
            }
        }
    }
    
    @IBAction func onCameraButton(_ sender: Any)
    {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            picker.sourceType = .camera
        }
        else
        {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageAspectScaled(toFill: size)
        
        pictureView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
        
    }

}
