//
//  QuestionnaireViewController.swift
//  BreakApp
//
//  Created by Nishant Gulani on 26/02/26.
//

import UIKit

final class QuestionnaireViewController: UIViewController {
    
    @IBOutlet weak var backButtonView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var continueButtonBackView: UIView!

    private var viewModel: QuestionnaireViewModel
    
    init(viewModel: QuestionnaireViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "QuestionnaireViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var smartphoneQuestionView: QuestionView!
    private var googleMapsQuestionView: QuestionView!
    private var canGetPhoneQuestionView: QuestionView?
    private var collectionViewHeightConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        setupCollection()
        setupQuestions()
        bindViewModel()
        updateContinueState()
    }

    private func setupBackButton() {
        backButtonView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(backTapped))
        backButtonView.addGestureRecognizer(tap)
    }

    @objc private func backTapped() {
        viewModel.onBack?()
    }

    private func setupCollection() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            UINib(nibName: "TasksCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "TasksCollectionViewCell"
        )
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 0)
        collectionViewHeightConstraint?.isActive = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCollectionViewHeight()
    }

    private func updateCollectionViewHeight() {
        collectionView.layoutIfNeeded()
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionViewHeightConstraint?.constant = height
    }

    private func setupQuestions() {
        smartphoneQuestionView = loadQuestionView()
        smartphoneQuestionView.configure(title: "Do you have your own smartphone?")
        smartphoneQuestionView.onSelectionChanged = { [weak self] value in
            self?.viewModel.setHasSmartphone(value)
        }
        stackView.addArrangedSubview(smartphoneQuestionView)

        googleMapsQuestionView = loadQuestionView()
        googleMapsQuestionView.configure(title: "Have you ever used Google Maps?")
        googleMapsQuestionView.onSelectionChanged = { [weak self] value in
            self?.viewModel.setHasUsedGoogleMaps(value)
        }
        stackView.addArrangedSubview(googleMapsQuestionView)
    }

    private func bindViewModel() {
        viewModel.onStateChanged = { [weak self] in
            self?.handleDynamicQuestions()
            self?.updateContinueState()
            self?.collectionView.reloadData()
        }
        viewModel.onError = { [weak self] message in
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }

    private func handleDynamicQuestions() {

        if viewModel.shouldShowCanGetPhone {
            if canGetPhoneQuestionView == nil {
                let view = loadQuestionView()
                view.configure(title: "Will you be able to get a phone for the job?")
                view.onSelectionChanged = { [weak self] value in
                    self?.viewModel.setCanGetPhone(value)
                }
                canGetPhoneQuestionView = view
                stackView.addArrangedSubview(view)
            }
        } else {
            if let view = canGetPhoneQuestionView {
                stackView.removeArrangedSubview(view)
                view.removeFromSuperview()
                canGetPhoneQuestionView = nil
            }
        }
    }

    private func updateContinueState() {
        let enabled = viewModel.isContinueEnabled
        continueButtonBackView.backgroundColor = enabled ? .purple : .systemGray6
        continueButtonBackView.isUserInteractionEnabled = enabled
        if let button = continueButtonBackView.subviews.first(where: { $0 is UIButton }) as? UIButton {
            button.tintColor = enabled ? .white : .systemGray2
        }
    }

    @IBAction func continueTapped(_ sender: Any) {
        viewModel.submit()
    }
    
    private func loadQuestionView() -> QuestionView {
        let nib = UINib(nibName: "QuestionView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).first as! QuestionView
    }
}

extension QuestionnaireViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10
        let width = (collectionView.bounds.width - spacing) / 2
        return CGSize(width: width, height: 44)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return QuestionnaireViewModel.SkillTask.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let task = QuestionnaireViewModel.SkillTask.allCases[indexPath.row]

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "TasksCollectionViewCell",
            for: indexPath
        ) as! TasksCollectionViewCell

        cell.taskLabel.text = task.rawValue

        let selected = viewModel.selectedTasks.contains(task)
        cell.radioImage.image = UIImage(
            named: selected ? "checkbox_selected" : "checkbox_unselected"
        )

        cell.onTap = { [weak self] in
            self?.viewModel.toggleTask(task)
        }

        return cell
    }
}
