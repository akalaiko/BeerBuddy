//
//  HeaderView.swift
//  BeerBuddy
//
//  Created by Ke4a on 15.01.2023.
//

import UIKit

/// Header with title and optional ability to add a button.
///
/// To add a button, need to call a method.
class HeaderView: UIView {
    // MARK: - Visual Components

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var rightButton: UIButton?

    /// The position and dimensions of the button, if any.
    var buttonFrame: CGRect? {
        rightButton?.frame
    }

    // MARK: - Public Properties
    
    /// Sets font in tittle.
    var font: UIFont {
        get {
            titleLabel.font
        }

        set {
            titleLabel.font = newValue
        }
    }

    // MARK: - Initialization

    /// Header with title and optional ability to add a button.
    /// - Parameter text: Text title.
    init(title text: String, backgroundIsDark: Bool = false) {
        super.init(frame: .zero)
        setupUI(title: text, backgroundIsDark: backgroundIsDark)
        
        #if DEBUG
        setUITests()
        #endif
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setting UI Methods

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawBottomSeparator(rect)
    }

    /// Settings  visual components.
    /// - Parameter title: Title text.
    private func setupUI(title text: String, backgroundIsDark: Bool ) {
        titleLabel.text = text
        backgroundColor = AppStyles.color.background.main

        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                constant: AppStyles.size.horizontalMargin.middle),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7)
        ])
    }

    /// Right Button Setting.
    /// - Parameters:
    ///   - imageName: Image title.
    ///   - target: Location of action call.
    ///   - action: Action button.
    func setRightButton(imageName: String, target: AnyObject, action: Selector) {
        rightButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            let image = UIImage(named: imageName)
            button.setImage(image, for: .normal)
            button.tintColor = titleLabel.textColor
            #if DEBUG
            button.accessibilityIdentifier = "headerRightButton"
            #endif
            return button
        }()

        guard let button = rightButton else { return }
        button.addTarget(target, action: action, for: .touchUpInside)

        addSubview(button)
        NSLayoutConstraint.activate([
            // Button size is one and a half times the size of the font
            button.heightAnchor.constraint(equalToConstant: titleLabel.font.pointSize * 1.5),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.widthAnchor.constraint(equalTo: button.heightAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor,
                                             constant: -AppStyles.size.horizontalMargin.middle)
        ])
    }

    /// Draws a line at the bottom of the view
    /// - Parameter rect: View’s bounds
    private func drawBottomSeparator(_ rect: CGRect) {
        let lineWidth: CGFloat = 1
        let path = UIBezierPath()
        path.move(to: .init(x: rect.maxX * 0.05, y: rect.maxY - lineWidth))
        path.addLine(to: .init(x: rect.maxX * 0.95, y: rect.maxY - lineWidth))
        path.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = titleLabel.textColor.cgColor
        shapeLayer.lineWidth = lineWidth

        layer.addSublayer(shapeLayer)
    }

    // MARK: - Public Methods

    /// Right button click animation, if it was added.
    func rightButtonClickAnimation() {
        guard let button = rightButton else { return }

        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn) {
            button.tintColor = .lightGray
            button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } completion: { _ in
            UIView.animate(withDuration: 0.15) {
                button.tintColor = self.titleLabel.textColor
                button.transform = CGAffineTransform.identity
            }
        }
    }
}

// MARK: - UI Testing

#if DEBUG
extension HeaderView {
    /// Setting ui test Identifiers.
    private func setUITests() {
        titleLabel.accessibilityIdentifier = "headerTitle"
    }
}
#endif
