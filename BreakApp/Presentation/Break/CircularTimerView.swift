//
//  CircularTimerView.swift
//  BreakApp
//
//  Created by Nishant Gulani on 26/02/26.
//

import UIKit

final class CircularTimerView: UIView {

    private let trackLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let timeLabel = UILabel()
    private let breakLabel = UILabel()

    var trackColor: UIColor = UIColor.white.withAlphaComponent(0.25) {
        didSet { trackLayer.strokeColor = trackColor.cgColor }
    }

    var progressColor: UIColor = .white {
        didSet { progressLayer.strokeColor = progressColor.cgColor }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - 16
        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -.pi / 2,
            endAngle: 3 * .pi / 2,
            clockwise: true
        )
        trackLayer.path = path.cgPath
        progressLayer.path = path.cgPath

        timeLabel.sizeToFit()
        timeLabel.center = CGPoint(x: bounds.midX, y: bounds.midY - 10)

        breakLabel.sizeToFit()
        breakLabel.center = CGPoint(x: bounds.midX, y: timeLabel.frame.maxY + 16)
    }

    func setProgress(_ progress: CGFloat, animated: Bool = false) {
        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = progressLayer.strokeEnd
            animation.toValue = progress
            animation.duration = 0.5
            progressLayer.add(animation, forKey: "progress")
        }
        progressLayer.strokeEnd = progress
    }

    func setTime(_ text: String) {
        timeLabel.text = text
        setNeedsLayout()
    }

    // MARK: - Setup

    private func setup() {
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = 10
        trackLayer.lineCap = .round
        layer.addSublayer(trackLayer)

        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = 10
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)

        timeLabel.textAlignment = .center
        timeLabel.font = .monospacedDigitSystemFont(ofSize: 44, weight: .bold)
        timeLabel.textColor = .white
        addSubview(timeLabel)

        breakLabel.text = "Break"
        breakLabel.textAlignment = .center
        breakLabel.font = .systemFont(ofSize: 15, weight: .medium)
        breakLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        addSubview(breakLabel)
    }
}
