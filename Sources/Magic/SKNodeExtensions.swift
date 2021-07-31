//
//  File.swift
//  
//
//  Created by Jonathan Pappas on 7/31/21.
//

public extension SKNode {
    //var width: CGFloat { frame.width }
    //var height: CGFloat { frame.height }
    var halfWidth: CGFloat { return frame.width.half }
    var halfHeight: CGFloat { return frame.height.half }
}
public extension SKNode {
    func framed(_ acolor: NSColor = .black) {
        
        var sizo: CGSize = .zero
        if let woo = self as? SKCropNode {
            sizo = woo.maskNode?.calculateAccumulatedFrame().size.padding(20) ?? .zero
        } else {
            sizo = self.calculateAccumulatedFrame().size.doubled.padding(20)
        }
        
        let wow = SKShapeNode.init(rectOf: sizo, cornerRadius: 10)
        wow.fillColor = acolor
        wow.strokeColor = acolor
        wow.zPosition = zPosition - 1
        let p = parent
        removeFromParent()
        wow.addChild(self)
        p?.addChild(wow)
        wow.position = position
        position = .zero
        //addChild(wow)
    }
}

public extension SKNode {
    var padding: SKNode {
        let oldScale = (self.xScale, self.yScale)
        setScale(1)
        let newNode = SKSpriteNode.init(color: .white, size: self.calculateAccumulatedFrame().size.padding(20))
        addChild(newNode)
        (xScale, yScale) = oldScale
        newNode.alpha = 0
        return self
    }
    
    var copied: SKNode {
        return self.copy() as! SKNode
    }
    var copiedChildren: [SKNode] {
        return self.children.map { $0.copied }
    }
    
    func centerOn(_ node: SKScene) {
        let whereThis: CGPoint = .init(x: node.size.width/2, y: node.size.height/2)
        position = whereThis
        let newWhereThis = calculateAccumulatedFrame()
        position.x += whereThis.x - newWhereThis.midX
        position.y += whereThis.y - newWhereThis.midY
    }
    func centerOn(_ node: SKNode) {
        let whereThis = node.calculateAccumulatedFrame()
        position = .init(x: whereThis.midX, y: whereThis.midY)
        let newWhereThis = calculateAccumulatedFrame()
        position.x += whereThis.midX - newWhereThis.midX
        position.y += whereThis.midY - newWhereThis.midY
    }
    func centerAt(point: CGPoint) {
        position = point
        let whereThis = calculateAccumulatedFrame()
        position.x += point.x - whereThis.midX
        position.y += point.y - whereThis.midY
    }
    
    func keepInside(_ thhisSize: CGSize) {
        let nodeSize = calculateAccumulatedFrame()
        setScale(min((thhisSize.width / nodeSize.width) * xScale, (thhisSize.height / nodeSize.height) * yScale))
    }
}


