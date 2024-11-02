//
//# Author:    Tran Ngoc Thien Kim
//# Email Id:   TRANY057
//# Description:  Big Things, IOS assignment 2
//# This is my own work as defined by the University's Academic Misconduct policy.

import UIKit

class BigThingsListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    private let bigThingsRepository: BigThingsRepositoryType = BigThingsRepository(apiService: .shared, coreDataService: .shared )
    private var bigThings: [BigThing] = []
    private var filteredBigThings: [BigThing] = []
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let searchController = UISearchController(searchResultsController: nil)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        setupTableView()
        setupSearchController()
        getBigThings()
    }
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "BigThingTableViewCell", bundle: nil), forCellReuseIdentifier: "BigThingTableViewCell")
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Big Things"
        searchController.searchBar.searchTextField.backgroundColor = .main
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    @objc private func refreshData() {
        getBigThings()
    }
    
    private func sortBigThings(_ bigThings: [BigThing]) -> [BigThing] {
        return bigThings.sorted {
            let rating1 = Double($0.rating) ?? 0
            let rating2 = Double($1.rating) ?? 0
            if rating1 != rating2 {
                return rating1 > rating2
            } else {
                return $0.name.lowercased() < $1.name.lowercased()
            }
        }
    }
    
    private func getBigThings() {
        activityIndicator.startAnimating()
        bigThingsRepository.getListBigThing() { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            switch result {
            case .success(let bigThings):
                self.bigThings = self.sortBigThings(bigThings)
                self.filteredBigThings = self.bigThings
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.showAlert(title: "ERROR", message: "No data response")
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
}

extension BigThingsListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            filteredBigThings = bigThings
            tableView.reloadData()
            return
        }
        
        filteredBigThings = bigThings.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        tableView.reloadData()
    }
}

extension BigThingsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBigThings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BigThingTableViewCell", for: indexPath) as? BigThingTableViewCell else {
            return UITableViewCell()
        }
        let bigThing = filteredBigThings[indexPath.row]
        cell.setContent(bigThing: bigThing)
        return cell
    }
}

extension BigThingsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBigThing = filteredBigThings[indexPath.row]
        performSegue(withIdentifier: "toDetailView", sender: selectedBigThing)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView",
           let bigThingDetailViewController = segue.destination as? BigThingDetailViewController,
           let selectedBigThing = sender as? BigThing {
            bigThingDetailViewController.bigThing = selectedBigThing
        }
    }
}
