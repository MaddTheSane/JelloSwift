//
//  PointMass.swift
//  JelloSwift
//
//  Created by Luiz Fernando Silva on 07/08/14.
//  Copyright (c) 2014 Luiz Fernando Silva. All rights reserved.
//

import UIKit

/// Specifies a point mass that composes a body
public class PointMass
{
    /// The mass of this point mass.
    /// Leave this value always >0 to maintain consistency on the simulation, unless
    /// the point is supposed to fixed
    internal(set) public var mass: CGFloat = 1;
    
    /// The spatial information for the point mass
    public var position: Vector2 = Vector2();
    public var velocity: Vector2 = Vector2();
    public var force: Vector2 = Vector2();
    
    public init(mass: CGFloat = 0, position: Vector2 = Vector2())
    {
        self.mass = mass;
        self.position = position;
    }
    
    /// Integrates a single physics simulation step for this point mass
    public func integrate(elapsed: CGFloat)
    {
        if (mass != CGFloat.infinity)
        {
            let elapMass = elapsed / mass;
            
            velocity += force * elapMass;
            
            position += (velocity * elapsed);
        }
        
        force = Vector2();
    }
    
    /// Applies the given force vector to this point mass
    public func applyForce(force: Vector2)
    {
        self.force += force;
    }
}
