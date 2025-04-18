//
//  ViewController.swift
//  卓建佑_果思作業
//
//  Created by Ray Septian Togi on 2025/4/17.
//

import UIKit

class ViewController: UIViewController {
    let tableView = UITableView()
    let searchController = UISearchController()
    var repositories: [Repository] = []
    var query: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Repository Search"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.backButtonTitle = "Back"

        setupSearchController()
        setupTableView()
        setupPullToRefresh()
    }

    /// Setup search controller settings
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.automaticallyShowsCancelButton = false
        searchController.searchBar.placeholder = "請輸入關鍵字搜尋"
        searchController.searchBar.delegate = self

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    /// Setup table view for search results
    func setupTableView() {
        tableView.frame = view.bounds
        tableView.register(RepositoryCell.self, forCellReuseIdentifier: "RepoCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInsetAdjustmentBehavior = .automatic
        view.addSubview(tableView)
    }

    /// This functions enables refreshing by pulling up
    func setupPullToRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTriggered), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    /// Checks for query
    @objc func refreshTriggered() {
        guard !query.isEmpty else {
            showAlert(message: "The data couldn't be read because it is missing.")
            tableView.refreshControl?.endRefreshing()
            return
        }
        searchGitHub(query: query)
    }
    
    /// Search github for repositories
    func searchGitHub(query: String) {
        guard !query.isEmpty else {
            return
        }
        /// encode query into url-string format
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: "https://api.github.com/search/repositories?q=\(encoded)") else {
            return
        }

        // Shared singleton
        URLSession.shared.dataTask(with: url) { data, response, error in
            // end refresh as we have a query
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
            }

            guard let data = data else {
                return
            }

            do {
                // decode from custom structure
                let decoded = try JSONDecoder().decode(GitHubSearchResponse.self, from: data)
                DispatchQueue.main.async {
                    self.repositories = decoded.items
                    self.tableView.reloadData()
                }
            } catch {
                print("Decode error: \(error)")
            }
        }.resume()
    }

    /// Show alert when there are no query
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Table View

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let repo = repositories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath) as! RepositoryCell
        cell.configure(with: repo)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let repo = repositories[indexPath.row]
        
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailVC.repository = repo
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Fit 6 cells into the frame
        return view.frame.height / 6
    }
}

// MARK: - Search Bar

extension ViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmpty {
            query = text
            searchGitHub(query: text)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            query = ""
            repositories = []
            tableView.reloadData()
        }
    }
}
