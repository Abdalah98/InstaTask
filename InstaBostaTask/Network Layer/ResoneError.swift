//
//  ResoneError.swift
//  InstaBostaTask
//
//  Created by Abdallah on 02/02/2023.
//

import Foundation
enum ResoneError :String,Error{
    case invaldURL               = "This URL invalid request."
    case invalidData             = "The data received from the server was invalid. Please try again."
}
