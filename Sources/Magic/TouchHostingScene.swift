//
//  File.swift
//  
//
//  Created by Jonathan Pappas on 8/16/21.
//


open class TouchHostingScene: HostingScene {
    open var nodesTouched: [SKNode] = []
    
    open func realTouchBegan(at: CGPoint, nodes: [SKNode]) {}
    open func realTouchMoved(with: CGVector) {}
    open func realTouchEnd(at: CGPoint, with: CGVector) {}
    
    #if os(macOS)
    var startingLoc: CGPoint = .zero
    open override func mouseDown(with event: NSEvent) {
        let loc = event.location(in: self)
        let nodesTouched = nodes(at: loc)
        nodesTouched.touchBegan()
        self.nodesTouched += nodesTouched
        startingLoc = loc
        currentPos = loc
        realTouchBegan(at: loc, nodes: nodesTouched)
    }
    var currentPos: CGPoint = .zero
    open override func mouseDragged(with event: NSEvent) {
        let loc = event.location(in: self)
        realTouchMoved(with: .init(dx: loc.x - currentPos.x, dy: loc.y - currentPos.y))
        currentPos = loc
    }
    open override func mouseUp(with event: NSEvent) {
        let loc = event.location(in: self)
        let nodesEndedOn = nodes(at: loc)
        Array(Set(nodesTouched).subtracting(nodesEndedOn)).touchReleased()
        //nodesTouched.touchReleased()
        nodesTouched = []
        nodesEndedOn.touchEndedOn()
        realTouchEnd(at: loc, with: .init(dx: loc.x - startingLoc.x, dy: loc.y - startingLoc.y))
    }
    #endif
    
    #if os(iOS)
    open var touched: [UITouch:[SKNode]] = [:]
    open var iStartingPos: [UITouch:CGPoint] = [:]
    open var iCurrentPos: [UITouch:CGPoint] = [:]
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for i in touches {
            if i.phase == .began {
                let loc = i.location(in: self)
                let iTouched = nodes(at: loc)
                iTouched.touchBegan()
                touched[i] = iTouched
                
                iStartingPos[i] = loc
                iCurrentPos[i] = loc
                realTouchBegan(at: loc, nodes: nodesTouched)
            }
        }
    }
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for i in touches {
            if i.phase == .moved, let currentPos = iCurrentPos[i] {
                let loc = i.location(in: self)
                realTouchMoved(with: .init(dx: loc.x - currentPos.x, dy: loc.y - currentPos.y))
                iCurrentPos[i] = loc
            }
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { touchesReallyEnded(touches, with: event) }
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) { touchesReallyEnded(touches, with: event) }
    open func touchesReallyEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for i in touches {
            if i.phase == .ended || i.phase == .cancelled, let originallyTouched = touched[i], let starting = iStartingPos[i] {
                
                let loc = i.location(in: self)
                let nodesEndedOn = nodes(at: loc)
                Array(Set(originallyTouched).subtracting(nodesEndedOn)).touchReleased()
                //nodesTouched.touchReleased()
                touched[i] = nil
                nodesEndedOn.touchEndedOn()
                realTouchEnd(at: loc, with: .init(dx: loc.x - starting.x, dy: loc.y - starting.y))
            }
        }
    }
    #endif
}

public extension HostingScene {
    func words(_ string: [String]) -> SKShapeNode {
        let text = SKLabelNode.init(text: string.reduce("") { $0 + "\n" + $1 })
        text.text?.removeFirst()
        text.fontName = "Hand"
        #if os(macOS)
        if #available(macOS 10.13, *) {
            text.numberOfLines = text.text?.split(separator: "\n").count ?? 1
        }
        #elseif os(iOS)
        if #available(iOS 11.0, *) {
            text.numberOfLines = text.text?.split(separator: "\n").count ?? 1
        }
        #endif
        text.horizontalAlignmentMode = .center
        text.verticalAlignmentMode = .center
        addChild(text)
        text.framed()
        text.fontSize *= 2
        guard let frameParent = text.parent as? SKShapeNode else { fatalError() }
        frameParent.centerAt(point: .midScreen)
        frameParent.removeFromParent()
        return frameParent
    }
}
