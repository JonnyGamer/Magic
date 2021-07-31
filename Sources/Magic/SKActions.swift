//
//  File.swift
//  
//
//  Created by Jonathan Pappas on 7/31/21.
//

let M_PI_2_f = Float(Double.pi / 2)
let M_PI_f = Float(Double.pi)
public func sinFloat(_ num:Float)->Float {
    return sin(num)
}
public func SineEaseOut(_ p:Float)->Float {
    return sinFloat(p * M_PI_2_f)
}

//
//extension SKAction {
//    static func moveBy(_ velocty: CGVector, duration: Double) -> SKAction {
//        return .moveBy(x: velocty.dx, y: velocty.dy, duration: duration)
//    }
//}
public extension SKAction {
    static func smoothMoveBy(_ vel: CGVector, duration: Double) -> SKAction {
        let action = SKAction.move(by: vel, duration: duration)
        action.timingFunction = SineEaseOut(_:)
        return action
    }
}

