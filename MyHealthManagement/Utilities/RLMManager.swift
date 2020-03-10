//
//  RLMManager.swift
//  MyHealthManagement
//
//  Created by EVERTRUST on 2020/3/10.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import RealmSwift

typealias RealmCompletionHandler = (() -> Void)?
typealias RealmFailedHandler = ((Error) -> Void)?

protocol RLMManageable {
    var realm: Realm? { get }
    func fetch<T: Object>(type: T.Type) -> [T]
    func update<T: Object>(object: T,
                           completionHandler: RealmCompletionHandler,
                           failedHandler: RealmFailedHandler)
    func delete<T: Object>(type: T.Type,
                           primaryKey: Any,
                           completionHandler: RealmCompletionHandler,
                           failedHandler: RealmFailedHandler)
}

class RLMManager: RLMManageable {
    
    static let shared = RLMManager()
    var realm: Realm?
    
    private(set) var schemaVersion: UInt64 = 0
    
    private init() {
        self.migrationVersion()
        do {
            try self.realm = Realm()
            print("Realm db file path: \(self.realm?.configuration.fileURL?.absoluteString ?? "無路徑")")
        } catch {
            print("Create realm db failed: \(error.localizedDescription)")
        }
    }
    
    func fetch<T: Object>(type: T.Type) -> [T] {
        guard let objects = self.realm?.objects(type) else { return [] }
        return Array(objects).map { $0.unmanagedCopy() }
    }
    
    func update<T: Object>(object: T,
                           completionHandler: RealmCompletionHandler,
                           failedHandler: RealmFailedHandler) {
        self.execute({
            self.realm?.add(object, update: .all)
            completionHandler?()
        }, failedHandler: failedHandler)
    }
    
    func delete<T: Object>(type: T.Type,
                           primaryKey: Any,
                           completionHandler: RealmCompletionHandler,
                           failedHandler: RealmFailedHandler) {
        guard let object = self.realm?.object(ofType: type, forPrimaryKey: primaryKey) else { return }
        self.execute({
            self.realm?.delete(object)
            completionHandler?()
        }, failedHandler: failedHandler)
    }
}

extension RLMManager {
    private func migrationVersion() {
        var configure = Realm.Configuration(schemaVersion: self.schemaVersion, migrationBlock: { (migration, oldVersion) in
            if oldVersion < self.schemaVersion {
                
            }
        })
        configure.fileURL = configure.fileURL?.deletingLastPathComponent().appendingPathComponent("mAgent.realm")
        Realm.Configuration.defaultConfiguration = configure
    }
    
    private func execute(_ block: () -> Void, failedHandler: RealmFailedHandler) {
        do {
            try self.realm?.write(block)
        } catch let error {
            failedHandler?(error)
            print("Realm write failed: \(error.localizedDescription)")
        }
    }
}
