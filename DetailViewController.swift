//
//  DetailViewController.swift
//  PizzaMe
//
//  Created by RAVI RANDERIA on 7/15/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import UIKit




class DetailViewController: UIViewController {

    
    var currentPizzaLocation : PizzaLocationProtocol?
    var detailViewModel : DetailViewModelProtocol?
    
    var alert = UIAlertController()
    
    @IBOutlet weak var openInMapButtonOutlet: UIButton?
    @IBOutlet weak var phoneNumberButtonOutlet: UIButton?
    
    
    @IBAction func phoneNumberButtonAction(sender: UIButton) {
        
        if let currentPizza = currentPizzaLocation {
            if let phone = currentPizza.phone {
                print(phone)
                
            if let detailModel = self.detailViewModel {
                if let parsedNumber = detailModel.parsePhoneNumber(phone) {
                    if let url = NSURL(string: "tel://\(parsedNumber)") {
                        UIApplication.sharedApplication().openURL(url)
                    }
                    else{
                        self.displayAlert("Sorry call cannot be made")
                    }
                }else{
                    self.displayAlert("Sorry number is not valid")
                }
                }
                else{
                    self.displayAlert("Could not generate Detail Model")
                }
                
                
            }else{
                self.displayAlert("Sorry current pizza location does not have a number")
            }
        }
        else{
            self.displayAlert("Current Pizza Location cannot be found")
        }
    }
    
    @IBAction func openInMapButtonAction(sender: AnyObject) {
        
        
        if let currentPizza = currentPizzaLocation {
         
            if let detailModel = self.detailViewModel {
            if let lat = currentPizza.latitude,let long = currentPizza.longitude {
                detailModel.openMapForPlace(lat, long: long, venueName: currentPizza.title!)
            }
            else{
                self.displayAlert("Coordinates are not valid")
            }
            }
            else{
                self.displayAlert("Could not generate Detail Model")
            }
        }
        else{
            self.displayAlert("Current Location could not be found")
        }

        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailViewModel = ServiceFactory().detailViewModel
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func displayAlert(message : String) {
        alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
