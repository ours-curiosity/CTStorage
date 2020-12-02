//
//  CTStorageTools.swift
//  CTStorage
//
//  Created by walker on 2020/12/2.
//

import Foundation
import RealmSwift
public extension CTStorage {
    
    /// 根据修改内容生成新的数据库目录
    /// - Parameters:
    ///   - newFileUrl: 新的数据库目录
    ///   - newFileName: 新的数据库名称
    func ct_createFileUrl(curConfig: Realm.Configuration? = nil, newFileUrl: URL? = nil, newFileName: String? = nil) -> (path: String, fileName: String, allPath: URL) {
        
        var curFilePath = URL.init(string: self.realmFilePath + "default.realm")
        if curConfig != nil {
            curFilePath = curConfig!.fileURL
        }
        // 当前的路径和文件名称
        var path: String = curFilePath?.deletingLastPathComponent().absoluteString ?? self.realmFilePath
        var fileName: String = curFilePath?.lastPathComponent ?? "default.realm"
        // 新传入的路径
        if newFileUrl != nil && !newFileUrl!.absoluteString.isEmpty {
            if newFileUrl!.lastPathComponent.hasSuffix(".realm") { // 带文件名
                path = newFileUrl!.deletingLastPathComponent().absoluteString
                fileName = newFileUrl!.lastPathComponent
            }else { // 不带文件名
                path = newFileUrl!.absoluteString
            }
        }
        // 新传入的文件名
        if newFileName != nil && !newFileName!.isEmpty {
            fileName = newFileName! + ".realm"
        }
        return (path, fileName, URL.init(string: "\(path)\(fileName)")!)
    }
    
}
