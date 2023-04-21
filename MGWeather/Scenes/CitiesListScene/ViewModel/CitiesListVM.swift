//
//  CitiesListVM.swift
//  MGWeather
//
//  Created by Michael Ghevondyan on 19.04.23.
//

import Foundation

class CitiesListVM: BaseVM {
    
    // MARK: - Private properties
    
    private var citiesList: [String]?
    
    // MARK: - Public properties
    
    var filteredCitiesList: [String]?
    
    // MARK: - Functions
    
    func getCitiesCount() -> Int {
        guard let count = filteredCitiesList?.count else { return 0}
        return count
    }
    
    func getCityByIndex(_ indexPath: IndexPath) -> String {
        guard let city = filteredCitiesList?[indexPath.row] else { return ""}
        return city
    }
    
    func getCitiesList() -> [String] {
        return citiesList ?? []
    }
    
    func setCitiesList(list: [String]) {
        self.citiesList = list
        self.filteredCitiesList = citiesList
    }
}
