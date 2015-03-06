//
//  InternalSpring.swift
//  JelloSwift
//
//  Created by Luiz Fernando Silva on 07/08/14.
//  Copyright (c) 2014 Luiz Fernando Silva. All rights reserved.
//

import UIKit

// Represents an internal spring inside a soft body object, and keeps points close together
public class InternalSpring
{
    public var pointMassA: PointMass;
    public var pointMassB: PointMass;
    
    public var springD: CGFloat = 0;
    public var springK: CGFloat = 0;
    public var damping: CGFloat = 0;
    
    public init(_ pmA: PointMass, _ pmB: PointMass, _ springD: CGFloat = 0, _ springK: CGFloat, _ damping: CGFloat)
    {
        self.pointMassA = pmA;
        self.pointMassB = pmB;
        self.springD = springD;
        self.springK = springK;
        self.damping = damping;
    }
}
