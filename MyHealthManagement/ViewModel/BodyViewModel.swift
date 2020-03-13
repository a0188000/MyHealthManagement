//
//  BodyViewModel.swift
//  MyHealthManagement
//
//  Created by EVERTRUST on 2020/3/9.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

class BodyViewModel {
    
    var saveBtnEnableObservable = { (_ enable: Bool) -> Void in }
    var deleteBtnEnableObservable = { (_ enable: Bool) -> Void in }
    var bodyDataDidChangedCallback = { () -> Void in }
    var removedBodyDataSuccessCallback = { () -> Void in }
    
    var bodys: [RLM_Body] {
        return RLMManager.shared.fetch(type: RLM_Body.self)
    }
    var body: RLM_Body?
    
    var date: Date = Date() {
        didSet {
            self.changeBody()
        }
    }
    
    private var dateFormatter = DateFormatter {
        $0.dateFormat = "yyyy-MM-dd"
    }
    
    init() {
        self.date = Date(timeIntervalSince1970: Date.currentDayTimestamp())
        if let index = bodys.firstIndex(where: { $0.timestamp == date.timeIntervalSince1970 }) {
            self.body = self.bodys[index]
            self.saveBtnEnableObservable(true)
            self.deleteBtnEnableObservable(true)
        }
        self.changeBody()
    }
    
    func updateBodyValue(value: String, bodyData: InBody) {
        switch bodyData {
        case .bodyWeigth:
            self.body?.bodyWeigth = value.asDouble()
            self.saveBtnEnableObservable(!(value.isEmpty || value == "0" || value == "0.0"))
        case .muscleWeight: self.body?.muscleWeight = value.asDouble()
        case .bodyFat:      self.body?.bodyFat = value.asDouble()
        case .bmi:          self.body?.bmi = value.asDouble()
        case .pbf:          self.body?.pbf = value.asDouble()
        }
    }
    
    func save() {
        guard let body = self.body else { return }
        RLMManager.shared.update(object: body, completionHandler: nil, failedHandler: nil)
        self.deleteBtnEnableObservable(true)
        self.bodyDataDidChangedCallback()
    }
    
    func delete() {
        guard let body = self.body else { return }
        RLMManager.shared.delete(type: RLM_Body.self, primaryKey: body.uuid, completionHandler: nil, failedHandler: nil)
        self.changeBody()
        self.removedBodyDataSuccessCallback()
        self.saveBtnEnableObservable(false)
        self.deleteBtnEnableObservable(false)
        self.bodyDataDidChangedCallback()
    }
}

extension BodyViewModel {
    private func changeBody() {
        self.body = nil
        if let index = bodys.firstIndex(where: { $0.timestamp == date.timeIntervalSince1970 }) {
            self.body = self.bodys[index].unmanagedCopy()
            self.deleteBtnEnableObservable(true)
        } else {
            self.body = RLM_Body()
            self.body?.timestamp = self.date.timeIntervalSince1970
            self.deleteBtnEnableObservable(false)
        }
        self.saveBtnEnableObservable(self.body?.bodyWeigth != 0.0)
    }
}
