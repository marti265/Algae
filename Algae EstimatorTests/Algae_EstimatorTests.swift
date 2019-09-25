//
//  Algae_EstimatorTests.swift
//  Algae EstimatorTests
//
//  Created by App Factory on 9/30/16.
//  Copyright © 2016 Software Engineering. All rights reserved.
//

import XCTest
@testable import Algae_Estimator

class Algae_EstimatorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCalculations() {
        let calculations = Calculations(total_chla: Float(4.0), cyano_chla: Float(4.0), Pbot: Float(4.0), surtemp: Float(3.0), bottemp: Float(2.0), depth: Float(4.0), lux: Float(100.0))
        
        
        XCTAssertNotNil(calculations.getCyanoCurTime())
        XCTAssertNotNil(calculations.getTotalCurTime())
        XCTAssertNotNil(calculations.getK1())
        XCTAssertNotNil(calculations.getK2())
        XCTAssertNotNil(calculations.getR01())
        XCTAssertNotNil(calculations.getR02())
        XCTAssertNotNil(calculations.getT_CUR_CHL(isTotal: true))
        XCTAssertNotNil(calculations.getCyanoChlaDataSet())
        XCTAssertNotNil(calculations.getTotalChlaDataSet())
        XCTAssertNotNil(Calculations.estimateTotalChla(SD_value: Float(4.0), DO_value: Float(3.0)))
        XCTAssertNotNil(Calculations.estimateCyanoChla(SD_value: Float(4.0), surtemp: Float(4.0)))
    }
    
    func testCalculationsSmallValues() {
        let calculations = Calculations(total_chla: Float(0.000000000000008), cyano_chla: Float(0.578557587278), Pbot: Float(0.7472727), surtemp: Float(0.0000000005070585), bottemp: Float(0.827282782), depth: Float(0.7857858527278), lux: Float(0.0000875857))
        
        
        XCTAssertNotNil(calculations.getCyanoCurTime())
        XCTAssertNotNil(calculations.getTotalCurTime())
        XCTAssertNotNil(calculations.getK1())
        XCTAssertNotNil(calculations.getK2())
        XCTAssertNotNil(calculations.getR01())
        XCTAssertNotNil(calculations.getR02())
        XCTAssertNotNil(calculations.getT_CUR_CHL(isTotal: true))
        XCTAssertNotNil(calculations.getCyanoChlaDataSet())
        XCTAssertNotNil(calculations.getTotalChlaDataSet())
        XCTAssertNotNil(Calculations.estimateTotalChla(SD_value: Float(4.0), DO_value: Float(3.0)))
        XCTAssertNotNil(Calculations.estimateCyanoChla(SD_value: Float(4.0), surtemp: Float(4.0)))
    }
    
    func testCalculationsLargeNumbers() {
        let calculations = Calculations(total_chla: Float(88888888884.0), cyano_chla: Float(57872782782784.0), Pbot: Float(88767782784.0), surtemp: Float(38787878678.0), bottemp: Float(7868737837837832.0), depth: Float(5437827537374.0), lux: Float(1231561684946100.0))
        
        
        XCTAssertNotNil(calculations.getCyanoCurTime())
        XCTAssertNotNil(calculations.getTotalCurTime())
        XCTAssertNotNil(calculations.getK1())
        XCTAssertNotNil(calculations.getK2())
        XCTAssertNotNil(calculations.getR01())
        XCTAssertNotNil(calculations.getR02())
        XCTAssertNotNil(calculations.getT_CUR_CHL(isTotal: true))
        XCTAssertNotNil(calculations.getCyanoChlaDataSet())
        XCTAssertNotNil(calculations.getTotalChlaDataSet())
        XCTAssertNotNil(Calculations.estimateTotalChla(SD_value: Float(4.0), DO_value: Float(3.0)))
        XCTAssertNotNil(Calculations.estimateCyanoChla(SD_value: Float(4.0), surtemp: Float(4.0)))
    }
    
    func testCalculationsTrying() {
        let calculations = Calculations(total_chla: Float(88888888884.0), cyano_chla: Float(57872782782784.0), Pbot: Float(88767782784.0), surtemp: Float(38787878678.0), bottemp: Float(7868737837837832.0), depth: Float(5437827537374.0), lux: Float(1231561684946100.0))
        
        
        XCTAssertNotNil(calculations.getCyanoCurTime())
        XCTAssertNotNil(calculations.getTotalCurTime())
        XCTAssertNotNil(calculations.getK1())
        XCTAssertNotNil(calculations.getK2())
        XCTAssertNotNil(calculations.getR01())
        XCTAssertNotNil(calculations.getR02())
        XCTAssertNotNil(calculations.getT_CUR_CHL(isTotal: true))
        XCTAssertNotNil(calculations.getCyanoChlaDataSet())
        XCTAssertNotNil(calculations.getTotalChlaDataSet())
        XCTAssertNotNil(Calculations.estimateTotalChla(SD_value: Float(4.0), DO_value: Float(3.0)))
        XCTAssertNotNil(Calculations.estimateCyanoChla(SD_value: Float(4.0), surtemp: Float(4.0)))
    }
    
}
