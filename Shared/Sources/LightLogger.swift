//
//  LightLogger.swift
//  Shared
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import os

public enum LogLevel {
    case verbose
    case info
    case debug
    case warning
    case error
}

extension LogLevel: Comparable {
    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        return lhs.raw < rhs.raw
    }

    var raw: Int {
        switch self {
        case .verbose: return 0
        case .info: return 1
        case .debug: return 2
        case .warning: return 3
        case .error: return 4
        }
    }
}

extension LogLevel: CustomStringConvertible {
    public var description: String {
        switch self {
        case .verbose: return "📝 [VERBOSE]"
        case .debug: return "💻 [DEBUG]"
        case .info: return "📱 [INFO]"
        case .warning: return "🔥 [WARNING]"
        case .error: return "❌ [ERROR]"
        }
    }
}

func osLogType(_ level: LogLevel) -> OSLogType {
    switch level {
    case .verbose: return .default
    case .debug: return .debug
    case .info: return .info
    case .warning: return .info
    case .error: return .error
    }
}

func fileName(of filePath: String) -> String? {
    let fileNameOrNil = filePath.components(separatedBy: "/").last
    return fileNameOrNil
}

func build(level: LogLevel, message: String, threadName: String, functionName: String, filePath: String, lineNumber: Int) -> String { // swiftlint:disable:this function_parameter_count
    if let fileName = fileName(of: filePath) {
        return "\(level.description) [\(threadName)] [\(fileName):\(lineNumber)] \(functionName) > \(message)"
    } else {
        return "\(level.description) [\(threadName)] \(functionName) > \(message)"
    }
}

public struct LightLogger {
    public static var log = OSLog.default

    static var threadName: String {
        if Thread.isMainThread {
            return "main"
        } else if let threadName = Thread.current.name, !threadName.isEmpty {
            return threadName
        } else {
            return String(format: "%p", Thread.current)
        }
    }

    static func doLog(_ level: LogLevel, _ message: String, _ log: OSLog = log) {
        let type = osLogType(level)
        os_log("%@", log: log, type: type, message)
    }

    public static func verbose(_ message: @autoclosure () -> Any, functionName: String = #function, filePath: String = #file, lineNumber: Int = #line, log: OSLog = log) {
        let message = build(level: .verbose, message: "\(message())", threadName: threadName, functionName: functionName, filePath: filePath, lineNumber: lineNumber)
        doLog(.verbose, message, log)
    }

    public static func info(_ message: @autoclosure () -> Any, functionName: String = #function, filePath: String = #file, lineNumber: Int = #line, log: OSLog = log) {
        let message = build(level: .info, message: "\(message())", threadName: threadName, functionName: functionName, filePath: filePath, lineNumber: lineNumber)
        doLog(.info, message, log)
    }

    public static func debug(_ message: @autoclosure () -> Any, functionName: String = #function, filePath: String = #file, lineNumber: Int = #line, log: OSLog = log) {
        let message = build(level: .debug, message: "\(message())", threadName: threadName, functionName: functionName, filePath: filePath, lineNumber: lineNumber)
        doLog(.debug, message, log)
    }

    public static func warning(_ message: @autoclosure () -> Any, functionName: String = #function, filePath: String = #file, lineNumber: Int = #line, log: OSLog = log) {
        let message = build(level: .warning, message: "\(message())", threadName: threadName, functionName: functionName, filePath: filePath, lineNumber: lineNumber)
        doLog(.warning, message, log)
    }

    public static func error(_ message: @autoclosure () -> Any, functionName: String = #function, filePath: String = #file, lineNumber: Int = #line, log: OSLog = log) {
        let message = build(level: .error, message: "\(message())", threadName: threadName, functionName: functionName, filePath: filePath, lineNumber: lineNumber)
        doLog(.error, message, log)
    }
}
