//
//  List.swift
//  demo01
//
//  Created by alex cheng on 3/11/16.
//  Copyright © 2016 aboni llc. All rights reserved.
//

import Foundation

class List :NSObject {
        
    var items: [ListItem]
    //let sourceText: String
    //let sourceParent: String
    
    init (items newItems: [ListItem]) {
        self.items = newItems
        //self.sourceText = newText
        //self.sourceParent = newParent!
        super.init()
    }
    
/*    convenience init? (data: [String]) {
        var newItems = [ListItem]()
        for item in data {
            newItems.append(ListItem(id: 0, text: item, parent: ""))
        }
        self.init(items: newItems)
    }
    
    func insertParentItem(itemText: String) {
        let listitem = ListItem(id: 0, text: itemText, parent: "")
        items.append(listitem)
    }
    
    func deleteItem(index: Int) {
        self.items.removeAtIndex(index)
    }
   */
}
