//
//  Array+Extension.swift
//  SDLProjectionDemo
//
//  Created by Dandy.Guan on 2018/9/3.
//  Copyright © 2018 YuanWei. All rights reserved.
//

import Foundation


extension Array {
    public func shuffle() -> Array {
        var list = self
        for index in 0..<list.count {
            let newIndex = Int(arc4random_uniform(UInt32(list.count - index))) + index
            if index != newIndex {
                list.swapAt(index, newIndex)
            }
        }
        return list
    }
    
    public func shuffleRandomCount() -> Array {
        var list = self
        for index in 0..<list.count {
            let newIndex = Int(arc4random_uniform(UInt32(list.count - index))) + index
            if index != newIndex {
                list.swapAt(index, newIndex)
            }
        }
        let i : Int = list.count + 1
        
        var newList : Array = []
        let x = Int(arc4random_uniform(UInt32(i)))
       
        for index in 0..<x {
            newList.append(list[index])
        }
        return newList
    }
    
}
