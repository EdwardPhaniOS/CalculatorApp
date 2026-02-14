//
//  UIView+Ext.swift
//  CalculatorApp
//
//  Created by Vinh Phan on 13/2/26.
//

import UIKit

extension UIView {
  
  @discardableResult
  func anchor(top: NSLayoutYAxisAnchor? = nil,
              topConstant: CGFloat = 0,
              trailing: NSLayoutXAxisAnchor? = nil,
              trailingConstant: CGFloat = 0,
              bottom: NSLayoutYAxisAnchor? = nil,
              bottomConstant: CGFloat = 0,
              leading: NSLayoutXAxisAnchor? = nil, 
              leadingConstant: CGFloat = 0, 
              centerX: NSLayoutXAxisAnchor? = nil,
              centerXConstant: CGFloat = 0,
              centerY: NSLayoutYAxisAnchor? = nil, 
              centerYConstant: CGFloat = 0, 
              width: CGFloat? = nil, 
              height: CGFloat? = nil) -> [NSLayoutConstraint] {
    
    translatesAutoresizingMaskIntoConstraints = false
    
    var constraints = [NSLayoutConstraint]()
    
    if let top = top {
      constraints
        .append(topAnchor.constraint(equalTo: top, constant: topConstant))
    }
    
    if let bottom = bottom {
      constraints
        .append(
          bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant)
        )
    }
    
    if let leading = leading {
      constraints
        .append(
          leadingAnchor.constraint(equalTo: leading, constant: leadingConstant)
        )
    }
    
    if let trailing = trailing {
      constraints
        .append(
          trailingAnchor
            .constraint(equalTo: trailing, constant: -trailingConstant)
        )
    }
    
    if let centerX = centerX {
      constraints
        .append(
          centerXAnchor.constraint(equalTo: centerX, constant: centerXConstant)
        )
    }
    
    if let centerY = centerY {
      constraints
        .append(
          centerYAnchor.constraint(equalTo: centerY, constant: centerYConstant)
        )
    }
    
    if let width = width {
      constraints.append(widthAnchor.constraint(equalToConstant: width))
    }
    
    if let height = height {
      constraints.append(heightAnchor.constraint(equalToConstant: height))
    }
    
    NSLayoutConstraint.activate(constraints)
    
    return constraints
  }
  
  func roundCorner(_ radius: CGFloat = 8) {
    self.layer.cornerRadius = radius
    self.layer.masksToBounds = true
  }
}
