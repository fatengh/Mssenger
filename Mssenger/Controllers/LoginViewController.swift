//
//  LoginViewController.swift
//  Mssenger
//
//  Created by administrator on 03/01/2022.
//

import UIKit

class LoginViewController: UIViewController  {
    
    // UI Items 
    private let  scroll: UIScrollView = {
       let scroll = UIScrollView()
        scroll.clipsToBounds = true
        return scroll
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
    
    private let loginBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.setTitle("LOGIN", for: .normal)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.layer.cornerRadius = 12
        loginBtn.layer.masksToBounds = true
        loginBtn.backgroundColor = .link

        
        
        return loginBtn
        
        
    }()

    private let logoImgView: UIImageView = {
        let logoImgView = UIImageView()
        logoImgView.image = UIImage(named: "logo")
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
        // add emial textField
        scroll.addSubview(emailfld)
        // add Password
        scroll.addSubview(passFld)
        // add btn
        scroll.addSubview(loginBtn)
        
        
        loginBtn.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        
        
        emailfld.delegate = self
        passFld.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scroll.frame = view.bounds
        // constraint
        let s = scroll.frame.size.width/2
        logoImgView.frame = CGRect(x: (scroll.frame.size.width-s)/2,
                                   y: 25,
                                   width: s,
                                   height: s)
        
        emailfld.frame = CGRect(x: 25,
                                y: logoImgView.bottom+14,
                                width: scroll.width-60,
                                height: 52)
        passFld.frame = CGRect(x: 25,
                                y:emailfld.bottom+8,
                                width: scroll.width-60,
                                height: 52)
        loginBtn.frame = CGRect(x: 25,
                                y:passFld.bottom+8,
                                width: scroll.width-60,
                                height: 52)
    }
    @objc private func chooseRegister(){
        let vc = RegisterViewController()
        vc.title = "Create a New Account"
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc private func loginPressed(){
//        emailfld.resignFirstResponder()
//        passFld.resignFirstResponder()
        guard let email = emailfld.text,
              let pass = passFld.text,
              !email.isEmpty, !pass.isEmpty , pass.count >= 6  else {
                  return
              }
       // firebase login
                
    
    }
    func alertDailgLogErr(){
        let alertDailog = UIAlertController(title: "Wrong ", message: "Please Enter all fields", preferredStyle: .alert)
        alertDailog.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
present(alertDailog, animated: true)
    
             }
    



}
extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailfld{
            passFld.becomeFirstResponder()
        }else if textField == passFld{
            loginPressed()
        }
        return true

    }
}

