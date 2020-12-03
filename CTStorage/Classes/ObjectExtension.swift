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
    
    /// 深拷贝出未托管的模型
    /// - Returns: 未托管的模型
    func deepCopy() -> Self {
        let newObject = type(of: self).init()
        for property in objectSchema.properties {
            guard let value = value(forKey: property.name) else {
                continue
            }
            if let detachable = value as? Object {
                newObject.setValue(detachable.deepCopy(), forKey: property.name)
            } else {
                newObject.setValue(value, forKey: property.name)
            }
        }
        return newObject
    }
}
