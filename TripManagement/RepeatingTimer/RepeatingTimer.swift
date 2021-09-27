//
//  Timer.swift
//  TripManagement
//
//  Created by Virtual Dusk  on 25/09/21.
//

import Foundation
import UIKit

class RepeatingTimer{
    
    let timeInterval : TimeInterval
    init(timeInterval : TimeInterval) {
        self.timeInterval = timeInterval
    }
    private lazy var timer : DispatchSourceTimer = {
        let queue = DispatchQueue(label: Bundle.main.bundleIdentifier! + "timer")
        let t = DispatchSource.makeTimerSource(queue: queue)
        
        t.schedule(deadline: .now() + .seconds(Int(self.timeInterval)) , repeating: .seconds(Int(self.timeInterval)))
        t.setEventHandler(handler: { [weak self] in
            self?.eventHandler?()
        })
        return t
    }()
    
    var eventHandler: (() -> Void)?
    
    private enum State {
        case suspended
        case resumed
    }
    
    private var state: State = .suspended
    
    deinit {
        timer.setEventHandler {}
        timer.cancel()
        resume()
        eventHandler = nil
    }
    
    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }
    
    func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
}
