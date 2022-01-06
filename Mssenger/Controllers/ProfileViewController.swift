//
//  ProfileViewController.swift
//  Mssenger
//
//  Created by administrator on 03/01/2022.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController{

    
    @IBOutlet var tableView: UITableView!
 
    let data = ["LOGOUT"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        tableView.delegate = self
        tableView.dataSource = self
    }

}
extension ProfileViewController:  UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        do{
          try FirebaseAuth.Auth.auth().signOut()
        
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            // to avoid pop like card and  can avoid it
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        }
        catch{
            print("Field log out")
        }
    }
}
