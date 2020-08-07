//
//  CustomNavigateController.swift
//
//  Created by Arthur Luiz Lara Quites
//  Copyright © 2020 Arthur Luiz Lara Quites. All rights reserved.
//


import Foundation
import UIKit

class CustomNavigationController: UINavigationController {
    
    // overload this so you can delegate to each subclass the definition of the supported interface orientations
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return self.topViewController!.supportedInterfaceOrientations
    }
}

