//
//  GameTile+Train.swift
//  Look Left Look Right
//
//  Created by Jia Chen Yee on 5/5/25.
//

import Foundation

extension GameTile {
    struct Train: Codable {
        var id = UUID()
        
        // can be +ve or -ve, just to represent how far along the "run over animation" the train starts off with
        var startTimeOffset: TimeInterval
        
        // the train runs every x seconds
        var frequency: TimeInterval
        
        // how fast train move (m/s)
        var speed: Double
        
        // how long is the train car
        var cars: Int
        
        // is the train coming from lhs or rhs
        var direction: Direction
        
        var length: Double {
            Double(cars) * Constants.trainCarLength + Double(cars - 1) * Constants.trainCarLinkerLength
        }
        
        enum Direction: Int, Equatable, Codable {
            case left
            case right
            
            static func random() -> Self {
                Bool.random() ? .left : .right
            }
        }
        
        static func random() -> Self {
            let speed: Double = .random(in: 0.2...2)
            let cars: Int = 1 //Int.random(in: 1...3)
            
            let trainLength = Double(cars) * Constants.trainCarLength + Double(cars - 1) * Constants.trainCarLinkerLength
            
            let timeToTravelAcross = (trainLength + Constants.totalWidth) / speed
            
            let frequency: TimeInterval = .random(in: timeToTravelAcross...timeToTravelAcross * 2)
            let startTimeOffset = TimeInterval.random(in: -frequency...frequency)
            
            return Train(startTimeOffset: startTimeOffset, frequency: frequency, speed: speed, cars: cars, direction: .random())
        }
        
        // return in meters offset from 0
        func position(for startTime: Date, currentTime: Date) -> Double? {
            let elapsed = currentTime.timeIntervalSince(startTime) + startTimeOffset
            
            let timeSinceLastTrain = abs(elapsed.truncatingRemainder(dividingBy: frequency))
            
            let trainLength = Double(cars) * Constants.trainCarLength + Double(cars - 1) * Constants.trainCarLinkerLength
            
            switch direction {
            case .left:
                return -trainLength + speed * timeSinceLastTrain
            case .right:
                return Constants.totalWidth - speed * timeSinceLastTrain
            }
        }
        
        func inCrashRange(for position: Double) -> Bool {
            let front = position
            let rear = front + length
            
            let trainRange = min(front, rear)...max(front, rear)
            
            return trainRange.overlaps(Constants.crashRange)
        }
    }
}
