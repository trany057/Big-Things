//
//# Author:    Tran Ngoc Thien Kim
//# Email Id:   TRANY057
//# Description:  Big Things, IOS assignment 2
//# This is my own work as defined by the University's Academic Misconduct policy.

import UIKit

class BigThingsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    private let bigThingsRepository: BigThingsRepositoryType = BigThingsRepository(apiService: .shared, coreDataService: .shared)
    
    private var bigThings: [BigThing] = []
    private var knownBigThings: [BigThing] = []
    private var unknownBigThings: [BigThing] = []
    private var filteredKnownBigThings: [BigThing] = []
    private var filteredUnknownBigThings: [BigThing] = []
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let searchController = UISearchController(searchResultsController: nil)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        setupTableView()
        setupSearchController()
        getBigThings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
                self.filterBigThings()
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
    
    private func filterBigThings() {
        knownBigThings.removeAll()
        unknownBigThings.removeAll()
        
        let dispatchGroup = DispatchGroup()
        
        for bigThing in bigThings {
            dispatchGroup.enter()
            bigThingsRepository.getSavedBigThing(byId: bigThing.id) { [weak self] result in
                defer { dispatchGroup.leave() }
                guard let self = self else { return }
                switch result {
                case .success(let isSaved):
                    if isSaved {
                        self.knownBigThings.append(bigThing)
                    } else {
                        self.unknownBigThings.append(bigThing)
                    }
                case .failure(_):
                    break
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.filteredKnownBigThings = self.knownBigThings
            self.filteredUnknownBigThings = self.unknownBigThings
            self.tableView.reloadData()
        }
    }
}

extension BigThingsListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            filteredKnownBigThings = knownBigThings
            filteredUnknownBigThings = unknownBigThings
            tableView.reloadData()
            return
        }
        
        filteredKnownBigThings = knownBigThings.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        filteredUnknownBigThings = unknownBigThings.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        tableView.reloadData()
    }
}

extension BigThingsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return section == 0 ? filteredKnownBigThings.count : filteredUnknownBigThings.count
        } else {
            return section == 0 ? knownBigThings.count : unknownBigThings.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BigThingTableViewCell", for: indexPath) as? BigThingTableViewCell else {
            return UITableViewCell()
        }
        
        let bigThing: BigThing
        if searchController.isActive {
            bigThing = indexPath.section == 0 ? filteredKnownBigThings[indexPath.row] : filteredUnknownBigThings[indexPath.row]
        } else {
            bigThing = indexPath.section == 0 ? knownBigThings[indexPath.row] : unknownBigThings[indexPath.row]
        }
        
        cell.setContent(bigThing: bigThing)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let rowCount = self.tableView(tableView, numberOfRowsInSection: section)
        if rowCount == 0 {
            return nil
        }
        
        let headerView = BigThingHeaderView()
        let title = section == 0 ? "Known" : "Unknown"
        headerView.configure(with: title)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let rowCount = self.tableView(tableView, numberOfRowsInSection: section)
        return rowCount == 0 ? 0 : 40
    }
}

extension BigThingsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBigThing = indexPath.section == 0 ? (searchController.isActive ? filteredKnownBigThings[indexPath.row] : knownBigThings[indexPath.row]) : (searchController.isActive ? filteredUnknownBigThings[indexPath.row] : unknownBigThings[indexPath.row])
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
