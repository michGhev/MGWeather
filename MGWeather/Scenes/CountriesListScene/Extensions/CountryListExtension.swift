//
//  CountryListExtension.swift
//  MGWeather
//
//  Created by Michael Ghevondyan on 19.04.23.
//

import UIKit

extension CountriesListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.getCountriesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell",
                                                 for: indexPath) as! CountryCell
        let countryModel = self.vm.getCountryByIndex(indexPath)
        cell.setCell(countryName: countryModel.country)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true)
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CitiesListVC") as? CitiesListVC
        vc?.vm.setCitiesList(list: self.vm.getCountryByIndex(indexPath).cities)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension CountriesListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.vm.filteredCountryList = searchText.isEmpty ? self.vm.getCountriesList() : self.vm.getCountriesList().filter({(dataString: CountryModel) -> Bool in
            return dataString.country.range(of: searchText, options: .caseInsensitive) != nil
        })
        tableView.reloadData()
    }
}
