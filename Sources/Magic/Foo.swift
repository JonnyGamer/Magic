//
//  File.swift
//  
//
//  Created by Jonathan Pappas on 5/12/21.
//

@_exported import SpriteKit


public extension CGSize {
    static var hundred: Self { .init(width: 100, height: 100) }
    var doubled: Self { .init(width: width*2, height: height*2) }
    var halved: Self { .init(width: width/2, height: height/2) }
    func padding(_ with: CGFloat) -> Self {
        return .init(width: self.width + with, height: self.height + with)
    }
}
public extension SKNode {
    var copied: SKNode {
        return self.copy() as! SKNode
    }
    func centerAt(point: CGPoint) {
        position = point
        let whereThis = calculateAccumulatedFrame()
        position.x += point.x - whereThis.midX
        position.y += point.y - whereThis.midY
    }
    var padding: SKNode {
        let oldScale = (self.xScale, self.yScale)
        setScale(1)
        let newNode = SKSpriteNode.init(color: .white, size: self.calculateAccumulatedFrame().size.padding(20))
        addChild(newNode)
        (xScale, yScale) = oldScale
        newNode.alpha = 0
        return self
    }
}


public protocol Stackable {
    var orderedChildren: [SKNode] { get set }
    init(nodes: [SKNode])
    func repositionNodes()
    func append(node: SKNode)
    func append(nodes: [SKNode])
    func prepend(nodes: [SKNode])
}
public extension Stackable {
    func append(node: SKNode) { append(nodes: [node]) }
    func prepend(node: SKNode) { prepend(nodes: [node]) }
}


public class HStack: SKNode, Stackable {
    public var orderedChildren: [SKNode] = []
    
    override init() {
        super.init()
        print("HUH?")
    }
    public required init(nodes: [SKNode]) {
        super.init()
        orderedChildren = nodes
        for i in nodes {
            addChild(i)
        }
        repositionNodes()
    }
    
    public func repositionNodes() {
        var maxXo: CGFloat = 0
        for i in orderedChildren {
            i.centerAt(point: .zero)
            i.position.x = maxXo// + (i.calculateAccumulatedFrame().width/2)
            i.position.x += i.position.x - i.calculateAccumulatedFrame().minX
            maxXo = i.calculateAccumulatedFrame().maxX
        }
    }
    
    public func append(nodes: [SKNode]) {
        for i in nodes { addChild(i) }
        orderedChildren += nodes
        self.repositionNodes()
    }
    public func prepend(nodes: [SKNode]) {
        for i in nodes { addChild(i) }
        orderedChildren = nodes + orderedChildren
        self.repositionNodes()
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class VStack: SKNode, Stackable {
    public var orderedChildren: [SKNode] = []
    
    public override init() {
        super.init()
        print("HUH?")
    }
    required public init(nodes: [SKNode]) {
        super.init()
        orderedChildren = nodes
        for i in nodes {
            addChild(i)
        }
        repositionNodes()
    }
    
    public func repositionNodes() {
        var maxXo: CGFloat = 0
        for i in orderedChildren {
            i.centerAt(point: .zero)
            i.position.y = maxXo// + (i.calculateAccumulatedFrame().width/2)
            i.position.y += i.position.y - i.calculateAccumulatedFrame().minY
            maxXo = i.calculateAccumulatedFrame().maxY
        }
    }
    
    public func append(nodes: [SKNode]) {
        for i in nodes { addChild(i) }
        orderedChildren += nodes
        self.repositionNodes()
    }
    public func prepend(nodes: [SKNode]) {
        for i in nodes { addChild(i) }
        orderedChildren = nodes + orderedChildren
        self.repositionNodes()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
