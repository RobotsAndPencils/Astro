//
// Created by Michael Beauregard on 2015-06-11.
// Copyright (c) 2015 Robots and Pencils Inc. All rights reserved.
//
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

public protocol Logger {
    func log(level: Log.Level, message: String);
}

public struct Log {
    
    public enum Level: Int {
        case Debug
        case Info
        case Warning
        case Error
        case Silent
    }
    
    public struct BasicLogger: Logger {
        public func log(level: Level, message: String) {
            var prefix = ""
            
            switch level {
            case .Debug:
                prefix = "DEBUG"
                break
            case .Info:
                prefix = "INFO"
                break
            case .Warning:
                prefix = "WARN"
                break
            case .Error:
                prefix = "ERROR"
                break
            default:
                prefix = ""
            }
            NSLog("%@", "\(prefix): \(message)")
        }
    }
    
    public static var level = Level.Error
    public static var logger: Logger = BasicLogger()
    
    public static func debug(@autoclosure msg: () -> String) {
        if level.rawValue <= Level.Debug.rawValue {
            logger.log(.Debug, message: msg())
        }
    }
    
    public static func info(@autoclosure msg: () -> String) {
        if level.rawValue <= Level.Info.rawValue {
            logger.log(.Info, message: msg())
        }
    }
    
    public static func warn(@autoclosure msg: () -> String) {
        if level.rawValue <= Level.Warning.rawValue {
            logger.log(.Warning, message: msg())
        }
    }
    
    public static func error(@autoclosure msg: () -> String) {
        if level.rawValue <= Level.Error.rawValue {
            logger.log(.Error, message: msg())
        }
    }
}

