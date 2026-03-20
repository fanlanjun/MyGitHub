//
//  MyGitHubApp.swift
//  SearchViewController
//
//  Created by Frank Fan on 2026/3/20.
//

import UIKit
import SnapKit
import Alamofire
import SVProgressHUD

class SearchViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let api = GitHubAPIService.shared
    private var repos: [Repo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "搜索"
        
        searchBar.placeholder = "搜索仓库"
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        tableView.register(RepoCell.self, forCellReuseIdentifier: "RepoCell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.text, !text.isEmpty else { return }
        SVProgressHUD.show()
        api.searchRepos(query: text) { [weak self] result in
            SVProgressHUD.dismiss()
            switch result {
            case .success(let list):
                self?.repos = list
                self?.tableView.reloadData()
            case .failure:
                break
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath) as! RepoCell
        cell.configure(with: repos[indexPath.row])
        return cell
    }
}
