//
//  DiagnosisCell.swift
//  Health and Fitness
//
//  Created by Thao Phan on 7/31/20.
//  Copyright © 2020 Thao Phan. All rights reserved.
//

import UIKit

class DiagnosisCell: UITableViewCell {
    
    var illness = UILabel()
    var accuracy = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        setupIllnessLabel()
        setupAccuracyLabel()
    }
    
    func setupIllnessLabel() {
        addSubview(illness)
        illness.numberOfLines = 0
        
        illness.translatesAutoresizingMaskIntoConstraints = false
        illness.topAnchor.constraint(equalTo: topAnchor).isActive = true
        illness.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        illness.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        illness.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func setupAccuracyLabel() {
        addSubview(accuracy)
        accuracy.numberOfLines = 0
        
        accuracy.translatesAutoresizingMaskIntoConstraints = false
        accuracy.topAnchor.constraint(equalTo: illness.bottomAnchor, constant: 5).isActive = true
        accuracy.trailingAnchor.constraint(equalTo: illness.trailingAnchor).isActive = true
        accuracy.leadingAnchor.constraint(equalTo: illness.leadingAnchor).isActive = true
        accuracy.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        accuracy.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
}
