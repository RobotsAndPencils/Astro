//  Copyright © 2016 Robots and Pencils, Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  Neither the name of the Robots and Pencils, Inc. nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation

/**
 Prototol that allows you to define your own Logger implementations and use them for logging messages.
 */
public protocol Logger {
    /**
     Log a message with a given log level
     
     - Parameter level: Importance level of the message to be logged
     - Parameter message: Message contents that will be logged
    */
    func log(_ level: Log.Level, message: String);
}

/**
 Log is a structure that streamlines the printing of log messages and has a basic logger implementation that logs to NSLog.
 */
public struct Log {
    
    /**
     The available levels that can be logged by the Logger. 
     
     - Debug - is good for dumping variable values and runtime details and is typically only turned on for dev builds
     - Info - is good for tracing application flow and is typically only turned on for dev builds
     - Warning - is good for logging application problems that aren't fatal or affect users
     - Error - is good for logging application errors that are fatal or impact users
     - Silent - allows you to shut off the logger completely with minimal performance impacts
    */
    public enum Level: Int {
        case debug
        case info
        case warning
        case error
        case silent
    }
    
    /**
     A default logger implementation that logs to NSLog with the log message prefixed by its log Level
    */
    public struct BasicLogger: Logger {
        public func log(_ level: Level, message: String) {
            var prefix = ""
            
            switch level {
            case .debug:
                prefix = "DEBUG"
                break
            case .info:
                prefix = "INFO"
                break
            case .warning:
                prefix = "WARN"
                break
            case .error:
                prefix = "ERROR"
                break
            default:
                prefix = ""
            }
            NSLog("%@", "\(prefix): \(message)")
        }
    }
    
    /**
     Contains the current logging level that is configured
     */
    public static var level = Level.error
    
    /**
     Contains the current logger that is configured
     */
    public static var logger: Logger = BasicLogger()
    
    /**
     Log a debug message
     */
    public static func debug(_ msg: @autoclosure () -> String) {
        if level.rawValue <= Level.debug.rawValue {
            logger.log(.debug, message: msg())
        }
    }
    
    /**
     Log an info message
     */
    public static func info(_ msg: @autoclosure () -> String) {
        if level.rawValue <= Level.info.rawValue {
            logger.log(.info, message: msg())
        }
    }
    
    /**
     Log a warning message
     */
    public static func warn(_ msg: @autoclosure () -> String) {
        if level.rawValue <= Level.warning.rawValue {
            logger.log(.warning, message: msg())
        }
    }
    
    /**
     Log an error message
     */
    public static func error(_ msg: @autoclosure () -> String) {
        if level.rawValue <= Level.error.rawValue {
            logger.log(.error, message: msg())
        }
    }
}

