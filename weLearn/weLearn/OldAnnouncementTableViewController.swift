//
//  OldAnnouncementTableViewController.swift
//  weLearn
//
//  Created by Karen Fuentes on 2/27/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit

class OldAnnouncementsTableViewController: UITableViewController {
    
    fileprivate let reuseIdentifier = "AnnouncemntCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Past Announcements"
        
        tableView.register(AnnouncementTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 268.0
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! AnnouncementTableViewCell
        // Configure the cell...
        switch indexPath.row {
        case 0:
            cell.date.text = "02/28/2017"
            cell.quote.text = "You all got A's! Wow!"
            cell.author.text = "- Ben"
        case 1:
            cell.date.text = "02/12/2017"
            cell.quote.text = "There will be pizza."
            cell.author.text = "- Rina"
        case 2:
            cell.date.text = "02/10/2017"
            cell.quote.text = "TGIF."
            cell.author.text = "- Jason"
        case 3:
            cell.date.text = "02/07/2017"
            cell.quote.text = "We're having a Yu-Gi-Oh duel."
            cell.author.text = "- Louis"
        case 4:
            cell.date.text = "02/06/2017"
            cell.quote.text = "You're all working for Google."
            cell.author.text = "- Liz"
        default:
            cell.date.text = "02/14/2017"
            cell.quote.text = "You all got A's! Wow!"
            cell.author.text = "- Ben"
        }
        
        cell.bar.isHidden = true
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
