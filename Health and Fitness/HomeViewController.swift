//
//  ViewController.swift
//  Health and Fitness
//
//  Created by Thao Phan on 6/28/20.
//  Copyright © 2020 Thao Phan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var gender = ""
    var patientAge = Int()
    
    @IBOutlet weak var maleButton: UIButton!
    @IBAction func male(_ sender: Any) {
        gender = "male"
        maleButton.backgroundColor = UIColor.green
    }
    
    @IBOutlet weak var femaleButton: UIButton!
    @IBAction func female(_ sender: Any) {
        gender = "female"
        femaleButton.backgroundColor = UIColor.green
    }
    
    @IBAction func next(_ sender: Any) {
        guard let ageText: String = age.text else {
            return
        }
        
        guard let patientAge = Int(ageText) else {
            invalidAlert(title: "Invalid Age", message: "Please enter a valid age")
            return
        }
        
        if (patientAge <= 115 && patientAge > 0 && gender != "") {
            performSegue(withIdentifier: "s", sender: self)
        } else if (patientAge > 115 && gender == ""){
            invalidAlert(title: "Invalid Age and Gender", message: "Please enter a valid age and select a gender")
        } else if (patientAge > 115 && gender != "") {
            invalidAlert(title: "Invalid Age", message: "Please enter a valid age")
        } else if (patientAge <= 115 && patientAge > 0 && gender == "") {
            invalidAlert(title: "Invalid gender", message: "Please choose a gender")
        }
        
    }
    
    @IBOutlet weak var age: UITextField!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sp = segue.destination as! SymptomsViewController
        
        sp.age = Int(self.age.text!)!
        sp.gender = self.gender
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createToolBar()
        
        
    }
    
    func createToolBar() {
         let toolBar = UIToolbar()
         toolBar.sizeToFit()
         
         let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(HomeViewController.dismissKeyboard))
         
         toolBar.setItems([doneButton], animated: false)
         toolBar.isUserInteractionEnabled = true
         
         age.inputAccessoryView = toolBar
    }
     
     @objc func dismissKeyboard() {
         view.endEditing(true)
     }
    
    func invalidAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }

}

