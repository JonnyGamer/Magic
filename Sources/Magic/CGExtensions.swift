//
//  File.swift
//  
//
//  Created by Jonathan Pappas on 7/31/21.
//



public extension CGPoint {
    //static var midScreen: Self { .init(x: w/2, y: h/2) }
    static var half: Self { .init(x: 0.5, y: 0.5) }
}
public extension CGSize {
    static var hundred: Self { .init(width: 100, height: 100) }
    var doubled: Self { .init(width: width*2, height: height*2) }
    var halved: Self { .init(width: width/2, height: height/2) }
    func padding(_ with: CGFloat) -> Self {
        return .init(width: self.width + with, height: self.height + with)
    }
}
extension CGVector {
    func times(_ some: CGFloat) -> CGVector {
        return .init(dx: dx * some, dy: dy * some)
    }
    func chechForYInverse(_ from: CGFloat) -> CGVector {
        return .init(dx: dx, dy: dy * from.pos)
    }
}
extension CGFloat {
    var half: Self { self / 2 }
    var pos: CGFloat { return self > 0 ? 1 : -1 }
}


#if os(iOS)
extension UITouch {
    func velocityIn(_ node: SKNode) -> CGVector {
        let loc = location(in: node)
        let loc2 = previousLocation(in: node)
        return .init(dx: loc.x - loc2.x, dy: loc.y - loc2.y)
    }
}
#endif
