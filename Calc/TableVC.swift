//
//  TableVC.swift
//  Calc
//
//  Created by Evgeniy Kolesin on 08.09.16.
//  Copyright © 2016 Evgeniy Kolesin. All rights reserved.
//

import UIKit

class TableVC: UITableViewController {
    
    var TableArray = [String]()
    
    override func viewDidLoad() {
        TableArray = ["Калькулятор","Фото","Камера"]
        
        tableView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        self.tableView.rowHeight = 75
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableArray[(indexPath as NSIndexPath).row], for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = TableArray[(indexPath as NSIndexPath).row]
        cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        cell.textLabel?.textColor = UIColor.orange
        cell.textLabel?.font = UIFont(name:"Helvetica Neue", size:18)
        return cell
    }
    
}

