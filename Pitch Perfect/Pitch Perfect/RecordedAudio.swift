//
//  RecordedAudio.swift
//  
//
//  Created by Felix Christmann-Jacoby on 16.04.15.
//
//

//MODEL

import Foundation


class RecordedAudio: NSObject {
    //parameters of class
    //init function
    
    var filePathUrl: NSURL
    var title: String
    
    init(url: NSURL, titleArg: String!) {
        self.filePathUrl = url
        self.title = titleArg
    }
    
}