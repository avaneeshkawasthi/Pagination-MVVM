//
//  DetailsViewController.swift
//  PaginationAssesment
//
//  Created by Avaneesh Kumar on 27/04/24.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    var post: Post?
    var computedData: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        guard let post = post else { return }
        titleLabel.text = "Post ID: \(post.id)"
        bodyLabel.text = post.body
    }

}
