//
//  UITableViewCell + Extension.swift
//  Weather Logger
//
//  Created by Mike Haydan on 13/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    class var nibName: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
}
