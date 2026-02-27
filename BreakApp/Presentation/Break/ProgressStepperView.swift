//
//  ProgressStepperView.swift
//  BreakApp
//
//  Created by Nishant Gulani on 26/02/26.
//

import UIKit

final class ProgressStepperView: UIView {

    enum StepState {
        case completed, inProgress, pending
    }

    struct Step {
        let title: String
        let state: StepState
    }

    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 0
        sv.alignment = .leading
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(steps: [Step]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for (index, step) in steps.enumerated() {
            let isLast = index == steps.count - 1
            let row = makeStepRow(step: step, showLine: !isLast)
            stackView.addArrangedSubview(row)
        }
    }

    private func makeStepRow(step: Step, showLine: Bool) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let indicator = makeIndicator(state: step.state)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(indicator)

        let label = UILabel()
        label.text = step.title
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkText
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)

        var constraints = [
            indicator.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            indicator.topAnchor.constraint(equalTo: container.topAnchor),
            indicator.widthAnchor.constraint(equalToConstant: 28),
            indicator.heightAnchor.constraint(equalToConstant: 28),

            label.leadingAnchor.constraint(equalTo: indicator.trailingAnchor, constant: 12),
            label.centerYAnchor.constraint(equalTo: indicator.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
        ]

        if showLine {
            let line = UIView()
            line.backgroundColor = UIColor.systemGray4
            line.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(line)

            constraints.append(contentsOf: [
                line.topAnchor.constraint(equalTo: indicator.bottomAnchor, constant: 2),
                line.centerXAnchor.constraint(equalTo: indicator.centerXAnchor),
                line.widthAnchor.constraint(equalToConstant: 2),
                line.heightAnchor.constraint(equalToConstant: 20),
                container.bottomAnchor.constraint(equalTo: line.bottomAnchor, constant: 2),
            ])
        } else {
            constraints.append(
                container.bottomAnchor.constraint(equalTo: indicator.bottomAnchor)
            )
        }

        NSLayoutConstraint.activate(constraints)
        return container
    }

    private func makeIndicator(state: StepState) -> UIView {
        let outer = UIView()
        outer.layer.cornerRadius = 14

        switch state {
        case .completed:
            outer.backgroundColor = UIColor(red: 0.2, green: 0.75, blue: 0.45, alpha: 1)
            let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)
            let iv = UIImageView(image: UIImage(systemName: "checkmark", withConfiguration: config))
            iv.tintColor = .white
            iv.translatesAutoresizingMaskIntoConstraints = false
            outer.addSubview(iv)
            NSLayoutConstraint.activate([
                iv.centerXAnchor.constraint(equalTo: outer.centerXAnchor),
                iv.centerYAnchor.constraint(equalTo: outer.centerYAnchor),
            ])

        case .inProgress:
            outer.backgroundColor = UIColor(red: 1.0, green: 0.65, blue: 0.0, alpha: 1)

        case .pending:
            outer.backgroundColor = .clear
            outer.layer.borderWidth = 2
            outer.layer.borderColor = UIColor.systemGray3.cgColor
        }

        return outer
    }
}
