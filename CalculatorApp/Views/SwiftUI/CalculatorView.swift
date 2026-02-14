//
//  CalculatorView.swift
//  CalculatorApp
//
//  Created by Vinh Phan on 14/2/26.
//

import SwiftUI

struct CalculatorView: View {
  // MARK: Variables
  private var buttons: [[String]] = [
    ["C", "+/-", "%", "/"],
    ["9", "8", "7", "x"],
    ["6", "5", "4", "-"],
    ["1", "2", "3", "+"]
  ]
  
  @ObservedObject
  private var viewModel: CalculatorVM
  
  init(viewModel: CalculatorVM = CalculatorVM()) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    VStack(spacing: 8) {
      Spacer()
      textView
      firstFourRowView
      lastRowView
    }
    .padding()
  }
}

extension CalculatorView {
  
  var textView: some View {
    HStack() {
      Spacer()
      Text(viewModel.displayValue)
        .font(.system(size: 42))
        .foregroundStyle(viewModel.textColor)
        .fontWeight(.semibold)
        .multilineTextAlignment(.trailing)
    }
    .padding(.trailing, 8)
  }
  
  var firstFourRowView: some View {
    ForEach(buttons, id: \.self) { row in
      HStack(spacing: 16) {
        ForEach(row, id: \.self) { title in
          createButton(title: title)
        }
      }
    }
  }
  
  var lastRowView: some View {
    HStack(spacing: 16) { 
      createButton(title: "0")
      
      HStack(spacing: 16) {
        createButton(title: ",")
        createButton(title: "=")
      }
    }
  }
}

extension CalculatorView {
  func createButton(title: String) -> some View {
    Button {
      viewModel.handleInput(title)
    } label: { 
      Text(title)
        .font(.title2)
        .frame(maxWidth: .infinity, minHeight: 72)
        .foregroundStyle(Color.white)
        .background(getButtonBackgroundColor(title: title))
        .cornerRadius(16)
    }
  }
  
  func getButtonBackgroundColor(title: String) -> Color {
    if "0123456789".contains(title) {
      return Color(uiColor: UIColor.royalBlue)
    } else if ["+", "-", "x", "/"].contains(title) {
      return Color(uiColor: UIColor.gold)
    } else if title == "=" {
      return Color(uiColor: UIColor.skyBlue)
    } else {
      return Color(uiColor: UIColor.slateGray)
    }
  }
}

#Preview {
  CalculatorView()
}
