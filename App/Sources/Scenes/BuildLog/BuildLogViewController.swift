//
//  BuildLogViewController.swift
//  App
//
//  Created by Yu Tawata on 2019/08/11.
//

import Foundation
import UIKit
import Pipeline
import Shared
import Domain

class BuildLogViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var textView: UITextView! {
        didSet {
            apply(textView, terminalStyle)
        }
    }

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView! {
        didSet {
            activityIndicatorView.hidesWhenStopped = true
        }
    }
}
