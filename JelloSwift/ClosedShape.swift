//
//  ClosedShape.swift
//  JelloSwift
//
//  Created by Luiz Fernando Silva on 07/08/14.
//  Copyright (c) 2014 Luiz Fernando Silva. All rights reserved.
//

import CoreGraphics
import Foundation

// Contains a set of points that is equivalent as the internal shape of a sofy body
public class ClosedShape
{
    public var localVertices: [Vector2] = [];
    
    /// Start adding vertices to this closed shape.
    /// Calling this method will erase any existing verts
    public func begin()
    {
        localVertices = [];
    }
	
	/// Default initializer
	public init() {
		
	}
	
    /// Adds a vertex to this closed shape
    public func addVertex(vertex: Vector2)
    {
        localVertices += vertex;
    }
    
    /// Finishes constructing this closed shape, and convert them to local space (by default)
    public func finish(recenter: Bool = true)
    {
        if(recenter)
        {
            // Find the average location of all the vertices
            var center = Vector2.Zero;
            
            for vertex in localVertices
            {
                center += vertex;
            }
            
            center /= localVertices.count;
            
            // Subtract the center from all the elements
            for i in 0..<localVertices.count
            {
                localVertices[i] -= center;
            }
        }
    }
    
    /// Transforms all vertices by the given angle and scale
    public func transformOwn(angleInRadians: CGFloat, localScale: Vector2)
    {
        for i in 0..<localVertices.count
        {
            localVertices[i] = rotateVector(localVertices[i] * localScale, angleInRadians);
        }
    }
    
    /// Gets a new list of vertices, transformed by the given position, angle, and scale.
    /// transformation is applied in the following order:  scale -> rotation -> position.
    public func transformVertices(worldPos: Vector2, angleInRadians: CGFloat, localScale: Vector2 = Vector2(1, 1)) -> [Vector2]
    {
        let count = localVertices.count;
        var ret: [Vector2] = [Vector2](count: count, repeatedValue: Vector2());
        
        for (i, lv) in enumerate(localVertices)
        {
            ret[i] = rotateVector(lv * localScale, angleInRadians) + worldPos;
        }
        
        return ret;
    }
    
    /// Transforms the points on this closed shape into the given array of points.
    /// The array of points must have the same count of vertices as this closed shape
    /// transformation is applied in the following order:  scale -> rotation -> position.
    public func transformVertices(inout target:[Vector2], worldPos: Vector2, angleInRadians: CGFloat, localScale: Vector2 = Vector2(1, 1))
    {
        let count = localVertices.count;
		for (i, lv) in enumerate(localVertices)
        {
            target[i] = rotateVector(lv * localScale, angleInRadians) + worldPos;
        }
    }
}
