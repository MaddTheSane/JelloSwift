//
//  PhysicsMathTest.swift
//  JelloSwift
//
//  Created by Luiz Fernando Silva on 09/08/14.
//  Copyright (c) 2014 Luiz Fernando Silva. All rights reserved.
//

#if os(iOS)
    import UIKit
    #elseif os(OSX)
    import Cocoa
#endif
@testable import Jello
import XCTest

class PhysicsMathTest: XCTestCase
{
    func testVector2Perp()
    {
        let vec1 = Vector2(0, 1)
        let vecPerp = vec1.perpendicular()
        
        XCTAssert(vecPerp.X == -vec1.Y && vecPerp.Y == vec1.X, "Pass")
    }
    
    func testVector2Dist()
    {
        let vec1 = Vector2(4, 8)
        let vec2 = Vector2(14, 13)
        
        let dx: CGFloat = 4 - 14
        let dy: CGFloat = 8 - 13
        
        let dis = vec1.distanceTo(vec2)
        let dissq = vec1.distanceToSquared(vec2)
        let sss = sqrt((dx * dx) + (dy * dy))
        XCTAssert(dis == sss, "Pass")
        XCTAssert(dissq == (dx * dx) + (dy * dy), "Pass")
    }
    
    func testVector2Math()
    {
        let vec1 = Vector2(4, 6)
        let vec2 = Vector2(9, 7)
        
        XCTAssert((vec1 =* vec2) == CGFloat(4 * 9 + 6 * 7), "DOT product test failed!")
        XCTAssert((vec1 =/ vec2) == CGFloat(4 * 9 - 6 * 7), "CROSS product test failed!")
    }
    
    func testVector2Rotate()
    {
        let vec = Vector2(0, 1)
        
//        XCTAssertEqual(rotateVector(vec, PI * 2), vec, "Vector rotation test failed!")
//        XCTAssertEqual(rotateVector(vec, PI / 2), Vector2(-1,  0), "Vector rotation test failed!")
//        XCTAssertEqual(rotateVector(vec, PI)    , Vector2( 0, -1), "Vector rotation test failed!")
    }
}