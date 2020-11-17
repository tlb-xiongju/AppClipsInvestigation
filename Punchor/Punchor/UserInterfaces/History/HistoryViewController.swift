//
//  HistoryViewController.swift
//  Punchor
//
//  Created by 熊 炬 on 2020/11/17.
//

import UIKit

class HistoryViewController: UITableViewController {
    
    var monthRecords: MonthRecords? {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let className = String(describing: HistoryHeaderView.self)
        let nib = UINib(nibName: className, bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: className)
        
        let cellName = String(describing: HistoryCell.self)
        let cellNib = UINib(nibName: cellName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellName)
        
        tableView.tableFooterView = .init()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        monthRecords?.records.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellName = String(describing: HistoryCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath)
        // TODO:
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let className = String(describing: HistoryHeaderView.self)
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: className)
        return view
    }
}
