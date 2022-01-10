//
//  ProfileViewController.swift
//  Mssenger
//
//  Created by administrator on 03/01/2022.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class ProfileViewController: UIViewController{

    
    @IBOutlet var tableView: UITableView!
 
    let data = ["LOGOUT"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = createTableHeader()
    }

    func createTableHeader() -> UIView? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        let safeEmail = DataBaseManger.safe(emailAdd: email)
        let fileName = safeEmail + "_profile_picture.png"
        let path = "images/"+fileName
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 300))
        view.backgroundColor = .gray
        let imgView = UIImageView(frame: CGRect(x: (view.width-150)/2, y: 75, width: 150, height: 150))
        imgView.contentMode = .scaleAspectFill
        imgView.layer.borderColor = UIColor.white.cgColor
        imgView.layer.borderWidth = 3
        imgView.layer.cornerRadius = imgView.width/2
        imgView.layer.masksToBounds = true
        view.addSubview(imgView)

        StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
            
            switch result{
            case  .success(let url):
                self?.downloadImage(imageView: imgView, url: url)
            case .failure(let error):
                print("failuer to get download url: \(error)")
            }
            
        })
        
        
        return view
        
        
    }
    func downloadImage(imageView: UIImageView, url: URL){
        URLSession.shared.dataTask(with: url, completionHandler: {data, _, error in
            
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data:data)
                imageView.image = image
                
            }
        }).resume()
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
        let actionSheet = UIAlertController(title: "" , message: "", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "LOG OUT", style: .destructive, handler: {[weak self] _ in
            guard let stgSelf = self else {
                return
            }
            do{
                try FirebaseAuth.Auth.auth().signOut()
                
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                // to avoid pop like card and  can avoid it
                nav.modalPresentationStyle = .fullScreen
                stgSelf.present(nav, animated: true)
            }
            catch{
                print("Field log out")
            }
            
            
        }))
        actionSheet.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil ))
        present(actionSheet, animated: true )
        
    }
}
