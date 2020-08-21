//
//  SQlite.swift
//  Health and Fitness
//
//  Created by Thao Phan on 7/17/20.
//  Copyright © 2020 Thao Phan. All rights reserved.
//

import Foundation
import SQLite3

func openDataBase() -> OpaquePointer? {
    var db: OpaquePointer?
    let path: String = "HealthDatabase.sqlite"
    let filePath = try! FileManager.default.url(for: .documentDirectory   , in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(path)
    
    if (sqlite3_open(filePath.path, &db) == SQLITE_OK) {
        print("Successfully opened connection to database at \(filePath)")
        return db
    } else {
        print("Unable to open database")
        sqlite3_close(db)
        return nil
    }
}

func createTable(createTableString: String, db: OpaquePointer) {
    var createTableStatement: OpaquePointer?
    
    if (sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK) {
        if (sqlite3_step(createTableStatement) == SQLITE_DONE) {
            print("\ntable created successfully")
        } else {
            print("\ntable can't be created or table has already been created")
        }
    } else {
        print("create table statement not prepared")
    }   
    
    sqlite3_finalize(createTableStatement)
}

func insertSymptom(insertStatementString: String, db: OpaquePointer, name: String, ID: Int32) {
    var insertStatement: OpaquePointer?
    
    if (sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK) {
        sqlite3_bind_int(insertStatement, 1, ID)
        sqlite3_bind_text(insertStatement, 2, name, -1, nil)
        
        if (sqlite3_step(insertStatement) == SQLITE_DONE) {
            print("\nSucessfully inserted one row")
        } else {
            print("\nCannot insert row")
        }
    } else {
        print("\nInsert statement not prepared")
    }
    
    sqlite3_finalize(insertStatement)
}

func insertSymptomList(db: OpaquePointer, insertStatementString: String, symptomList: [Symptom]) {
    var insertStatement: OpaquePointer?
    
    if (sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK) {
        for symptom in symptomList {
            guard let id = symptom.ID else {
                print("\nSymptom does not have valid ID")
                return
            }
            
            guard let symptomName = symptom.Name else {
                print("\nSymptom does not have valid Name")
                return
            }
            
            let symptomID = Double(id)
            
            sqlite3_bind_int(insertStatement, 1, Int32(symptomID))
            sqlite3_bind_text(insertStatement, 2, symptomName, -1, nil)
            print("\nInserted new row with ID: \(symptomID) | Name: \(symptomName)")
        }
        
        print ("\nSuccessfully inserted symptom list with \(symptomList.count) rows")
    } else {
        print("\nInsert symptom list statement not prepared")
    }
    
    sqlite3_finalize(insertStatement)
}

func checkEmptyTable(db: OpaquePointer, tableName: String) -> Bool {
    let queryStatementString = "SELECT * FROM \(tableName)"
    var queryStatement: OpaquePointer?
    
    if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
        var count = 0
        
        while (sqlite3_step(queryStatement) == SQLITE_ROW) {
            count+=1
        }
        
        sqlite3_finalize(queryStatement)
        
        if (count > 0) {
            print("\nTable not empty. Table has \(count) rows")
            return false
        } else {
            return true
        }
    } else {
        print("CheckEmptyTable Statement not prepared")
        return true
    }
}

func query(db: OpaquePointer, tableName: String) {
    let queryStatementString = "SELECT * FROM \(tableName)"
    var queryStatement: OpaquePointer?
    
    if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
        while (sqlite3_step(queryStatement) == SQLITE_ROW) {
            let id = sqlite3_column_int(queryStatement, 0)
            guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1) else {
                print("\nQuery result is nil")
                return
            }
            
            let name = String(cString: queryResultCol1)
            print("\nQuery Result:")
            print("\(id) | \(name)")
        }
    } else {
        print("\nCannot query")
    }
    
    sqlite3_finalize(queryStatement)
}

func deleteAllRows(db: OpaquePointer, tableName: String) {
    let deleteStatementString = "DELETE FROM \(tableName)"
    var deleteStatement: OpaquePointer?
    
    if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) ==
    SQLITE_OK {
        if sqlite3_step(deleteStatement) == SQLITE_OK {
            print("Deleted every rows")
        } else {
            print("\nCould not delete rows")
        }
    } else {
        print("\nDelete statement not prepared")
    }
    
    sqlite3_finalize(deleteStatement)
}

func insertTableToArray(db: OpaquePointer, tableName: String, array: inout [Symptom]) {
    let query = "SELECT * FROM \(tableName)"
    var insertStatement: OpaquePointer?
    
    if sqlite3_prepare_v2(db, query, -1, &insertStatement, nil) == SQLITE_OK {
        while(sqlite3_step(insertStatement) == SQLITE_ROW) {
            let tempid = sqlite3_column_int(insertStatement, 0)
            guard let tempName = sqlite3_column_text(insertStatement, 1) else {
                print("No name from query")
                return
            }
            
            let id = Int(tempid)
            let name = String(cString: tempName)
            array.append(Symptom(ID: id, Name: name))
        }
    } else {
        print("Cannot query")
    }
    
    sqlite3_finalize(insertStatement)
}
