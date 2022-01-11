//
//  ViewController.swift
//  Mssenger
//
//  Created by administrator on 03/01/2022.
//

import UIKit
import Firebase
import JGProgressHUD

class ConversationViewController : UIViewController {
    
    private let spinn = JGProgressHUD(style: .dark)

    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        return table
    }()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapComposeBtn))
        view.addSubview(tableView)
        view.addSubview(noConv)
        setupTV()
        fetchConv()
        
    }
    
    @objc private func didTapComposeBtn(){
         
           let vc = NewConversationViewController()
           vc.completion = { [weak self] result in
                   print("\(result)")
               self?.createNewConversation(result: result)

                    }
           let navVC = UINavigationController(rootViewController: vc)
           present(navVC,animated: true)
       }
    private func createNewConversation(result: [String:String]) {
        guard let name = result["name"], let email = result["email"] else {
            return
        }
        let vc = ChatViewController(with: "ghamdi@gmail.com")
        vc.isNewConversation = true
        vc.title = name
        navigationController?.pushViewController(vc, animated: true) 
    }

    // check if use log in or not
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
        validAuth()
       }
    
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            tableView.frame = view.bounds
        }
    
    private func fetchConv(){
          
          tableView.isHidden = false
      }
    private let noConv: UILabel = {
        let conLabel = UILabel()
        conLabel.text = "You dont have any conversations!"
        conLabel.textAlignment = .center
        conLabel.textColor = .gray
        conLabel.font = .systemFont(ofSize: 22, weight: .medium)
        return conLabel
    }()
    
    
    private func validAuth(){
        if Firebase.Auth.auth().currentUser == nil {
            
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            // to avoid pop like card and  can avoid it
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }
    
    private func setupTV(){
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        cell.textLabel?.text = "Test!!"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ChatViewController(with: "faten@gmail.cco")
        vc.title = "Test Chat"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
 
