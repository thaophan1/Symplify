//
//  APIFuncions.swift
//  Health and Fitness
//
//  Created by Thao Phan on 7/17/20.
//  Copyright © 2020 Thao Phan. All rights reserved.
//

import Foundation

//returning an array of JSON objects
func callAPI<T: Codable> (GETCall: String, token: String, format: String, language: String, completionHandler: @escaping ([T]) -> Void) {
    let resourceURL = "https://healthservice.priaid.ch/\(GETCall)token=\(token)&format=\(format)&language=\(language)"
    
    guard let url = URL(string: resourceURL) else {return}
    
    let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
        
        if (error == nil && data != nil) {
            let decoder = JSONDecoder()
            
            do {
                let symptomsList = try decoder.decode([T].self, from: data!)
                completionHandler(symptomsList)
            } catch {
                print(error)
            }
        } else if (error != nil || response.hashValue == 400) {
            completionHandler([])
        }
    }
    
    dataTask.resume()
}

//returning one JSON object (for diagnosis use)
func callAPI2<T: Codable> (GETCall: String, token: String, format: String, language: String, completionHandler: @escaping (T) -> Void) {
    let resourceURL = "https://healthservice.priaid.ch/\(GETCall)token=\(token)&format=\(format)&language=\(language)"
    
    guard let url = URL(string: resourceURL) else {return}
    
    let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
        
        if (error == nil && data != nil) {
            let decoder = JSONDecoder()
            
            do {
                let symptomsList = try decoder.decode(T.self, from: data!)
                completionHandler(symptomsList)
            } catch {
                print(error)
            }
        }
    }
    
    dataTask.resume()
}
