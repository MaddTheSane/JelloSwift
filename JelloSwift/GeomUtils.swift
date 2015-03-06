//
//  GeomUtils.swift
//  JelloSwift
//
//  Created by Luiz Fernando Silva on 07/08/14.
//  Copyright (c) 2014 Luiz Fernando Silva. All rights reserved.
//

import UIKit

/// CGFloat version of the PI constant
public let PI: CGFloat = CGFloat(M_PI);

/// Returns an approximation of the area of the polygon defined by a given set of vertices
public func polygonArea(points: [Vector2]) -> CGFloat
{
    var area: CGFloat = 0;
    var j = points.count - 1;
    
    for i in 0..<points.count
    {
        area += (points[j].X + points[i].X) * (points[j].Y - points[i].Y);
        j = i;
    }
    
    return area / 2;
}

/// Returns an approximation of the area of the polygon defined by a given set of point masses
public func polygonArea(points: [PointMass]) -> CGFloat
{
    var area: CGFloat = 0;
    let c = points.count;
    var v2 = points.last!.position;
    
    for v1Point in points {
        let v1 = v1Point.position;
        
        area += (v2.X + v1.X) * (v2.Y - v1.Y);
        
        v2 = v1;
    }
    
    return area / 2;
}

/// Checks if 2 line segments intersect. (line AB collides with line CD) (reference type version)
public func lineIntersect(ptA: Vector2, ptB: Vector2, ptC: Vector2, ptD: Vector2, inout hitPt: Vector2, inout Ua: CGFloat, inout Ub: CGFloat) -> Bool
{
    var denom = ((ptD.Y - ptC.Y) * (ptB.X - ptA.X)) - ((ptD.X - ptC.X) * (ptB.Y - ptA.Y));
    
    // if denom == 0, lines are parallel - being a bit generous on this one..
    if (abs(denom) < 0.000000001)
    {
        return false;
    }
    
    var UaTop = ((ptD.X - ptC.X) * (ptA.Y - ptC.Y)) - ((ptD.Y - ptC.Y) * (ptA.X - ptC.X));
    var UbTop = ((ptB.X - ptA.X) * (ptA.Y - ptC.Y)) - ((ptB.Y - ptA.Y) * (ptA.X - ptC.X));
    
    var revDenom = 1 / denom;
    
    Ua = UaTop * revDenom;
    Ub = UbTop * revDenom;
    
    if ((Ua >= 0) && (Ua <= 1) && (Ub >= 0) && (Ub <= 1))
    {
        // these lines intersect!
        hitPt = ptA + ((ptB - ptA) * Ua);
        
        return true;
    }
    
    return false;
}

/// Calculates a spring force, given position, velocity, spring constant, and damping factor
public func calculateSpringForce(posA: Vector2, velA: Vector2, posB: Vector2, velB: Vector2, springD: CGFloat, springK: CGFloat, damping:CGFloat) -> Vector2
{
    var dist = posA.distanceTo(posB);
    
    if (dist <= 0.0000005)
    {
        return Vector2(0, 0);
    }
    
    var BtoA = (posA - posB) / dist;
    
    dist = springD - dist;
    
    var relVel = velA - velB;
    var totalRelVel = relVel =* BtoA;
    
    return BtoA * ((dist * springK) - (totalRelVel * damping));
}
