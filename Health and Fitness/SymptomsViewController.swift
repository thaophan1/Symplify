//
//  SymptomsViewController.swift
//  Health and Fitness
//
//  Created by Thao Phan on 7/2/20.
//  Copyright © 2020 Thao Phan. All rights reserved.
//

import UIKit
import SQLite3

class SymptomsViewController: UIViewController{
    
    //MARK: - variable declarations
    var gender = String()
    var age = Int()
    
    var pickerSubjects : [Symptom] = []
    var selectedSymptom = Symptom()
    var patientSelectedSymptoms : [Symptom] = []
    
    let token = "tokens available at apimedic.com"
    
    //MARK: - IBOutlets && IBActions
    @IBAction func addSymptomButton(_ sender: Any) {        
        if (containSymptom(symptom: selectedSymptom, symptomsArray: &patientSelectedSymptoms)) {
            print("symptom already added")
        } else {
            patientSelectedSymptoms.append(selectedSymptom)
            print(patientSelectedSymptoms.count)
        }
            
        self.tableView.reloadData()
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "SymptomToHome", sender: self)
    }
    
    @IBAction func getDiagnosisButton(_ sender: Any) {
        if (patientSelectedSymptoms.count < 1) {
            invalidAlert(title: "No Symptoms", message: "Please enter your symptoms")
        } else {
            performSegue(withIdentifier: "diagnosis", sender: self)
        }
    }
    
    @IBOutlet weak public var tableView: UITableView!
    
    let pickerView = UIPickerView()
    
    @IBOutlet weak var symptomPickerTextField: UITextField!
    
    //MARK: - create table string
    let createTableString = """
    CREATE TABLE IF NOT EXISTS Symptom(
    Id INT PRIMARY KEY NOT NULL,
    Name STRING);
    """

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(gender, age)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        
        symptomPickerTextField.inputView = pickerView
        createToolBar()
        
        //MARK: - creating database
        guard let db = openDataBase() else {
            print("cannot open a database")
            return
        }
        
        createTable(createTableString: createTableString, db: db)
        
        //MARK: - check empty table & creating list of symptoms
        if (checkEmptyTable(db: db, tableName: "Symptom") == true) {
            callAPI(GETCall: "symptoms?", token: token, format: "json", language: "en-gb") { [weak self] (result: [Symptom]) in
                DispatchQueue.main.async {
                    self!.pickerSubjects = result
                    self!.pickerView.delegate = self
                    
                    //check to see if APICALL was successful
                    if (self!.pickerSubjects.count > 0) {
                        let insertStatementString = "INSERT INTO Symptom (Id, Name) VALUES (?, ?)"
                        insertSymptomList(db: db, insertStatementString: insertStatementString, symptomList: self!.pickerSubjects)
                    } else {
                        self!.invalidAlert(title: "Unable to load symptoms", message: "Please make sure you're connected to the internet")
                    }
                }
           }
            
        } else {
            insertTableToArray(db: db, tableName: "Symptom", array: &pickerSubjects)
        }

        sqlite3_close(db)
    }
    
    
    //MARK: - function delcarations
    
    //toolbar for pickerView
    func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(SymptomsViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        symptomPickerTextField.inputAccessoryView = toolBar
   }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - segue prepare function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "diagnosis") {
            let diagnosis = segue.destination as! DiagnosisViewController
            
            diagnosis.age = self.age
            diagnosis.gender = self.gender
            diagnosis.patientSelectedSymptoms = self.patientSelectedSymptoms
            diagnosis.token = self.token
        } else if (segue.identifier == "SymptomToHome") {
            _ = segue.destination as! HomeViewController
        }
    }
    
    func invalidAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}


//MARK: - extensions

extension SymptomsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerSubjects.count
    }
    
    
}

extension SymptomsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerSubjects.count > 0) {
            return pickerSubjects[row].Name
        } else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerSubjects.count > 0) {
            selectedSymptom = pickerSubjects[row]
            symptomPickerTextField.text = pickerSubjects[row].Name
        }
    }
}

extension SymptomsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patientSelectedSymptoms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SymptomCell
        
        cell.selectedSymptom.text = patientSelectedSymptoms[indexPath.row].Name
        
        return cell
    }
    
    
}

extension SymptomsViewController: UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == SymptomCell.EditingStyle.delete {
            patientSelectedSymptoms.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            print(patientSelectedSymptoms.count)
        }
    }
    
}
