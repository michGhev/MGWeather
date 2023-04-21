//
//  CountryCell.swift
//  MGWeather
//
//  Created by Michael Ghevondyan on 19.04.23.
//

import UIKit

class CountryCell: UITableViewCell {

    @IBOutlet weak var countryNameLabel: UILabel!
    
    func setCell(countryName: String) {
        self.countryNameLabel.text = countryName
    }
}
