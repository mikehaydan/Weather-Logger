//
//  UIViewController + Extension.swift
//  Weather Logger
//
//  Created by Mike Haydan on 11/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func alert(message: String, title: String? = nil, okText: String? = "Ok", cancelText: String? = "Cancel",  okHandler: @escaping ((UIAlertAction) -> ()), cancelHandler: @escaping ((UIAlertAction) -> ())) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: okText, style: .default, handler: okHandler)
            let cancelAction = UIAlertAction(title: cancelText, style: .cancel, handler: cancelHandler)
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            strongSelf.present(alertController, animated: true, completion: nil)
        }
    }
    
    func alert(message: String, title: String? = nil, okText: String? = "Ok", okHandler: ((UIAlertAction) -> ())? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: okText, style: .default, handler: okHandler)
            alertController.addAction(okAction)
            strongSelf.present(alertController, animated: true, completion: nil)
        }
    }
    
}
