//
//  CalculatorViewController.swift
//  CalculatorApp
//
//  Created by Vinh Phan on 13/2/26.
//

import UIKit

class CalculatorViewController: UIViewController {
  
  // MARK: View elements
  private var displayLabel: UILabel = {
    let label = UILabel()
    label.text = "0"
    label.font = .systemFont(ofSize: 42, weight: .semibold)
    label.textAlignment = .right
    label.textColor = UIColor.royalBlue
    return label
  }()
  
  // MARK: Variables
  private var buttons: [[String]] = [
    ["C", "+/-", "%", "/"],
    ["9", "8", "7", "x"],
    ["6", "5", "4", "-"],
    ["1", "2", "3", "+"],
    ["0", ",", "="],
  ]
  
  private var viewModel: CalculatorViewModel!
  
  // MARK: View's life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.offWhite
    setupUI()
    bindViewModel()
  }
  
  func configure(viewModel: CalculatorViewModel = CalculatorViewModel()) {
    self.viewModel = viewModel
  }
  
  // MARK: Layout
  func setupUI() {
    let buttonStack = UIStackView()
    buttonStack.axis = .vertical
    buttonStack.spacing = 16
    
    let safeArea = view.safeAreaLayoutGuide
    view.addSubview(buttonStack)
    buttonStack.anchor(
      trailing: safeArea.trailingAnchor, 
      trailingConstant: 16,
      bottom: safeArea.bottomAnchor, 
      bottomConstant: 16,
      leading: safeArea.leadingAnchor, 
      leadingConstant: 16
    )
    
    let totalWidth: CGFloat = self.view.bounds.width - 32
    let totalItems: CGFloat = 4
    let totalSpace: CGFloat = (totalItems - 1) * 16
    let itemWidth: CGFloat = (totalWidth - totalSpace) / totalItems
    
    for (_, row) in buttons.enumerated() {
      let buttonRow = UIStackView()
      buttonRow.axis = .horizontal
      buttonRow.alignment = .fill
      buttonRow.distribution = .equalSpacing
      
      for title in row {
        if title == "0" {
          let button = makeButton(title: title, width: itemWidth * 2 + 16, height: 72)
          buttonRow.addArrangedSubview(button)
        } else {
          let button = makeButton(title: title, width: itemWidth, height: 72)
          buttonRow.addArrangedSubview(button)
        }
      }
      
      buttonStack.addArrangedSubview(buttonRow)
    }
    
    view.addSubview(displayLabel)
    displayLabel.anchor(
      trailing: buttonStack.trailingAnchor, 
      trailingConstant: 16,
      bottom: buttonStack.topAnchor, 
      bottomConstant: 16,
      leading: buttonStack.leadingAnchor,
      height: 42
    )
  }
  
  func makeButton(title: String, width: CGFloat, height: CGFloat) -> UIButton {
    let button = UIButton(type: .system)
    button.setTitle(title, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 22, weight: .semibold)
    button.roundCorner()
    button.anchor(width: width, height: height)
    
    if "0123456789".contains(title) {
      button.backgroundColor = UIColor.royalBlue
      button.setTitleColor(.white, for: .normal)
    } else if ["+", "-", "x", "/"].contains(title) {
      button.backgroundColor = UIColor.gold
      button.setTitleColor(UIColor.white, for: .normal)
    } else if title == "=" {
      button.backgroundColor = UIColor.skyBlue
      button.setTitleColor(UIColor.white, for: .normal)
    } else {
      button.backgroundColor = UIColor.slateGray
      button.setTitleColor(UIColor.white, for: .normal)
    }
    
    button.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside )
    return button
  }
  
  // MARK: Selectors
  @objc func handleButtonTapped(_ sender: UIButton) {
    guard let title = sender.currentTitle else { return }
    viewModel.handleInput(title)
  }
  
  // MARK: Binding
  func bindViewModel() {
    viewModel.displayResultCallback = { [weak self] result in
      guard let self = self else { return }
      displayLabel.text = result
    }
    
    viewModel.displayErrorCallback = { [weak self] message in
      guard let self = self else { return }
      print("DEBUG - error: \(message)")
      
      displayLabel.textColor = UIColor.crimson
      Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
        self.displayLabel.textColor = UIColor.royalBlue
      }
    }
  }
}

