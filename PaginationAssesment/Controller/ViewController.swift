//
//  ViewController.swift
//  PaginationAssesment
//
//  Created by Avaneesh Kumar on 26/04/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = PostViewModel()
    
    private var computedData: [Int: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: PaginationTableViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: PaginationTableViewCell.cellIdentifier)
        fetchPosts()
    }
    
    func fetchPosts() {
          viewModel.fetchPosts { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let newPosts):
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print("Error fetching posts: \(error)")
                }
            }
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail", let detailVC = segue.destination as? DetailsViewController {
            if let userInfo = sender as? [String: Any] {
                if let selectedPost = userInfo["post"] as? Post {
                    detailVC.post = selectedPost
                }
                if let additionalData = userInfo["additionalData"] {
                    detailVC.computedData = additionalData
                }
            }
        }
    }

    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PaginationTableViewCell.cellIdentifier, for: indexPath) as? PaginationTableViewCell {
            let post = viewModel.posts[indexPath.row]
            cell.postData = post
            //Perform heavy computation task for each cell
            viewModel.computeHeavyTask(for: post, completion:{ [weak self] computedObject in
                self?.computedData[indexPath.row] = computedObject
            })
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = viewModel.posts[indexPath.row]
        let computedOject = computedData[indexPath.row]
        let userInfo: [String: Any] = ["post": selectedPost, "additionalData": computedOject!]
        performSegue(withIdentifier: "showDetail", sender: userInfo)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let secondLastRow = tableView.numberOfRows(inSection: 0) - 2
        if indexPath.row == secondLastRow {
            //fetching more data
            viewModel.currentPage += 1
            fetchPosts()
        }
    }
}

// let controller = DetailsViewController.ViewController(postData: selectedPost, otherData: computedOject)
