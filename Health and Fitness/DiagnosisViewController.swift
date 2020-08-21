//
//  DiagnosisViewController.swift
//  Health and Fitness
//
//  Created by Thao Phan on 7/29/20.
//  Copyright © 2020 Thao Phan. All rights reserved.
//

import UIKit

class DiagnosisViewController: UIViewController {
    
    //MARK: - IBActions & IBOutlets
    @IBOutlet weak var disclaimerLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "DiagnosisToSymptom", sender: self)
    }
    
    @IBAction func finishButton(_ sender: Any) {
        self.performSegue(withIdentifier: "backToHomePage", sender: self)
    }
    
    //MARK: - variable declarations
    let tableView = UITableView()
    
    var label = UILabel()
    
    var token = String()
    var age = Int()
    var gender = String()
    var patientSelectedSymptoms: [Symptom] = []
    var patientSelectedIssue = IssueInfo()
    var patientDetailedDiagnosis = DetailedDiagnosis()
    var patientSelectedSymptomsIDs: [Int] = []
    var patientDiagnosis: [IssueObject] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var detailedDiagnosis: [DetailedDiagnosis] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DiagnosisCell.self, forCellReuseIdentifier: "diagnosisCell")
        
        for symptom in patientSelectedSymptoms {
            patientSelectedSymptomsIDs.append(symptom.ID!)
        }
        
        //MARK: - GET Diagnosis
        callAPI(GETCall: "diagnosis?symptoms=\(patientSelectedSymptomsIDs)&gender=\(gender)&year_of_birth=\(age)&", token: token, format: "json", language: "en-gb") { [weak self] (result: [IssueObject]) in
            
            DispatchQueue.main.async {
                self!.patientDiagnosis = result
                
                var index = 0
                
                if (self!.patientDiagnosis.count >= 1) {
                    while index < self!.patientDiagnosis.count {
                        //MARK: - GET DetailedDiagnosis
                        callAPI2(GETCall: "issues/\(self!.patientDiagnosis[index].Issue.ID!)/info?", token: self!.token, format: "json", language: "en-gb") { [weak self] (result: DetailedDiagnosis) in
                            DispatchQueue.main.async {
                                self!.detailedDiagnosis.append(result)
                            }
                        }
                        
                        index += 1
                    }
                    
                    //MARK: - tableview setup
                    self!.view.addSubview(self!.tableView)
                    
                    self!.tableView.translatesAutoresizingMaskIntoConstraints = false
                    self!.tableView.rowHeight = 100
                    self!.tableView.topAnchor.constraint(equalTo: self!.disclaimerLabel.bottomAnchor, constant: 30).isActive = true
                    self!.tableView.centerXAnchor.constraint(equalTo: self!.view.centerXAnchor).isActive = true
                    self!.tableView.leftAnchor.constraint(equalTo: self!.view.leftAnchor).isActive = true
                    self!.tableView.rightAnchor.constraint(equalTo: self!.view.rightAnchor).isActive = true
                    self!.tableView.bottomAnchor.constraint(equalTo: self!.finishButton.topAnchor, constant: 20).isActive = true
                    
                    self!.tableView.reloadData()
                    
                } else {
                    //in case no valid diagnosis
                    self!.view.addSubview(self!.label)
                    self!.label.numberOfLines = 0
                    self!.label.text = "Not able to get a valid diagnosis with the given symptoms. Please remove or add symptoms to make them more consistent."
                    
                    self!.label.translatesAutoresizingMaskIntoConstraints = false
                    self!.label.centerXAnchor.constraint(equalTo: self!.view.centerXAnchor).isActive = true
                    self!.label.topAnchor.constraint(equalTo: self!.view.topAnchor, constant: 200).isActive = true
                    self!.label.widthAnchor.constraint(equalToConstant: 300).isActive = true
                    self!.label.heightAnchor.constraint(equalToConstant: 150).isActive = true
                }
            }
        }

        // Do any additional setup after loading the view.
    }
    
    //MARK: - segue prepare function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailedDiagnosis") {
            let DD = segue.destination as! DetailedDiagnosisViewController
            
            DD.patientSelectedIssue = self.patientSelectedIssue
            DD.patientDetaileDiagnosis = self.patientDetailedDiagnosis
        } else if (segue.identifier == "backToHomePage"){
            _ = segue.destination as! HomeViewController
        } else if (segue.identifier == "DiagnosisToSymptom") {
            _ = segue.destination as! SymptomsViewController
        }
    }
    
}

//MARK: - extensions
extension DiagnosisViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patientDiagnosis.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "diagnosisCell", for: indexPath) as! DiagnosisCell
        
        if (detailedDiagnosis.count == patientDiagnosis.count) {
            
            cell.illness.font = UIFont (name: "Courier", size: 25)
            cell.illness.text = "Name: \(patientDiagnosis[indexPath.row].Issue.Name!)"
            
            cell.accuracy.font = UIFont (name: "Courier", size: 15)
            cell.accuracy.text = "Accuracy: \(patientDiagnosis[indexPath.row].Issue.Accuracy!)"
        }
        
        return cell
    }
    
    
}

extension DiagnosisViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        patientSelectedIssue = patientDiagnosis[indexPath.row].Issue
        patientDetailedDiagnosis = detailedDiagnosis[indexPath.row]
        
        performSegue(withIdentifier: "detailedDiagnosis", sender: self)
    }
    
}
