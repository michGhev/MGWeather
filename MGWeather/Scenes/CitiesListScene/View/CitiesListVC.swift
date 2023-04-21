//
//  CitiesListVC.swift
//  MGWeather
//
//  Created by Michael Ghevondyan on 19.04.23.
//

import UIKit

class CitiesListVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - properties
    
    let vm: CitiesListVM = CitiesListVM()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initNavigationBar()
        self.initTableView()
    }
    
    // MARK: - Initialization
    
    func initNavigationBar() {
        self.title = "Cities List"
    }
    
    func initTableView() {
        tableView.keyboardDismissMode = .onDrag
    }
}
