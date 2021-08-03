//
//  File.swift
//  
//
//  Created by Jonathan Pappas on 8/3/21.
//


@objc public protocol HostingNode {
    var c: [SKNode] { get set }
    
    var size: CGSize { get }
    
    var velocity: CGVector { get set }
    var previous: CGPoint { get set }
    var dragged: Bool { get set }
    var touching: [SKNode] { get set }
    
    #if os(iOS)
    var touchers: [UITouch:[SKNode]]  { get set }
    var touchBegan: UITouch! { get set }
    #endif
    
    var panning: [SKNode]  { get set }
    
    static var screens: Int { get set }
    var launchScene: SKSceneNode.Type! { get set }
    var width: CGFloat { get }
    var height: CGFloat { get }
    func addChild(_ node: SKNode)
    //func nodes(at: CGPoint) -> [SKNode]
    
    //#if os(iOS)
    //@objc func _touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    //@objc func _touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    //@objc func _touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    //#elseif os(macOS)
    //func _mouseDown(with event: NSEvent)
    //func _mouseDragged(with event: NSEvent)
    //func _mouseUp(with event: NSEvent)
    //#endif
    //func genericTouchesBegan(loc: CGPoint)
    
}
public extension HostingNode {
    func keepInsideScene(_ node: SKNode) {
        let nodeSize = node.calculateAccumulatedFrame()
        node.setScale(min((size.width / nodeSize.width) * node.xScale, (size.height / nodeSize.height) * node.yScale))
    }
    
    func _begin() {
        var playerDesign: [(CGFloat,CGFloat,CGFloat,CGFloat,CGFloat)] = []
        
        if Self.screens == 1 { playerDesign = [(width,height,0,0,1)] }
        if Self.screens == 2 { playerDesign = [(width/2, height, -width/4, 0,1), (width/2, height, width/4, 0,1)] }
        if Self.screens == 3 { playerDesign = [(width/3, height, -width/3, 0,1), (width/3, height, 0, 0,-1), (width/3, height, width/3, 0,1)] }
        if Self.screens == 4 {
            //playerDesign = [(width/4, 1000, -3*width/8, 0), (width/4, 1000, -width/8, 0), (width/4, 1000, width/8, 0), (width/4, 1000, 3*width/8, 0)]
            
            playerDesign = [(width/2, height/2, -width/4, -height/4,1), (width/2, height/2, width/4, -height/4,1), (width/2, height/2, -width/4, height/4,-1), (width/2, height/2, width/4, height/4,-1)]
            
        }
        
        for i in playerDesign {
            let cropper = launchScene.Rect(width: i.0-20, height: i.1-20) {
                $0.position = .zero
            }
            cropper.yScale *= i.4
            cropper.position.x = i.2 + (size.width/2)
            cropper.position.y = i.3 + (size.height/2)
            addChild(cropper)
            //cropper.maskNode?.alpha = 0.5
            cropper.framed(.darkGray)
            c.append(cropper.parent!)
            cropper.begin()
        }
    }
}


// TOUCH CODE
public extension HostingNode {
    // Touch Down
    #if os(iOS)
    func _touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for i in touches {
            if i.phase == .began {
                //UITouch.thirdPrevious[i] = i.previousLocation(in: self) // YES backup
                // Remember which finger touched what
                touchBegan = i
                touchers[i] = []
                genericTouchesBegan(loc: i.location(in: self as! SKNode))
            }
        }
    }
    #elseif os(macOS)
    func _mouseDown(with event: NSEvent) {
        velocity = .zero
        let loc = event.location(in: self as! SKNode)
        genericTouchesBegan(loc: loc)
    }
    #endif
    // Generic Touch Down
    func genericTouchesBegan(loc: CGPoint) {
        previous = loc
        dragged = false
        for c1 in c {
            guard let io = (c1.children.first as? SKSceneNode) else { continue }
            if io.touchedInside(loc) {
                #if os(iOS) // Remember which finger touched what
                touchers[touchBegan]?.append(c1)
                #endif
                touching.append(c1)
                io.touchesBegan(.zero, nodes: (self as! SKNode).nodes(at: loc))
            }
        }
        // Zoom Out ;)
        if touching.isEmpty {
            //touching = c
            panning = c
            //magicCamera.setScale(event.locationInWindow.x / 200)
        } else {
            panning = []
        }
    }
    
    
    // Dragging
    #if os(iOS)
    func _touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for (i,o) in touchers {
            if i.phase == .moved || i.phase == .stationary {
                touching = o
                velocity = i.velocityIn(self as! SKNode)
                genericTouchesMoved()
            }
        }
    }
    #elseif os(macOS)
    func _mouseDragged(with event: NSEvent) {
        let loc = event.location(in: self as! SKNode)
        velocity = .init(dx: loc.x - previous.x, dy: loc.y - previous.y)
        genericTouchesMoved()
        previous = loc
    }
    #endif
    func genericTouchesMoved() {
        dragged = true
        for i in touching {
            guard let io = (i.children.first as? SKSceneNode) else { continue }
            io.touchesMoved(velocity.chechForYInverse(io.yScale))
        }
        for i in panning {
            guard let io = (i.children.first as? SKSceneNode) else { continue }
            if io.draggable {
                i.run(.move(by: velocity, duration: 0.1))
            }
        }
    }
    
    // Touches Ended
    #if os(iOS)
    func _touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for (i,o) in touchers {
            if i.phase == .ended || i.phase == .cancelled {
                touching = o
                //print(i.velocityIn(self), i.releaseVelocity(self))
                velocity = i.velocityIn(self as! SKNode)
                genericTouchEnded(loc: i.location(in: self as! SKNode), velocity: velocity)
                touchers[i] = nil
                //UITouch.thirdPrevious[i] = nil
            }
        }
        for i in panning {
            guard let io = (i.children.first as? SKSceneNode) else { continue }
            if io.draggable {
                i.run(.smoothMoveBy(velocity, duration: 0.5))
                //i.run(.move(by: velocity, duration: 0.1))
            }
        }
    }
    #elseif os(macOS)
    func _mouseUp(with event: NSEvent) {
        let loc = event.location(in: self as! SKNode)
        genericTouchEnded(loc: loc, velocity: velocity)
    }
    #endif
    func genericTouchEnded(loc: CGPoint, velocity: CGVector) {
        //if dragged {
            let uwu = SKAction.move(by: velocity.times(10), duration: 0.5)
            uwu.timingFunction = SineEaseOut(_:)
            
            for i in touching {
                guard let io = (i.children.first as? SKSceneNode) else { continue }
                io.touchesEnded(loc, release: velocity.times(10).chechForYInverse(io.yScale))
                
                if io.draggable {
                    i.run(uwu)
                }
            }
        //}
        touching = []
    }
}






