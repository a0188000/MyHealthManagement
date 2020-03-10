//
//  UnmanagedCopy.swift
//  MyHealthManagement
//
//  Created by EVERTRUST on 2020/3/10.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import RealmSwift

protocol UnmanagedCopy {
    func unmanagedCopy() -> Self
}

extension Object: UnmanagedCopy {
    func unmanagedCopy() -> Self {
        let o = type(of: self).init()
        for p in objectSchema.properties {
            let value = self.value(forKey: p.name)
            switch p.type {
            case .linkingObjects: break
            default:
                o.setValue(value, forKey: p.name)
            }
        }
        return o
    }
}
