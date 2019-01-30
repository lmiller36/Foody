//
//  Survey_Cloud_Model.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by user on 1/29/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import CloudKit


class Survey_Cloud_Model {
    
    public static var shared_instance = Survey_Cloud_Model.init()
    
   private let container : CKContainer
   private let publicDatabase : CKDatabase
    fileprivate init(){
        self.container = CKContainer.default()
        self.publicDatabase = container.publicCloudDatabase
        
        checkPermissions()
    }
    
    func checkPermissions(){
        CKContainer.default().requestApplicationPermission(CKApplicationPermissions.userDiscoverability) { (status, error) in
            switch status {
            case .granted:
                print("granted")
            case .denied:
                print("denied")
            case .initialState:
                print("initial state")
            case .couldNotComplete:
                print("an error as occurred: ", error ?? "Unknown error")
            }
        }
    }
    
    func savePublicRecord(record:CKRecord) {
//        let aRecord = CKRecord(recordType: "SurveyCloud")
//
//        let random = SurveyID.generate()
//        let date = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss" + random.id
//        let result = formatter.string(from: date)
//
//        print(aRecord.recordID)
//        print(aRecord.recordID.recordName)
//        print(aRecord)
//
//        aRecord.setObject(random.id as CKRecordValue, forKey: "id")
//        aRecord.setObject(result as CKRecordValue, forKey: "data")

//        let container = CKContainer.default()
//        let publicDatabase = container.publicCloudDatabase
        
        
        publicDatabase.save(record, completionHandler: { (record, error) -> Void in
            if let error = error {
                print(error)
            }
            else {
                print("record saved successfully")
            }
        })
    }
    
    func updatePublicRecord(record:CKRecord){
        print(record)
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        
//        operation.perRecordProgressBlock = { self.progressView.progress = $1 }
//        operation.completionBlock = { self.progressView.hidden = true }
//
        //progressView.hidden = false
        
        CKContainer.default().publicCloudDatabase.add(operation)
        
       
        let saveOper = CKModifyRecordsOperation()
        saveOper.recordsToSave = [record]
        saveOper.savePolicy = .ifServerRecordUnchanged
        
        saveOper.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, error in
            
            if saveOper.isFinished == true {
                
            }
        }
        publicDatabase.add(saveOper)
   
    }
    
    func getPublicRecord(recordName:String,completion: @escaping (_ record: CKRecord) -> Void){
        
        let recordID = CKRecordID.init(recordName: recordName)
        
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { record, error in
            guard let record = record, error == nil else {
                print(error)
                
                // show off your error handling skills
                return
            }
            print("The user record is: \(record)")
            completion(record)
        }
    

    }
    

    
}
