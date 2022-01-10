//
//  NewConversationViewController.swift
//  Mssenger
//
//  Created by administrator on 03/01/2022.
//

import UIKit
import JGProgressHUD
import Network

class NewConversationViewController: UIViewController {
    
    private let spinn = JGProgressHUD(style: .dark)
    //public var completion: ((SearchResult) -> (Void))?
    private var users = [[String: String]]()
    private var hasFetched = false
    private var results = [[String: String]]()
    
    private let searchBar: UISearchBar = {
           let searchBar = UISearchBar()
           searchBar.placeholder = "Search for Users..."
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
        view.addSubview(noContact)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
        searchBar.becomeFirstResponder()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.bounds
        noContact.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
 
}


extension NewConversationViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell" , for: indexPath)
        cell.textLabel?.text = results[indexPath.row]["name"]
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    
    
}




extension NewConversationViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
                    return
                }
        searchBar.resignFirstResponder()

        results.removeAll()
        spinn.show(in: view)
        self.searchContact(query: text)

    }
    
    func searchContact(query: String) {
        if hasFetched {
                   filterUsers(with: query)
               }
               else {
                   DataBaseManger.shared.getAllUsers(completion: { [weak self] result in
                       switch result {
                       case .success(let usersCollection):
                           self?.hasFetched = true
                           self?.users = usersCollection
                           self?.filterUsers(with: query)
                       case .failure(let error):
                           print("Failed get usres: \(error)")
                       }
                   })
               }
           }

           func filterUsers(with term: String) {
               guard hasFetched else {
                   return
               }

               self.spinn.dismiss()

               let results: [[String: String]] = users.filter({
                   guard let name = $0["name"]?.lowercased() else {
                       return false
                   }

                   return name.hasPrefix(term.lowercased())
               })


               self.results = results

               updateUI()
           }

           func updateUI() {
               if results.isEmpty {
                   noContact.isHidden = false
                   tableView.isHidden = true
               }
               else {
                   noContact.isHidden = true
                   tableView.isHidden = false
                   tableView.reloadData()
               }
           }

       }

