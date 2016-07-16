//
//  ViewController.swift
//  PizzaMe
//
//  Created by RAVI RANDERIA on 7/15/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import UIKit
import CoreLocation

class PizzaListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var pizzaList = [PizzaLocationProtocol]()
    
    var serviceFactory = ServiceFactory()
    var pizzaListViewModel : PizzaListViewModelProtocol?
    var refreshControl: UIRefreshControl!


    var alert = UIAlertController()

    @IBOutlet weak var pizzaListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.startAgain()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(PizzaListViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        pizzaListTableView.addSubview(refreshControl) // not required when using UITableViewController
        
        self.pizzaListTableView.delegate = self
        self.pizzaListTableView.dataSource = self
        
     }
    
    func stopAnimations(){
        self.activityIndicator.stopAnimating()
        self.refreshControl.endRefreshing()
    }
    
    func refresh(sender:AnyObject) {
        self.startAgain()
    }
    
    
    func startAgain() {
        
        activityIndicator.startAnimating()
        if pizzaListViewModel == nil {
            serviceFactory.pizzaListViewModel { (pizzaListModel, error) in
                if let pizzaModel = pizzaListModel {
                    self.pizzaListViewModel = pizzaModel
                    self.retrievePizzaList()
                }
                else{
                    self.displayAlert(String(error))
                }
            }
        }
        else{
            self.retrievePizzaList()
        }
        
    }
    
    
    func retrievePizzaList() {
        if let pizzaViewModel = self.pizzaListViewModel {
            pizzaViewModel.retrievePizzaList { (pizzaList,error) in
            
                dispatch_async(dispatch_get_main_queue(), {

                    if let pizzaList = pizzaList {
                
                        self.pizzaList = pizzaList
                        self.pizzaListTableView.reloadData()
                    }
                    else{
                        if error != nil {
                            self.displayAlert(String(error))
                        }
                    }
                    self.stopAnimations()
                })
            }
        }
        else{
            self.displayAlert("Could not generate pizza view model")
        }
 
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pizzaList.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PizzaInformationCell
        
        cell.nameLabel.text = pizzaList[indexPath.row].title
        
        if let city = (pizzaList[indexPath.row].city) {
        cell.cityLabel.text = city
        }
        else{
            cell.cityLabel.text = "N/A"
        }
        
        if let state = (pizzaList[indexPath.row].state) {
        cell.stateLabel.text = state
        }
        else{
            cell.stateLabel.text = "N/A"
        }
        
        if let address = (pizzaList[indexPath.row].address) {
            cell.addressLabel.text = address
        }
        else{
            cell.addressLabel.text = "N/A"
            
        }
        
        if let distance = (pizzaList[indexPath.row].distance) {
            cell.distanceLabel.text = String(distance)
        }
        else{
            cell.distanceLabel.text = "N/A"
   
        }
        
        return cell
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetail" {
            let destinationVC = segue.destinationViewController as! DetailViewController
            destinationVC.currentPizzaLocation = pizzaList[self.pizzaListTableView.indexPathForSelectedRow!.row]
        }
        
    }
   
    
    func displayAlert(message : String) {
        alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { (alert) in
            self.stopAnimations()
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

}

