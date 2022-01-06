//
//  ViewController.swift
//  Mssenger
//
//  Created by administrator on 03/01/2022.
//

import UIKit
import Firebase

class ConversationViewController : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // check if user log in or not
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
        validAuth()
       }
    
    private func validAuth(){
       // let isLoggedIn = UserDefaults.standard.bool(forKey: "logged")
        if Firebase.Auth.auth().currentUser == nil {
            // present login view controller
            
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            // to avoid pop like card and  can avoid it
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }
}

