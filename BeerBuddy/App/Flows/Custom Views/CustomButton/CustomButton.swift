//
//  CustomButton.swift
//  BeerBuddy
//
//  Created by Никита Мошенцев on 15.01.2023.
//

import Foundation
import UIKit

final class CustomButton: UIButton {
    private var title: String = ""
    private var isDarkMode: Bool = false
    
    init(title: String, isDarkMode: Bool = false) {
        super.init(frame: .init(x: 0, y: 0, width: 0, height: 50))
        self.title = title
        self.isDarkMode = isDarkMode
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setBorder()
    }
    
    private func setBorder() {
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
    }
    
    private func setupUI() {
        setTitle(title, for: .normal)
        
        switch UIScreen.main.traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            setTitleColor(.white, for: .normal)
            backgroundColor = AppStyles.color.brown
        case .dark:
            setTitleColor(.black, for: .normal)
            backgroundColor = AppStyles.color.light
        default:
            setTitleColor(.white, for: .normal)
            backgroundColor = AppStyles.color.brown
        }
        titleLabel?.font = AppStyles.font.button
        
        if isDarkMode {
            setTitleColor(.black, for: .normal)
            backgroundColor = AppStyles.color.offwhite
        }
    }
}
