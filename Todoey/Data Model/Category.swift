//
//  Category.swift
//  Todoey
//
//  Created by Abdulla Aseed on 25/11/1440 AH.
//  Copyright © 1440 Abdulla Aseed. All rights reserved.
//

import Foundation
import RealmSwift
class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
   

}
