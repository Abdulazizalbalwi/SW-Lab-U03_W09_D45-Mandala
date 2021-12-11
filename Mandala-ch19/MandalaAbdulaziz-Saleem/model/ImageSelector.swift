//
//  ImageSelector.swift
//  Mandala
//
//  Created by عبدالعزيز البلوي on 07/05/1443 AH.
//

import UIKit

class ImageSelector: UIControl {
  
  var highlightColors: [UIColor] = []
  {
    didSet {
      highlightView.backgroundColor = highlightColor(forIndex: selectedIndex)
    }
  }
  
  private let selectorStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.alignment = .center
    stackView.spacing = 12.0
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private let highlightView: UIView = {
    let view = UIView()
    // view.backgroundColor = view.tintColor
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  var images: [UIImage] = [] {
    didSet {
      imageButtons = images.map { image in
        let imageButton = UIButton()
        
        imageButton.setImage(image, for: .normal)
        imageButton.imageView?.contentMode = .scaleAspectFit
        imageButton.adjustsImageWhenHighlighted = false
        imageButton.addTarget(self,
                              action: #selector(imageButtonTapped(_:)),
                              for: .touchUpInside)
        
        return imageButton
      }
      selectedIndex = 0
    }
  }
  
  private func configureViewHierarchy() {
    addSubview(selectorStackView)
    insertSubview(highlightView, belowSubview: selectorStackView)
    
    NSLayoutConstraint.activate([
      selectorStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      selectorStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      selectorStackView.topAnchor.constraint(equalTo: topAnchor),
      selectorStackView.bottomAnchor.constraint(equalTo: bottomAnchor), highlightView.heightAnchor.constraint(equalTo: highlightView.widthAnchor), highlightView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9), highlightView.centerYAnchor
        .constraint(equalTo: selectorStackView.centerYAnchor),
    ])
  }
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureViewHierarchy()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configureViewHierarchy()
  }
  
  
  var selectedIndex = 0 {
    didSet {
      if selectedIndex < 0 {
        selectedIndex = 0
      }
      if selectedIndex >= imageButtons.count {
        selectedIndex = imageButtons.count - 1
      }
      highlightView.backgroundColor = highlightColor(forIndex: selectedIndex)
      
      let imageButton = imageButtons[selectedIndex]
      highlightViewXConstraint = highlightView.centerXAnchor.constraint(equalTo: imageButton.centerXAnchor)
    }
  }
  
  private var imageButtons: [UIButton] = [] {
    didSet {
      oldValue.forEach { $0.removeFromSuperview() }
      imageButtons.forEach { selectorStackView.addArrangedSubview($0)}
    }
  }
  
  
  
  @objc private func imageButtonTapped(_ sender: UIButton) {
    guard let buttonIndex = imageButtons.firstIndex(of: sender)
    else {
      preconditionFailure("The buttons and images are not parallel.")
    }
    let selectionAnimator = UIViewPropertyAnimator(
      duration: 0.3,
      //  curve: .easeInOut,
      dampingRatio: 0.7,
      animations: {
        self.selectedIndex = buttonIndex
        self.layoutIfNeeded()
      })
    selectionAnimator.startAnimation()
    sendActions(for: .valueChanged)
    
    //selectedIndex = buttonIndex
    sendActions(for: .valueChanged)
    
  }
  
  
  private var highlightViewXConstraint: NSLayoutConstraint! {
    didSet {
      oldValue?.isActive = false
      highlightViewXConstraint.isActive = true
    }
  }
  private func highlightColor(forIndex index: Int) -> UIColor {
    guard index >= 0 && index < highlightColors.count else {
      return UIColor.blue.withAlphaComponent(0.6)
    }
    return highlightColors[index]
  }
  
  
  
  override func layoutSubviews() {
    super.layoutSubviews()
    highlightView.layer.cornerRadius = highlightView.bounds.width / 2.0
  }
}
