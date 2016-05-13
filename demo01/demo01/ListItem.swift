//
//  ListItem.swift
//  demo01
//
//  Created by alex cheng on 3/11/16.
//  Copyright © 2016 aboni llc. All rights reserved.
//

import Foundation

class ListItem: NSObject {
    
    let id: Int
    let name: String
    let parentKey: String
    let isDone: Bool
    let createdTS: NSDate
    
    init (id: Int, name: String, parentKey: String, isDone: Bool, createdTS: NSDate) {
        self.id = id
        self.name = name
        self.parentKey = parentKey
        self.isDone = isDone
        self.createdTS = createdTS
        super.init()
    }
    
}
