//
//  Scrolling.swift
//  PandemicTableView
//
//  Created by Yakov on 8/26/15.
//  Copyright (c) 2015 yakov. All rights reserved.
//

import UIKit

extension ViewController {
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        timer?.invalidate()
        
        isScrolling = true
        addingLoadingIndicator = false
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: Selector("loadFramesWhenScrolling"), userInfo: nil, repeats: true)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if dialogAndQuestionForSavingAndDisplaying.count < 8 {
            isScrolling = false
            countFramesForDisplayingAfterScrolling = 0
            callMainFunctionWithDelay(0.5)
            return
        }
        
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            isScrolling = false
            
            if areUnselectedButtonsDisplayed() {
                countFramesForDisplayingAfterScrolling = 0
                return
            }

//            displayDataAfterScrolling()
            callMainFunctionWithDelay(0.5)
        }
    }
    
    func loadFramesWhenScrolling() {
        countFramesForDisplayingAfterScrolling++
    }
    
    func displayDataAfterScrolling() {
        timer?.invalidate()
        
        while (countFramesForDisplayingAfterScrolling--) != 0 {
            if dialogSequence!.count != currentPhrase {
                addDialogFrame()
            }
        }
    }
    
    func areUnselectedButtonsDisplayed() -> Bool {
        var buttonIdentifier = dialogAndQuestionForSavingAndDisplaying.count - 2
        
        if buttonIdentifier > 2 &&
            dialogAndQuestionForSavingAndDisplaying[buttonIdentifier] == "buttonUnselected" &&
            dialogAndQuestionForSavingAndDisplaying[buttonIdentifier - 2] == "buttonUnselected" {
                return true
        }
        
        return false
    }
}