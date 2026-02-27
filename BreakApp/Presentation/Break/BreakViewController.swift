import UIKit

final class BreakViewController: UIViewController {

    private let viewModel: BreakViewModel

    // MARK: - Common Header

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

    // MARK: - Active State

    private let activeContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let activeCard: GradientCardView = {
        let view = GradientCardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let cardSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "We value your hard work!\nTake this time to relax"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.white.withAlphaComponent(0.85)
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
        button.backgroundColor = UIColor(red: 0.85, green: 0.22, blue: 0.22, alpha: 1)
        button.layer.cornerRadius = 14
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Ended State

    private let endedContainerView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let endedCard: GradientCardView = {
        let view = GradientCardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let checkmarkView: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: 70, weight: .medium)
        let image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: config)
        let iv = UIImageView(image: image)
        iv.tintColor = UIColor(red: 0.2, green: 0.75, blue: 0.45, alpha: 1)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let endedMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Hope you are feeling refreshed and\nready to start working again"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.white.withAlphaComponent(0.85)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Loading

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

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

        view.addSubview(greetingLabel)
        view.addSubview(headerLabel)
        view.addSubview(activeContainerView)
        view.addSubview(endedContainerView)
        view.addSubview(activityIndicator)

        setupActiveState()
        setupEndedState()

        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            greetingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            headerLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 4),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            activeContainerView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
            activeContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activeContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activeContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            endedContainerView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
            endedContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            endedContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            endedContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    private func setupActiveState() {
        activeContainerView.addSubview(activeCard)
        activeCard.addSubview(cardSubtitleLabel)
        activeCard.addSubview(timerView)
        activeContainerView.addSubview(breakEndsLabel)
        activeContainerView.addSubview(endEarlyButton)

        endEarlyButton.addTarget(self, action: #selector(endEarlyTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            activeCard.topAnchor.constraint(equalTo: activeContainerView.topAnchor),
            activeCard.leadingAnchor.constraint(equalTo: activeContainerView.leadingAnchor, constant: 20),
            activeCard.trailingAnchor.constraint(equalTo: activeContainerView.trailingAnchor, constant: -20),

            cardSubtitleLabel.topAnchor.constraint(equalTo: activeCard.topAnchor, constant: 24),
            cardSubtitleLabel.leadingAnchor.constraint(equalTo: activeCard.leadingAnchor, constant: 20),
            cardSubtitleLabel.trailingAnchor.constraint(equalTo: activeCard.trailingAnchor, constant: -20),

            timerView.topAnchor.constraint(equalTo: cardSubtitleLabel.bottomAnchor, constant: 16),
            timerView.centerXAnchor.constraint(equalTo: activeCard.centerXAnchor),
            timerView.widthAnchor.constraint(equalToConstant: 220),
            timerView.heightAnchor.constraint(equalToConstant: 220),
            timerView.bottomAnchor.constraint(equalTo: activeCard.bottomAnchor, constant: -24),

            breakEndsLabel.topAnchor.constraint(equalTo: activeCard.bottomAnchor, constant: 20),
            breakEndsLabel.centerXAnchor.constraint(equalTo: activeContainerView.centerXAnchor),

            endEarlyButton.leadingAnchor.constraint(equalTo: activeContainerView.leadingAnchor, constant: 24),
            endEarlyButton.trailingAnchor.constraint(equalTo: activeContainerView.trailingAnchor, constant: -24),
            endEarlyButton.bottomAnchor.constraint(equalTo: activeContainerView.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            endEarlyButton.heightAnchor.constraint(equalToConstant: 52),
        ])
    }

    private func setupEndedState() {
        endedContainerView.addSubview(endedCard)
        endedCard.addSubview(checkmarkView)
        endedCard.addSubview(endedMessageLabel)

        NSLayoutConstraint.activate([
            endedCard.topAnchor.constraint(equalTo: endedContainerView.topAnchor),
            endedCard.leadingAnchor.constraint(equalTo: endedContainerView.leadingAnchor, constant: 20),
            endedCard.trailingAnchor.constraint(equalTo: endedContainerView.trailingAnchor, constant: -20),

            checkmarkView.topAnchor.constraint(equalTo: endedCard.topAnchor, constant: 48),
            checkmarkView.centerXAnchor.constraint(equalTo: endedCard.centerXAnchor),
            checkmarkView.widthAnchor.constraint(equalToConstant: 90),
            checkmarkView.heightAnchor.constraint(equalToConstant: 90),

            endedMessageLabel.topAnchor.constraint(equalTo: checkmarkView.bottomAnchor, constant: 20),
            endedMessageLabel.leadingAnchor.constraint(equalTo: endedCard.leadingAnchor, constant: 20),
            endedMessageLabel.trailingAnchor.constraint(equalTo: endedCard.trailingAnchor, constant: -20),
            endedMessageLabel.bottomAnchor.constraint(equalTo: endedCard.bottomAnchor, constant: -48),
        ])
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
            activeContainerView.isHidden = true
            endedContainerView.isHidden = true

        case .active:
            activityIndicator.stopAnimating()
            activeContainerView.isHidden = false
            endedContainerView.isHidden = true
            timerView.setTime(viewModel.formattedTime)
            timerView.setProgress(viewModel.progress)
            breakEndsLabel.text = viewModel.formattedEndTime

        case .ended:
            activityIndicator.stopAnimating()
            activeContainerView.isHidden = true
            endedContainerView.isHidden = false

        case .noBreak:
            activityIndicator.stopAnimating()
            activeContainerView.isHidden = true
            endedContainerView.isHidden = false
            endedMessageLabel.text = "There is no break scheduled\nfor you right now."

        case .error(let message):
            activityIndicator.stopAnimating()
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
                self?.viewModel.loadBreak()
            })
            present(alert, animated: true)
        }
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
}
