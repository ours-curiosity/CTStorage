//
//  ObjectExtension.swift
//  CTStorage
//
//  Created by walker on 2020/12/2.
//

import RealmSwift
import ObjectiveC

public extension Object {
    
    /// 判断是否有主键
    /// - Returns: 有主键返回true
    func havePrimaryKey() -> Bool {
        if let cls = object_getClass(self) {
            let primaryKey = cls.primaryKey()
            return (primaryKey != nil && !primaryKey!.isEmpty)
        }
        return false
    }
}
