import UIKit

final class GradientCardView: UIView {

    private let gradientLayer = CAGradientLayer()

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
        gradientLayer.frame = bounds
    }

    private func setup() {
        layer.cornerRadius = 20
        clipsToBounds = true

        gradientLayer.colors = [
            UIColor(red: 0.22, green: 0.25, blue: 0.65, alpha: 1).cgColor,
            UIColor(red: 0.35, green: 0.20, blue: 0.55, alpha: 1).cgColor,
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
