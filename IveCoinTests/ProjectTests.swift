//
//  ProjectTests.swift
//  IveCoin
//
//  Created by vlad on 5/7/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import XCTest
@testable import IveCoin

class ProjectTests: XCTestCase {
    func test_comparisonReturnTrue_forEqualProjects() {
        let firstProject = Project(name: "Test", rateInCents: 10, totalTimeSpentInSeconds: 10)
        
        let secondProject = firstProject
        
        XCTAssertEqual(firstProject, secondProject)
    }
    
    func test_comparisonReturnFalse_forDifferentProjects() {
        let firstProject = Project(name: "Test", rateInCents: 10, totalTimeSpentInSeconds: 10)
        
        var secondProject = firstProject
        secondProject.name = "Not test"
        
        XCTAssertNotEqual(firstProject, secondProject)
    }
}
