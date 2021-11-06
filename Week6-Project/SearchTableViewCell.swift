//
//  SearchTableViewCell.swift
//  Week6-Project
//
//  Created by mac on 2021/11/02.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    static let identifier = "SearchTableViewCell"
    
    @IBOutlet weak var contentImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func prepareForReuse() {
//         super.prepareForReuse()
//         self.contentLabel.text = nil
//         self.titleLabel.text = nil
//
//         self.updateLayout()
//     }
     
//     func updateLayout(){
//         self.setNeedsLayout()
//         self.layoutIfNeeded()
//     }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        self.translatesAutoresizingMaskIntoConstraints = false
        // Configure the view for the selected state
    }
    
}
