//
// Created by Michael Beauregard on 2016-03-01.
// Copyright (c) 2016 Robots and Pencils. All rights reserved.
//

import Foundation

public protocol ExecutableQueue {
    var queue: dispatch_queue_t { get }
}

public extension ExecutableQueue {
    public func execute(closure: () -> Void) {
        dispatch_async(queue, closure)
    }
    public func executeAfter(delay delay: NSTimeInterval, closure: () -> Void) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, queue, closure)
    }
}

public enum Queue: ExecutableQueue {
    case Main
    case UserInteractive
    case UserInitiated
    case Utility
    case Background

    public var queue: dispatch_queue_t {
        switch self {
        case .Main:
            return dispatch_get_main_queue()
        case .UserInteractive:
            return dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)
        case .UserInitiated:
            return dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
        case .Utility:
            return dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
        case .Background:
            return dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
        }
    }
}
