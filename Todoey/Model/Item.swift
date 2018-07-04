//
//  Item.swift
//  Todoey
//
//  Created by NIK-HIL on 6/29/18.
//  Copyright © 2018 NIKHIL. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    
    let parentCategory = LinkingObjects(fromType: Categories.self, property: "items")
}

