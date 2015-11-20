//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Scott Knutti on 11/19/15.
//  Copyright © 2015 Scott Knutti. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL!, title: String!) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}