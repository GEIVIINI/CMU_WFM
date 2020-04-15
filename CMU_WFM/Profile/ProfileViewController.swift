//
//  ProfileViewController.swift
//  CMU_WFM
//
//  Created by Methawin on 11/4/2563 BE.
//  Copyright © 2563 Methawin. All rights reserved.
//

import UIKit
import Alamofire
import ImageSlideshow
import Kingfisher

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var teacherName: UILabel!
    @IBOutlet weak var buildingName: UILabel!
    let imagePicker = UIImagePickerController()
    
    var settingButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        let user = LocalFile.getUser()
        if let name = user?.displayname {
            nameLabel.text = name
        }
        if let image = user?.image {
            let imageUrl = URL(string: image)
            profileImageView.kf.setImage(with: imageUrl)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.titleView = customNavbar(titleTopText: "Work", titleButtomText: "\nFrom Home", imageName: "logo_cmu")
    }
    
    func customNavbar(titleTopText: String, titleButtomText: String, imageName: String) -> UIView {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let label = UILabel(frame: CGRect(x: 50, y: 0, width: screenWidth/2, height: 44))
        label.numberOfLines = 0
        label.text = titleTopText
        label.textAlignment = NSTextAlignment.left
        
        let topAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20.0) as Any]
        let botAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 14.0) as Any]

        let topString = NSMutableAttributedString(string: titleTopText, attributes: topAttributes)
        let botString = NSAttributedString(string: titleButtomText, attributes: botAttributes)
        topString.append(botString)
        label.attributedText = topString
        
        let image = UIImageView()
        image.image = UIImage(named: imageName)
        let imageWidth = label.frame.size.height
        let imageHeight = label.frame.size.height
        
        let imageSpace = UIImageView(frame: CGRect(x: 46, y: 0, width: 1, height: 44))
        imageSpace.backgroundColor = .darkGray
        
        image.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        image.contentMode = UIView.ContentMode.scaleAspectFit

        settingButton.imageView?.contentMode = .scaleAspectFit
        settingButton = UIButton(frame: CGRect(x: screenWidth * 0.86, y: 5, width: screenWidth * 0.1, height: 30))
        settingButton.setImage(UIImage(named: "more"), for: .normal)
        settingButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        titleView.addSubview(label)
        titleView.addSubview(image)
        titleView.addSubview(imageSpace)
        titleView.addSubview(settingButton)
        return titleView
    }
    
    @objc func buttonAction(sender: UIButton!) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "เปลี่ยนภาษา", style: .default , handler:{ (UIAlertAction)in
            
        }))
        alert.addAction(UIAlertAction(title: "ข้อเสนอแนะ", style: .default , handler:{ (UIAlertAction)in
            
        }))
        alert.addAction(UIAlertAction(title: "เกี่ยวกับ", style: .default , handler:{ (UIAlertAction)in
            let viewController = AboutViewController(nibName: "AboutViewController", bundle: nil)
            self.present(viewController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "ออกจากระบบ", style: .destructive , handler:{ (UIAlertAction)in
            print("Log out")
            LocalFile.removeUser()
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "loginPage", sender: self)
            }
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
 
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.contentMode = .scaleAspectFit
            profileImageView.image = pickedImage
            let parameters: [String: AnyObject] = [
                "type" : "profile" as AnyObject
            ]
            uploadPhoto("https://b-gib.banana.co.th/upload?type=profile", image: pickedImage, params: parameters) { (data) in
                print("Data", data)
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func uploadPhoto(_ url: String, image: UIImage, params: [String : Any], completion: @escaping (NSDictionary) -> ()) {
        let user = LocalFile.getUser()
        if let token = user?.token {
            var headers = HTTPHeaders()
            headers.add(name: "X-WFH-SESSION", value: token)
            AF.upload(multipartFormData: { multiPart in
                for p in params {
                    multiPart.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
                }
                multiPart.append(image.pngData()!, withName: "fileData", fileName: "profile.png", mimeType: "multipart/form-data")
                //multiPart.append(image.jpegData(compressionQuality: 0.4)!, withName: "fileData", fileName: "profile.jpg", mimeType: "multipart/form-data")
            }, to: url, method: .post, headers: headers) .uploadProgress(queue: .main, closure: { progress in
                print("Upload Progress: \(progress.fractionCompleted)")
            }).responseString(completionHandler: { data in
                print("upload finished: \(data)")
            }).response { (response) in
                switch response.result {
                case .success(let resut):
                    print("upload success result: \(resut)")
                case .failure(let err):
                    print("upload err: \(err)")
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
