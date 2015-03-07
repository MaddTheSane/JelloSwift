//
//  InternalSpring.swift
//  JelloSwift
//
//  Created by Luiz Fernando Silva on 07/08/14.
//  Copyright (c) 2014 Luiz Fernando Silva. All rights reserved.
//

import CoreGraphics
import Foundation

/// Represents an internal spring inside a soft body object, and keeps points close together
public class InternalSpring
{
    public internal(set) var pointMassA: PointMass;
    public internal(set) var pointMassB: PointMass;
    
    public internal(set) var distance: CGFloat = 0;
    public internal(set) var springK: CGFloat = 0;
    public internal(set) var springD: CGFloat = 0;
    
    init(_ pmA: PointMass, _ pmB: PointMass, _ distance: CGFloat = 0, _ springK: CGFloat, _ springD: CGFloat)
    {
        self.pointMassA = pmA;
        self.pointMassB = pmB;
        self.distance = distance;
        self.springK = springK;
        self.springD = springD;
    }
}
