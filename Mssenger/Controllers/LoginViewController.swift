//
//  LoginViewController.swift
//  Mssenger
//
//  Created by administrator on 03/01/2022.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FacebookLogin
import JGProgressHUD

class LoginViewController: UIViewController  {
    
    private let spinn = JGProgressHUD(style: .dark)

    
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
    
    private let loginButton: FBLoginButton = {
        let btn = FBLoginButton()
        btn.permissions=["public_profile","email"]
        return btn
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
        
       
        scroll.addSubview(loginButton)
        
        loginBtn.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        
        loginButton.delegate = self
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
        loginButton.frame = CGRect(x: 25,
                                y:loginBtn.bottom,
                                width: scroll.width-60,
                                height: 52)
        loginButton.frame.origin.y = loginButton.bottom+20
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
        spinn.show(in: view)
        
       // firebase login
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: pass, completion: {[weak self] authReult, error in
            
            guard let stgSelf = self else{
                return
            }
            DispatchQueue.main.async {
                stgSelf.spinn.dismiss()

            }

            guard let res = authReult, error == nil else {
                print("filed log in with this email ")
                return
            }
            let user = res.user
            UserDefaults.standard.set(email, forKey: "email")
            print("logged in user \(user)")
            stgSelf.navigationController?.dismiss(animated: true, completion: nil)
            
        })
    
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

extension LoginViewController: LoginButtonDelegate{

    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {

    }

func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
  // UNWRAP TOKEN FROM FACBOOK
    guard let token = result?.token?.tokenString else {
        print("filed login with fc")
        return
    }
    // request obj
    let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                            parameters: ["fields":
                                                               "email, first_name, last_name, picture.type(large)"],
                                                            tokenString: token,
                                                            version: nil,
                                                            httpMethod: .get)

         facebookRequest.start(completion: { _, result, error in
               guard let result = result as? [String: Any],
                   error == nil else {
                       print("Failed to make facebook graph request")
                       return
               }

        
        print("\(result)")
           
             guard let firstName = result["first_name"] as? String,
                   let lastName = result["last_name"] as? String,
                   let email = result["email"] as? String,
                   let picture = result["picture"] as? [String: Any],
                   let data = picture["data"] as? [String: Any],
                   let picUrl = data["url"] as? String else{
                       print("fieled to get data ")
                       return
                   }
        
             UserDefaults.standard.set(email, forKey: "email")
             DataBaseManger.shared.checkNewUserExists(with: email, completion: { exists in
                 if !exists {
                     let chatUser = ChatUser(firstName: firstName, lastName: lastName, emailAdd: email)
                     DataBaseManger.shared.insertNewUser(with: chatUser, completion:{ success in
                         if success{
                             guard let url = URL(string: picUrl) else {
                                 return
                             }
                             
                             URLSession.shared.dataTask(with: url, completionHandler: {data, _, _ in
                                 guard let data = data else {
                                     return
                                 }
                                 let fileName = chatUser.profilePicFileName
                                 StorageManager.shared.uploadProfilePhoto(with: data, fileName: fileName, completion: { result in
                                     switch result {
                                     case .success(let downloadUrl):
                                         UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                         print(downloadUrl)
                                     case .failure(let errordownUrl):
                                         print("storage error \(errordownUrl)")
                                     }
                                     
                                 })
                             }).resume()
                             
                         }
                         
                     })
                 }
            
        })
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: token)

        FirebaseAuth.Auth.auth().signIn(with: credentials, completion: {[weak self] authReult, error in
            guard let stgSelf = self else{
                return
            }
            guard authReult != nil , error == nil else{
                if let error = error {
                print("Facebook credential login failed MFA may needed \(error)")
                }
                return
            }

            print("Successfully logged")
            stgSelf.navigationController?.dismiss(animated: true, completion: nil)

        })
    })
   


}

}


