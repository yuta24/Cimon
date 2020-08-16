//
//  UIDevice+Extension.swift
//  Shared
//
//  Created by Yu Tawata on 2019/07/09.
//

import UIKit

extension UIDevice {
    public static var model: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        return String(validatingUTF8: NSString(bytes: &systemInfo.machine, length: Int(_SYS_NAMELEN), encoding: String.Encoding.ascii.rawValue)!.utf8String!)!
    }
    public var osVersion: String {
        return UIDevice.current.systemVersion
    }
    public var bundleIdentifier: String {
        return Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String // swiftlint:disable:this force_cast
    }
    public var shortVersion: String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String // swiftlint:disable:this force_cast
    }
    public var buildVersion: String {
        return Bundle.main.infoDictionary!["CFBundleVersion"] as! String // swiftlint:disable:this force_cast
    }
}
