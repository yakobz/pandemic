//
//  RestoringData.swift
//  Pandemic_TableView
//
//  Created by Yakov on 8/15/15.
//  Copyright (c) 2015 yakov. All rights reserved.
//

import UIKit

extension ViewController {
    func saveData() {
        // This method calls when you push home button
        
        var userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.setObject(dialogAndQuestionForSavingAndDisplaying, forKey: "dialogAndQuestions")
        userDefaults.setObject(dialogSequence, forKey: "dialogSequence")
        userDefaults.setObject(questionsForButtons, forKey: "questionsForButtons")
        userDefaults.setInteger(currentPhrase, forKey: "currentPhrase")
    }
    
    func restoreData() {
        // Comment this line and data will restored.
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
        
        var userDefaults = NSUserDefaults.standardUserDefaults()
        
        if userDefaults.objectForKey("dialogSequence") == nil {
            (dialogSequence, questionsForButtons) = model.getDialogAndQuestions("0")
            // (dialogSequence, questionsForButtons) = model.getDialogAndQuestions("Death Display System Message")
            // This comment line for testing behaviour program for last dialog

            callMainFunctionWithDelay(2)
            // This method is defined in Utilities.swift
            
            return
        }
        
        dialogAndQuestionForSavingAndDisplaying = (userDefaults.objectForKey("dialogAndQuestions") as? Array<String>)!
        dialogSequence = userDefaults.objectForKey("dialogSequence") as? Array<String>
        questionsForButtons = userDefaults.objectForKey("questionsForButtons")as? Array<String>
        currentPhrase = userDefaults.integerForKey("currentPhrase")
        
        displaySavedData()
        
        let indexPath = NSIndexPath(forRow: tableView.numberOfRowsInSection(0) - 1, inSection: 0)
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
    }
    
    func displaySavedData() {
        let test = dialogAndQuestionForSavingAndDisplaying.count/2
        
        for var row = 0; row < dialogAndQuestionForSavingAndDisplaying.count/2; row++ {
            countRows++
            let indexPath = NSIndexPath(forRow: row, inSection: 0)
            tableView.beginUpdates()
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            tableView.endUpdates()
        }
        
        let buttonUnselectedIndicator = countRows*2 - 2
        
        if dialogAndQuestionForSavingAndDisplaying[buttonUnselectedIndicator] != "buttonUnselected" &&
            dialogAndQuestionForSavingAndDisplaying[buttonUnselectedIndicator - 2] != "buttonUnselected" {
            // We call addLoadingIndicator() after 0.1 sec because if we will call this method without delay,
            // cell with dialog frame will not added in table, and after adding loading indicator, all cells will
            // with loading indicator
            
            NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("addLoadingIndicator"), userInfo: nil, repeats: false)
            
            callMainFunctionWithDelay(2)
            // This method is defined in Utilities.swift
        }
    }
}







