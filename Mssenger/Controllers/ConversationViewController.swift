//
//  ViewController.swift
//  Mssenger
//
//  Created by administrator on 03/01/2022.
//

import UIKit

class ConversationViewController : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    
    // check if user log in or not
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           let isLoggedIn = UserDefaults.standard.bool(forKey: "logged")
           if !isLoggedIn {
               // present login view controller
               
               let vc = LoginViewController()
               let nav = UINavigationController(rootViewController: vc)
               // to avoid pop like card and  can avoid it
               nav.modalPresentationStyle = .fullScreen
               present(nav, animated: false)
           }
       }
}

