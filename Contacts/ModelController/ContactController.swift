//
//  ContactController.swift
//  Contacts
//
//  Created by Kamil Wrobel on 9/28/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import UIKit
import CloudKit
import UserNotifications


class ContactController {
    
    //MARK: - Shared instance
    static let shared = ContactController()
    private init() {}
    
    
    //MARK: - Properties
    let contactWasUpdatedNotification = Notification.Name("contactWasUpdated")
    
    var contacts : [Contact] = []{
        didSet{
            NotificationCenter.default.post(name: contactWasUpdatedNotification, object: nil)
        }
    }
    var contact: Contact?
    
    
    //MARK: - Create New Contact Method
    func createNewContactWith(name: String, phonenumber: String, email: String){
        let contact = Contact(name: name, phoneNumber: phonenumber, email: email)
        saveToiCloud(contact: contact) { (contact) in
            // it adds to array in save function
        }
    }
    
    
    //MARK: - Update Method
    func updateExisitng(contact: Contact, with newName: String, newPhoneNumber: String, newEmail: String, completion: @escaping (Bool) ->Void ){
        
        contact.name = newName
        contact.phoneNumber = newPhoneNumber
        contact.email = newEmail
        
        let recordToBeUpdated = CKRecord(contact: contact)
        
        let operation = CKModifyRecordsOperation(recordsToSave: [recordToBeUpdated], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.queuePriority = .high
        operation.qualityOfService = .userInteractive
        operation.completionBlock = nil
        
        self.contact = contact
        completion(true)
        
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    
    //MARK: - Delete Method
    func delete(contact: Contact, completion: @escaping(Bool)-> Void){
        let recordID = contact.recordID
        
        CKContainer.default().publicCloudDatabase.delete(withRecordID: recordID) { (recordID, error) in
            if let error = error {
                print("There was an error deleting contact from iCloud on \(#function): \(error) \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        }
        guard let indexOfContact = self.contacts.index(of: contact) else {return}
        self.contacts.remove(at: indexOfContact)
    }
    
    
    //MARK: - Save to iCloud Method
    func saveToiCloud(contact: Contact, completion: @escaping(Contact?)-> Void){
        let record  = CKRecord(contact: contact)
        CKContainer.default().publicCloudDatabase.save(record) { (record, error) in
            if let error = error {
                print("There was an error saving to icloud:  \(#function): \(error) \(error.localizedDescription)")
                return
            }
            guard let record = record else {completion(nil); return}
            guard let contact = Contact(ckRecord: record) else {return}
            self.contacts.append(contact)
        }
    }
    
    
    //MARK: - Fetch From iCloud Method
    func fetchRecordsFromiCloud(completion: @escaping([Contact]?)-> Void){
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Constants.ContactKey, predicate: predicate)
        
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("There was an error fething Records from iCloud on \(#function): \(error) \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let records = records else {return}
            let contacts = records.compactMap{Contact(ckRecord: $0)}
            self.contacts = contacts
            completion(contacts)
        }
    }
    
    
    //MARK: - Account Status Method
    func accountStatus(completion: @escaping(Bool)-> Void){
        CKContainer.default().accountStatus {[weak self] (status, error) in
            if let error = error {
                print("There was an error checking account status on \(#function): \(error) \(error.localizedDescription)")
                completion(false)
                return
            }
            
            let alertTitle = "Error Signing in to iCloud‼️"
            
            switch status {
            case .available:
                print("✅Succesfully logged in")
                completion(true)
            case .couldNotDetermine:
                self?.presentAlert(title: alertTitle, message: "Cannot determine account status")
                completion(false)
            case .noAccount:
                self?.presentAlert(title: alertTitle, message: "No account Found")
                completion(false)
            case .restricted:
                self?.presentAlert(title: alertTitle, message: "Account ststus restricted")
                completion(false)
                
            }
        }
    }
    
    //FIXME: - for some reason alertTitle goes into alert title, and alert message, even tho i have separete strings for that
    
    //MARK: - Alert Helper Method
    func presentAlert(title: String, message: String?) {
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate,
                let appWindow = appDelegate.window!,
                let rootViewController = appWindow.rootViewController {
                rootViewController.presentErrorAlert(title: title, message: message)
            }
        }
    }
    
}
