//
//  File.swift
//  
//
//  Created by Jonathan Pappas on 5/12/21.
//



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


open class HStack: SKNode, Stackable {
    open var orderedChildren: [SKNode] = []
    
    override init() {
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
    
    open func repositionNodes() {
        var maxXo: CGFloat = 0
        for i in orderedChildren {
            i.centerAt(point: .zero)
            i.position.x = maxXo// + (i.calculateAccumulatedFrame().width/2)
            i.position.x += i.position.x - i.calculateAccumulatedFrame().minX
            maxXo = i.calculateAccumulatedFrame().maxX
        }
    }
    
    open func append(nodes: [SKNode]) {
        for i in nodes { addChild(i) }
        orderedChildren += nodes
        self.repositionNodes()
    }
    open func prepend(nodes: [SKNode]) {
        for i in nodes { addChild(i) }
        orderedChildren = nodes + orderedChildren
        self.repositionNodes()
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class VStack: SKNode, Stackable {
    open var orderedChildren: [SKNode] = []
    
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
    
    open func repositionNodes() {
        var maxXo: CGFloat = 0
        for i in orderedChildren {
            i.centerAt(point: .zero)
            i.position.y = maxXo// + (i.calculateAccumulatedFrame().width/2)
            i.position.y += i.position.y - i.calculateAccumulatedFrame().minY
            maxXo = i.calculateAccumulatedFrame().maxY
        }
    }
    
    open func append(nodes: [SKNode]) {
        for i in nodes { addChild(i) }
        orderedChildren += nodes
        self.repositionNodes()
    }
    open func prepend(nodes: [SKNode]) {
        for i in nodes { addChild(i) }
        orderedChildren = nodes + orderedChildren
        self.repositionNodes()
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
