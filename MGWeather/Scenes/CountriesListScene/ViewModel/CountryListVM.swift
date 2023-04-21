//
//  CountryListVM.swift
//  MGWeather
//
//  Created by Michael Ghevondyan on 19.04.23.
//

import Foundation
import RealmSwift

class CountryListVM: BaseVM {
    
    // MARK: - Private properties
    
    private var countriesListRepo: CountriesListRepo = CountriesListRepo()
    private var countryList: [CountryModel]?
    
    // MARK: - Public properties
    
    var filteredCountryList: [CountryModel]?
    
    // MARK: - Functions
    
    func getCountriesCount() -> Int {
        self.filteredCountryList = self.countryList
        guard let count = filteredCountryList?.count else { return 0}
        return count
    }
    
    func getCountryByIndex(_ indexPath: IndexPath) -> CountryModel {
        guard let country = filteredCountryList?[indexPath.row] else { return CountryModel(country: "", cities: [])}
        return country
    }
    
    func getCountriesList() -> [CountryModel] {
        return countryList ?? []
    }
    
    func uploadToRealm() {
        countryList?.forEach({ modelCountry in
            do {
                let realm = try Realm()
                let model = CountryModelRealm()
                model.country = modelCountry.country
                for (_, element) in modelCountry.cities.enumerated() {
                    model.cities.append(element)
                }
                try realm.write {
                    realm.add(model)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
    }
    
    func getRealmData() {
        do {
            let realm = try Realm()
            let countries = realm.objects(CountryModelRealm.self)
            self.countryList?.removeAll()
            if(!countries.isEmpty) {
                var data: [CountryModel] = []
                for country in countries {
                    let countryModel = CountryModel(country: country.country, cities: getCitiesRealm(model: country))
                    data.append(countryModel)
                }
                self.countryList = data
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getCountries() {
        ActivityIndicatorView.shared.startAnimating()
        if self.checkInternet() {
            countriesListRepo.getCountriesList() { [weak self] countryListData, error in
                guard let self = self else { return }
                if error == nil {
                    guard let result = countryListData else { return }
                    self.countryList = result.countryData
                    self.filteredCountryList = self.countryList
                    self.baseDelegate?.dataFetched(type: CountryResponseModel.self, data: result, observerName: "")
                } else if let error = error {
                    if let safeErrors = error.errors {
                        self.baseDelegate?.invalidDataErrorReceived(fieldType: WeatherRequestParams.self, data: safeErrors)
                    } else {
                        self.baseDelegate?.errorReceived(error: error)
                    }
                }
            }
        } else {
            self.getRealmData()
            self.baseDelegate?.invalidDataErrorReceived(fieldType: CountryResponseModel.self, data: [:])
        }
    }
    
    // MARK: - Private func
    
    private func getCitiesRealm(model: CountryModelRealm) -> [String] {
        var cities: [String] = []
        model.cities.forEach { name in
            cities.append(name)
        }
        return cities
    }
}
