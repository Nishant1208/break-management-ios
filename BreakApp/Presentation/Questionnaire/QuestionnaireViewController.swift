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

    private var viewModel = QuestionnaireViewModel()
    
    init(viewModel: QuestionnaireViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "QuestionnaireViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var smartphoneQuestionView: QuestionView!
    private var canGetPhoneQuestionView: QuestionView?
    private var collectionViewHeightConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        setupQuestions()
        bindViewModel()
        updateContinueState()
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
    }

    private func bindViewModel() {
        viewModel.onStateChanged = { [weak self] in
            self?.handleDynamicQuestions()
            self?.updateContinueState()
            self?.collectionView.reloadData()
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
        continueButtonBackView.backgroundColor = viewModel.isContinueEnabled ? UIColor.purple : UIColor.systemGray6
        continueButtonBackView.isUserInteractionEnabled = viewModel.isContinueEnabled
    }

    @IBAction func continueTapped(_ sender: Any) {
        viewModel.onSubmitSuccess?()
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
        return QuestionnaireViewModel.Task.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let task = QuestionnaireViewModel.Task.allCases[indexPath.row]

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
