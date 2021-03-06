//
//  DataModel.swift
//  Scroll messages
//
//  Created by Yakov on 7/19/15.
//  Copyright (c) 2015 Nicolas . All rights reserved.
//

import Foundation

// This class is parces for .html files generated by program 'Twine'
// Before reading methods below, look at the story file (for now - LifelineExtract.html in Stories folder)

class DataModel {
    var story: String?
    
    init() {
        //Copy contents LifelineExtract.html file to string contentOfFile
        let path = NSBundle.mainBundle().pathForResource("LifelineExtract", ofType: "html")
        let contentOfFile = String(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil)
        
        //Get indexes of all symbols of "<tw-storydata" in contentOfFile
        //options: NSStringCompareOptions.LiteralSearch - exact character-by-character equivalence.
        //range: nil - search in all string
        var range = contentOfFile!.rangeOfString("<tw-storydata", options: NSStringCompareOptions.LiteralSearch, range: nil, locale: nil)
        
        //After teg <tw-storydata...> started our story
        var start = range!.endIndex
        
        //Story ended with teg </tw-storydata>
        //options: NSStringCompareOptions.BackwardsSearch - search from end of source string.
        range = contentOfFile!.rangeOfString("</tw-storydata", options: NSStringCompareOptions.BackwardsSearch, range: nil, locale: nil)
        
        //Get index where story is ended
        var end = range!.startIndex
        
        //Get story
        story = contentOfFile!.substringWithRange(start ..< end)
    }

    func getDialogAndQuestions(dialogName: String) -> (Array<String>?, Array<String>?) {
        var startIndex = story!.startIndex
        var endIndex = story!.endIndex
        
        var range: Range<String.Index>?
        
        //We search needed dialog with questions and references from questions to appropriate dialogue
        for teg in [" name=\"" + dialogName, "\">"] {
            range = story!.rangeOfString(teg, options: NSStringCompareOptions.LiteralSearch, range: startIndex ..< endIndex, locale: nil)

            //When loop will ended in startIndex we will hold index where dialogue is started in story
            startIndex = range!.endIndex
        }
        
        //Each dialogue ended with teg </tw-passagedata>
        range = story!.rangeOfString("</tw-passagedata>", options: NSStringCompareOptions.LiteralSearch, range: startIndex ..< endIndex, locale: nil)
        
        //This variable hold index where dialog is ended in story
        endIndex = range!.endIndex
        
        var dialogue = story!.substringWithRange(startIndex ..< endIndex)

        var dialogueArray = getDialogArray(dialogue)
        var questionsArray = getQuestionsArray(dialogue)
        
        if questionsArray != nil {
            if questionsArray!.count == 2 {
                // If we have one choise button - call this method again and add to arrays with dialogs and buttons
                // next dialog sequence
                
                var tempDialogueArray = Array<String>?()
            
                (tempDialogueArray, questionsArray) = getDialogAndQuestions(questionsArray![1])
            
                for item in tempDialogueArray! {
                    dialogueArray!.append(item)
                }
            }
        }
        
        return (dialogueArray, questionsArray)
    }
    
    func getDialogArray(dialogue: String) -> Array<String>? {
        var dialogArray = Array<String>()
        
        //Get end of dialogue (before questions)
        var range = dialogue.rangeOfString("\n\n[[", options: NSStringCompareOptions.LiteralSearch, range: dialogue.startIndex ..< dialogue.endIndex, locale: nil)

        //If this dialogue has no questions
        if range == nil {
            range = dialogue.rangeOfString("</tw-passagedata>", options: NSStringCompareOptions.LiteralSearch, range: dialogue.startIndex ..< dialogue.endIndex, locale: nil)
        }
        
        //In this variable we hold index of end dialogue without questions
        var endIndex = range!.startIndex
        
        var startIndex = dialogue.startIndex

        //Divide all dialogue on phrases and write them in array
        while true {
            //Get the end of qurrent phrase
            range = dialogue.rangeOfString("\n", options: NSStringCompareOptions.LiteralSearch, range: startIndex ..< endIndex, locale: nil)
            
            var singleExpression: String
            
            if range == nil {
                singleExpression = dialogue.substringWithRange(startIndex ..< endIndex)
            } else {
                singleExpression = dialogue.substringWithRange(startIndex ..< range!.startIndex)
            }
            
            //If this is empty string - we will not add it to array
            if  singleExpression != "" {
                //If phrase started from '-' symbol - delete this symbol
                if singleExpression.hasPrefix("-") {
                    singleExpression.removeAtIndex(singleExpression.startIndex)
                }
                
                dialogArray.append(replaceWrongSymbols(singleExpression))
            }
            
            if range == nil {
                break
            }
            
            //search next phrases and add them to array
            startIndex = range!.endIndex
        }
        
        return dialogArray
    }
    
    func getQuestionsArray(dialogue: String) -> Array<String>? {
        var questionsArray = Array<String>()

        //Get start of questions (after dialogue)
        var range = dialogue.rangeOfString("\n\n[[", options: NSStringCompareOptions.LiteralSearch, range: dialogue.startIndex ..< dialogue.endIndex, locale: nil)
        
        //If this dialogue has no questions
        if range == nil {
            return nil
        }
        
        //From this index will started text of first question
        var startIndex = range!.endIndex
        
        while true {
            //Get indexes where in sialogue first question is ended
            range = dialogue.rangeOfString("]]", options: NSStringCompareOptions.LiteralSearch, range: startIndex ..< dialogue.endIndex, locale: nil)
            
            var endFirstQuestionIndex = range!.endIndex
            
            //This variable hold text of first question and link to appropriate dialogue
            var question = dialogue.substringWithRange(startIndex ..< range!.startIndex)
            
            //If name of this question is not equal to name of approprate dialogue, find link to next dialogue
            //In html file question and link to next dialogue separated by " -&gt;"
            //If name of this question is equal to name of approprate dialogue, the question name it is link
            range = question.rangeOfString(" -&gt;", options: NSStringCompareOptions.LiteralSearch, range: question.startIndex ..< question.endIndex, locale: nil)
            
            if range == nil {
                questionsArray.append(replaceWrongSymbols(question))
                questionsArray.append(question)
            } else {
                var questionText = question.substringWithRange(question.startIndex ..< range!.startIndex)
                var linkToNextDialogue = question.substringWithRange(range!.endIndex ..< question.endIndex)
                
                questionsArray.append(replaceWrongSymbols(questionText))
                questionsArray.append(linkToNextDialogue)
            }
            
            range = dialogue.rangeOfString("[[", options: NSStringCompareOptions.LiteralSearch, range: endFirstQuestionIndex ..< dialogue.endIndex, locale: nil)

            if range == nil {
                break
            }
            
            startIndex = range!.endIndex
        }
        
        return questionsArray
    }
    
    func replaceWrongSymbols(var string: String) -> String {
        // In story ' sign and " sign writen like &#x27; and &quot;
        // In this method we replace strange symbols to normal
        
        for (wrongSymbol, normalSymbol) in [("&#x27;", "'"), ("&quot;", "\"")] {
            while true {
                var range = string.rangeOfString(wrongSymbol, options: NSStringCompareOptions.LiteralSearch, range: string.startIndex ..< string.endIndex, locale: nil)
                
                if range == nil {
                    break
                }
                
                string.replaceRange(range!, with: normalSymbol)
            }
        }
        
        return string
    }
}