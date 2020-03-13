//
//  UIView + Extension.swift
//  MyHealthManagement
//
//  Created by EVERTRUST on 2020/3/12.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

extension UIView {
    public func asImage() -> UIImage {
        return UIGraphicsImageRenderer(bounds: self.bounds).image {
            self.layer.render(in: $0.cgContext)
        }
    }
}
