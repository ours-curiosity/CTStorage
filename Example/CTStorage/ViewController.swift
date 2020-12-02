//
//  ViewController.swift
//  CTStorage
//
//  Created by ghostlordstar on 11/27/2020.
//  Copyright (c) 2020 ghostlordstar. All rights reserved.
//

import UIKit
import CTStorage
import RealmSwift
class ViewController: UIViewController {
    
    var person: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        CTStorage.shared.updateRealm(newVer: 1, fileName: "2345")
        
        print("realm file path: \(String(describing: CTStorage.shared.realm?.configuration.fileURL?.standardizedFileURL))")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btn1Action(_ sender: UIButton) {
                
        let dog = Dog.init()
        dog.id = 4
        dog.name = "rich222"
        dog.age = 21
        
        let person = Person.init()
        person.id = 3
        person.name = "walker22221"
        person.dogs.append(dog)
        self.person = person
        
        CTStorage.shared.addObject(obj: person)

    }
    
    @IBAction func btn2Action(_ sender: UIButton) {
        CTStorage.shared.deleteObject(self.person)
//        CTStorage.shared.deleteDataBaseFile(fileName: "2345")
//        CTStorage.shared.deleteAllFile()
        
    }
}

