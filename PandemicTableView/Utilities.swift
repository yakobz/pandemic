//
//  Utilities.swift
//  Scroll messages
//
//  Created by Yakov on 7/20/15.
//  Copyright (c) 2015 Nicolas . All rights reserved.
//

import UIKit
import AVFoundation

extension ViewController {
    func callMainFunctionWithDelay(delay: Double) {
        timer = NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: Selector("mainFunction"), userInfo: nil, repeats: false)
    }
    
    func getNextDialogAndContinue(dialogIdentifier: String) {
        (dialogSequence, questionsForButtons) = model.getDialogAndQuestions(dialogIdentifier)
        currentPhrase = 0
        callMainFunctionWithDelay(2)
        
        addLoadingIndicator()
    }
    
    func getNumberOfLinesInString(str: String) -> Int {
        let maxNumberCharactersInOneLine: Int
        
        if self.view.frame.size.height == 480 {
            maxNumberCharactersInOneLine = 46
        } else {
            maxNumberCharactersInOneLine = 39
        }
        
        // Get array of words
        let arrayOfWordsInText = str.componentsSeparatedByString(" ")
        // Minimum number of lines is one
        var stringsAmount = 1
        var numberCharactersInOneLine = 0
        
        for word in arrayOfWordsInText {
            // Count characters
            numberCharactersInOneLine += count(word)
            
            if numberCharactersInOneLine > maxNumberCharactersInOneLine {
                stringsAmount++
                // This word will displaying in next line, so it character adding to number characters of new line
                numberCharactersInOneLine = count(word)
            }
            
            // It's for space
            numberCharactersInOneLine += 1
        }
        
        return stringsAmount
    }
    
    // Vertical alignment
    
    func makeVerticalAlignmentForTextInTextView(textView: UITextView) {
        let linesNumber = getNumberOfLinesInString(textView.text)
        
        if linesNumber%2 == 0 {
            alignmentForEvenNumberLines(linesNumber, textView: textView)
        } else {
            alignmentForOddNumberLines(linesNumber, textView: textView)
        }
    }
    
    func makeHorizontalAlignmentForTextInTextView(textView: UITextView) {
        textView.textAlignment = .Center
    }
    
    func alignmentForEvenNumberLines(numberLines: Int, textView: UITextView) {
        offsetTextViewVertically(textView)
        
        var countSpaces = 4 - Int(numberLines/2)
        
        while countSpaces > 0 {
            textView.text = "\n" + textView.text
            countSpaces--
        }
        
    }
    
    func alignmentForOddNumberLines(numberLines: Int, textView: UITextView) {
        var countSpaces = 3 - Int(numberLines/2)
        
        while countSpaces > 0 {
            textView.text = "\n" + textView.text
            countSpaces--
        }
    }
    
    // Hide status bar
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // Loading indicator
    
    func addIndicatorToImageView(imageView: UIImageView){
        imageView.animationImages = [UIImage]()
        
        for var index = 0; index < 30; index++ {
            var frameName = String(format: "loading@2x_%05d", index)
            imageView.animationImages?.append(UIImage(named: frameName)!)
        }
        
        imageView.animationDuration = 1
    }
    
}






