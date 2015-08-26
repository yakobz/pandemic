//
//  ViewController.swift
//  Pandemic_TableView
//
//  Created by Yakov on 8/5/15.
//  Copyright (c) 2015 yakov. All rights reserved.
//

// In this file contained all initial settings and main program (adding dialog frames, buttons
// and adding loading indicator)

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    var tableView = UITableView()
    
    let cellIdentifier = "Cell"
    
    var dialogAndQuestionForSavingAndDisplaying = Array<String>()
    // In this array (dialogAndQuestionForSavingAndDisplaying) will stored all dialogs and qestions
    // for displaying when you scroll up in table view or when you close app and open again.
    // For each dialog or question array contain two records: first record - is this text for
    // dialog cell or for button ('dialogFrame', 'buttonSelected' and 'buttonUnselected');
    // second record - text for disaplying. Example:
    //  ('dialogFrame',      'Hi!',
    //   'dialogFrame',      'My name is Taylor!',
    //   'buttonSelected',   'I understand',
    //   'buttonUnselected', 'I don't understand, can you repeat please?');
    
    var dialogSequence = Array<String>?()
    // This array will contain sequence of phrases from story to displaying. First time this array initialized in
    // 'viewDidLoad()' method. When you press one from choise buttons in this array will written new sequence
    // phrases from story to displaying. If after one sequence story contain one choise button, then this button is
    // skipped and sequence for this button added to previous sequence.
    
    var currentPhrase = 0
    // This variable used like index for displaying records from dialogSequence array. When we read next sequence of
    // phrases for choise button in this variable will write 0. When we display each record from dialogSequence array,
    // we increase this variable. When this variale will equal count of dialogSequence array - we displayed all phrases
    // and now we ready to display buttons.
    
    var questionsForButtons = Array<String>?()
    // In this array will stored questions for displaying and dialog identifiers for each question. Story in .html file
    // looks: 'dialog identifier': ... sequence of phrases ... 'question' -> 'dialog identifier', 'question' -> 'dialog
    // identifier'. You can look how story is look in folder Stories. So, this array can contain four records, or
    // nothing. First record: text of question for displaying; second record: dialog identifier (often question text and
    // dialog idfentifier are equals). Third record looks like first and fourths looks like second.
    
    var model = DataModel()
    // In DataModel class we will devide story on sequences of phrases and questions
    
    var audioPlayer = AVAudioPlayer()
    
    var isBackgroundMusicOff = true
    var isSystemMusicOff = true
    
    var addingLoadingIndicator = false
    // When we will add loading indicator some functions, required for table view, have other behaviour
    
    var countRows = 0
    
    var delayForMainFunction: Double = 2
    
    var timer: NSTimer?
    // This variable used when you scrolling - we must stop program
    
    var isScrolling = false
    // When you start scroll up table view adding reusable cell's, and in this moment variable addingLoadingIndicator
    // may be true. So we will use this variable, that display dialog frames and buttons instead loading indicator in
    // this situation

    var countFramesForDisplayingAfterScrolling = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackgroundImage()
        addTableView()
        addTopFrame()
        
        restoreData()
        // This method is defined in RestoringData.swift file
        
        // Will added setting panel, and music will setting there
        // Method turnOnMusic calling with delay because we don't want play music when cells restored
        // In method turnOnMusic called playBackgroundMusic()
        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("turnOnMusic"), userInfo: nil, repeats: false)
        // Method turnOnMusic() is defined in Music.swift
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mainFunction() {
        let willAddLoadingIndicator = dialogSequence!.count - currentPhrase
        // This variable used when we adding buttons. When we add buttons, we don't need add buttons.
        // Value of this variable computing before addNewCell() call, because after calling this method
        // for penultimate dialog frame, currentPhrase value increase by one and loading indicator will not added
        // after penultimate dialogFrame.
        
        addNewCell()
        // Will adding dialog frame or button
        
        if willAddLoadingIndicator != 0 {
            addLoadingIndicator()
        }
    }
    
    func addBackgroundImage() {
        let backgroundImageView = UIImageView(frame: getMainFrame())
        // Method getMainFrame() is defined in Sizes.swift file
        
        backgroundImageView.image = UIImage(named: "init.png")
        
        self.view.addSubview(backgroundImageView)
    }
    
    func addTableView() {
        tableView.frame = getFrameForTableView()
        // Method getFrameForTableView() is defined in Sizes.swift file
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        
        self.view.addSubview(tableView)
    }
    
    func addTopFrame() {
        let topFrameImageView = UIImageView(frame: getFrameForTopFrame())
        // Method getFrameForTopFrame() is defined in Sizes.swift file
        
        topFrameImageView.image = UIImage(named: "topFrame.png")
        
        self.view.addSubview(topFrameImageView)
    }
    
    func addNewCell() {
        addingLoadingIndicator = false
        
        if dialogSequence!.count == currentPhrase {
            addButtons()
        } else {
            addDialogFrame()
            callMainFunctionWithDelay(delayForMainFunction)
        }
    }
    
    func addButtons() {
        // Because we have two questions, we must call two times method getNextPhrase, and two times add new cells
        // in table
        
        if questionsForButtons == nil {
            // TODO: in this place will code for start game, or what we must to do when game is ended
            
            stopLoadingIndicator()
            return
        }
        
        var indexPath: NSIndexPath?
        
        for textIdentifier in [0, 2] {
            getNextPhrase(buttonTextIdentifier: textIdentifier)
            // We must read text for buttons from questionsForButtons array. It will first and third recors.
            
            let row = countRows - 1
            
            indexPath = NSIndexPath(forRow: row, inSection: 0)
            
            if let cell = tableView.cellForRowAtIndexPath(indexPath!) {
                // In this block we will one time - when we add first button - we add in last cell (indicator).
                // If we will delete indicator and then add cell - cell was go down, and then go up (it will look
                // not good). And after changing cell we must increase count of rows because next button will in
                // new cell.
                
                addCell(cell, row: row)
                
                countRows++
            } else {
                tableView.beginUpdates()
                tableView.insertRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Bottom)
                tableView.endUpdates()
                
                countRows++
            }
        }
        
        countRows--
        
        tableView.scrollToRowAtIndexPath(indexPath!, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        
        playSoundWhenButtonIsAppear()
        // This method is defined in Music.swift
    }
    
    func addDialogFrame() {
        // When this function calls first time - we add dialog frame in new cell, but in other times we will use
        // cells with indicator, so, in first time we increase count of rows, in other times we don't use it
        
        getNextPhrase()
        
        if countRows == 0 {
            countRows++
        }
        
        let row = countRows - 1
        
        let indexPath = NSIndexPath(forRow: row, inSection: 0)
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            addCell(cell, row: row)
        } else {
            tableView.beginUpdates()
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
            tableView.endUpdates()
        }
        
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
    }
    
    func getNextPhrase(buttonTextIdentifier: Int = 0) {
        if dialogSequence!.count == currentPhrase {
            dialogAndQuestionForSavingAndDisplaying.append("buttonUnselected")
            dialogAndQuestionForSavingAndDisplaying.append(questionsForButtons![buttonTextIdentifier])
        } else {
            dialogAndQuestionForSavingAndDisplaying.append("dialogFrame")
            dialogAndQuestionForSavingAndDisplaying.append(dialogSequence![currentPhrase++])
        }
    }
    
    func addLoadingIndicator() {
        addingLoadingIndicator = true
        
        countRows++
        
        let row = countRows - 1
        
        let indexPath = NSIndexPath(forRow: row, inSection: 0)
        
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
        tableView.endUpdates()
        
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
    }
    
    func stopLoadingIndicator() {
        // This method calls when game is finished
        
        let row = countRows - 1
        
        let indexPath = NSIndexPath(forRow: row, inSection: 0)
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let subviews = cell.backgroundView!.subviews
            
            for item in subviews {
                item.stopAnimating()
            }
        }
    }
}









