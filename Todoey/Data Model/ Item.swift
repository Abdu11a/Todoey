 //
//   Item.swift
//  Todoey
//
//  Created by Abdulla Aseed on 25/11/1440 AH.
//  Copyright © 1440 Abdulla Aseed. All rights reserved.
//

import Foundation
import RealmSwift
 class Item: Object {
    
   @objc dynamic var titel : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date? 
    var perentCategory = LinkingObjects(fromType: Category.self, property:  "Items")
    
 }
