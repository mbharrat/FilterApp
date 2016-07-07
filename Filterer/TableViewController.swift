//
//  TableViewController.swift
//  Filterer
//
//  Created by Michael Bharrat on 6/28/16.
//  Copyright © 2016 Michael Bharrat. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView! //tableview
    
    let filters = [
        "hi",
        "Red",
        "Blue",
        "Bright",
        "B/W"
    ]
    
    
    //delegate handles actions and user interface
    //delegate uses protocols
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        print("hi")
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FilterCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = "hi"
        return cell
    }
    
    

}