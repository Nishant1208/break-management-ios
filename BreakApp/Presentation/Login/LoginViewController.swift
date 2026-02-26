//
//  LoginViewController.swift
//  BreakApp
//
//  Created by Nishant Gulani on 26/02/26.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    
    var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "LoginViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
