//
//  UIColor+Ext.swift
//  CalculatorApp
//
//  Created by Vinh Phan on 14/2/26.
//

import UIKit

extension UIColor {
  // Primary
  static var royalBlue: UIColor { UIColor(hex: "#1E3A8A")! }
  
  // Accent
  static var gold: UIColor { UIColor(hex: "#D4AF37")! }
  
  // Background
  static var offWhite: UIColor { UIColor(hex: "#F9FAFB")! }
  
  // Secondary Text
  static var slateGray: UIColor { UIColor(hex: "#6B7280")! }
  
  // Highlight / Active
  static var skyBlue: UIColor { UIColor(hex: "#3B82F6")! }
  
  // Error / Alert
  static var crimson: UIColor { UIColor(hex: "#DC2626")! }
}

extension UIColor {
  convenience init?(hex: String) {
    var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
    
    var rgb: UInt64 = 0
    let length = hexSanitized.count
    
    guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
    
    var r, g, b, a: CGFloat
    switch length {
    case 6: // RGB (no alpha)
      r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
      g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
      b = CGFloat(rgb & 0x0000FF) / 255.0
      a = 1.0
    case 8: // RGBA
      r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
      g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
      b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
      a = CGFloat(rgb & 0x000000FF) / 255.0
    default:
      return nil
    }
    
    self.init(red: r, green: g, blue: b, alpha: a)
  }
}
