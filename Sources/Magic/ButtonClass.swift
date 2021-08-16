//
//  File.swift
//  
//
//  Created by Jonathan Pappas on 8/16/21.
//

open class Button: SKNode, SuperTouchable {
    var touched = false
    
    open func _touchBegan() {
        if touched { return }
        touched = true
        
        button.run(.customAction(withDuration: 0.1, actionBlock: { i, j in
            let foo = (255 - (j * 10 * 128))/255
            (i as? SKShapeNode)?.fillColor = .init(red: foo, green: foo, blue: foo, alpha: 1.0)
        }))
        button.run(.moveBy(x: 0, y: -size.times(0.1).height, duration: 0.1).circleOut())
        text.run(.moveBy(x: 0, y: -size.times(0.1).height, duration: 0.1).circleOut())
        touchBegan(self)
    }
    open func _touchReleased() {
        if !touched { return }
        touched = false
        button.run(.customAction(withDuration: 0.1, actionBlock: { i, j in
            let foo = ((j * 10 * 128) + 128)/255
            (i as? SKShapeNode)?.fillColor = .init(red: foo, green: foo, blue: foo, alpha: 1.0)
        }))
        button.run(.moveBy(x: 0, y: size.times(0.1).height, duration: 0.1).circleOut())
        text.run(.moveBy(x: 0, y: size.times(0.1).height, duration: 0.1).circleOut())
        touchReleased(self)
    }
    open func _touchEndedOn() {
        if !touched { return }
        touched = false
        button.run(.customAction(withDuration: 0.1, actionBlock: { i, j in
            let foo = ((j * 10 * 128) + 128)/255
            (i as? SKShapeNode)?.fillColor = .init(red: foo, green: foo, blue: foo, alpha: 1.0)
        }))
        button.run(.moveBy(x: 0, y: size.times(0.1).height, duration: 0.1).circleOut())
        text.run(.moveBy(x: 0, y: size.times(0.1).height, duration: 0.1).circleOut())
        touchEndedOn(self)
    }
    open var touchBegan: (Button) -> () = { _ in }
    open var touchReleased: (Button) -> () = { _ in }
    open var touchEndedOn: (Button) -> () = { _ in }
    
    open var size: CGSize
    open var button: SKShapeNode
    open var buttonShadow: SKShapeNode
    open var text: SKNode
    
    public convenience init(size: CGSize, text: String) {
        self.init(size: size, node: SKLabelNode(text: text))
    }
    public convenience init(size: CGSize, image: String) {
        self.init(size: size, node: SKSpriteNode(imageNamed: image))
    }
    
    public init(size: CGSize, node: SKNode) {

        self.text = node.then {
            if $0 is SKLabelNode, let oo = $0 as? SKLabelNode {
                oo.verticalAlignmentMode = .center
                oo.horizontalAlignmentMode = .center
                oo.fontColor = .black
                oo.zPosition = 1
                oo.keepInside(.init(width: 1000.0, height: size.times(0.75).height))
                oo.fontSize *= $0.xScale
                oo.setScale(1)
                oo.fontName = "Hand"
            } else {
                $0.zPosition = 1
                $0.keepInside(.init(width: 1000.0, height: size.times(0.75).height))
                $0.centerAt(point: .zero)
            }
        }
        let textFrame = text.calculateAccumulatedFrame()
        let newSize = CGSize.init(width: max(100, textFrame.size.padding(40).width), height: size.height)
        self.size = newSize
        
        button = SKShapeNode(rectOf: newSize, cornerRadius: 10).then {
            $0.fillColor = .white
            $0.strokeColor = .black
            $0.zPosition = -1
        }
        buttonShadow = button.coppied.then {
            $0.fillColor = .black
            $0.strokeColor = .black
            $0.position.y -= size.times(0.1).height
            $0.zPosition = -2
            $0.alpha = 0.5
        }
//        self.text.then {
//            //$0.keepInside(size.times(0.75))
//            //$0.fontSize *= $0.xScale
//            //$0.setScale(1)
//        }
        
        super.init()
        addChild(button)
        addChild(buttonShadow)
        addChild(self.text)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

