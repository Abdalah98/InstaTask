//
//   Helper+Ext.swift
//  InstaBostaTask
//
//  Created by Abdallah on 01/02/2023.
//


import Foundation
import UIKit
import Toast

extension  UIViewController {
    func showLoadingView(){DispatchQueue.main.async {self.view.makeToastActivity(.center)}}
    func dismissLoadingView(){DispatchQueue.main.async {self.view.hideToastActivity()}}
}
