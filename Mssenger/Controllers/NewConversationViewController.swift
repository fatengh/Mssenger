//
//  NewConversationViewController.swift
//  Mssenger
//
//  Created by administrator on 03/01/2022.
//

import UIKit
import JGProgressHUD

class NewConversationViewController: UIViewController {
    
    private let spinn = JGProgressHUD()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "search for contact"
        
        return searchBar
    }()
    
    
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        return table
    }()
    
    
    private let noContact: UILabel = {
        let Label = UILabel()
        Label.isHidden = true
        Label.text = "No Contacts!"
        Label.textAlignment = .center
        Label.textColor = .green
        Label.font = .systemFont(ofSize: 22, weight: .medium)
        return Label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
        searchBar.becomeFirstResponder()
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
 
}



extension NewConversationViewController: UISearchBarDelegate{
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
}
