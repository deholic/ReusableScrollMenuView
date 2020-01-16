//
//  ReusableScrollMenuView.swift
//  BigNavBar
//
//  Created by EUIGYOM KIM on 2020/01/15.
//  Copyright © 2020 EUIGYOM KIM. All rights reserved.
//

import UIKit
import SnapKit

protocol ReusableScrollMenuViewDelegate: class {
    func headerMenuView(_ headerMenuView: ReusableScrollMenuView, didSelectMenu index: Int)
}

protocol ReusableScrollMenuViewDataSource: class {
    func titlesForMenuView(_ menuView: ReusableScrollMenuView) -> [String]
    func selectedIndexForMenuView(_ menuView: ReusableScrollMenuView) -> Int?
}

class ReusableScrollMenuView: UITableViewHeaderFooterView {

    static let reuseIdentifier: String = String(describing: self)
    
    dynamic var normalColor: UIColor = .gray {
        didSet { updateAppearance() }
    }
    
    dynamic var highlightColor: UIColor = .black {
        didSet { updateAppearance() }
    }
    
    dynamic var highlightUnderlineHeight: CGFloat = 2.0 {
        didSet { updateAppearance() }
    }
    
    dynamic var fontSize: CGFloat = 14 {
        didSet { updateAppearance() }
    }
    
    dynamic var highlightFontWeight: UIFont.Weight = .bold {
        didSet { updateAppearance() }
    }
    
    dynamic var seperatorColor: UIColor = .lightGray {
        didSet { updateAppearance() }
    }
    
    dynamic var currentIndex: Int = 0 {
        didSet {
            if currentIndex != oldValue {
                updateMenuHighlight(at: [currentIndex, oldValue])
                updateHighlightBarLocation(to: currentIndex)
            }
        }
    }
    
    lazy private var menuStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = .zero
        return stackView
    }()
    
    lazy private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy private var separator: UIView = {
        let view = UIView()
        view.backgroundColor = self.seperatorColor
        return view
    }()
    
    lazy private var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy private var highlightBarView: UIView = {
        let view = UIView()
        view.backgroundColor = highlightColor
        return view
    }()
    
    weak var delegate: ReusableScrollMenuViewDelegate?
    weak var dataSource: ReusableScrollMenuViewDataSource? {
        didSet { setupViews() }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

extension ReusableScrollMenuView {
    @objc private func touchedMenuItem(_ sender: Any) {
        guard let itemView = (sender as? UIView)?.superview as? MenuItemView else { return }
        guard let selectedIndex = menuStackView.arrangedSubviews.firstIndex(of: itemView) else { return }
        currentIndex = selectedIndex
        delegate?.headerMenuView(self, didSelectMenu: selectedIndex)
    }
}

extension ReusableScrollMenuView {
    
    private func setupViews() {
        addBackgroudView()
        addScrollView()
        addMenuStackView()
        addHighlightBarView()
        addSeperator()
    }
    
    private func addBackgroudView() {
        self.addSubview(bgView)
        
        bgView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func addScrollView() {
        bgView.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func addMenuStackView() {
        guard let source = dataSource else { return }
        
        let menuTitles = source.titlesForMenuView(self)
        let highlightIndex = source.selectedIndexForMenuView(self) ?? 0
        
        guard menuTitles.count > highlightIndex else { return }
        
        menuTitles.enumerated().forEach { addMenuToStackView(title: $0.element, highlighted: $0.offset == highlightIndex) }
        
        scrollView.addSubview(menuStackView)
        
        menuStackView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
            maker.width.equalToSuperview().priority(.low)
            maker.height.equalToSuperview()
        }
    }
    
    private func addMenuToStackView(title: String, highlighted: Bool = false) {
        let view = MenuItemView(title: title, highlighted: highlighted)
        view.addTarget(self, action: #selector(touchedMenuItem(_:)), for: .touchUpInside)
        updateMenuViewAppearance(view)
        menuStackView.addArrangedSubview(view)
    }
    
    private func addHighlightBarView() {
        guard let source = dataSource else { return }
        
        let menuTitles = source.titlesForMenuView(self)
        let highlightIndex = source.selectedIndexForMenuView(self) ?? 0
        
        guard menuTitles.count > highlightIndex else { return }
        
        bgView.addSubview(highlightBarView)
        updateHighlightBarLocation(to: highlightIndex)
    }
    
    private func addSeperator() {
        self.addSubview(separator)
        
        separator.snp.makeConstraints { (maker) in
            maker.leading.bottom.trailing.equalToSuperview()
            maker.height.equalTo(0.5)
        }
    }
    
}

extension ReusableScrollMenuView {
    private func updateHighlightBarLocation(to index: Int?) {
        guard let selectedIndex = index, menuStackView.arrangedSubviews.count > selectedIndex else { return }
        
        let targetMenuView = menuStackView.arrangedSubviews[selectedIndex]
        
        highlightBarView.snp.remakeConstraints { (maker) in
            maker.leading.equalTo(targetMenuView.snp.leading)
            maker.trailing.equalTo(targetMenuView.snp.trailing)
            maker.bottom.equalToSuperview()
            maker.height.equalTo(highlightUnderlineHeight)
        }
        
        UIView.animate(withDuration: 0.2) { self.layoutIfNeeded() }
    }
    
    private func updateMenuHighlight(at indexes: [Int]) {
        indexes.compactMap { index -> (index: Int, view: MenuItemView)? in
            guard menuStackView.arrangedSubviews.count > index else { return nil }
            guard let menuView = menuStackView.arrangedSubviews[index] as? MenuItemView else { return nil }
            return (index: index, view: menuView)
        }.forEach {
            $0.view.isHighlighedMenu = $0.index == currentIndex
        }
    }
    
    private func updateAppearance() {
        separator.backgroundColor = seperatorColor
        updateMenuHighlight(at: [currentIndex])
        menuStackView.arrangedSubviews.compactMap({ $0 as? MenuItemView }).forEach({ updateMenuViewAppearance($0) })
    }
    
    private func updateMenuViewAppearance(_ view: MenuItemView) {
        view.fontSize = fontSize
        view.normalColor = normalColor
        view.highlightColor = highlightColor
        view.highlightFontWeight = highlightFontWeight
    }
}
