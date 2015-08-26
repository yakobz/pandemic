//
//  Sizes.swift
//  Pandemic_TableView
//
//  Created by Yakov on 8/4/15.
//  Copyright (c) 2015 yakov. All rights reserved.
//

// This file contain all functions for working with sizes

import UIKit

extension ViewController {
    
    // Frames:
    
    func getFrameForTopFrame() -> CGRect {
        return CGRect(  x: 0,
                        y: 0,
                        width: self.view.frame.size.width,
                        height: self.view.frame.size.width/5)
    }
    
    func getFrameForTableView() -> CGRect {
        return CGRect(  x: self.view.frame.width/15,
                        y: self.view.frame.height/20,
                        width: self.view.frame.size.width - 2*self.view.frame.width/15,
                        height: self.view.frame.size.height - 2*self.view.frame.height/20 - self.view.frame.height/50)
    }
    
    func getMainFrame() -> CGRect {
        return self.view.frame
    }    
    
    func getFrameForTextViewInCell(cell: UITableViewCell) -> CGRect {
        var frameForTextViewInCell = cell.frame
        
        switch mainHeight() {
        case iPhone4Height():
            frameForTextViewInCell.origin.y = self.view.frame.size.height*0.022
        case iPhone5Height():
            frameForTextViewInCell.origin.y = self.view.frame.size.height*0.022
        case iPhone6Height():
            frameForTextViewInCell.origin.y = self.view.frame.size.height*0.025
        default:
            frameForTextViewInCell.origin.y = self.view.frame.size.height*0.026
        }
        
        frameForTextViewInCell.origin.x = self.view.frame.size.width*0.04

        frameForTextViewInCell.size.width = self.view.frame.size.width*0.785
        frameForTextViewInCell.size.height = self.view.frame.size.height*0.18
        
        return frameForTextViewInCell
    }
    
    func getFrameForButtonInCell(cell: UITableViewCell) -> CGRect {
        var frameForButtonInCell = cell.frame
        
        frameForButtonInCell.origin.x = self.view.frame.size.width*0.02
        frameForButtonInCell.origin.y = self.view.frame.size.height*0.011
        frameForButtonInCell.size.width = self.view.frame.size.width*0.825
        frameForButtonInCell.size.height = self.view.frame.size.height*0.2
        
        return frameForButtonInCell
    }
    
    func getFrameForLoadingIndicator() -> CGRect {
        let width: CGFloat = self.view.frame.size.height/18
        let height: CGFloat = self.view.frame.size.height/25
        let x: CGFloat = self.view.frame.size.width/2.7
        let y: CGFloat = 0
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func getFrameForDialogFrameInCell(cell: UITableViewCell) -> CGRect {
        return CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
    }
    
    // Sizes
    
    func getHeightForDialogFrame() -> CGFloat {
        return self.view.frame.size.height/4.5
    }
    
    func getSizeForText() -> CGFloat {
        return self.view.frame.size.height*0.018
    }
    
    func mainHeight() -> CGFloat {
        return self.view.frame.size.height
    }
    
    
    // Heights
    
    func iPhone4Height() -> CGFloat {
        return 480
    }
    
    func iPhone5Height() -> CGFloat {
        return 568
    }

    func iPhone6Height() -> CGFloat {
        return 667
    }
    
    func iPhone6PlusHeight() -> CGFloat {
        return 736
    }
    
    func getCellHeightForLoadingIndicator() -> CGFloat {
        return self.view.frame.height/10
    }

    
    // Offset
    
    // This function used for vertical alignment (text view offset for y coordinate)
    func offsetTextViewVertically(textView: UITextView) {
        switch mainHeight() {
        case iPhone4Height(), iPhone5Height():
            textView.frame.origin.y = self.view.frame.height*0.01
        case iPhone6Height():
            textView.frame.origin.y = self.view.frame.height*0.015
        default:
            textView.frame.origin.y = self.view.frame.height*0.018
        }
    }
}


