//
//  CTStorage.swift
//  CTStorage
//
//  Created by walker on 2020/11/30.
//

import UIKit
import RealmSwift

public class CTStorage {
    
    // MARK: 单例
    private init(){}
    public static let shared: CTStorage = CTStorage()
    
    /// 数据库对象
    public private(set) var realm: Realm?
    /// 数据库存储位置
    public private(set) var realmFilePath: String = NSHomeDirectory() + "/Documents/realm/"
    
    /// 更新数据库
    
    /// 创建或更新数据库
    /// - Parameters:
    ///   - newVer: 新版本号
    ///   - fileName: 数据库名称
    public func updateRealm(newVer: UInt64, fileName: String? = "") {
        
        var config = Realm.Configuration()
        // 版本号
        config.schemaVersion = newVer
        
        // 创建数据库路径，并配置目录权限
        try? FileManager.default.createDirectory(at: URL.init(fileURLWithPath: self.realmFilePath), withIntermediateDirectories: true, attributes: [FileAttributeKey.protectionKey: FileProtectionType.none])
        config.fileURL = URL.init(fileURLWithPath: realmFilePath + ((fileName?.isEmpty ?? false) ? "default.realm" : "\(fileName ?? "default").realm"))
        
        // 压缩策略
        config.shouldCompactOnLaunch = {(totalBytes, usedBytes) in
            let limitSize = 100 * 1024 * 1024
            return (totalBytes > limitSize) && ((Double(usedBytes) / Double(totalBytes)) < 0.5)
        }
        
        openRealm(config: config)
    }
    
    /// 开启数据库
    /// - Parameter config: 开启数据库的配置
    public func openRealm(config: Realm.Configuration? = nil) {
        
        if config != nil {
            Realm.Configuration.defaultConfiguration = config!
        }
        
        do {
            self.realm = try Realm()
        } catch {
            print("writeHandler error: \(error)")
        }
        
        self.realm = try? Realm()
    }
    
    /// 添加对象
    /// - Parameters:
    ///   - obj: 需要添加的数据
    ///   - update: 添加时或更新时的模式
    public func addObject(obj: Object?, update: Realm.UpdatePolicy = .error) {
        
        if obj != nil {
            var safeUpdatePolicy = update
            // 对updatePolicy 类型进行容错
            if obj?.havePrimaryKey() == true {
                if safeUpdatePolicy == .error {
                    assert(false, "updateObject(obj:update:) ，当前模型有primaryKey，传入的updatePolicy有误(应为'.modified、.all')")
                    safeUpdatePolicy = .modified
                }
            }else {
                if safeUpdatePolicy != .error {
                    assert(false, "updateObject(obj:update:) ，当前模型没有primaryKey，传入的updatePolicy有误(应为'.error')")
                    safeUpdatePolicy = .error
                }
            }
            
            self.writeHandler { (realm) in
                realm?.add(obj!, update: safeUpdatePolicy)
            }
        }
    }
    
    /// 更新对象
    /// - Parameters:
    ///   - obj: 需要更新的数据
    ///   - update: 更新的模式
    public func updateObject(obj: Object?, update: Realm.UpdatePolicy = .modified) {
        if obj != nil {
            var safeUpdatePolicy = update
            // 对updatePolicy 类型进行容错
            if obj?.havePrimaryKey() == true {
                if safeUpdatePolicy == .error {
                    assert(false, "updateObject(obj:update:) ，当前模型有primaryKey，传入的updatePolicy有误(应为'.modified、.all')")
                    safeUpdatePolicy = .modified
                }
            }else {
                if safeUpdatePolicy != .error {
                    assert(false, "updateObject(obj:update:) ，当前模型没有primaryKey，传入的updatePolicy有误(应为'.error')")
                    safeUpdatePolicy = .error
                }
            }
            self.writeHandler { (realm) in
                realm?.add(obj!, update: safeUpdatePolicy)
            }
        }
    }
    
    /// 删除对象
    /// - Parameter obj: 删除的对象
    public func deleteObject(_ obj: ObjectBase?) {
        if obj != nil {
            self.writeHandler { (realm) in
                realm?.delete(obj!)
            }
        }
    }
    
    /// 删除对象集合
    /// - Parameter objs: 删除的对象集合
    public func deleteObject<S: Sequence>(_ objs: S?) where S.Iterator.Element: ObjectBase {
        if objs != nil {
            self.writeHandler { (realm) in
                realm?.delete(objs!)
            }
        }
    }
    
    /// 删除对象集合
    /// - Parameter objs: 删除对象集合
    public func deleteObject<Element: ObjectBase>(_ objs: List<Element>?) {
        if objs != nil {
            self.writeHandler { (realm) in
                realm?.delete(objs!)
            }
        }
    }
    
    /// 写入操作处理
    public func writeHandler(handler: @escaping ((_ realm: Realm?)->())) {
        do {
            try self.realm?.write({ [weak self] in
                handler(self?.realm)
            })
        } catch {
            print("writeHandler error: \(error)")
        }
    }
    
    /// 取消写入
    public func cancelWrite() {
        
        self.realm?.cancelWrite()
    }
    
    /// 删除数据库文件
    /// - Parameter fileName: 数据库名称
    public func deleteDataBaseFile(fileName: String?) {
        
        var filePath = Realm.Configuration.defaultConfiguration.fileURL
        if fileName != nil && !fileName!.isEmpty {
            filePath = filePath?.deletingLastPathComponent().appendingPathComponent("\(fileName!).realm")
        }
        
        let needRemoveURLs = [
            filePath,
            filePath!.appendingPathExtension("lock"),
            filePath!.appendingPathExtension("note"),
            filePath!.appendingPathExtension("management")
        ];
        
        for url in needRemoveURLs {
            do {
                if url != nil {
                    try FileManager.default.removeItem(at: url!)
                }
            } catch {
                print("deleteDataBaseFile error: \(error)")
            }
        }
    }
    
    /// 删除指定目录下所有的文件，不仅是数据库文件⚠️
    /// - Parameter filePath: 指定目录
    public func deleteAllFile(filePath: String? = nil) {
        let url = URL.init(fileURLWithPath: filePath ?? self.realmFilePath)
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("deleteAllDataBaseFile error: \(error)")
        }
    }
    
}
