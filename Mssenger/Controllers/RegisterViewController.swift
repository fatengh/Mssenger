//
//  RegisterViewController.swift
//  Mssenger
//
//  Created by administrator on 03/01/2022.
//

import UIKit
import Firebase
class RegisterViewController: UIViewController {

    private let  scroll: UIScrollView = {
       let scroll = UIScrollView()
        scroll.clipsToBounds = true
        return scroll
    }()
    

    private let firstNameFld: UITextField = {
          let firstNameFld = UITextField()
        firstNameFld.autocapitalizationType = .none
        firstNameFld.autocorrectionType = .no
        firstNameFld.returnKeyType = .continue
        firstNameFld.layer.cornerRadius = 14
        firstNameFld.layer.borderWidth = 1
        firstNameFld.layer.borderColor = UIColor.lightGray.cgColor
        firstNameFld.placeholder = "First Name "
          
        firstNameFld.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        firstNameFld.leftViewMode = .always
        firstNameFld.backgroundColor = .white
          return firstNameFld
      }()
    private let lastNameFld: UITextField = {
          let lastNameFld = UITextField()
        lastNameFld.autocapitalizationType = .none
        lastNameFld.autocorrectionType = .no
        lastNameFld.returnKeyType = .continue
        lastNameFld.layer.cornerRadius = 14
        lastNameFld.layer.borderWidth = 1
        lastNameFld.layer.borderColor = UIColor.lightGray.cgColor
        lastNameFld.placeholder = "Last Name "
          
        lastNameFld.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        lastNameFld.leftViewMode = .always
        lastNameFld.backgroundColor = .white
          return lastNameFld
      }()


    private let emailfld: UITextField = {
          let emailfld = UITextField()
          emailfld.autocapitalizationType = .none
          emailfld.autocorrectionType = .no
          emailfld.returnKeyType = .continue
          emailfld.layer.cornerRadius = 14
          emailfld.layer.borderWidth = 1
          emailfld.layer.borderColor = UIColor.lightGray.cgColor
          emailfld.placeholder = "Your Email "
          
          emailfld.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
          emailfld.leftViewMode = .always
          emailfld.backgroundColor = .white
          return emailfld
      }()
    
      private let passFld: UITextField = {
          let passFld = UITextField()
          passFld.autocapitalizationType = .none
          passFld.autocorrectionType = .no
          passFld.returnKeyType = .done
          passFld.layer.cornerRadius = 12
          passFld.layer.borderWidth = 1
          passFld.layer.borderColor = UIColor.lightGray.cgColor
          passFld.placeholder = "Password"
          
          passFld.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 6, height: 0))
          passFld.leftViewMode = .always
          passFld.backgroundColor = .white
          passFld.isSecureTextEntry = true
          return passFld
      }()
    
    private let signupBtn: UIButton = {
        let signuobtn = UIButton()
        signuobtn.setTitle("SIGNUP", for: .normal)
        signuobtn.setTitleColor(.white, for: .normal)
        signuobtn.layer.cornerRadius = 12
        signuobtn.layer.masksToBounds = true
        signuobtn.backgroundColor = .link

        
        
        return signuobtn
        
        
    }()
    
    
    private let logoImgView: UIImageView = {
        let logoImgView = UIImageView()
        logoImgView.layer.masksToBounds = true
        logoImgView.image = UIImage(systemName: "person.circle.fill")
        logoImgView.tintColor = .gray
        logoImgView.contentMode = .scaleAspectFit
        return logoImgView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Log_In"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(chooseRegister))
        UINavigationBar.appearance().backgroundColor = UIColor.secondarySystemBackground
        // add scroll
        view.addSubview(scroll)
        // add img
        scroll.addSubview(logoImgView)
        // add emial first name
        scroll.addSubview(firstNameFld)
        // add emial last name
        scroll.addSubview(lastNameFld)
        // add emial textField
        scroll.addSubview(emailfld)
        // add Password
        scroll.addSubview(passFld)
        // add btn
        scroll.addSubview(signupBtn)
        
        logoImgView.isUserInteractionEnabled = true
        scroll.isUserInteractionEnabled = true        // chnge photo
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imgPressed))
        gesture.numberOfTouchesRequired = 1
        logoImgView.addGestureRecognizer(gesture)
        
        signupBtn.addTarget(self, action: #selector(signUpPressed), for: .touchUpInside)
        
        
        emailfld.delegate = self
        passFld.delegate = self
    }
    
    @objc private func imgPressed(){
        showPhoto()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scroll.frame = view.bounds
        // 2
        let s = scroll.frame.size.width/3
        logoImgView.frame = CGRect(x: (scroll.frame.size.width-s)/2,
                                   y: 25,
                                   width: s,
                                   height: s)
        logoImgView.layer.cornerRadius = logoImgView.width/2.0
        firstNameFld.frame = CGRect(x: 25,
                                y: logoImgView.bottom+14,
                                width: scroll.width-60,
                                height: 52)
        lastNameFld.frame = CGRect(x: 25,
                                y: firstNameFld.bottom+14,
                                width: scroll.width-60,
                                height: 52)
        emailfld.frame = CGRect(x: 25,
                                y: lastNameFld.bottom+14,
                                width: scroll.width-60,
                                height: 52)
        passFld.frame = CGRect(x: 25,
                                y:emailfld.bottom+8,
                                width: scroll.width-60,
                                height: 52)
        signupBtn.frame = CGRect(x: 25,
                                y:passFld.bottom+8,
                                width: scroll.width-60,
                                height: 52)
    }
    @objc private func chooseRegister(){
        let vc = RegisterViewController()
        vc.title = "Create a New Account"
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc private func signUpPressed(){
        guard let firstName = firstNameFld.text,
              let lastName = lastNameFld.text,
              let email = emailfld.text,
              let pass = passFld.text,
              !email.isEmpty, !pass.isEmpty, pass.count >= 6 , !firstName.isEmpty, !lastName.isEmpty else {
                  return
              }
        
        
        DataBaseManger.shared.checkNewUserExists(with: email, completion: { [weak self] valid in
            // check not exites
            guard let stgSelf = self else{
                return
            }
            guard !valid else {
                stgSelf.alertDailgLogErr(msg: " Email already exist")
                return
            }
       // firebase login
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: pass, completion:{ authReult, error in
            
            guard authReult != nil, error == nil else {
                print("Error in create new account")
                return
            }

            
                DataBaseManger.shared.insertNewUser(with: ChatUser(firstName: firstName, lastName: lastName, emailAdd: email))
                stgSelf.navigationController?.dismiss(animated: true, completion: nil)

            })
                
            })
        
    }
    
    func alertDailgLogErr(msg: String){
        let alertDailog = UIAlertController(title: "Wrong ", message: msg, preferredStyle: .alert)
        alertDailog.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
present(alertDailog, animated: true)
    
             }
    



}
extension RegisterViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailfld{
            passFld.becomeFirstResponder()
        }else if textField == passFld{
            signUpPressed()
        }
        return true

    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      
        
             picker.dismiss(animated: true, completion: nil)
             print(info)
             // editedImge to rsize
        guard let choosenImg = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
                 return
             }
             
             self.logoImgView.image = choosenImg
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func showPhoto(){
        let action = UIAlertController(title: "Your Profile Picture", message:"from camera or libriry", preferredStyle: .actionSheet)
       
               action.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
                   self?.choosenCamera()
               }))
               action.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
                   self?.choosenLibriry()
               }))
        action.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
               
               present(action, animated: true)
        
    }
    
    func choosenCamera() {
            let imgecon = UIImagePickerController()
            imgecon.sourceType = .camera
            imgecon.delegate = self
            imgecon.allowsEditing = true
            present(imgecon, animated: true)
        }
    
        func choosenLibriry() {
            let imgecon = UIImagePickerController()
            imgecon.sourceType = .photoLibrary
            imgecon.delegate = self
            imgecon.allowsEditing = true
            present(imgecon, animated: true)
        }
    
}
