//
//  LoginViewController.swift
//  BreakApp
//
//  Created by Nishant Gulani on 26/02/26.
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginButtonBackView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - Properties

    var viewModel: LoginViewModel
    private var isLoading = false
    
    // MARK: - Init

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "LoginViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        errorLabel.isHidden = true
        passwordTextField.isSecureTextEntry = true
        loginButton.layer.cornerRadius = 8
        loginButtonBackView.layer.cornerRadius = 8

        emailTextField.addTarget(self, action: #selector(updateLoginButtonState), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(updateLoginButtonState), for: .editingChanged)
        updateLoginButtonState()
    }

    private var isValidInput: Bool {
        let email = (emailTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let password = (passwordTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        return !email.isEmpty && !password.isEmpty
    }

    @objc private func updateLoginButtonState() {
        let enabled = isValidInput && !isLoading
        loginButton.isEnabled = enabled
        if enabled {
            loginButtonBackView.backgroundColor = .purple
            loginButton.setTitleColor(.white, for: .normal)
        } else {
            loginButtonBackView.backgroundColor = .systemGray4
            loginButton.setTitleColor(.systemGray, for: .disabled)
        }
    }

    private func setupBindings() {

        viewModel.onError = { [weak self] message in
            self?.errorLabel.text = message
            self?.errorLabel.isHidden = false
        }

        viewModel.onLoadingStateChange = { [weak self] isLoading in
            self?.isLoading = isLoading
            self?.updateLoginButtonState()
        }
    }
    
    // MARK: - Actions

    @IBAction func loginTapped(_ sender: Any) {
        errorLabel.isHidden = true

        viewModel.login(
            email: emailTextField.text,
            password: passwordTextField.text
        )
    }
}
