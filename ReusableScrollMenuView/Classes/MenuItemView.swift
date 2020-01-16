//
//  MenuItemView.swift
//  BigNavBar
//
//  Created by EUIGYOM KIM on 2020/01/15.
//  Copyright © 2020 EUIGYOM KIM. All rights reserved.
//

import UIKit
import SnapKit

class MenuItemView: UIView {
    
    dynamic var fontSize: CGFloat = 14 {
        didSet { updateLabelAppearance() }
    }
    
    dynamic var highlightFontWeight: UIFont.Weight = .bold {
        didSet { updateLabelAppearance() }
    }
    
    dynamic var normalColor: UIColor = .black {
        didSet { updateLabelAppearance() }
    }
    
    dynamic var highlightColor: UIColor = .gray {
        didSet { updateLabelAppearance() }
    }
    
    dynamic var verticalMargin: CGFloat = 15 {
        didSet { updateLabelConstraint() }
    }
    
    dynamic var horizontalMargin: CGFloat = 16 {
        didSet { updateLabelConstraint() }
    }
    
    dynamic var isHighlighedMenu: Bool = false {
        didSet { updateLabelAppearance() }
    }
    
    var text: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    var menuView: ReusableScrollMenuView!
    
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy private var button: UIButton = {
        let button = UIButton()
        return button
    }()
    
    convenience init(title: String, highlighted: Bool = false) {
        self.init(frame: .zero)
        self.isHighlighedMenu = highlighted
        self.titleLabel.text = title
        setupView()
    }
    
    func addTarget(_ target: Any?, action selector: Selector, for event: UIControl.Event) {
        button.addTarget(target, action: selector, for: event)
    }
    
    private func setupView() {
        self.addSubview(button)
        updateButtonConstraint()
        
        self.addSubview(titleLabel)
        updateLabelAppearance()
        updateLabelConstraint()
    }
    
    private func updateButtonConstraint() {
        button.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func updateLabelAppearance() {
        titleLabel.font = .systemFont(ofSize: fontSize, weight: isHighlighedMenu ? highlightFontWeight : .regular)
        titleLabel.textColor = isHighlighedMenu ? highlightColor : normalColor
    }
    
    private func updateLabelConstraint() {
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(verticalMargin)
            maker.bottom.equalToSuperview().inset(verticalMargin)
            maker.leading.equalToSuperview().offset(horizontalMargin)
            maker.trailing.equalToSuperview().inset(horizontalMargin)
        }
    }
}
