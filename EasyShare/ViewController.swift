//
//  ViewController.swift
//  EasyShare
//
//  Created by Muya on 21/09/2015.
//  Copyright © 2015 muya. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController {
    @IBOutlet weak var noteTextView: UITextView!

    @IBAction func showShareOptions(sender: AnyObject) {
        // first dismiss keyboard
        dismissKeyboard()
        
        if self.noteTextView.text.characters.count < 1 {
            self.showAlertMessage("Why don't you write something first? 😉", alertActionHandler: {
                (alert: UIAlertAction!)
                in self.showKeyboard()
            })
            return
        }
        
        let actionSheet = UIAlertController(title: "", message: "Share your note", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let tweetAction = UIAlertAction(title: "Share on Twitter", style: .Default, handler: {
            (action) -> Void in
            // check if sharing to twitter is possible
            // check character length
            let charCount = self.noteTextView.text.characters.count
            if charCount > 140 {
                self.showAlertMessage("Sorry, Twitter has a 140 characters limit. You have \(charCount)", alertActionHandler: {
                    (alert: UIAlertAction!) in
                    self.showKeyboard()
                })
                return
            }
            
            // check availability of service
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                let twitterComposerVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                twitterComposerVC.setInitialText(self.noteTextView.text)
                self.presentViewController(twitterComposerVC, animated: true, completion: nil)
            }
            else {
                self.showAlertMessage("You are not logged in to your Twitter Account :(")
            }
        })
        
        let facebookPostAction = UIAlertAction(title: "Share on Facebook", style: .Default, handler: {
            (action) -> Void in
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                let fbComposerVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                fbComposerVC.setInitialText(self.noteTextView.text)
                self.presentViewController(fbComposerVC, animated: true, completion: nil)
            }
            else {
                self.showAlertMessage("You are not logged in to your Facebook Account")
            }
        })
        
        let moreAction = UIAlertAction(title: "More", style: .Default, handler: {
            (action) -> Void in
            let activityViewController = UIActivityViewController(activityItems: [self.noteTextView.text], applicationActivities: nil)
            activityViewController.excludedActivityTypes = [UIActivityTypeMail]
            self.presentViewController(activityViewController, animated: true, completion: nil)
        })
        
        let dismissAction = UIAlertAction(title: "Close", style: .Cancel, handler: {
            (action) -> Void in
        })
        
        actionSheet.addAction(tweetAction)
        actionSheet.addAction(facebookPostAction)
        actionSheet.addAction(moreAction)
        actionSheet.addAction(dismissAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showAlertMessage(message: String, var alertTitle: String?=nil, var alertStyle: UIAlertActionStyle?=nil, alertActionHandler: ((UIAlertAction) -> Void)?=nil) {
        let alertController = UIAlertController(title: "EasyShare", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        // check for default values
        // title
        if alertTitle == nil {
            alertTitle = "Okay"
        }
        
        // alert style
        if alertStyle == nil {
            alertStyle = UIAlertActionStyle.Default
        }
        
        alertController.addAction(UIAlertAction(title: alertTitle!, style: alertStyle!, handler: alertActionHandler))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // make textview have rounded borders and border line
    func configureNoteTextView() {
        noteTextView.layer.cornerRadius = 8.0
        noteTextView.layer.borderColor = UIColor(white: 0.75, alpha: 0.5).CGColor
        noteTextView.layer.borderWidth = 1.2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureNoteTextView()
        
        // dismiss keyboard
        // look for single/multiple taps
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    func showKeyboard() -> Void {
        self.noteTextView.becomeFirstResponder()
    }

}

