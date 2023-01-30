//
//  CustomTextField.swift
//  BeerBuddy
//
//  Created by Polina Tikhomirova on 13.01.2023.
//

import Foundation
import UIKit

extension CustomTextField {
    enum RestrictionType: Int {
        case none
        case lettersOnly
        case numbersOnly
        case phoneNumber
    }

}

final class CustomTextField: UITextField {
    private var maxLength: Int = 0
    private var minLength: Int = 0
    private var isSecure: Bool = false
    private var allowedCharInString: String = ""
    private var restriction = RestrictionType.none
    private var textPadding = UIEdgeInsets(
        top: 10,
        left: 20,
        bottom: 10,
        right: 20
    )
    
    init(
        restriction: RestrictionType = .none,
        maxLength: Int = 0,
        minLength: Int = 0,
        isSecure: Bool = false,
        placeholder: String) {
            super.init(frame: .init(x: 0, y: 0, width: 0, height: 40))
            self.restriction = restriction
            self.maxLength = maxLength
            self.minLength = minLength
            self.isSecure = isSecure
            self.placeholder = placeholder

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setBorder()
    }
    
    private func calcRestrictionType(
        range: NSRange,
        string: String
    ) -> Bool {
        switch restriction {
        case .none:
            break
        case .lettersOnly:
            let characterSet = CharacterSet.letters
            if string.rangeOfCharacter(from: characterSet.inverted) != nil {
                return false
            }
        case .numbersOnly:
            let numberSet = CharacterSet.decimalDigits
            if string.rangeOfCharacter(from: numberSet.inverted) != nil {
                return false
            }
        case .phoneNumber:
            let phoneNumberSet = CharacterSet(charactersIn: "+0123456789")
            if string.rangeOfCharacter(from: phoneNumberSet.inverted) != nil {
                return false
            }
        }
        return true
    }
    
    private func verify(
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard calcRestrictionType(range: range, string: string) else {
            return false
        }
            guard
                let text = self.text,
                let textRange = Range(range, in: text)
            else { return false }
        
            let finalText = String()
        
            if finalText == text.replacingCharacters(in: textRange, with: string) {
                if maxLength > 0, maxLength < finalText.utf8.count {
                    return false
                }
                if minLength < 0, minLength < finalText.utf8.count {
                    return false
                }
            }
    
            if self.text != nil {
                if isSecure == true {
                    isSecureTextEntry = true
                }
            }
        
            if !self.allowedCharInString.isEmpty {
                let customSet = CharacterSet(charactersIn: self.allowedCharInString)
                if string.rangeOfCharacter(from: customSet.inverted) != nil {
                    return false
                }
            }
            return true
        }
    
    private func setupUI() {
        textColor = .black
        attributedPlaceholder = NSAttributedString(
            string: self.placeholder ?? "",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ]
        )
        isSecureTextEntry = isSecure
    }

    private func setBorder() {
        layer.cornerRadius = frame.size.height / 2
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        layer.masksToBounds = true
    }
}

extension CustomTextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
