//
//  BuildLogViewController.swift
//  App
//
//  Created by Yu Tawata on 2019/08/11.
//

import UIKit
import Common
import Domain
import Core

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
