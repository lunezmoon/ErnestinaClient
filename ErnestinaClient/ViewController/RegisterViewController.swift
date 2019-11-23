//
//  RegisterViewController.swift
//  ErnestinaClient
//
//  Created by 針谷ひろき on 2018/10/10.
//  Copyright © 2018年 test. All rights reserved.
//

import UIKit
import RSKImageCropper

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, RSKImageCropViewControllerDelegate {

    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var userIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCheckTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    let borderAlpha : CGFloat = 0.7
    
    var profilePicture: Data? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.layer.cornerRadius = 4.0;
        nextButton.clipsToBounds = true;
        
        cameraButton.setImage(UIImage(named: "Camera_Icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        cameraButton.tintColor = UIColor.white
        cameraButton.layer.cornerRadius = cameraButton.frame.size.width / 2
        cameraButton.clipsToBounds = true
        cameraButton.layer.borderWidth = 1.0
        cameraButton.layer.borderColor = UIColor.white.cgColor
        
        userIDTextField.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        userIDTextField.layer.borderWidth = 0.7
        userIDTextField.layer.cornerRadius = 4.0;
        userIDTextField.clipsToBounds = true;
        userIDTextField.attributedPlaceholder = NSAttributedString(string: "ユーザーIDを入力",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        passwordTextField.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        passwordTextField.layer.borderWidth = 0.7
        passwordTextField.layer.cornerRadius = 4.0;
        passwordTextField.clipsToBounds = true;
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "パスワードを入力",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        passwordCheckTextField.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        passwordCheckTextField.layer.borderWidth = 0.7
        passwordCheckTextField.layer.cornerRadius = 4.0;
        passwordCheckTextField.clipsToBounds = true;
        passwordCheckTextField.attributedPlaceholder = NSAttributedString(string: "パスワードを再度入力",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
    }
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        cameraButton.alpha = 1.0
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ imagePicker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image : UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        
        guard let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        imagePicker.dismiss(animated: false, completion: { () -> Void in
            
            var imageCropVC : RSKImageCropViewController!
            
            imageCropVC = RSKImageCropViewController(image: image, cropMode: RSKImageCropMode.circle)
            
            imageCropVC.moveAndScaleLabel.text = "切り取り範囲を選択"
            imageCropVC.cancelButton.setTitle("キャンセル", for: .normal)
            imageCropVC.chooseButton.setTitle("完了", for: .normal)
            imageCropVC.delegate = self
            
            self.present(imageCropVC, animated: true)
            
        })
        
        cameraButton.setImage(editedImage, for: .normal)
        dismiss(animated:true, completion: nil)
        profilePicture = UIImagePNGRepresentation(editedImage)
        
    }
    
    @IBAction func clickCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func clickProceed(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toRegisterDetailedInfoViewSegue", sender: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRegisterDetailedInfoViewSegue" {
            if let viewController = segue.destination as? RegisterDetailedInfoViewController {
                viewController.userId = userIDTextField.text!
                viewController.password = passwordCheckTextField.text!
                viewController.profilePicture = profilePicture
            }
        }
    }
    
    @IBAction func returnToRegisterViewController(segue: UIStoryboardSegue) {
        
    }
}
