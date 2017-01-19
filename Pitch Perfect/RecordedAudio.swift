//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Scott Knutti on 11/19/15.
//  Copyright © 2015 Scott Knutti. All rights reserved.
//

import Foundation

class RecordedAudio {
    var filePathUrl: URL!
    var title: String!
    
    init(filePathUrl: URL!, title: String!) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
