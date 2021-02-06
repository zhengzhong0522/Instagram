//
//  CameraViewController.swift
//  Instagram
//
//  Created by zhong zheng on 2/4/21.
//  Copyright © 2021 ZHONG ZHENG. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onCamera(_ sender: Any) {
        let picker = UIImagePickerController()
               picker.delegate = self
               picker.allowsEditing = true
               
               if UIImagePickerController.isSourceTypeAvailable(.camera){
                   picker.sourceType = .camera
               }else{
                   picker.sourceType = .photoLibrary
               }
               
               present(picker,animated: true,completion: nil)
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        let post = PFObject(className: "MyPosts")
        post["caption"] = textField.text!
        post["author"] = PFUser.current()!
        
        let imageData = imageView.image!.pngData()
        let file = PFFileObject(name: "image.png", data: imageData!)
        post["image"] = file!
        
        post.saveInBackground { (success, error) in
            if success {
                print("saved!")
                self.dismiss(animated: true, completion: nil)
            }else{
                print("Failed to save!")
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 268, height: 268)
        let scaledImage = image.af_imageAspectScaled(toFill: size)
        
        imageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
