//
//  CalculatorViewModel.swift
//  CalculatorApp
//
//  Created by Vinh Phan on 13/2/26.
//

import Foundation

class CalculatorViewModel {
  
  // MARK: Callback
  var displayResultCallback: ((String) -> Void)?
  var displayErrorCallback: ((String) -> Void)?
  
  // MARK: Variable
  private var expressionTokens: [String] = []
  private var currentInput: String = ""
  private var resultText: String = ""
  private var showingResult: Bool = false
  
  // MARK: Public APIs
  func clearAll() {
    expressionTokens = []
    currentInput = ""
    resultText = "0"
    showingResult = true
    updateDisplay()
  }
  
  func handleInput(_ input: String) {
    //If input is a digit right after showing result
    if showingResult && "123456789".contains(input) {
      expressionTokens = []
      currentInput = ""
      resultText = "0"
      showingResult = false
    }
    
    switch input {
    case "C":
      clearAll()
    case "+/-":
      toggleSignCurrent()
    case "%":
      percentageCurrent()
    case ",":
      appendDecimalCurrent()
    case "+", "-", "x", "/":
      appendOperator(input)
    case "=":
      evaluateExpress()
    default:
      //digits
      appendDigit(input)
    }
  }
  
  // MARK: Internal Behaviors
  private func toggleSignCurrent() {
    if showingResult {
      if let result = expressionTokens.last, !isOperators(result) {
        currentInput = result
        expressionTokens = []
      }
      showingResult = false
    }
    
    if currentInput.hasPrefix("-") {
      currentInput.removeFirst()
    } else {
      currentInput = currentInput.isEmpty ? "-0" : "-\(currentInput)"
    }
    
    updateDisplay()
  }
  
  private func appendOperator(_ op: String) {
    commitCurrentInputIfNeeded()
    if let last = expressionTokens.last, isOperators(last) {
      expressionTokens.removeLast()
    }
    expressionTokens.append(op)
    showingResult = false
    updateDisplay()
  }
  
  private func appendDigit(_ digit: String) {
    if currentInput == "0" && digit == "0" { return }
    if currentInput == "0" && digit != "0" {
      currentInput = digit
    } else {
      currentInput += digit
    }
    updateDisplay()
  }
  
  private func percentageCurrent() {
    if showingResult {
      if let result = expressionTokens.last, !isOperators(result) {
        currentInput = result
        expressionTokens = []
      }
      showingResult = false
    }
    
    if currentInput.contains("%") { return }
    
    if currentInput.isEmpty {
      currentInput = "0%"
    } else {
      currentInput.append("%")
    }
    
    updateDisplay()
  }
  
  private func appendDecimalCurrent() {
    if showingResult {
      if let result = expressionTokens.last, !isOperators(result) {
        currentInput = result
        expressionTokens = []
      }
      showingResult = false
    }
    
    if currentInput.contains(",") { return }
    
    if currentInput.isEmpty {
      currentInput = "0,"
    } else {
      currentInput.append(",")
    }
    
    updateDisplay()
  }
  
  private func evaluateExpress() {
    commitCurrentInputIfNeeded()
    let exp = expressionTokens.joined(separator: " ")
      .replacingOccurrences(of: "x", with: "*")
      .replacingOccurrences(of: ",", with: ".")
      .replacingOccurrences(of: "%", with: " / 100")
      .trimmingCharacters(in: .whitespacesAndNewlines)
    
    if exp.isEmpty {
      resultText = "0"
      showingResult = true
      updateDisplay()
      return
    }
    
    do {
      let val = try ExpressionEvaluator.evaluate(expression: exp)
      resultText = formatDisplay(val)
      currentInput = ""
      expressionTokens = [resultText]
      showingResult = true
      updateDisplay()
    } catch {
      displayErrorCallback?("Error")
    }
  }
  
  func commitCurrentInputIfNeeded() {
    if !currentInput.isEmpty {
      expressionTokens.append(currentInput)
      currentInput = ""
    }
  }
  
  // MARK: Helpers
  func updateDisplay() {
    if showingResult {
      displayResultCallback?(resultText)
    } else {
      var parts = expressionTokens
      if !currentInput.isEmpty {
        parts.append(currentInput)
      }
      
      let text = parts.joined(separator: " ")
      displayResultCallback?(text)
    }
  }
  
  func isOperators(_ input: String) -> Bool {
    return ["+", "-", "x", "*", "/", "="].contains(input)
  }
  
  func formatDisplay(_ val: Double) -> String {
    if val.rounded(.towardZero) == val {
      return String(Int(val))
    } else {
      let s = trimmingTrailingZero(String(val))
      return s.replacingOccurrences(of: ".", with: ",")
    }
  }
  
  func trimmingTrailingZero(_ s: String) -> String {
    var text = s
    if text.contains(".") {
      while text.last == "0" {
        text.removeLast()
        if text.last == "." {
          text.removeLast()
        }
      }
    }
    
    return text
  }
  
}
