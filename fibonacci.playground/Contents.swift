//: Playground - noun: a place where people can play

import UIKit

func fibonacci(until : Int) -> String {
    var fibonacciString = ""
    var curNum = 0
    var nxtNum = 1
    for _ in 1...until {
        let num = curNum + nxtNum
        fibonacciString += "\(num),"
        curNum = nxtNum
        nxtNum = num
    }
    return fibonacciString
}

print(fibonacci(until: 10))
