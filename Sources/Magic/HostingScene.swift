//
//  File.swift
//  
//
//  Created by Jonathan Pappas on 7/31/21.
//

open class MagicHostingNode: SKSceneNode, HostingNode {
    open var c: [SKNode] = []
    open override func begin() {
        backgroundColor(.black)
        _begin()
    }
    
    open var velocity: CGVector = .zero
    open var previous: CGPoint = .zero
    open var dragged: Bool = false
    open var touching: [SKNode] = []
    open override var width: CGFloat {
        get { super.width }
        set { super.width = newValue }
    }
    open override var height: CGFloat {
        get { super.width }
        set { super.width = newValue }
    }
    open override var size: CGSize {
        get { super.size }
    }
    
    public static var screens: Int = 4
    open var launchScene: SKSceneNode.Type!// = Scene1.self
    
    
    #if os(iOS)
    open var touchers: [UITouch:[SKNode]] = [:]
    open var touchBegan: UITouch!
    #endif
    
    open var panning: [SKNode] = []
    
    #if os(iOS)
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        _touchesBegan(touches, with: event)
    }
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        _touchesMoved(touches, with: event)
    }
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        _touchesEnded(touches, with: event)
    }
    #elseif os(macOS)
    open override func mouseUp(with event: NSEvent) {
        _mouseUp(with: event)
    }
    open override func mouseDown(with event: NSEvent) {
        _mouseDown(with: event)
    }
    open override func mouseDragged(with event: NSEvent) {
        _mouseDragged(with: event)
    }
    #endif
}


//@available(macOS 10.11, *)
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
    
    #if os(iOS)
    open var touchers: [UITouch:[SKNode]] = [:]
    open var touchBegan: UITouch!
    #endif
    
    open var panning: [SKNode] = []
    
    #if os(iOS)
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        _touchesBegan(touches, with: event)
    }
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        _touchesMoved(touches, with: event)
    }
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        _touchesEnded(touches, with: event)
    }
    #elseif os(macOS)
    open override func mouseUp(with event: NSEvent) {
        _mouseUp(with: event)
    }
    open override func mouseDown(with event: NSEvent) {
        _mouseDown(with: event)
    }
    open override func mouseDragged(with event: NSEvent) {
        _mouseDragged(with: event)
    }
    #endif
}


