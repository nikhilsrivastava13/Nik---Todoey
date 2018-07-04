//
//  Categories.swift
//  Todoey
//
//  Created by NIK-HIL on 6/29/18.
//  Copyright © 2018 NIKHIL. All rights reserved.
//

import Foundation
import RealmSwift

class Categories: Object {
    
    @objc dynamic var name : String = ""
    
    let items = List<Item>()
}
