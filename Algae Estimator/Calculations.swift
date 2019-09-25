//
//  File.swift
//  Algae Estimator
//
//  Created by App Factory on 10/5/16.
//  Copyright © 2016 Software Engineering. All rights reserved.
//

import Foundation

class Calculations {
    
    
    // All of the require constant
    let R0_MIN: Float = 0.001
    let R0_MAX: Float = 0.065
    let N0_MIN: Float = 5
    let GROWTH_RATE_SCALE: Float = 1.635
    let TIMESHIFT: Int = 21
    var N0:Float
    
    // Parameters main
    var total_chla: Float
    var cyano_chla:Float
    var Pbot:Float
    var surtemp:Float
    var bottemp:Float
    var depth:Float
    var lux:Float
    
    // Direct constructor
    public init(total_chla:Float, cyano_chla: Float,Pbot:Float, surtemp:Float,bottemp:Float, depth:Float, lux:Float){
        self.total_chla = total_chla
        self.cyano_chla = cyano_chla
        self.Pbot = Pbot
        self.surtemp = surtemp
        self.bottemp = bottemp
        self.depth = depth
        self.lux = lux
        self.N0 = N0_MIN
    }
    //Estimate constructor
    public init(SD_value:Float, DO_value:Float,Pbot:Float,surtemp:Float, bottemp:Float, depth:Float, lux:Float, estimate:Bool) {
        self.cyano_chla = Calculations.estimateCyanoChla(SD_value: SD_value,surtemp: surtemp)
        if (DO_value>0) {
            self.total_chla = Calculations.estimateTotalChla(SD_value: SD_value, DO_value: DO_value)
        } else {
            self.total_chla = 0
        }
        self.Pbot = Pbot
        self.surtemp = surtemp
        self.bottemp = bottemp
        self.depth = depth
        self.lux = lux
        self.N0 = N0_MIN
    }
    
    func getTotalCurTime() -> Int {
        return 0
    }
    
    func getCyanoCurTime() -> Int{
        return 0
    }
    
    // static methods to return estimate Chla
    static func estimateTotalChla(SD_value: Float, DO_value:Float) -> Float {
        return -6.4775 + 21.6396 * (1/SD_value) + 0.0006 * Float(pow(DO_value,2))
    }
    
    static func estimateCyanoChla(SD_value: Float, surtemp: Float) -> Float{
        return 0.409 - 0.7486 * surtemp + 17.6979 * (1/SD_value)
    }
    
    func getK1() -> Float {
        let pav = Pbot/depth
        var K1 = 1875 * pav - 7.5
        if (K1<0) {
            K1 = 0
        }
        if (K1>250) {
            K1=250
        }
        return K1
    }
    
    func getK2() -> Float{
        let pav = Pbot/depth
        var K2 = 1625 * pav - 12.5
        if (K2<0) {
            K2 = 0
        }
        if (K2>200) {
            K2 = 200
        }
        return K2
    }
    
    func getR01() -> Float {
        let pav = Pbot/depth
        var tempdiff: Float
        
        var R01 = R0_MIN
        tempdiff = surtemp - bottemp
        if (surtemp > 15 && pav > 0.02 && tempdiff < 4) {
            
            R01 = R0_MAX * Float(min(-tempdiff / 3 + 4 / 3, 10 * pav))
            if (tempdiff <= 1 && pav <= 0.1) {
                R01 = R0_MAX * 10 * pav
            }
            
            if (tempdiff > 1 && pav > 0.1) {
                R01 = R0_MAX*(-tempdiff/3+4/3)
            }
            if (tempdiff <= 1 && pav > 0.1) {
                R01 = R0_MAX
            }
        }
        
        R01 = R01 * Float(exp(-pow(0.17*(surtemp-27),2)))
        if(lux<12000) {
            R01 = R01 * lux/12000
        }
        return R01
    }
    
    func getR02() -> Float {
        let pav: Float = Pbot/depth
        var tempdiff: Float
        var R02: Float = R0_MIN
        tempdiff = surtemp - bottemp
        if (surtemp > 18 && pav > 0.02 && tempdiff < 4) {
            R02 = R0_MAX * min((-tempdiff/3+4/3),10*pav)
            if (tempdiff <= 1 && pav <= 0.1) {
                R02 = R0_MAX*10*pav
            }
            if (tempdiff > 1 && pav > 0.1) {
                R02 = R0_MAX*(-tempdiff/3+4/3)
            }
            if (tempdiff <= 1 && pav > 0.1)
            {
                R02 = R0_MAX
            }
        }
        R02 = R02 * Float (exp(-pow((0.17)*(surtemp-27),2)))
        if(lux<12000)
        {
            R02 = R02 * lux/12000
        }
        return R02
    }
    
    func getT_CUR_CHL(isTotal: Bool) -> Float{
        var t_cur_Chl: Float = 0
        var R0: Float
        var K: Float
        var N_CUR_CHL:Float
        if(isTotal){
            R0 = getR01()
            K = getK1()
            N_CUR_CHL = total_chla
        }
        else{
            R0 = getR02()
            K = getK2()
            N_CUR_CHL = cyano_chla
        }
        t_cur_Chl = t_cur_Chl - (1/(R0*GROWTH_RATE_SCALE)) * Float (log((N0 * K / N_CUR_CHL-N0)/(K-N0))) + Float(TIMESHIFT)
        return t_cur_Chl
    }
    
    func getTotalChlaDataSet() -> Array<Float>{
        var totalDataSet: Array<Float> = [Float]()
        totalDataSet.append(0)
        var q:Int = 0
        let K:Float = getK1()
        let R0:Float = getR01()
        var Nt_continuous:Float = (N0 * K)/(N0+(K - N0) * Float (exp(-R0 * GROWTH_RATE_SCALE * Float(q - TIMESHIFT))))
        totalDataSet.append(Nt_continuous)
        while (K-Nt_continuous>0.1&&q<360){
            q += 1
            Nt_continuous = (N0*K)/(N0+(K-N0)*Float(exp(-R0*GROWTH_RATE_SCALE*Float((q-TIMESHIFT)))))
            totalDataSet.append(Nt_continuous)
            
        }
        let peak:Int = q
        for q in((q + 1)..<401){
            let tempTemp: Int = (-(q - 2 * peak) - TIMESHIFT)
            let temp:Float = exp(-R0 * GROWTH_RATE_SCALE * Float(tempTemp))
            Nt_continuous = (N0*K)/(N0+(K-N0) * temp)
            totalDataSet.append(Nt_continuous)
        }
        return totalDataSet
    }
    
    func getCyanoChlaDataSet() -> Array<Float>{
        var cyanoDataSet:Array<Float> = [Float]()
        cyanoDataSet.append(0)
        var q:Int = 0
        let K:Float = getK2()
        let R0:Float = getR02()
        var Nt_continuous:Float = (N0*K)/(N0+(K-N0)*Float(exp(-R0*GROWTH_RATE_SCALE * Float((q-TIMESHIFT)))))
        cyanoDataSet.append(Nt_continuous)
        while (K-Nt_continuous>0.1&&q<360){
            q += 1
            Nt_continuous = (N0*K)/(N0+(K-N0)*Float(exp(-R0*GROWTH_RATE_SCALE*Float((q-TIMESHIFT)))))
            cyanoDataSet.append(Nt_continuous)
            
        }
        let peak:Int = q
        for q in((q + 1)..<401){
            let temp:Float = exp(-R0*GROWTH_RATE_SCALE * Float((-(q-2*peak)-TIMESHIFT)))
            Nt_continuous = (N0*K)/(N0+(K-N0)*temp)
            cyanoDataSet.append(Nt_continuous)
        }
        return cyanoDataSet
    }
}



