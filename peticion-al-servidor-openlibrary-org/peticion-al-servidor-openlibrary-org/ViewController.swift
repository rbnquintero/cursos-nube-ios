//
//  ViewController.swift
//  peticion-al-servidor-openlibrary-org
//
//  Created by Ruben Quintero on 1/11/16.
//  Copyright © 2016 Ruben Quintero. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let isbnUrl = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"

    @IBOutlet var label: UILabel!
    @IBOutlet var textField: UITextField!
    @IBAction func search(sender: AnyObject) {
        let sesion = NSURLSession.sharedSession()
        if let isbnSearch = textField.text {
            print(isbnSearch)
            
            let completionHandler = {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                if(data?.length>0 && error==nil) {
                    if let text = NSString(data: data!, encoding: NSUTF8StringEncoding) {
                        print(text)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.label.text = text as String
                            self.label.hidden = false
                        })
                    }
                } else  if error != nil {
                    if let errorObj = error {
                        NSLog("Error: \(errorObj.localizedDescription)")
                    } else {
                        NSLog("Error: unknown");
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                    let alertController = UIAlertController(title: "Error", message: "Service not available", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in }
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true, completion:nil)
                    })
                }
            }
            
            let urlString = "\(isbnUrl)\(isbnSearch)"
            let url = NSURL(string: urlString)
            let request = NSURLRequest(URL: url!)
            let dt = sesion.dataTaskWithRequest(request, completionHandler: completionHandler)
            dt.resume()
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

