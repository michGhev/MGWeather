//
//  CountriesListVC.swift
//  MGWeather
//
//  Created by Michael Ghevondyan on 19.04.23.
//

import UIKit

class CountriesListVC: BaseVC {

    // MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - properties

    let vm: CountryListVM = CountryListVM()
    
    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        self.vm.getCountries()
        self.initTableView()
        self.initNavigationBar()
    }
    
    // MARK: - Initialization

    func initNavigationBar() {
        self.title = "Countries List"
    }
    
    func initTableView() {
        tableView.keyboardDismissMode = .onDrag
    }
    
    //MARK: - Override Functions

    override func dataFetched<T>(type: T.Type, data: T, observerName: String) {
        ActivityIndicatorView.shared.stopAnimating()
        self.tableView.reloadData()
        self.vm.uploadToRealm()
    }
}
