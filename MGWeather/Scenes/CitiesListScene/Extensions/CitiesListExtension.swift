//
//  CitiesListExtension.swift
//  MGWeather
//
//  Created by Michael Ghevondyan on 19.04.23.
//

import UIKit

extension CitiesListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.getCitiesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell",
                                                 for: indexPath) as! CountryCell
        let city = self.vm.getCityByIndex(indexPath)
        cell.setCell(countryName: city)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        BaseUrl.shared.baseUrl = .baseWeatherUrl
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "WeatherVC") as? WeatherVC
        let city = self.vm.getCityByIndex(indexPath)
        vc?.vm.setCity(city)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension CitiesListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.vm.filteredCitiesList = searchText.isEmpty ? self.vm.getCitiesList() : self.vm.getCitiesList().filter({(dataString: String) -> Bool in
            return dataString.range(of: searchText, options: .caseInsensitive) != nil
        })
        tableView.reloadData()
    }
}
