//
//  CameraViewController.swift
//  Parstagram
//
//  Created by Priyanka Balwadkar on 10/24/20.
//

import UIKit
import AlamofireImage

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    
    @IBAction func onCameraButton(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
            
        }
        else{
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
        
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 348, height: 348)
        let scaledImage = image.af_imageScaled(to: size)
        imgView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func onUploadButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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