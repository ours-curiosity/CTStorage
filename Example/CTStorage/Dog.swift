//
//  Dog.swift
//  CTStorage
//
//  Created by apple on 2020/11/30.
//

import UIKit
import RealmSwift

class Dog: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var age = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class Person: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    let dogs = List<Dog>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
