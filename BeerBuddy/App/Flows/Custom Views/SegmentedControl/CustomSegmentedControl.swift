//
//  CustomSegmentedControl.swift
//  BeerBuddy
//
//  Created by Ke4a on 11.02.2023.
//

import UIKit

/// Custom segment control with animation.
final class CustomSegmentedControl: UIControl {
    // MARK: - Visual Components

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppStyles.color.offwhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.spacing = 1
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    /// Background stackview with segment separators.
    private var backgroundStackView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = AppStyles.color.offwhite
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// Viiew that highlights the selected segment.
    private lazy var highlightingView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = AppStyles.color.sand
        return view
    }()

    // MARK: - Public Properties

    /// The index number that identifies the selected segment that the user last touched.
    ///
    /// Set this property to -1 to turn off the current selection.
    /// When the user touches a segment to change the selection, the system generates the control event valueChanged.
    lazy var selectedSegmentIndex: Int = -1 {
        willSet {
            selectSegment(currentIndex: selectedSegmentIndex, newIndex: newValue)
        }
    }

    // MARK: - Private Properties

    /// Segment separator color.
    private lazy var separatorColor = UIColor.lightGray.withAlphaComponent(0.5)
    private var isDarkMode: Bool = false

    // MARK: - Initialization

    /// Creates custom segmented control. With animation and default height.
    /// - Parameter isDarkMode: Switches the color of the segment to dark. The default color is light.
    init(isDarkMode: Bool = false) {
        super.init(frame: .zero)

        self.isDarkMode = isDarkMode
        setupUI(withTitle: false)
    }

    /// Creates custom segmented control. With animation and default height.
    /// - Parameters:
    ///    - items: Values of segmented control.
    /// - Parameter isDarkMode: Switches the color of the segment to dark. The default color is light.
    init(items: [String], isDarkMode: Bool = false) {
        super.init(frame: .zero)

        self.isDarkMode = isDarkMode
        configure(items, title: nil)
        setupUI(withTitle: false)
    }

    /// Creates custom segmented control. With animation and default height.
    /// - Parameters:
    ///   - text: The title of segmented control.
    /// - Parameter isDarkMode: Switches the color of the segment to dark. The default color is light.
    init(title text: String, isDarkMode: Bool = false) {
        super.init(frame: .zero)

        self.isDarkMode = isDarkMode
        configure(nil, title: text)
        setupUI(withTitle: true)
    }

    /// Creates custom segmented control. With animation and default height.
    /// - Parameters:
    ///   - text: The title of segmented control.
    ///   - items: Values of segmented control.
    /// - Parameter isDarkMode: Switches the color of the segment to dark. The default color is light.
    init(title text: String, items: [String], isDarkMode: Bool = false) {
        super.init(frame: .zero)

        self.isDarkMode = isDarkMode
        configure(items, title: text)
        setupUI(withTitle: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        settingsStackView()
    }

    // MARK: - Setting UI Methods

    /// Settings visual components.
    /// - Parameter withTitle: Indicating whether to display a title on the interface or not.
    private func setupUI(withTitle: Bool) {
        if withTitle {
            addSubview(titleLabel)
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: topAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                titleLabel.heightAnchor.constraint(equalToConstant: titleLabel.font.pointSize)
            ])
        }

        if isDarkMode {
            stackView.backgroundColor = AppStyles.color.light
            highlightingView.backgroundColor = AppStyles.color.swamp
        }

        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: withTitle ? titleLabel.bottomAnchor : topAnchor,
                                           constant: withTitle ? AppStyles.size.verticalMargin.small : 0),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.heightAnchor.constraint(lessThanOrEqualToConstant: 100),
            stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: AppStyles.size.height.minimalSize),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        stackView.insertSubview(backgroundStackView, at: 0)
        NSLayoutConstraint.activate([
            backgroundStackView.topAnchor.constraint(equalTo: stackView.topAnchor),
            backgroundStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            backgroundStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            backgroundStackView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ])

        stackView.insertSubview(highlightingView, at: 1)
    }

    /// Setting stackview , used after frame are acquired.
    private func settingsStackView() {
        stackView.layer.cornerRadius = stackView.frame.height / 2
        stackView.clipsToBounds = true
        drawSegmentsSeparators(color: separatorColor)
    }

    // MARK: - Public Methods

    /// Set values segmented control.
    /// - Parameter items: Values of segmented control.
    func setItems(_ items: [String]) {
        stackView.arrangedSubviews.forEach { item in
            stackView.removeArrangedSubview(item)
            item.removeFromSuperview()
        }
        selectedSegmentIndex = -1

        let createLabel: () -> UILabel = { [ weak self ] in
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = .black
            label.font = .systemFont(ofSize: AppStyles.font.pointSize.small, weight: .regular)
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self?.switchAction)))
            return label
        }

        items.enumerated().forEach { index, item in
            let label = createLabel()
            label.text = item
            label.tag = index
            stackView.addArrangedSubview(label)
        }

        drawSegmentsSeparators(color: separatorColor)
    }

    // MARK: - Private Methods

    /// Segmented сontrol сonfiguration.
    /// - Parameters:
    ///   - items: The title of segmented control. This parameter is optional.
    ///   - title: -Values of segmented control. This parameter is optional.
    private func configure(_ items: [String]?, title: String?) {
        if let title = title {
            titleLabel.text = title
        }
        if let items = items {
            setItems(items)
        }
    }

    /// Highlights the selected segment in a segmented control.
    /// - Parameters:
    ///   - currentIndex: The current index of the selected segment.
    ///   - newIndex: The new index to highlight as selected.
    private func selectSegment(currentIndex: Int, newIndex: Int) {
        guard newIndex >= 0 else {
            highlightingView.isHidden = true

            if currentIndex >= 0 && !stackView.arrangedSubviews.isEmpty {
                self.switchHideSegmentSeparators(hideIndex: nil, visableIndex: currentIndex,
                                                 color: separatorColor, animate: nil)
                stackView.arrangedSubviews[currentIndex].isUserInteractionEnabled = true
            }
            return
        }

        highlightingView.isHidden = false

        let animateDuration = currentIndex >= 0 ? 0.5 : nil
        let newSegment = stackView.arrangedSubviews[newIndex]
        newSegment.isUserInteractionEnabled = false
        self.moveHighlightingView(newSegment.frame, index: newIndex, animate: animateDuration)
        self.switchHideSegmentSeparators(hideIndex: newIndex, visableIndex: currentIndex >= 0 ? currentIndex : nil,
                                         color: separatorColor, animate: animateDuration)
        if isDarkMode {
            changeTextColorSegment(newIndex, color: AppStyles.color.offwhite, animate: animateDuration)
        }

        guard currentIndex >= 0 else { return }
        stackView.arrangedSubviews[currentIndex].isUserInteractionEnabled = true

        if isDarkMode {
            changeTextColorSegment(currentIndex, color: .black, animate: animateDuration)
        }
    }

    /// Moves the selection view to a new position.
    /// - Parameters:
    ///   - newFrame: The new frame to move the selection view to.
    ///   - index: The index of the segment to select.
    ///   - duration: Animation duration in seconds. If the parameter is not specified, then the animation does not occur.
    private func moveHighlightingView(_ newFrame: CGRect, index: Int, animate duration: Double?) {
        DispatchQueue.main.async {
            guard let duration = duration else {
                self.highlightingView.frame = newFrame
                self.chooseCornerRadiusHighlightingView(segmentHeight: newFrame.height, index: index, animate: duration)
                return
            }

            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) {
                self.highlightingView.frame = newFrame
            }
            self.chooseCornerRadiusHighlightingView(segmentHeight: newFrame.height, index: index, animate: duration)
        }
    }

    /// Changes the text color of the segment. With animation option.
    /// - Parameters:
    ///   - index: The segment index to change.
    ///   - color: Text color.
    ///   - duration: Animation duration in seconds. If the parameter is not specified, then the animation does not occur.
    private func changeTextColorSegment(_ index: Int, color: UIColor, animate duration: Double?) {
        DispatchQueue.main.async {
            guard let segment = self.stackView.arrangedSubviews[index] as? UILabel else { return }
            guard let duration = duration else {
                segment.textColor = color
                return
            }

            UIView.transition(with: segment, duration: duration, options: .transitionCrossDissolve) {
                segment.textColor = color
            }
        }
    }

    /// Selects сorner radius for highlighting view.
    /// - Parameters:
    ///   - segmentHeight: Segment height.
    ///   - index: Segment index.
    ///   - duration: Animation duration in seconds. If the parameter is not specified, then the animation does not occur.
    private func chooseCornerRadiusHighlightingView(segmentHeight: CGFloat, index: Int, animate duration: Double?) {
        DispatchQueue.main.async {
            let isFirstPosition = index == 0
            let isLastPosition = index == self.stackView.arrangedSubviews.count - 1

            let newCornerRadius = isFirstPosition || isLastPosition ? segmentHeight / 2 : 0

            var newMaskedCorners: CACornerMask = []
            if isFirstPosition {
                newMaskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
            } else if isLastPosition {
                newMaskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            }

            guard self.highlightingView.layer.cornerRadius != newCornerRadius ||
                    self.layer.maskedCorners != newMaskedCorners  else { return }

            guard let duration = duration else {
                if self.highlightingView.layer.cornerRadius != newCornerRadius {
                    self.highlightingView.layer.cornerRadius = newCornerRadius
                }
                if self.highlightingView.layer.maskedCorners != newMaskedCorners {
                    self.highlightingView.layer.maskedCorners = newMaskedCorners
                }
                return
            }

            var completeAnimation = duration
            let resetAnimation: Double = completeAnimation / 2
            completeAnimation -= resetAnimation

            if self.highlightingView.layer.cornerRadius == 0 {
                self.highlightingView.layer.maskedCorners = newMaskedCorners
            } else {
                UIView.animate(withDuration: resetAnimation, delay: 0, options: .curveEaseInOut) {
                    self.highlightingView.layer.cornerRadius = 0
                } completion: { _ in
                    self.highlightingView.layer.maskedCorners = newMaskedCorners
                }
            }

            UIView.animate(withDuration: completeAnimation, delay: resetAnimation, options: .curveEaseInOut) {
                self.highlightingView.layer.cornerRadius = newCornerRadius
            }
        }
    }

    /// Draws separators between segments if there is spacing.
    /// - Parameter color: Separator color.
    private func drawSegmentsSeparators(color: UIColor) {
        DispatchQueue.main.async {
            guard self.stackView.spacing > 0,
                  self.stackView.arrangedSubviews.count > 1,
                  self.backgroundStackView.frame != .zero else { return }
            
            self.backgroundStackView.layer.sublayers?.removeAll()

            let widthSegment = self.stackView.frame.width / CGFloat(self.stackView.arrangedSubviews.count)
            let verticalPadding = self.stackView.frame.height * 0.15

            for i in 1..<self.stackView.arrangedSubviews.count {
                let path = UIBezierPath()
                let x = widthSegment * CGFloat(i)
                path.move(to: .init(x: x, y: self.stackView.bounds.minY + verticalPadding))
                path.addLine(to: .init(x: x, y: self.stackView.bounds.maxY - verticalPadding))
                path.close()

                let shapeLayer = CAShapeLayer()
                shapeLayer.path = path.cgPath
                shapeLayer.strokeColor = color.cgColor
                shapeLayer.lineWidth = self.stackView.spacing

                self.backgroundStackView.layer.addSublayer(shapeLayer)
            }
        }
    }

    /// Сontrol the visibility of segment separators.
    /// - Parameters:
    ///   - hideIndex: Segment index whose separators should be made invisible.
    ///   - visableIndex: Segment index whose separators should be made visible
    ///   - color: The separator color to apply if it is not hidden.
    ///   - duration: The duration of the animation at which the visibility of the separators will be changed.
    ///   If the parameter is not specified, then the animation does not occur.
    ///
    ///   If the separators of the current and new segments intersect, the hidden one takes precedence.
    private func switchHideSegmentSeparators( hideIndex: Int?,
                                              visableIndex: Int?,
                                              color: UIColor,
                                              animate duration: Double?) {
        DispatchQueue.main.async {
            guard let sublayers = self.backgroundStackView.layer.sublayers as? [CAShapeLayer],
                  !sublayers.isEmpty else { return }

            let visableColor = color.cgColor, hideColor = color.withAlphaComponent(0).cgColor

            let separators: [(item: CAShapeLayer, newStrokeColor: CGColor)] =
            sublayers.enumerated().compactMap { itemIndex, item in
                if let hideIndex = hideIndex, (hideIndex != 0 && itemIndex == hideIndex - 1) ||
                    (hideIndex != sublayers.count && itemIndex == hideIndex) || (sublayers.count == 1) {
                    guard item.strokeColor != hideColor else { return nil }
                    
                    return (item: item, newStrokeColor: hideColor)
                }

                guard sublayers.count != 1, hideIndex != visableIndex else { return nil }

                if let visableIndex = visableIndex,
                   (visableIndex != 0 && itemIndex == visableIndex - 1 && hideIndex != visableIndex - 1) ||
                    (visableIndex != sublayers.count && itemIndex == visableIndex && hideIndex != visableIndex + 1) {
                    return (item: item, newStrokeColor: visableColor)
                }
                return nil
            }

            guard !separators.isEmpty, let duration = duration else {
                separators.forEach { $0.item.strokeColor = $0.newStrokeColor }
                return
            }

            CATransaction.setCompletionBlock({
                separators.forEach { item, newStrokeColor in
                    item.strokeColor = newStrokeColor
                    item.removeAllAnimations()
                }
            })
            let animation = CABasicAnimation(keyPath: "strokeColor")
            animation.duration = duration
            CATransaction.begin()
            separators.forEach { item, newStrokeColor in
                animation.fromValue = item.strokeColor
                animation.toValue = newStrokeColor
                item.add(animation, forKey: "strokeColor")
            }
            CATransaction.commit()
        }
    }

    // MARK: - Actions

    /// Action user touches a segment.
    /// - Parameter sender: UIGestureRecognizer.
    @objc private func switchAction(_ sender: UIGestureRecognizer) {
        guard let index = sender.view?.tag else { return }

        selectedSegmentIndex = index
        self.sendActions(for: .valueChanged)
    }
}
