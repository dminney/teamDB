//
//  StopwatchModel.swift
//  Team_stopWatch
//
//  Created by Dave Minney on 11/30/17.
//  Copyright © 2017 dminn. All rights reserved.
//

import Foundation

class StopWatchModel {

    var  startTime =  Date()
    var  timing : Bool = false
    
    func starttimer() {
        startTime = Date()
        timing = true
    }
    
    func stoptimer()
    {
        timing = false
    }
    
    @objc func elapsedTime() -> Double {
        
        let timeElapsed = Date().timeIntervalSince1970 - startTime.timeIntervalSince1970
        return timeElapsed
    }

  func elapsedTimeasString() -> String {
        
        let timeElapsed = Date().timeIntervalSince1970 - startTime.timeIntervalSince1970
        let timeString = stringFromTimeInterval(interval: timeElapsed)
    
    return timeString as String
    }
    
    
    func stringFromTimeInterval(interval: TimeInterval) -> NSString {
        
        let ti = NSInteger(interval)
        
        let ms = Int(interval.truncatingRemainder(dividingBy: 1) * 100)
        
        let seconds = ti % 60
        let minutes = (ti / 60)
        
        
        return NSString(format: "%0.2d:%0.2d.%.2d",minutes,seconds,ms)
    }
}
