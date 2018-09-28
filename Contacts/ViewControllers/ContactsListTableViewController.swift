//
//  ContactsListTableViewController.swift
//  Contacts
//
//  Created by Kamil Wrobel on 9/28/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import UIKit
import UserNotifications

class ContactsListTableViewController: UITableViewController {

    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: ContactController.shared.contactWasUpdatedNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactController.shared.contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        let contact  = ContactController.shared.contacts[indexPath.row]
        cell.textLabel?.text = contact.name
        return cell
    }
    

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
   
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contact = ContactController.shared.contacts[indexPath.row]
            
            ContactController.shared.delete(contact: contact) { (success) in
                if success {
                    print("❌Contact sucesfully removed")
                }
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDetailView" {
            let destinationVC = segue.destination as? AddContactViewController
            guard let index = tableView.indexPathForSelectedRow else {return}
            let contact = ContactController.shared.contacts[index.row]
            destinationVC?.contact = contact
        }
    }
    
    
    //MARK: - Helper Methods
    @objc func updateTableView(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
