//
//  Symptoms.swift
//  Health and Fitness
//
//  Created by Thao Phan on 7/3/20.
//  Copyright © 2020 Thao Phan. All rights reserved.
//

import Foundation

struct Symptom: Codable {
    var ID: Int?
    var Name: String?
}

func removeSymptomFromArray (symptomName: String, symptomsArray: inout [Symptom]) {
    for index in 0...symptomsArray.count - 1 {
        if symptomsArray[index].Name == symptomName {
            symptomsArray.remove(at: index)
            break
        }
    }
}

func containSymptom (symptom: Symptom, symptomsArray: inout [Symptom]) -> Bool {
    for s in symptomsArray {
        if (s.Name == symptom.Name) && (s.ID == symptom.ID) {
            return true
        }
    }
    
    return false
}

struct IssueObject: Codable {
    var Issue: IssueInfo
}

struct IssueInfo: Codable {
    var ID: Int?
    var Name: String?
    var Accuracy : Int?
}

struct DetailedDiagnosis: Codable {
    var Description: String?
    var DescriptionShort: String?
    var MedicalCondition: String?
    var PossibleSymptoms: String?
    var TreatmentDescription: String?
}
