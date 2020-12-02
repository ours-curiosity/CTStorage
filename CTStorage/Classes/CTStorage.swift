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
    public private(set) var realmFilePath: String = NSHomeDirectory() + "/Documents/"
    
    /// 更新数据库
    
    /// 创建或更新数据库
    /// - Parameters:
    ///   - newVer: 新版本号
    ///   - fileName: 数据库名称
    public func updateRealm(newVer: UInt64 = 1, fileURL: URL? = nil, fileName: String? = "", syncConfiguration: SyncConfiguration? = nil, readOnly:Bool = false, inMemoryId: String? = nil, encryptionKey: Data? = nil, migrationBlock: MigrationBlock? = nil, deleteRealmIfMigrationNeeded: Bool = false, shouldCompactOnLaunch: ((Int, Int) -> Bool)? = nil, objectTypes: [ObjectBase.Type]? = nil) {
        
        var config = Realm.Configuration.defaultConfiguration
        
        if config.schemaVersion == newVer {
            // 不需升级,直接打开数据库
            openRealm()
            return
        }
        
        // --- 版本号
        config.schemaVersion = newVer
        // --- 文件路径
        let newPathTuple = self.ct_createFileUrl(curConfig: config, newFileUrl: fileURL, newFileName: fileName)
        // 创建数据库路径，并配置目录权限
        try? FileManager.default.createDirectory(at: URL.init(fileURLWithPath: newPathTuple.path), withIntermediateDirectories: true, attributes: [FileAttributeKey.protectionKey: FileProtectionType.none])
        config.fileURL = newPathTuple.allPath
        // --- 与MongoDB Realm同步的配置
        config.syncConfiguration = syncConfiguration
        // --- 是否只读
        config.readOnly = readOnly
        // --- 内存数据库key
        if inMemoryId != nil && !(inMemoryId!.isEmpty) {
            config.inMemoryIdentifier = inMemoryId
        }
        // --- 加密key
        config.encryptionKey = encryptionKey
        // --- 合并时的操作block
        config.migrationBlock = migrationBlock
        // --- 迁移数据库出现问题或者有新版本时是否允许删除原有数据库（慎用⚠️）
        config.deleteRealmIfMigrationNeeded = deleteRealmIfMigrationNeeded
        // --- 压缩策略
        config.shouldCompactOnLaunch = shouldCompactOnLaunch ?? {(totalBytes, usedBytes) in
            let limitSize = 100 * 1024 * 1024
            return (totalBytes > limitSize) && ((Double(usedBytes) / Double(totalBytes)) < 0.5)
        }
        // --- 数据库跟踪的类型限制
        config.objectTypes = objectTypes
        
        openRealm(config: config)
    }
    
    /// 开启数据库
    /// - Parameter config: 开启数据库的配置
    public func openRealm(config: Realm.Configuration? = nil) {
        
        if config != nil || self.realm == nil {
            Realm.Configuration.defaultConfiguration = config!
            do {
                self.realm = try Realm()
            } catch {
                print("writeHandler error: \(error)")
            }
        }
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
