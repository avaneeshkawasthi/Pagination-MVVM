//
//  PaginationTableViewCell.swift
//  PaginationAssesment
//
//  Created by Avaneesh Kumar on 27/04/24.
//

import UIKit

class PaginationTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "PaginationTableViewCell"
    
    var postData: Post? {
        didSet {
                indexLabel.text = "\(postData?.id ?? 0)"
                titleLabel.text = postData?.title
                bodyLabel.text = postData?.body
              }
        }
    
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
