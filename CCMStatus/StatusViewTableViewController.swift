//
//  StatusViewTableViewController.swift
//  CCMStatus
//
//  Created by Johann Garces on 12/11/16.
//  Copyright © 2016 johannmg. All rights reserved.
//

import UIKit

class StatusViewTableViewController: UITableViewController {
    
    let cellIdentifier = "statusCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        StatusDataService.sharedInstance.refreshData { (endpoints, error) in
            print (endpoints)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.tableHeaderView = makeHeaderView()
        
    }
    
    func makeHeaderView() -> UIView{
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 150))
        headerView.backgroundColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1.0)
        
        return headerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let thinLine =  UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: tableView.frame.width, height: 1.0)))
        thinLine.backgroundColor = UIColor(red: 0.51, green: 0.52, blue: 0.53, alpha: 1.00)
        return thinLine
        
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
//    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = UIView()
//        header.backgroundColor = UIColor.clearColor()
//        
//        let label = UILabel( frame: CGRect(origin: CGPoint(x: 8, y: 0), size: CGSizeZero))
//        label.text = "Header"
//        label.textColor = UIColor.blackColor()
//        label.font = UIFont(name: ".SFUIText-Light", size: 24)
//        
//        header.addSubview(label)
//        return header
//    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let view = view as? UITableViewHeaderFooterView else {
            print ("Not a UITableViewHeaderFooterView" )
            return
        }
        
        view.textLabel?.textColor = UIColor.blackColor()
        view.backgroundView = nil
        view.tintColor = UIColor.clearColor()
        view.textLabel?.textColor = UIColor.blackColor()
        view.textLabel?.text = "Section"
        view.textLabel?.frame = view.frame
        view.textLabel?.font = UIFont.systemFontOfSize(24, weight: UIFontWeightUltraLight)
        
    }
    
    /**
     - (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
     UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
     
     header.textLabel.textColor = [UIColor redColor];
     header.textLabel.font = [UIFont boldSystemFontOfSize:18];
     CGRect headerFrame = header.frame;
     header.textLabel.frame = headerFrame;
     header.textLabel.textAlignment = NSTextAlignmentCenter;
     }
     */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
