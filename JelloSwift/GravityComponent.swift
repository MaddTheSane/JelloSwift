//
//  GravityComponent.swift
//  JelloSwift
//
//  Created by Luiz Fernando Silva on 30/08/14.
//  Copyright (c) 2014 Luiz Fernando Silva. All rights reserved.
//

import CoreGraphics
import Foundation

/// Represents a Gravity component that can be added to a body to make it constantly affected by gravity
public class GravityComponent: BodyComponent
{
    /// The gravity vector to apply to the body
    public var gravity: Vector2 = Vector2(0, -9.8);
    
    public override func accumulateInternalForces()
    {
        super.accumulateInternalForces();
        
        /*
        for p in body.pointMasses
        {
            p.applyForce(vector * p.mass);
        }
        */
        
        for i in 0 ..< body.pointMasses.count
        {
            body.pointMasses[i].applyForce(gravity * body.pointMasses[i].mass);
        }
    }
    
    /// Changes the gravity of the bodies on a given world object
    public static func setGravityOnWorld(world: World, newGravity: Vector2)
    {
        for b in world.bodies
        {
            if let g = b.getComponentType(GravityComponent)
            {
                g.gravity = newGravity;
            }
        }
    }
}

/// Component that can be added to bodies to add a gravity-like constant force
public class GravityComponentCreator: BodyComponentCreator
{
    public var vector: Vector2;
    
    public required init(gravity: Vector2 = Vector2(0, -9.8))
    {
        self.vector = gravity;
        
        super.init();
        
        self.bodyComponentClass = GravityComponent.self;
    }
    
    public override func prepareBodyAfterComponent(body: Body)
    {
        if let comp = body.getComponentType(GravityComponent)
        {
            comp.gravity = self.vector;
        }
    }
}
