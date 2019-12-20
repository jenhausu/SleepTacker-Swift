//
//  SleepDataManager.swift
//  SleepTracker-Swift
//
//  Created by 蘇健豪 on 2019/12/20.
//  Copyright © 2019 蘇健豪. All rights reserved.
//

import Foundation
import CoreData

class SleepDataManager {
    var moc: NSManagedObjectContext!
    typealias MyType = SleepData

    init(moc: NSManagedObjectContext) {
        self.moc = moc
    }

    func insert(entityName: String, attributeInfo: [String: Any], callback: @escaping (Result<(), Error>) -> Void) {
        let insertData = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.moc) as! MyType

        for (key, value) in attributeInfo {
            insertData.setValue(value, forKey: key)
        }
        
        callback(Result{ try moc.save() })
    }
    
    func fetch(entityName: String,
               predicate: NSPredicate,
               sortDescriptor: [NSSortDescriptor],
               callback: @escaping (Result<[SleepData], Error>) -> Void) {
        
        let request = NSFetchRequest<SleepData>(entityName: entityName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptor
        
        callback(Result { try self.moc.fetch(request) })
    }
    
    func update(entityName: String, predicate: NSPredicate, attibute: [String: Any], callback: @escaping (Result<(), Error>) -> Void) {
        self.fetch(entityName: entityName, predicate: predicate) { (fetchResult: Result<[SleepData], Error>) in
            switch fetchResult {
            case .success(let sleepDatas):
                for sleepData in sleepDatas {
                    for (key, value) in attibute {
                        sleepData.setValue(value, forKey: key)
                    }
                }
                
                callback(Result{ try self.moc.save() })
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
}
