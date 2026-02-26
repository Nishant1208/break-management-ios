//
//  TasksCollectionViewCell.swift
//  BreakApp
//
//  Created by Nishant Gulani on 26/02/26.
//

import UIKit

class TasksCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var radioImage: UIImageView!
    @IBOutlet weak var taskLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func clickedOnTask(_ sender: Any) {
    }
}
