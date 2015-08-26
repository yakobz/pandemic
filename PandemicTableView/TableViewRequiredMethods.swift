//
//  TableViewRequiredMethods.swift
//  Pandemic_TableView
//
//  Created by Yakov on 8/4/15.
//  Copyright (c) 2015 yakov. All rights reserved.
//

// This file contain all required methods for table view and some auxiliary function

import UIKit

extension ViewController {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countRows
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        let row = indexPath.row
        
        addCell(cell, row: indexPath.row)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return getHeightForDialogFrame()
        // Method getHeightForDialogFrame() is defined in Sizes.swift file
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // We can select only last cells, if we scrolling up, we can't select cell
        
        if indexPath.row < dialogAndQuestionForSavingAndDisplaying.count/2 - 2 {
            return
        }
        
        // We select cells in one case: when last two cells are buttons, and they still not selected
        
        let buttonIdentifier = dialogAndQuestionForSavingAndDisplaying.count - 2
        
        if dialogAndQuestionForSavingAndDisplaying[buttonIdentifier] == "buttonUnselected" &&
            dialogAndQuestionForSavingAndDisplaying[buttonIdentifier - 2] == "buttonUnselected" {
                
                dialogAndQuestionForSavingAndDisplaying[indexPath.row*2] = "buttonSelected"
                
                let cell = tableView.cellForRowAtIndexPath(indexPath)
                let imageView = cell!.backgroundView!.subviews[0] as! UIImageView
                imageView.image = UIImage(named: "buttonSelected")
                
                var nextDialogIdentifier = dialogAndQuestionForSavingAndDisplaying.count - indexPath.row*2 - 1
                // When we make this calculation, we can get two values - one or three. But we substract from count
                // of all elements in dialogAndQuestionForSavingAndDisplaying array button index + 1, and for first button
                // we obtain index 3, for second button - 1. Example: we have dialogAndQuestionForSavingAndDisplaying array:
                //  ('dialogFrame',      'Hi!',
                //   'dialogFrame',      'My name is Taylor!',
                //   'buttonSelected',   'I understand',
                //   'buttonUnselected', 'I don't understand, can you repeat please?');
                
                // It's mean, that we have questionsForButtons array:
                //   'I understand', 'Next dialog identifier'
                //   'I don't understand, can you repeat please?', 'Next dialog identifier');
                
                // Count for dialogAndQuestionForSavingAndDisplaying array = 8. If we push first button (5th and 6th
                // records), for cell it will row = 2, and var nextDialogIdentifier will equal 3. In questionsForButtons
                // array for index = 3 matches link to dialog for second button (not first), and we must change value
                // nextDialogIdentifier to one.
                
                if nextDialogIdentifier == 1 {
                    nextDialogIdentifier = 3
                } else {
                    nextDialogIdentifier = 1
                }
                
                getNextDialogAndContinue(questionsForButtons![nextDialogIdentifier])
                // This method is defined in Utilities.swift
                
                playSoundWhenButtonIsPressed()
                // This method is defined in Music.swift
        }
    }
    
    func addCell(cell: UITableViewCell, row: Int) {
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.backgroundColor = UIColor.clearColor()
        cell.backgroundView = UIView()
        
        // If we start scrolling up, then down and back to end can happened, that we must add loading
        // indicator. In this case dialogAndQuestionForSavingAndDisplaying will not have records for
        // this row
        if addingLoadingIndicator == true || (isScrolling && dialogAndQuestionForSavingAndDisplaying.count == row*2) {
            addLoadingIndicatorInCell(cell)
            return
        }
        
        addBackgroundImageForCell(cell, imageIdentifier: dialogAndQuestionForSavingAndDisplaying[row*2])
        // This record (dialogAndQuestionForSavingAndDisplaying[row*2]) will contain 'dialogFrame', 'buttonSelected'
        // and 'buttonUnselected'. And files with needed images calls similar
        
        addTextInCell(cell, row: row)
        
        cell.alpha = 0
        
        UIView.animateWithDuration(1, animations: {
            cell.alpha = 1
        })
    }
    
    func addBackgroundImageForCell(cell: UITableViewCell, imageIdentifier: String) {
        let imageView = UIImageView(image: UIImage(named: imageIdentifier))
        
        if imageIdentifier != "dialogFrame" {
            imageView.frame = getFrameForButtonInCell(cell)
            // This method is defined in Sizes.swift
        } else {
            imageView.frame = getFrameForDialogFrameInCell(cell)
            // This method is defined in Sizes.swift
        }
        
        cell.backgroundView!.addSubview(imageView)
    }
    
    func addTextInCell(cell: UITableViewCell, row: Int) {
        let textIndex = row*2 + 1
        // In dialogAndQuestionForSavingAndDisplaying array for this index match phrase for displaying
        
        let textView = UITextView()
        textView.frame = getFrameForTextViewInCell(cell)
        // This method is defined in Sizes.swift
        
        textView.backgroundColor = UIColor.clearColor()
        
        textView.editable = false
        textView.selectable = false
        
        textView.font = UIFont(name: "Courier New", size: getSizeForText())
        // Method getSizeForText() is defined in Sizes.swift
        
        textView.text = dialogAndQuestionForSavingAndDisplaying[textIndex]
        
        if dialogAndQuestionForSavingAndDisplaying[textIndex - 1] == "buttonSelected" ||
            dialogAndQuestionForSavingAndDisplaying[textIndex - 1] == "buttonUnselected"{
                textView.textColor = UIColor.whiteColor()
                textView.textAlignment = .Center
        } else if textView.text[textView.text.startIndex] == "[" {
            textView.textColor = UIColor.statusGreen()
            // Method statusGreen() defined in Colors.swift
            
            textView.textAlignment = .Center
            
            // If we display previous cells we don't must play music
            if dialogAndQuestionForSavingAndDisplaying.count/2 == row + 1 {
                playSoundForStatusCell()
                //This method is defined in Music.swift
            }
        } else {
            textView.textColor = UIColor.dialogBlue()
            // Method dialogBlue() defined in Colors.swift
            
            if dialogAndQuestionForSavingAndDisplaying.count/2 == row + 1 {
                playSoundForDialogCell()
                //This method is defined in Music.swift
            }
        }
        
        makeVerticalAlignmentForTextInTextView(textView)
        // This method is defined in Utilities.swift
        
        cell.backgroundView!.addSubview(textView)
    }
    
    func addLoadingIndicatorInCell(cell: UITableViewCell) {
        let imageView = UIImageView(frame: getFrameForLoadingIndicator())
        // Method getFrameForLoadingIndicator() defined in Sizes.swift
        
        addIndicatorToImageView(imageView)
        // This method defined in Utilities.swift
        
        cell.backgroundView!.addSubview(imageView)
        
        imageView.startAnimating()
    }
    
}








