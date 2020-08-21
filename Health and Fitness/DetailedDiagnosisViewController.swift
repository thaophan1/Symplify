//
//  DetailedDiagnosisViewController.swift
//  Health and Fitness
//
//  Created by Thao Phan on 8/5/20.
//  Copyright © 2020 Thao Phan. All rights reserved.
//

import UIKit

class DetailedDiagnosisViewController: UIViewController {
    
    @IBOutlet weak var detailedView: UILabel!
    
    var patientSelectedIssue = IssueInfo()
    var patientDetaileDiagnosis = DetailedDiagnosis()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailedView.text = "Name: \(patientSelectedIssue.Name!) \n \nAccuracy: \(patientSelectedIssue.Accuracy!) \n \nDescription: \(patientDetaileDiagnosis.Description!) \n \nMedical Condition: \(patientDetaileDiagnosis.MedicalCondition!) \n \nPossible Symptoms: \(patientDetaileDiagnosis.PossibleSymptoms!) \n \nRecommended Treatment: \(patientDetaileDiagnosis.TreatmentDescription!)"

    }


}
