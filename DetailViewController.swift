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
                    if let parsedNumber = detailModel.parsePhoneNumber(number: phone) {
                        if let url = URL(string: "tel://\(parsedNumber)") {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            self.displayAlert(message: "Sorry call cannot be made")
                        }
                    } else {
                        self.displayAlert(message: "Sorry number is not valid")
                    }
                }
                else{
                    self.displayAlert(message: "Could not generate Detail Model")
                }
                
                
            }else{
                self.displayAlert(message: "Sorry current pizza location does not have a number")
            }
        }
        else{
            self.displayAlert(message: "Current Pizza Location cannot be found")
        }
    }
    
    @IBAction func openInMapButtonAction(sender: AnyObject) {
        if let currentPizza = currentPizzaLocation {
            if let detailModel = self.detailViewModel {
                if let lat = currentPizza.latitude,let long = currentPizza.longitude {
                    detailModel.openMapForPlace(lat: lat, long: long, venueName: currentPizza.title!)
                } else {
                    self.displayAlert(message: "Coordinates are not valid")
                }
            } else {
                self.displayAlert(message: "Could not generate Detail Model")
            }
        } else {
            self.displayAlert(message: "Current Location could not be found")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailViewModel = ServiceFactory().detailViewModel
    }
    
    func displayAlert(message : String) {
        alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
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
