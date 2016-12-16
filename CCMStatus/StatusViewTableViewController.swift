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
    var endpointApiData: [EndpointsCategory]?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.separatorColor = UIColor.clear
        
        StatusDataService.sharedInstance.refreshData { (endpoints, error) in
            
            DispatchQueue.main.async {
                self.endpointApiData = endpoints
                self.tableView.reloadData()
            }
            
        }
        
        tableView.tableHeaderView = makeHeaderView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func makeHeaderView() -> UIView{
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 200))
        if let image = UIImage(named: "SEATTLEBAY") {
            let imageView = UIImageView(image: image)
            imageView.frame = headerView.frame
            imageView.contentMode = UIViewContentMode.scaleAspectFill
            headerView.addSubview(imageView)
        }
        
        let timeLabel = UILabel(frame: headerView.frame)
        headerView.addSubview(timeLabel)
        timeLabel.text = "Refreshed every 20 minutes"
//        timeLabel.font = UIFont.systemFontOfSize(12, weight: UIFontWeightUltraLight)
        timeLabel.font = UIFont.italicSystemFont(ofSize: 12)
        timeLabel.textColor = UIColor.white
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addConstraints([
            NSLayoutConstraint(item: headerView, attribute: .bottomMargin, relatedBy: .equal, toItem: timeLabel, attribute: .bottom, multiplier: 1, constant: 15),
            NSLayoutConstraint(item: headerView, attribute: .leadingMargin, relatedBy: .equal, toItem: timeLabel, attribute: .leading, multiplier: 1, constant: 0)
            
        ])
        
        
        
        
        headerView.backgroundColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1.0)
        headerView.clipsToBounds = true
        
        return headerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let endpointApiData = endpointApiData else {
            return 0
        }
        
        return endpointApiData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let endpointApiData = endpointApiData else {
            return 0
        }
        
        return endpointApiData[section].endpoints?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let endpointApiData = endpointApiData else {
            return tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! StatusTableViewCell
        let endpointDescribed = endpointApiData[indexPath.section].endpoints![indexPath.row]
        
        cell.endpointName.text = endpointDescribed.getEndpointName()
        
        if let statusCode =  endpointDescribed.statusCode, statusCode >= 200 && statusCode < 400 {
            cell.endpointResponseTimeLabel.text = String(endpointDescribed.responseTime ?? 0) + " ms"
            cell.statusBarView.currentRange = endpointDescribed.responseTime ?? 20
            cell.statusBarView.isHidden = false
            
        } else {
            cell.endpointResponseTimeLabel.text = "ERROR RESPONSE"
            cell.statusBarView.isHidden = true
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let wholeView = UIView(frame: CGRect.zero)
//        let thinLine =  UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: tableView.frame.width, height: 0.5)))
//        thinLine.backgroundColor = UIColor(red: 0.51, green: 0.52, blue: 0.53, alpha: 1.00)
//        wholeView.addSubview(thinLine)
        return wholeView
        
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }

    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return 0
//        }
        return 37
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let view = view as? UITableViewHeaderFooterView else {
            print ("Not a UITableViewHeaderFooterView" )
            return
        }
        
        var endpointName = ""
        
        if let endpointApiData = endpointApiData {
            endpointName = endpointApiData[section].categoryName ?? ""
        }
        
        
        view.textLabel?.textColor = UIColor.black
        view.backgroundView = nil
        view.tintColor = UIColor.clear
        view.textLabel?.textColor = UIColor.black
        view.textLabel?.text = endpointName
        view.textLabel?.frame = view.frame
        view.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightUltraLight)
        
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
