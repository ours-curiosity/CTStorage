//
//  ObjectExtension.swift
//  CTStorage
//
//  Created by walker on 2020/12/2.
//

import Realm
import RealmSwift
import ObjectiveC

public extension Object {
    
    /// 判断是否有主键
    /// - Returns: 有主键返回true
    func havePrimaryKey() -> Bool {
        return object_getClass(self)?.responds(to: #selector(RealmSwiftObject.primaryKey)) == true
    }
}
