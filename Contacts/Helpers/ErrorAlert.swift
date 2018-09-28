//
//  ErrorAlert.swift
//  Contacts
//
//  Created by Kamil Wrobel on 9/28/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import UIKit



extension UIViewController {
    
    func presentErrorAlert(title: String, message: String?){
        let errorAlert = UIAlertController(title: title, message: title, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
        }))
        present(errorAlert, animated: true)
    }
}
