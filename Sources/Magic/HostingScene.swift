//
//  File.swift
//  
//
//  Created by Jonathan Pappas on 7/31/21.
//

//open class HostingNode: SKSceneNode {
//    //open var magicCamera: SKCameraNode!
//    open var c: [SKNode] = []
//
//    public static var screens: Int = 4
//    open var launchScene: SKSceneNode.Type!// = Scene1.self
//
//    open override func begin() {
//        backgroundColor(.black)
//        var playerDesign: [(CGFloat,CGFloat,CGFloat,CGFloat,CGFloat)] = []
//
//        if Self.screens == 1 { playerDesign = [(width,height,0,0,1)] }
//        if Self.screens == 2 { playerDesign = [(width/2, height, -width/4, 0,1), (width/2, height, width/4, 0,1)] }
//        if Self.screens == 3 { playerDesign = [(width/3, height, -width/3, 0,1), (width/3, height, 0, 0,-1), (width/3, height, width/3, 0,1)] }
//        if Self.screens == 4 {
//            //playerDesign = [(width/4, 1000, -3*width/8, 0), (width/4, 1000, -width/8, 0), (width/4, 1000, width/8, 0), (width/4, 1000, 3*width/8, 0)]
//
//            playerDesign = [(width/2, height/2, -width/4, -height/4,1), (width/2, height/2, width/4, -height/4,1), (width/2, height/2, -width/4, height/4,-1), (width/2, height/2, width/4, height/4,-1)]
//
//        }
//
//        for i in playerDesign {
//            let cropper = launchScene.Rect(width: i.0-20, height: i.1-20) {
//                $0.position = .zero
//            }
//            cropper.yScale *= i.4
//            cropper.position.x = i.2
//            cropper.position.y = i.3
//            addChild(cropper)
//            //cropper.maskNode?.alpha = 0.5
//            cropper.framed(.darkGray)
//            c.append(cropper.parent!)
//            cropper.begin()
//        }
//    }
//
//}




@available(macOS 10.11, *)
open class HostingScene: SKScene, HostingNode {
    public convenience init (from: Bool) {
        self.init(size: .init(width: w, height: h))
    }
    
    open var c: [SKNode] = []
    
    open var width: CGFloat { frame.size.width }
    open var height: CGFloat { frame.size.height }
    
    public static var screens: Int = 4
    open var launchScene: SKSceneNode.Type!// = Scene1.self
    
    open override func didMove(to view: SKView) {
        backgroundColor = .black
        _begin()

    }

    open var velocity: CGVector = .zero
    open var previous: CGPoint = .zero
    open var dragged: Bool = false
    open var touching: [SKNode] = []
    
    open var touchers: [UITouch:[SKNode]] = [:]
    open var touchBegan: UITouch!
    
    open var panning: [SKNode] = []
}


