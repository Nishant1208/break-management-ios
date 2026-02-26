////
////  QuestionnaireViewController.swift
////  BreakApp
////
////  Created by Nishant Gulani on 26/02/26.
////
//
//

import UIKit

final class QuestionnaireViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var continueButtonBackView: UIView!
    
    
    
    override func viewDidLoad() {
        <#code#>
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true,animated: false)
    }
    
    @IBAction func continueTapped(_ sender: Any) {
    }
    
}
