//
//# Author:    Tran Ngoc Thien Kim
//# Email Id:   TRANY057
//# Description:  Big Things, IOS assignment 2
//# This is my own work as defined by the University's Academic Misconduct policy.

import UIKit

class BigThingsListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    private let bigThingsRepository: BigThingsRepositoryType = BigThingsRepository(apiService: .shared)
    private var bigThings: [BigThing] = []
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        setupTableView()
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
    
    @objc private func refreshData() {
        getBigThings()
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
                self.bigThings = bigThings
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

extension BigThingsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bigThings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BigThingTableViewCell", for: indexPath) as? BigThingTableViewCell else {
            return UITableViewCell()
        }
        let bigThing = bigThings[indexPath.row]
        cell.setContent(bigThing: bigThing)
        return cell
    }
}

extension BigThingsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBigThing = bigThings[indexPath.row]
        performSegue(withIdentifier: "toDetailView", sender: bigThings[indexPath.row])
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
