//
//  File.swift
//  
//
//  Created by Jonathan Pappas on 7/31/21.
//

public class HostingScene: SKScene {
    public convenience init (from: Bool) {
        self.init(size: .init(width: w, height: h))
    }
    
    @available(macOS 10.11, *)
    public var magicCamera: SKCameraNode!
    public var c: [SKNode] = []
    
    public var width: CGFloat { frame.size.width }
    public var height: CGFloat { frame.size.height }
    
    public static var screens: Int = 4
    public var launchScene: SKSceneNode.Type!// = Scene1.self
    
    public override func didMove(to view: SKView) {
        if #available(macOS 10.11, *) {
            magicCamera = SKCameraNode()
            camera = magicCamera
            addChild(magicCamera)
        } else {
            print("WARNING: Somehow the MAGIC_CAMERA did not work. MacOS 10.11")
        }
        backgroundColor = .black
        
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
            cropper.position.x = i.2
            cropper.position.y = i.3
            addChild(cropper)
            //cropper.maskNode?.alpha = 0.5
            cropper.framed(.darkGray)
            c.append(cropper.parent!)
            cropper.begin()
        }
        
    }
    

    public func keepInsideScene(_ node: SKNode) {
        let nodeSize = node.calculateAccumulatedFrame()
        node.setScale(min((size.width / nodeSize.width) * node.xScale, (size.height / nodeSize.height) * node.yScale))
    }

    public var velocity: CGVector = .zero
    public var previous: CGPoint = .zero
    public var dragged = false
    public var touching: [SKNode] = []
    
    
    
    
    // Touch Down
    #if os(iOS)
    public var touchers: [UITouch:[SKNode]] = [:]
    public var touchBegan: UITouch!
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for i in touches {
            if i.phase == .began {
                //UITouch.thirdPrevious[i] = i.previousLocation(in: self) // YES backup
                // Remember which finger touched what
                touchBegan = i
                touchers[i] = []
                genericTouchesBegan(loc: i.location(in: self))
            }
        }
    }
    #elseif os(macOS)
    public override func mouseDown(with event: NSEvent) {
        let loc = event.location(in: self)
        genericTouchesBegan(loc: loc)
    }
    #endif
    // Generic Touch Down
    public func genericTouchesBegan(loc: CGPoint) {
        previous = loc
        dragged = false
        for c1 in c {
            guard let io = (c1.children.first as? SKSceneNode) else { continue }
            if io.touchedInside(loc) {
                #if os(iOS) // Remember which finger touched what
                touchers[touchBegan]?.append(c1)
                #endif
                touching.append(c1)
                io.touchesBegan(.zero, nodes: nodes(at: loc))
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
    public var panning: [SKNode] = []
    
    // Dragging
    #if os(iOS)
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for (i,o) in touchers {
            if i.phase == .moved || i.phase == .stationary {
                touching = o
                velocity = i.velocityIn(self)
                genericTouchesMoved()
            }
        }
    }
    #elseif os(macOS)
    public override func mouseDragged(with event: NSEvent) {
        let loc = event.location(in: self)
        velocity = .init(dx: loc.x - previous.x, dy: loc.y - previous.y)
        genericTouchesMoved()
        previous = loc
    }
    #endif
    public func genericTouchesMoved() {
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
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for (i,o) in touchers {
            if i.phase == .ended || i.phase == .cancelled {
                touching = o
                //print(i.velocityIn(self), i.releaseVelocity(self))
                velocity = i.velocityIn(self)
                genericTouchEnded(loc: i.location(in: self), velocity: velocity)
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
    public override func mouseUp(with event: NSEvent) {
        let loc = event.location(in: self)
        genericTouchEnded(loc: loc, velocity: .zero)
    }
    #endif
    public func genericTouchEnded(loc: CGPoint, velocity: CGVector) {
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







