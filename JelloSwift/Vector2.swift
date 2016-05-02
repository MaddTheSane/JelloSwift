//
//  Vector2.swift
//  JelloSwift
//
//  Created by Luiz Fernando Silva on 07/08/14.
//  Copyright (c) 2014 Luiz Fernando Silva. All rights reserved.
//

import CoreGraphics
import simd

/// Represents a 2D vector
public struct Vector2: Equatable, CustomStringConvertible
{
    /// A zeroed-value Vector2
    public static let Zero = Vector2(0, 0)
    /// A one-valued Vector2
    public static let One = Vector2(1, 1)
	
	#if arch(x86_64) || arch(arm64)
	///Used to match `CGFloat`'s native type
	typealias NativeVectorType = double2
	#else
	///Used to match `CGFloat`'s native type
	typealias NativeVectorType = float2
	#endif
	var theVector: NativeVectorType
	
	public var X: CGFloat {
		get {
			return CGFloat(theVector.x)
		}
		set {
			theVector.x = newValue.native
		}
	}
	public var Y: CGFloat {
		get {
			return CGFloat(theVector.y)
		}
		set {
			theVector.y = newValue.native
		}
	}
		
    public var description: String { return toString() }
    
    public var cgPoint: CGPoint { return CGPoint(x: X, y: Y) }
	
	init(_ vector: NativeVectorType) {
		theVector = vector
	}
	
    public init()
    {
		theVector = NativeVectorType(0)
    }
    
    public init(_ x: Int, _ y: Int)
    {
		theVector = NativeVectorType(CGFloat.NativeType(x), CGFloat.NativeType(y))
    }
    
    public init(_ x:CGFloat, _ y:CGFloat)
    {
		theVector = NativeVectorType(x.native, y.native)
    }
    
    public init(_ x:Double, _ y:Double)
    {
		theVector = NativeVectorType(CGFloat.NativeType(x), CGFloat.NativeType(y))
    }
    
    public init(value: CGFloat)
    {
		theVector = NativeVectorType(value.native)
    }
    
    public init(_ point: CGPoint)
    {
		theVector = NativeVectorType(point.x.native, point.y.native)
    }
    
    /// Returns the angle in radians of this Vector2
    @warn_unused_result
    public func angle() -> CGFloat
    {
        return atan2(Y, X)
    }
    
    /// Returns the squared length of this Vector2
    @warn_unused_result
    public func length() -> CGFloat
    {
        return CGFloat(length_squared(theVector))
    }
    
    /// Returns the magnitude (or square root of the squared length) of this Vector2
    @warn_unused_result
    public func magnitude() -> CGFloat
    {
		return CGFloat(simd.length(theVector))
    }
    
    /// Returns the distance between this Vector2 and another Vector2
    @warn_unused_result
    public func distanceTo(vec: Vector2) -> CGFloat
    {
        return CGFloat(distance(self.theVector,vec.theVector))
    }
    
    /// Returns the distance squared between this Vector2 and another Vector2
    @warn_unused_result
    public func distanceToSquared(vec: Vector2) -> CGFloat
    {
		return CGFloat(distance_squared(self.theVector,vec.theVector))
    }
    
    /// Makes this Vector2 perpendicular to its current position.
    /// This alters the vector instance
    public mutating func perpendicularThis() -> Vector2
    {
        self = perpendicular()
        
        return self
    }
    
    /// Returns a Vector2 perpendicular to this Vector2
    @warn_unused_result
    public func perpendicular() -> Vector2
    {
        return Vector2(-Y, X)
    }
    
    // Normalizes this Vector2 instance.
    // This alters the current vector instance
    public mutating func normalizeThis() -> Vector2
    {
        self = normalized()
        
        return self
    }
    
    /// Returns a normalized version of this Vector2
    @warn_unused_result
    public func normalized() -> Vector2
    {
        let mag = magnitude()
        
        if(mag > CGFloat.min)
        {
            return self / mag
        }
        
        return self
    }
    
    /// Returns a string representation of this Vector2 value
    @warn_unused_result
    public func toString() -> String
    {
        return "{ \(self.X) : \(self.Y) }"
    }
}

extension Vector2
{
    @warn_unused_result
    func rotate(angleInRadians: CGFloat) -> Vector2
    {
        return rotateVector(self, angleInRadians: Double(angleInRadians))
    }
}

/// Returns a Vector2 that represents the minimum coordinates between two Vector2 objects
@warn_unused_result
public func min(a: Vector2, _ b: Vector2) -> Vector2
{
    return Vector2(min(a.theVector, b.theVector))
}

/// Returns a Vector2 that represents the maximum coordinates between two Vector2 objects
@warn_unused_result
public func max(a: Vector2, _ b: Vector2) -> Vector2
{
	return Vector2(max(a.theVector, b.theVector))
}

/// Rotates a given vector by an angle in radians
@warn_unused_result
public func rotateVector(vec: Vector2, angleInRadians: CGFloat) -> Vector2
{
    if(angleInRadians % (CGFloat(M_PI) * 2) == 0)
    {
        return vec
    }
    
    let c = cos(angleInRadians)
    let s = sin(angleInRadians)
    
    return Vector2((c * vec.X) - (s * vec.Y), (c * vec.Y) + (s * vec.X))
}

@warn_unused_result
public func rotateVector(vec: Vector2, angleInRadians: Double) -> Vector2
{
    if(angleInRadians % (M_PI * 2) == 0)
    {
        return vec
    }
    
    let c = CGFloat(cos(angleInRadians))
    let s = CGFloat(sin(angleInRadians))
    
    return Vector2((c * vec.X) - (s * vec.Y), (c * vec.Y) + (s * vec.X))
}

/// Returns whether rotating from A to B is counter-clockwise
@warn_unused_result
public func vectorsAreCCW(A: Vector2, B: Vector2) -> Bool
{
    return (B =* A.perpendicular()) >= 0.0
}

/// Averages a list of vectors into one normalized Vector2 point
@warn_unused_result
public func averageVectors<T: CollectionType where T.Generator.Element == Vector2, T.Index.Distance == Int>(vectors: T) -> Vector2
{
    return vectors.reduce(Vector2.Zero, combine: +) / vectors.count
}

////////
//// Define the operations to be performed on the Vector2
////////
infix operator =* { associativity left precedence 150 }
infix operator =/ { associativity left precedence 151 }

////
// Comparision operators
////
@warn_unused_result
public func ==(lhs: Vector2, rhs: Vector2) -> Bool
{
    return funcOnVectors(lhs, rhs, ==)
}

// Unary operators
@warn_unused_result
public prefix func -(lhs: Vector2) -> Vector2
{
    return Vector2(-lhs.theVector)
}

public prefix func ++(inout x: Vector2) -> Vector2
{
    return Vector2(++x.X, ++x.Y)
}

public postfix func ++(inout x: Vector2) -> Vector2
{
    return Vector2(x.X++, x.Y++)
}

public prefix func --(inout x: Vector2) -> Vector2
{
    return Vector2(--x.X, --x.Y)
}

public postfix func --(inout x: Vector2) -> Vector2
{
    return Vector2(x.X--, x.Y--)
}

// DOT operator
/// Calculates the dot product between two provided coordinates
@warn_unused_result
public func =*(lhs: Vector2, rhs: Vector2) -> CGFloat
{
    return CGFloat(dot(lhs.theVector, rhs.theVector))
}

// CROSS operator
@warn_unused_result
public func =/(lhs: Vector2, rhs: Vector2) -> CGFloat
{
    return lhs.X * rhs.X - lhs.Y * rhs.Y
}

////
// Basic arithmetic operators
////
@warn_unused_result
public func +(lhs: Vector2, rhs: Vector2) -> Vector2
{
	return Vector2(lhs.theVector + rhs.theVector)
}

@warn_unused_result
public func -(lhs: Vector2, rhs: Vector2) -> Vector2
{
	return Vector2(lhs.theVector - rhs.theVector)
}

@warn_unused_result
public func *(lhs: Vector2, rhs: Vector2) -> Vector2
{
	return Vector2(lhs.theVector * rhs.theVector)
}

@warn_unused_result
public func /(lhs: Vector2, rhs: Vector2) -> Vector2
{
	return Vector2(lhs.theVector / rhs.theVector)
}

@warn_unused_result
public func %(lhs: Vector2, rhs: Vector2) -> Vector2
{
    return funcOnVectors(lhs, rhs, %)
}

// CGFloat interaction
@warn_unused_result
public func +(lhs: Vector2, rhs: CGFloat) -> Vector2
{
	return Vector2(lhs.theVector + Vector2.NativeVectorType(rhs.native))
}

@warn_unused_result
public func -(lhs: Vector2, rhs: CGFloat) -> Vector2
{
	return Vector2(lhs.theVector - Vector2.NativeVectorType(rhs.native))
}

@warn_unused_result
public func *(lhs: Vector2, rhs: CGFloat) -> Vector2
{
	return Vector2(lhs.theVector * rhs.native)
}

@warn_unused_result
public func /(lhs: Vector2, rhs: CGFloat) -> Vector2
{
	return Vector2(lhs.theVector / Vector2.NativeVectorType(rhs.native))
}

@warn_unused_result
public func %(lhs: Vector2, rhs: CGFloat) -> Vector2
{
    return funcOnVectors(lhs, rhs, %)
}

@warn_unused_result
private func funcOnVectors(lhs: Vector2, _ rhs: Vector2, _ f: (CGFloat, CGFloat) -> CGFloat) -> Vector2
{
    return Vector2(f(lhs.X, rhs.X), f(lhs.Y, rhs.Y))
}

@warn_unused_result
private func funcOnVectors(lhs: Vector2, _ rhs: CGFloat, _ f: (CGFloat, CGFloat) -> CGFloat) -> Vector2
{
    return Vector2(f(lhs.X, rhs), f(lhs.Y, rhs))
}

@warn_unused_result
private func funcOnVectors(lhs: Vector2, _ rhs: Vector2, _ f: (CGFloat, CGFloat) -> Bool) -> Bool
{
    return f(lhs.X, rhs.X) && f(lhs.Y, rhs.Y)
}

// Int interaction
@warn_unused_result
public func +(lhs: Vector2, rhs: Int) -> Vector2
{
    return lhs + CGFloat(rhs)
}

@warn_unused_result
public func -(lhs: Vector2, rhs: Int) -> Vector2
{
    return lhs - CGFloat(rhs)
}

@warn_unused_result
public func *(lhs: Vector2, rhs: Int) -> Vector2
{
    return lhs * CGFloat(rhs)
}

@warn_unused_result
public func /(lhs: Vector2, rhs: Int) -> Vector2
{
    return lhs / CGFloat(rhs)
}

////
// Compound assignment operators
////
public func +=(inout lhs: Vector2, rhs: Vector2)
{
	lhs.theVector += rhs.theVector
}
public func -=(inout lhs: Vector2, rhs: Vector2)
{
	lhs.theVector -= rhs.theVector
}
public func *=(inout lhs: Vector2, rhs: Vector2)
{
	lhs.theVector *= rhs.theVector
}
public func /=(inout lhs: Vector2, rhs: Vector2)
{
	lhs.theVector /= rhs.theVector
}

// CGFloat interaction
public func +=(inout lhs: Vector2, rhs: CGFloat)
{
    lhs = lhs + rhs
}
public func -=(inout lhs: Vector2, rhs: CGFloat)
{
    lhs = lhs - rhs
}
public func *=(inout lhs: Vector2, rhs: CGFloat)
{
    lhs = lhs * rhs
}
public func /=(inout lhs: Vector2, rhs: CGFloat)
{
    lhs = lhs / rhs
}

// Int interaction
public func +=(inout lhs: Vector2, rhs: Int)
{
    lhs = lhs + rhs
}
public func -=(inout lhs: Vector2, rhs: Int)
{
    lhs = lhs - rhs
}
public func *=(inout lhs: Vector2, rhs: Int)
{
    lhs = lhs * rhs
}
public func /=(inout lhs: Vector2, rhs: Int)
{
    lhs = lhs / rhs
}

public func round(x: Vector2) -> Vector2
{
    return Vector2(round(x.X), round(x.Y))
}

public func ceil(x: Vector2) -> Vector2
{
    return Vector2(ceil(x.theVector))
}

public func floor(x: Vector2) -> Vector2
{
	return Vector2(floor(x.theVector))
}

public func abs(x: Vector2) -> Vector2
{
	return Vector2(abs(x.theVector))
}
