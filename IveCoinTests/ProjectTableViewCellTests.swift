//
//  ProjectTableViewCellTests.swift
//  IveCoin
//
//  Created by vlad on 5/7/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import XCTest
@testable import IveCoin

class ProjectTableViewCellTests: XCTestCase {
    func test_displayedInfoCorrect_afterCharge() {
        class MocProjectTableViewCell: ProjectTableViewCell {
            var _nameLabel = UILabel()
            var _rateLabel = UILabel()
            var _totalMoneyLabel = UILabel()
            
            override var nameLabel: UILabel! {
                get {
                    return _nameLabel
                }
                set{}
            }
            override var rateLabel: UILabel! {
                get {
                    return _rateLabel
                }
                set{}
            }
            override var totalMoneyLabel: UILabel! {
                get {
                    return _totalMoneyLabel
                }
                set{}
            }
        }
        
        let cell = MocProjectTableViewCell()
        
        let projectName = "Test Project"
        
        let testProject = Project(name: projectName, rateInCents: 3500, totalTimeSpentInSeconds: 3600)
        
        cell.charge(withProject: testProject)
        
        XCTAssertEqual(cell.nameLabel.text, projectName)
        XCTAssertEqual(cell.rateLabel.text, "35$")
    }
}
