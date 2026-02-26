//
//  QuestionView.swift
//  BreakApp
//
//  Created by Nishant Gulani on 26/02/26.
//

import UIKit

class QuestionView: UIView {

    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var yesRadioImage: UIImageView!
    @IBOutlet weak var noRadioImage: UIImageView!
    
    var onSelectionChanged: ((Bool) -> Void)?

    private var selectedValue: Bool?

    func configure(title: String) {
        questionTitle.text = title
        updateUI()
    }
    
    private func updateUI() {
        yesRadioImage.image = UIImage(named: selectedValue == true ? "radio_selected" : "radio_unselected")
        noRadioImage.image = UIImage(named: selectedValue == false ? "radio_selected" : "radio_unselected")
    }
    
    @IBAction func yesButtonTapped(_ sender: Any) {
        selectedValue = true
        updateUI()
        onSelectionChanged?(true)
    }
    
    @IBAction func noButtonTapped(_ sender: Any) {
        selectedValue = false
        updateUI()
        onSelectionChanged?(false)
    }
}
