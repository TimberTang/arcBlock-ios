//
//  ViewController.swift
//  ArcBlock
//
//  Created by TimberTang on 2020/7/17.
//

import UIKit

class ListViewController: UITableViewController {

    fileprivate var dataSource: [ArcItem] = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadDataFromJson()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < dataSource.count else {
            return .init()
        }
        let dataItem = dataSource[indexPath.row]
        if dataItem.type == .text {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ArcTextTableViewCell.registrableReuseIdentifier) as? ArcTextTableViewCell  else {
                return .init()
            }
            cell.configCell(with: dataItem)
            return cell
        }
        if dataItem.type == .textLink {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ArcLinkTableViewCell.registrableReuseIdentifier) as? ArcLinkTableViewCell  else {
                return .init()
            }
            cell.configCell(with: dataItem)
            return cell
        }
        if dataItem.type == .image || dataItem.type == .textImage {
            if dataItem.imgUrls?.count ?? 0 > 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ArcMutipleImageTableViewCell.registrableReuseIdentifier) as? ArcMutipleImageTableViewCell  else {
                    return .init()
                }
                cell.config(cell: dataItem)
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ArcImageTableViewCell.registrableReuseIdentifier) as? ArcImageTableViewCell  else {
                    return .init()
                }
                cell.configCell(with: dataItem)
                return cell
            }
        }
            
        return .init()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let arcItem = dataSource[indexPath.row]
        if arcItem.type == .textLink {
            let webVC = WebViewViewController(arcItem.link, webTitle: "")
            navigationController?.pushViewController(webVC, animated: true)
            return
        }
        let detailVC = DetailViewViewController(with: arcItem)
        navigationController?.pushViewController(detailVC, animated: true)
    }

}

fileprivate extension ListViewController {
    func loadDataFromJson() {
        guard let urlPath = Bundle.main.path(forResource: "data", ofType: "json") else { return }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: urlPath))
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            print("present = ", jsonData)
            let decoder = JSONDecoder()
            let listData = try decoder.decode(ResponseData.self, from: data)
            self.dataSource = listData.data
            tableView.reloadData()
        } catch let error {
            print(error)
        }
    }
}

fileprivate extension ListViewController {
    func setupUI () {
        title = "Arc List"
        setupTableView()
    }
    func setupTableView () {
        view.backgroundColor = .white
        
        tableView.separatorColor = UIColor.lightGray
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.tableFooterView = .init()
        tableView.register(ArcTextTableViewCell.nib, forCellReuseIdentifier: ArcTextTableViewCell.registrableReuseIdentifier)
        tableView.register(ArcImageTableViewCell.nib, forCellReuseIdentifier: ArcImageTableViewCell.registrableReuseIdentifier)
        tableView.register(ArcLinkTableViewCell.nib, forCellReuseIdentifier: ArcLinkTableViewCell.registrableReuseIdentifier)
        tableView.register(ArcMutipleImageTableViewCell.nib, forCellReuseIdentifier: ArcMutipleImageTableViewCell.registrableReuseIdentifier)
    }
}


