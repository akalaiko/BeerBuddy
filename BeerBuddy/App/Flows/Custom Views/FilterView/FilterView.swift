//
//  FilterView.swift
//  BeerBuddy
//
//  Created by Ke4a on 10.02.2023.
//

import UIKit

protocol FilterViewDelegate: AnyObject {
    /// User preferences.
    var userPreference: PreferenceRequest? { get }

    /// Passes the filtering options to the delegate.
    /// - Parameter data: Filtration data.
    func sendFiltrationData(_ data: PreferenceRequest)
}

final class FilterView: UIView {
    // MARK: - Visual Components

    private lazy var boxView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        view.backgroundColor = AppStyles.color.swamp
        return view
    }()

    private lazy var headerView: HeaderView = {
        let view = HeaderView(title: "FILTERS", backgroundIsDark: true)
        view.font = AppStyles.font.middle
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setRightButton(imageName: AppData.imageName.close, target: self, action: #selector(closeButtonAction))
        return view
    }()

    private lazy var preferenceStack: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.distribution = .equalSpacing
        stackview.spacing = AppStyles.size.verticalMargin.small
        return stackview
    }()

    private lazy var searchButton: CustomButton = {
        let button = CustomButton(title: "SEARCH", isDarkMode: true)
        button.titleLabel?.font = .systemFont(ofSize: AppStyles.font.pointSize.small, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(searchButtonAction), for: .touchUpInside)
        return button
    }()

    // MARK: - Private Properties

    /// A delegate that accepts the values of the filter options selected by the user.
    private weak var delegate: FilterViewDelegate?
    /// The area from which the filter screen will appear or disappear.
    private var frameArea: CGRect?
    private lazy var loopingMargin = 20
    private lazy var pickerData: [String] = []
    private lazy var preferencesData: [Preference] = [.sex(value: .none),
                                                      .smoke(value: .none),
                                                      .drink(value: .none),
                                                      .interest(value: .none)]

    // MARK: - Initialization

    /// Creates a filter view with an in/out animation. TНастройки визуальных компонентов.he view is hidden by default.
    /// - Parameter data: Selected filter options.
    ///
    /// View stretch to full screen.
    init(delegate: FilterViewDelegate?) {
        super.init(frame: .zero)

        self.delegate = delegate
        setupUI()
        settingsComponents()
        restoreSettings(restore: delegate?.userPreference)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setting UI Methods

    /// Settings visual components.
    private func setupUI() {
        isHidden = true
        
        addSubview(boxView)
        NSLayoutConstraint.activate([
            boxView.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor,
                                         constant: AppStyles.size.height.header),
            boxView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor,
                                             constant: AppStyles.size.height.header / 2),
            boxView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppStyles.size.horizontalMargin.middle),
            boxView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                              constant: -AppStyles.size.horizontalMargin.middle),
            boxView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor)
        ])

        boxView.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: boxView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: boxView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: boxView.trailingAnchor),
            headerView.heightAnchor.constraint(equalTo: boxView.heightAnchor, multiplier: 0.10)
        ])

        boxView.addSubview(searchButton)
        NSLayoutConstraint.activate([
            searchButton.bottomAnchor.constraint(equalTo: boxView.bottomAnchor,
                                                 constant: -AppStyles.size.verticalMargin.small),
            searchButton.heightAnchor.constraint(equalToConstant: AppStyles.size.height.minimalSize),
            searchButton.centerXAnchor.constraint(equalTo: boxView.centerXAnchor),
            searchButton.widthAnchor.constraint(equalTo: boxView.widthAnchor, multiplier: 0.33)
        ])

        boxView.addSubview(preferenceStack)
        NSLayoutConstraint.activate([
            preferenceStack.topAnchor.constraint(equalTo: headerView.bottomAnchor,
                                                 constant: AppStyles.size.verticalMargin.small),
            preferenceStack.leadingAnchor.constraint(equalTo: boxView.leadingAnchor,
                                                     constant: AppStyles.size.horizontalMargin.middle),
            preferenceStack.trailingAnchor.constraint(equalTo: boxView.trailingAnchor,
                                                      constant: -AppStyles.size.horizontalMargin.middle),
            preferenceStack.bottomAnchor.constraint(equalTo: searchButton.topAnchor,
                                                    constant: -AppStyles.size.verticalMargin.middle)
        ])
    }

    /// Filling components with data.
    private func settingsComponents() {
        preferencesData.forEach { preference in
            if let settings = preference.settings {
                switch settings.component {
                case .segmentedControl:
                    let control = createSegmentedControl(title: settings.title, items: settings.allOptionsPreference)
                    control.tag = settings.indexPreference
                    control.selectedSegmentIndex = settings.indexOptionPreference
                    preferenceStack.addArrangedSubview(control)
                case .picker:
                    pickerData = settings.allOptionsPreference

                    let picker = createInfinitePicker()
                    picker.selectRow(pickerData.endIndex, inComponent: 0, animated: false)
                    let box = addComponentToContainerWithTitle(title: settings.title,
                                                               subText: "Use this in special occasion e.g. you're" +
                                                               " looking for someone to watch football with tonight.",
                                                               component: picker)

                    picker.tag = settings.indexPreference
                    box.tag = settings.indexPreference
                    preferenceStack.addArrangedSubview(box)
                }
            }
        }
    }

    private func createSegmentedControl(title: String, items: [String]) -> CustomSegmentedControl {
        let control = CustomSegmentedControl(title: title, items: items)
        control.addTarget(self, action: #selector(preferenceSegmentedControlAction), for: .valueChanged)
        return control
    }

    private func createInfinitePicker() -> UIPickerView {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = AppStyles.color.offwhite
        picker.layer.cornerRadius = boxView.layer.cornerRadius
        picker.selectRow(0, inComponent: 0, animated: false)
        picker.clipsToBounds = true
        picker.delegate = self
        picker.dataSource = self
        picker.subviews.first?.backgroundColor = AppStyles.color.sand.withAlphaComponent(0.3)
        if #available(iOS 14.0, *) {
            picker.subviews.last?.backgroundColor = AppStyles.color.sand
            picker.subviews.last?.layer.zPosition = -1
        }

        return picker
    }

    private func addComponentToContainerWithTitle(title: String, subText: String, component: UIView) -> UIView {
        let containerView = UIView()

        let label: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = title
            label.textColor = AppStyles.color.offwhite
            return label
        }()

        let subLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = AppStyles.color.offwhite
            label.font = .systemFont(ofSize: label.font.pointSize * 0.7)
            label.numberOfLines = 2
            label.text = subText
            return label
        }()

        containerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: containerView.topAnchor),
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])

        containerView.addSubview(subLabel)
        NSLayoutConstraint.activate([
            subLabel.topAnchor.constraint(equalTo: label.bottomAnchor,
                                          constant: AppStyles.size.verticalMargin.small),
            subLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            subLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])

        containerView.addSubview(component)
        NSLayoutConstraint.activate([
            component.topAnchor.constraint(equalTo: subLabel.bottomAnchor,
                                           constant: AppStyles.size.verticalMargin.small),
            component.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            component.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            component.heightAnchor.constraint(lessThanOrEqualToConstant: AppStyles.size.height.minimalSize * 4),
            component.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        return containerView
    }

    // MARK: - Public Methods

    /// Animation of the appearance from the center of the area specified in the parameters.
    /// - Parameter frameArea: Location and dimensions area.
    func appearanceAnimation(_ frameArea: CGRect) {
        self.frameArea = frameArea
        animation(frameArea, disappearance: false)
    }

    // MARK: - Private Methods

    /// Animation of appearance / disappearance to the center of the area specified in the parameters.
    /// - Parameter frameArea: Location and dimensions area.
    private func disappearanceAnimation(_ frameArea: CGRect?) {
        guard let area = frameArea else { return }
        animation(area, disappearance: true)
    }

    /// Animation of disappearance to the center of the area specified in the parameters.
    /// - Parameters:
    ///   - frame: Location and dimensions area.
    ///   - disappearance: It's a disappear animation.
    private func animation(_ frame: CGRect, disappearance: Bool) {
        DispatchQueue.main.async {
            let originalFrame = self.boxView.frame
            var areaFrame: CGRect = self.boxView.frame
            areaFrame.origin.x = frame.midX - self.boxView.bounds.midX
            areaFrame.origin.y = frame.midY - self.boxView.bounds.midY

            if !disappearance {
                self.isHidden = false
                self.boxView.frame = areaFrame
                self.boxView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            }

            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
                if disappearance {
                    self.boxView.frame = areaFrame
                    self.boxView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                } else {
                    self.boxView.transform = CGAffineTransform.identity
                    self.boxView.frame = originalFrame
                }
                self.backgroundColor = .darkGray.withAlphaComponent(disappearance ? 0 : 0.3)
            }completion: { _ in
                if disappearance {
                    self.removeFromSuperview()
                } else {
                    self.boxView.transform = CGAffineTransform.identity
                }
            }
        }
    }

    /// Restoring the filter option selected by the user before.
    /// - Parameter data: Filter options.
    private func restoreSettings(restore data: PreferenceRequest?) {
        guard let data = data else { return }

        preferenceStack.arrangedSubviews.forEach { view in
            let preference = preferencesData[view.tag]
            var value: Int?

            switch preference {
            case .sex where data.sex != nil:
                value = data.sex == .male ? 0 : 1
            case .smoke where data.smoke != nil:
                value = data.smoke == true ? 0 : 1
            case .drink where data.drink != nil:
                value = data.drink == true ? 0 : 1
            case .interest:
                if let interest = data.interest, let index = pickerData.firstIndex(of: interest) {
                    value = index
                }
            default:
                break
            }

            if preference.settings?.component == .segmentedControl,
               let value = value,
               let control = view as? CustomSegmentedControl {
                preferencesData[view.tag] = .init(view.tag, indexOptionPreference: value)
                control.selectedSegmentIndex = value
            } else if preference.settings?.component == .picker, let picker = view.subviews.last as? UIPickerView {
                if let value = value {
                    preferencesData[view.tag] = .init(view.tag, indexOptionPreference: value)
                    picker.selectRow((loopingMargin / 2) * pickerData.count + value, inComponent: 0, animated: false)
                } else {
                    picker.selectRow(pickerData.endIndex, inComponent: 0, animated: false)
                }
            }
        }
    }

    // MARK: - Actions

    /// The action called on the control segment when the user selects a new value saves the user's choice.
    /// - Parameter sender: Segmented control.
    @objc private func preferenceSegmentedControlAction(_ sender: CustomSegmentedControl) {
        preferencesData[sender.tag] = .init(sender.tag, indexOptionPreference: sender.selectedSegmentIndex)
    }

    /// Header close button action. Causes a disappear animation.
    /// - Parameter sender: Close button.
    @objc private func closeButtonAction(_ sender: UIButton) {
        if let view = sender.superview as? HeaderView {
            view.rightButtonClickAnimation()
        }
        disappearanceAnimation(frameArea)
    }

    /// Search button action. Passes the filter options selected by the user to the delegate. Causes disapperance  animation.
    /// - Parameter sender: Search button.
    @objc private func searchButtonAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            var filterResult = PreferenceRequest()

            self.preferencesData.forEach { preference in
                switch preference {
                case .sex(value: let value):
                    filterResult.sex = value.result
                case .smoke(value: let value):
                    filterResult.smoke = value.result
                case .drink(value: let value):
                    filterResult.drink = value.result
                case .interest(value: let value):
                    filterResult.interest = value.result
                case .none:
                    break
                }
            }

            UIView.animate(withDuration: 0.33, delay: 0) {
                sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }completion: { _ in
                sender.transform = CGAffineTransform.identity
                self.delegate?.sendFiltrationData(filterResult)
                if let areaFrame = self.frameArea {
                    self.animation(areaFrame, disappearance: true)
                }
            }
        }
    }
}

// MARK: - UIPickerViewDelegate

extension FilterView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?
    ) -> UIView {
        let label = UILabel()
        label.font = .systemFont(ofSize: AppStyles.font.pointSize.small + 2)
        label.textAlignment = .center
        label.text = pickerData[row % pickerData.count]
        return label
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currentIndex = row % pickerData.count
        pickerView.selectRow((loopingMargin / 2) * pickerData.count + currentIndex, inComponent: 0, animated: false)
        preferencesData[pickerView.tag] = .init(pickerView.tag, indexOptionPreference: row % pickerData.count)
    }
}

// MARK: - UIPickerViewDataSource

extension FilterView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        loopingMargin * pickerData.count
    }
}

// MARK: - Settings

protocol PreferenceValueProtocol {
    /// All preference options.
    var allOptions: [String] { get }
}

private extension FilterView {
    /// Gender filtering options.
    ///
    /// rawValue contains the index of the selected option.
    enum SexPreferenceValue: Int, PreferenceValueProtocol {
        case male
        case female
        case none

        var allOptions: [String] {
            ["Male", "Female", "Don’t Care"]
        }

        /// The selected value in the selected type for the query.
        var result: Sex? {
            switch self {
            case .male:
                return .male
            case .female:
                return .female
            case .none:
                return nil
            }
        }
    }

    /// Boolean filtering options.
    ///
    /// rawValue contains the index of the selected option.
    enum BooleanPreferenceValue: Int, PreferenceValueProtocol {
        case trueValue
        case falseValue
        case none

        var allOptions: [String] {
            ["Yes", "Nope", "Don’t Care"]
        }

        /// The selected value in the selected type for the query.
        var result: Bool? {
            switch self {
            case .trueValue:
                return true
            case .falseValue:
                return false
            case .none:
                return nil
            }
        }
    }

    /// Interest filtering options.
    ///
    /// rawValue contains the index of the selected option.
    enum InterestValue: PreferenceValueProtocol {
        case selected(Int)
        case none

        init?(index: Int) {
            self = .selected(index)
        }

        /// All interest options.
        var allOptions: [String] {
            ["none", "vodka", "vine", "gym", "pool", "Obj-c"]
        }

        var rawValue: Int {
            switch self {
            case .selected:
                return 0
            case .none:
                return 1
            }
        }

        /// The selected interest as a string value.
        ///
        /// If none is selected, returns nil.
        var result: String? {
            switch self {
            case .selected(let index):
                let result = allOptions[index]
                return result == "none" ? nil : result
            case .none:
                return nil
            }
        }
    }

    enum Component {
        case segmentedControl
        case picker
    }

    enum Preference {
        case sex(value: SexPreferenceValue)
        case smoke(value: BooleanPreferenceValue)
        case drink(value: BooleanPreferenceValue)
        case interest(value: InterestValue)
        case none

        init(_ indexPreference: Int, indexOptionPreference: Int) {
            switch indexPreference {
            case 0:
                self = .sex(value: .init(rawValue: indexOptionPreference) ?? .none)
            case 1:
                self = .smoke(value: .init(rawValue: indexOptionPreference) ?? .none)
            case 2:
                self = .drink(value: .init(rawValue: indexOptionPreference) ?? .none)
            case 3:
                self = .interest(value: .init(index: indexOptionPreference) ?? .none)
            default:
                self = .none
            }
        }

        /// Preference settings.
        var settings: (component: Component, title: String, allOptionsPreference: [String],
                       indexPreference: Int, indexOptionPreference: Int)? {
            switch self {
            case .sex(value: let segmented):
                return (component: .segmentedControl, title: "Loking for:", allOptionsPreference: segmented.allOptions,
                        indexPreference: 0, indexOptionPreference: segmented.rawValue)
            case .smoke(value: let segmented):
                return (component: .segmentedControl, title: "Should the person smoke?",
                        allOptionsPreference: segmented.allOptions,
                        indexPreference: 1, indexOptionPreference: segmented.rawValue)
            case .drink(value: let segmented):
                return (component: .segmentedControl, title: "Should the person drink?",
                        allOptionsPreference: segmented.allOptions,
                        indexPreference: 2, indexOptionPreference: segmented.rawValue)
            case .interest(value: let segmented):
                return (component: .picker, title: "Forcefully specify an interest:",
                        allOptionsPreference: segmented.allOptions,
                        indexPreference: 3, indexOptionPreference: segmented.rawValue)
            case .none:
                return nil
            }
        }
    }
}
