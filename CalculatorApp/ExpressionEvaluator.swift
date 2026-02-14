//
//  ExpressionEvaluator.swift
//  CalculatorApp
//
//  Created by Vinh Phan on 13/2/26.
//

import Foundation

enum EvalError: Error, LocalizedError {
  case syntaxError
  case devideZero
  
  var errorDescription: String? {
    switch self {
    case .syntaxError:
      return "Syntax Error"
    case .devideZero:
      return "Can not devide zero"
    }
  }
}

struct ExpressionEvaluator {
  
  static func evaluate(expression: String) throws -> Double {
    let tokens = tokenize(expression: expression)
    let rpn = try shuntingYard(tokens: tokens)
    return try evalRPN(rpn)
  }
  
  private static func tokenize(expression: String) -> [String] {
    let exp = expression
      .replacingOccurrences(of: "(", with: " ( ")
      .replacingOccurrences(of: ")", with: " ) ")
    
    return exp.components(separatedBy: " ").filter { !$0.isEmpty }
  }
  
  private static func shuntingYard(tokens: [String]) throws -> [String] {
    var output: [String] = []
    var operations: [String] = []
    
    var i = 0
    while i <= tokens.count-1 {
      let token = tokens[i]
      
      if let _ = Double(token) {
        output.append(token)
      } else if isOperator(token) {
        if token == "-" {
          let prev = i == 0 ? "" : tokens[i-1]
          if i == 0 || prev == "(" || isOperator(prev) {
            if i+1 <= tokens.count-1 {
              let next = tokens[i+1]
              if let _ = Double(next) {
                output.append("-\(next)")
                i += 1
                i += 1
                continue
              } else if next == "(" {
                output.append("0")
                operations.append(token)
              } else {
                throw EvalError.syntaxError
              }
              
            } else {
              throw EvalError.syntaxError
            }
          } else {
            while operations.last != nil && operatorPriority(operations.last!) >= operatorPriority(token) {
              let op = operations.removeLast()
              output.append(op)
            }
            
            operations.append(token)
          }
        } else {
          while operations.last != nil && operatorPriority(operations.last!) >= operatorPriority(token) {
            let op = operations.removeLast()
            output.append(op)
          }
          
          operations.append(token)
        }
      } else if token == "(" {
        operations.append(token)
      } else if token == ")" {
        var found = false
        
        while operations.last != nil {
          let op = operations.removeLast()
          if op == "(" {
            found = true
            break
          }
          
          output.append(op)
        }
        
        if !found {
          throw EvalError.syntaxError
        }
      } else {
        throw EvalError.syntaxError
      }
      
      i += 1
    }
    
    while operations.last != nil {
      let op = operations.removeLast()
      if op == "(" || op == ")" {
        throw EvalError.syntaxError
      }
      
      output.append(op)
    }
    
    return output
  }
  
  private static func evalRPN(_ rpn: [String]) throws -> Double {
    var stack: [Double] = []
    
    for token in rpn {
      if let num = Double(token) {
        stack.append(num)
      } else if isOperator(token) {
        
        guard stack.count >= 2 else { throw EvalError.syntaxError }
        let b = stack.removeLast()
        let a = stack.removeLast()
        let result: Double
        
        switch token {
        case "-":
          result = a - b
        case "+":
          result = a + b
        case "/":
          if b == 0 {
            throw EvalError.devideZero
          }
          result = a / b
        case "*":
          result = a * b
        default:
          throw EvalError.syntaxError
        }
        
        stack.append(result)
      } else {
        throw EvalError.syntaxError
      }
    }
    
    return stack[0]
  }
  
  private static func isOperator(_ token: String) -> Bool {
    let operators = ["+", "-", "*", "/"]
    return operators.contains { $0 == token }
  }
  
  private static func operatorPriority(_ op: String) -> Int {
    if op == "+" || op == "-" {
      return 1
    } else if op == "*" || op == "/" {
      return 2
    } else {
      return 0
    }
  }
}
