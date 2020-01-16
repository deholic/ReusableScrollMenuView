//
//  ViewController.swift
//  ReusableScrollMenuView
//
//  Created by KIM EUIGYOM on 01/16/2020.
//  Copyright (c) 2020 KIM EUIGYOM. All rights reserved.
//

import UIKit
import ReusableScrollMenuView

class ViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedSectionHeaderHeight = 50
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    let menuTitles = ["Company", "Position", "Career", "Lifestyle", "Topic", "Longcat is very long"]
    var currentMenuIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addTableView() {
        self.view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "numberCell")
        tableView.register(ReusableScrollMenuView.self, forHeaderFooterViewReuseIdentifier: ReusableScrollMenuView.reuseIdentifier)
        
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "numberCell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableScrollMenuView.reuseIdentifier) as? ReusableScrollMenuView else { return nil }
        view.bgColor = .systemBackground
        view.highlightColor = .systemOrange
        view.delegate = self
        view.dataSource = self
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

extension ViewController: ReusableScrollMenuViewDelegate {
    func headerMenuView(_ headerMenuView: ReusableScrollMenuView, didSelectMenu index: Int) {
        guard menuTitles.count > index else { return }
        self.currentMenuIndex = index
        
        print("Menu \(index): \(menuTitles[index])")
    }
}

extension ViewController: ReusableScrollMenuViewDataSource {
    func titlesForMenuView(_ menuView: ReusableScrollMenuView) -> [String] {
        return menuTitles
    }
    
    func selectedIndexForMenuView(_ menuView: ReusableScrollMenuView) -> Int? {
        return currentMenuIndex
    }
}
