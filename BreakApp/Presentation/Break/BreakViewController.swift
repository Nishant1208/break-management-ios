//
//  BreakViewController.swift
//  BreakApp
//
//  Created by Nishant Gulani on 26/02/26.
//

import UIKit

final class BreakViewController: UIViewController {

    private let viewModel: BreakViewModel

    // MARK: - Background

    private let backgroundImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "break_bg"))
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    // MARK: - Header

    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.text = "Hi there!"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "You are on break!"
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Scroll view for content

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let contentStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 20
        sv.alignment = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    // MARK: - Active: Timer Card

    private let activeCard: GradientCardView = {
        let view = GradientCardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let cardSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "We value your hard work!\nTake this time to relax"
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = UIColor.white.withAlphaComponent(0.9)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let timerView: CircularTimerView = {
        let view = CircularTimerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Active: Below Card

    private let breakEndsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let endEarlyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("End my break", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor(red: 0.80, green: 0.25, blue: 0.25, alpha: 1)
        button.layer.cornerRadius = 14
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Ended: Card

    private let endedCardImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "break_ended_card"))
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        return iv
    }()

    // MARK: - Progress Stepper

    private let stepperContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let stepperView: ProgressStepperView = {
        let view = ProgressStepperView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Loading

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    // MARK: - Wrapper Views

    private let activeViews = UIView()
    private let endedViews = UIView()

    // MARK: - Init

    init(viewModel: BreakViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.loadBreak()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.10, green: 0.10, blue: 0.25, alpha: 1)
        navigationController?.setNavigationBarHidden(true, animated: false)

        view.addSubview(backgroundImageView)
        view.addSubview(greetingLabel)
        view.addSubview(headerLabel)
        view.addSubview(scrollView)
        view.addSubview(activityIndicator)

        scrollView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            greetingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            greetingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            headerLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 4),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            scrollView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -24),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        setupActiveViews()
        setupEndedViews()
        setupStepper()

        contentStackView.addArrangedSubview(activeViews)
        contentStackView.addArrangedSubview(endedViews)
        contentStackView.addArrangedSubview(stepperContainer)

        activeViews.isHidden = true
        endedViews.isHidden = true
    }

    private func setupActiveViews() {
        activeViews.translatesAutoresizingMaskIntoConstraints = false

        activeCard.addSubview(cardSubtitleLabel)
        activeCard.addSubview(timerView)
        activeViews.addSubview(activeCard)
        activeViews.addSubview(breakEndsLabel)
        activeViews.addSubview(endEarlyButton)

        endEarlyButton.addTarget(self, action: #selector(endEarlyTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            activeCard.topAnchor.constraint(equalTo: activeViews.topAnchor),
            activeCard.leadingAnchor.constraint(equalTo: activeViews.leadingAnchor),
            activeCard.trailingAnchor.constraint(equalTo: activeViews.trailingAnchor),

            cardSubtitleLabel.topAnchor.constraint(equalTo: activeCard.topAnchor, constant: 24),
            cardSubtitleLabel.leadingAnchor.constraint(equalTo: activeCard.leadingAnchor, constant: 20),
            cardSubtitleLabel.trailingAnchor.constraint(equalTo: activeCard.trailingAnchor, constant: -20),

            timerView.topAnchor.constraint(equalTo: cardSubtitleLabel.bottomAnchor, constant: 12),
            timerView.centerXAnchor.constraint(equalTo: activeCard.centerXAnchor),
            timerView.widthAnchor.constraint(equalToConstant: 220),
            timerView.heightAnchor.constraint(equalToConstant: 220),
            timerView.bottomAnchor.constraint(equalTo: activeCard.bottomAnchor, constant: -20),

            breakEndsLabel.topAnchor.constraint(equalTo: activeCard.bottomAnchor, constant: 16),
            breakEndsLabel.centerXAnchor.constraint(equalTo: activeViews.centerXAnchor),

            endEarlyButton.topAnchor.constraint(equalTo: breakEndsLabel.bottomAnchor, constant: 16),
            endEarlyButton.leadingAnchor.constraint(equalTo: activeViews.leadingAnchor),
            endEarlyButton.trailingAnchor.constraint(equalTo: activeViews.trailingAnchor),
            endEarlyButton.heightAnchor.constraint(equalToConstant: 52),
            endEarlyButton.bottomAnchor.constraint(equalTo: activeViews.bottomAnchor),
        ])
    }

    private func setupEndedViews() {
        endedViews.translatesAutoresizingMaskIntoConstraints = false
        endedViews.addSubview(endedCardImageView)

        NSLayoutConstraint.activate([
            endedCardImageView.topAnchor.constraint(equalTo: endedViews.topAnchor),
            endedCardImageView.leadingAnchor.constraint(equalTo: endedViews.leadingAnchor),
            endedCardImageView.trailingAnchor.constraint(equalTo: endedViews.trailingAnchor),
            endedCardImageView.bottomAnchor.constraint(equalTo: endedViews.bottomAnchor),
        ])
    }

    private func setupStepper() {
        stepperContainer.addSubview(stepperView)

        NSLayoutConstraint.activate([
            stepperView.topAnchor.constraint(equalTo: stepperContainer.topAnchor, constant: 20),
            stepperView.leadingAnchor.constraint(equalTo: stepperContainer.leadingAnchor, constant: 20),
            stepperView.trailingAnchor.constraint(equalTo: stepperContainer.trailingAnchor, constant: -20),
            stepperView.bottomAnchor.constraint(equalTo: stepperContainer.bottomAnchor, constant: -20),
        ])

        stepperView.onLogoutTapped = { [weak self] in
            self?.handleLogout()
        }
    }

    // MARK: - Binding

    private func bindViewModel() {
        viewModel.onStateChanged = { [weak self] in
            self?.updateUI()
        }
    }

    private func updateUI() {
        switch viewModel.state {
        case .loading:
            activityIndicator.startAnimating()
            activeViews.isHidden = true
            endedViews.isHidden = true
            stepperContainer.isHidden = true

        case .active:
            activityIndicator.stopAnimating()
            activeViews.isHidden = false
            endedViews.isHidden = true
            stepperContainer.isHidden = false
            timerView.setTime(viewModel.formattedTime)
            timerView.setProgress(viewModel.progress)
            breakEndsLabel.text = viewModel.formattedEndTime
            updateStepper(breakEnded: false)

        case .ended:
            activityIndicator.stopAnimating()
            activeViews.isHidden = true
            endedViews.isHidden = false
            stepperContainer.isHidden = false
            updateStepper(breakEnded: true)

        case .noBreak:
            activityIndicator.stopAnimating()
            activeViews.isHidden = true
            endedViews.isHidden = false
            stepperContainer.isHidden = false
            updateStepper(breakEnded: true)

        case .error(let message):
            activityIndicator.stopAnimating()
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
                self?.viewModel.loadBreak()
            })
            present(alert, animated: true)
        }
    }

    private func updateStepper(breakEnded: Bool) {
        let steps: [ProgressStepperView.Step] = [
            .init(title: "Login", state: .completed),
            .init(title: "Lunch in Progress", state: breakEnded ? .completed : .inProgress),
            .init(title: "Logout", state: .pending),
        ]
        stepperView.configure(steps: steps)
    }

    // MARK: - Actions

    @objc private func endEarlyTapped() {
        let alert = UIAlertController(
            title: "Ending break early?",
            message: "Are you sure you want to end your break now? Take this time to recharge before your next task.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Continue", style: .cancel))
        alert.addAction(UIAlertAction(title: "End now", style: .destructive) { [weak self] _ in
            self?.viewModel.endBreakEarly()
        })
        present(alert, animated: true)
    }

    private func handleLogout() {
        let alert = UIAlertController(
            title: "Logout",
            message: "Are you sure you want to logout?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
            self?.viewModel.onLogout?()
        })
        present(alert, animated: true)
    }
}
