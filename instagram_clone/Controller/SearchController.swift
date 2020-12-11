//
//  SearchController.swift
//  instagram_clone
//
//  Created by Projects on 11/13/20.
//

import UIKit

private let reuseIdentifier = "UserCell"

class SearchController: UITableViewController {
    
// MARK: - Properties
    
    private var users = [User]()
    private var filteredUsers = [User]()
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
// MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchUsers()
        configureSearchController()
        
    }
    
// MARK: - API
    
    func fetchUsers() {
        UserService.fetchUsers { (users) in
            self.users = users
            
            // Because calling API takes time, tableView is empty in the beginning.
            // After fetchUsers(), reload/rerun the TableView Datasource
            self.tableView.reloadData()
        }
    }
    
// MARK: - Helpers
    
    func configureTableView() {
        view.backgroundColor = .white
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 64
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self    // protocol
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}


// MARK: - TableView Datasource
extension SearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        cell.backgroundColor = .white
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.viewModel = UserCellViewModel(user: user)
        return cell
    }
    
}
// MARK: - UITabelViewDelegate

extension SearchController {
    // Did select user
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // When selecting a user row, presents the selected user's profile page
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        
        navigationController?.pushViewController(ProfileController(user: user), animated: true)
    }
}

// MARK: - UISearchResultUpdating

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // Update everytime value is entered into the search bar (This function is a Listener)
        
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        filteredUsers = users.filter({
            $0.username.lowercased().contains(searchText) || $0.fullname.lowercased().contains(searchText)
            
        })
        
        self.tableView.reloadData()
    }
}
