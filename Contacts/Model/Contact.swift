//
//  Contact.swift
//  Contacts
//
//  Created by Kamil Wrobel on 9/28/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import Foundation
import CloudKit


class Contact {
    
    var name: String
    var phoneNumber: String
    var email: String
    let recordID : CKRecord.ID
    
    init(name: String, phoneNumber: String, email: String, recordID : CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)){
        self.name = name
        self.phoneNumber = phoneNumber
        self.email = email
        self.recordID = recordID
    }
    
    
    convenience init?(ckRecord: CKRecord){
        guard let name = ckRecord[Constants.NameKey] as? String,
            let email = ckRecord[Constants.EmailKey] as? String,
            let phoneNumber = ckRecord[Constants.PhoneKey] as? String else {return nil}
        
        self.init(name: name, phoneNumber: phoneNumber, email: email, recordID: ckRecord.recordID)
    }
}


extension CKRecord {
    convenience init(contact: Contact){
        self.init(recordType: Constants.ContactKey, recordID: contact.recordID)
        self.setValue(contact.name, forKey: Constants.NameKey)
        self.setValue(contact.email, forKey: Constants.EmailKey)
        self.setValue(contact.phoneNumber, forKey: Constants.PhoneKey)
        
    }
}


struct Constants {
    static let ContactKey = "Contact"
    static let NameKey = "Name"
    static let PhoneKey = "Phone"
    static let EmailKey = "Email"
}


extension Contact: Equatable {
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        if lhs.name == rhs.name,
            lhs.email == rhs.email,
            lhs.phoneNumber == rhs.phoneNumber {
            return true
        } else {
            return false
        }
    }
}
