//
//  File.swift
//  
//
//  Created by Jonathan Pappas on 8/16/21.
//

public extension CGSize {
    static var screen: Self {
        return .init(width: w, height: h)
    }
    func times(_ n: CGFloat) -> Self {
        return .init(width: width * n, height: height * n)
    }
    func inverse() -> Self {
        return .init(width: 1 / width, height: 1 / height)
    }
}
public extension SKAction {
    func easeInOut() -> SKAction {
        timingFunction = SineEaseInOut(_:)
        return self
    }
    func easeOut() -> SKAction {
        timingFunction = SineEaseOut(_:)
        return self
    }
    func bounceOut() -> SKAction {
        timingFunction = BounceEaseOut(_:)
        return self
    }
    func circleOut() -> SKAction {
        timingFunction = CircularEaseOut(_:)//SineEaseOut
        return self
    }
    func circleIntOut() -> SKAction {
        timingFunction = CircularEaseInOut(_:)//SineEaseOut
        return self
    }
}


//let M_PI_2_f = Float(Double.pi / 2)
//let M_PI_f = Float(Double.pi)
//public func SineEaseOut(_ p:Float)->Float
//{
//    return sin(p * M_PI_2_f)
//}
public func SineEaseIn(_ p:Float)->Float
{
    return sin((p - 1.0) * M_PI_2_f)+1.0
}
public func SineEaseInOut(_ p:Float)->Float
{
    return 0.5 * (1.0 - cos(p * M_PI_f));
}

// Modeled after shifted quadrant IV of unit circle
public func CircularEaseIn(_ p:Float)->Float
{
    return 1 - sqrt(1 - (p * p));
}

// Modeled after shifted quadrant II of unit circle
public func CircularEaseOut(_ p:Float)->Float
{
    return sqrt((2 - p) * p);
}

// Modeled after the piecewise circular public function
// y = (1/2)(1 - sqrt(1 - 4x^2))           ; [0, 0.5)
// y = (1/2)(sqrt(-(2x - 3)*(2x - 1)) + 1) ; [0.5, 1]
public func CircularEaseInOut(_ p:Float)->Float
{
    if(p < 0.5)
    {
        return 0.5 * (1 - sqrt(1 - 4 * (p * p)));
    }
    else
    {
        return 0.5 * (sqrt(-((2 * p) - 3) * ((2 * p) - 1)) + 1);
    }
}


// Modeled after the damped sine wave y = sin(13pi/2*x)*pow(2, 10 * (x - 1))
public func ElasticEaseIn(_ p:Float)->Float
{
    return sin(13 * M_PI_2_f * p) * pow(2, 10.0 * (p - 1.0));
}

// Modeled after the damped sine wave y = sin(-13pi/2*(x + 1))*pow(2, -10x) + 1
public func ElasticEaseOut(_ p:Float)->Float
{
    return sin(-13 * M_PI_2_f * (p + 1)) * pow(2, -10 * p) + 1;
}

// Modeled after the piecewise exponentially-damped sine wave:
// y = (1/2)*sin(13pi/2*(2*x))*pow(2, 10 * ((2*x) - 1))      ; [0,0.5)
// y = (1/2)*(sin(-13pi/2*((2x-1)+1))*pow(2,-10(2*x-1)) + 2) ; [0.5, 1]
public func ElasticEaseInOut(_ p:Float)->Float
{
    if(p < 0.5)
    {
        return 0.5 * sin(13.0 * M_PI_2_f * (2 * p)) * pow(2, 10 * ((2 * p) - 1));
    }
    else
    {
        return 0.5 * (sin(-13 * M_PI_2_f * ((2 * p - 1) + 1)) * pow(2, -10 * (2 * p - 1)) + 2);
    }
}


public func BounceEaseOut(_ p:Float)->Float
{
    if(p < 4/11.0)
    {
        return (121 * p * p)/16.0;
    }
    else if(p < 8/11.0)
    {
        return (363/40.0 * p * p) - (99/10.0 * p) + 17/5.0;
    }
    else if(p < 9/10.0)
    {
        return (4356/361.0 * p * p) - (35442/1805.0 * p) + 16061/1805.0;
    }
    else
    {
        return (54/5.0 * p * p) - (513/25.0 * p) + 268/25.0;
    }
}

