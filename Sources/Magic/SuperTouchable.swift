//
//  File.swift
//  
//
//  Created by Jonathan Pappas on 8/16/21.
//

extension Array where Element == SKNode {
    func touchBegan() {
        for i in self {
            if let io = i as? SuperTouchable {
                io._touchBegan()
            }
        }
    }
    func touchEndedOn() {
        for i in self {
            if let io = i as? SuperTouchable {
                io._touchEndedOn()
            }
        }
    }
    func touchReleased() {
        for i in self {
            if let io = i as? SuperTouchable {
                io._touchReleased()
            }
        }
    }
}

@objc protocol SuperTouchable {
    func _touchBegan()
    func _touchReleased()
    func _touchEndedOn()
    var touchBegan: (Button) -> () { get set }
    var touchReleased: (Button) -> () { get set }
    var touchEndedOn: (Button) -> () { get set }
}

