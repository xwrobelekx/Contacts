//
//  AddContactViewController.swift
//  Contacts
//
//  Created by Kamil Wrobel on 9/28/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController {
    
    
    //MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    
    //MARK: - Properties
    var contact : Contact? {
        didSet{
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    
    //MARK: - Helper Methods
    func updateViews() {
        guard let contact = contact else {return}
        nameTextField.text = contact.name
        emailTextField.text = contact.email
        phoneTextField.text = contact.phoneNumber
    }
    
    
    //MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let nameText = nameTextField.text,
            let phoneText = phoneTextField.text,
            let emailText = emailTextField.text,
            nameText != "",
            phoneText != "",
            emailText != "" else {return}
        
        if contact != nil {
            guard let contactToUpdate = contact else {return}
            ContactController.shared.updateExisitng(contact: contactToUpdate, with: nameText, newPhoneNumber: phoneText, newEmail: emailText) { (success) in
            }
        } else {
        ContactController.shared.createNewContactWith(name: nameText, phonenumber: phoneText, email: emailText)
        }
        navigationController?.popViewController(animated: true)
    }
}
