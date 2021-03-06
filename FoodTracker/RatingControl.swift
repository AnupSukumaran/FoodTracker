//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Sukumar Anup Sukumaran on 17/06/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import UIKit

@IBDesignable
class RatingControl: UIStackView {

    //MARK: Properties
    
    @IBInspectable var starSize : CGSize = CGSize(width: 44.0, height: 44.0)
    {
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        
        didSet {
            setupButtons()
        }
        
    }
    
    private var ratingButtons = [UIButton]()
    
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    //MARK Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
    
        super.init(coder: coder)
        setupButtons()
        
    }
    
    //MARK: Button Action
    
    @objc func ratingButtonTapped(button: UIButton) {
        
        
        guard let index = ratingButtons.index(of: button) else {
            fatalError("the button , \(button), is not in the rating Buttons array: \(ratingButtons)")
        }
        
        //calculate the rating of the selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            
            rating = 0
            
        }else{
            
            rating = selectedRating
            
        }
        
    }
    
    //MARK: Private Methods
    
    private func setupButtons() {
        
       
        
        //clear any existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
            
        }
        
        
        
        ratingButtons.removeAll()
        
        //Load Button Images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for index in 0..<starCount {
            //Create Button
            let button = UIButton()
//            button.backgroundColor = UIColor.red
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            //Set the accessibility label
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            //Setup the button action
            button.addTarget(self, action: #selector(ratingButtonTapped(button:)), for: .touchUpInside)
            
            //Add the bitton to the stack
            addArrangedSubview(button)
            
            ratingButtons.append(button)
        }
        
        updateButtonSelectionStates()
    }
    
    private func updateButtonSelectionStates() {
        
        for (index, button) in ratingButtons.enumerated() {
            
            button.isSelected = index < rating
            
            //Set the hint string for the currently selected star
            let hintString: String?
            
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero."
                print("hintString = \(hintString!)")
            }else {
                hintString = nil
                print("hintString = \((hintString != nil) ? "\(hintString!)" : "Nil")")
            }
            
            //calculate the value string
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set."
                print("valueString = \(valueString)")
            case 1:
                valueString = "1 star set."
               print("valueString = \(valueString)")
            default:
                valueString = "\(rating) stars set."
               print("valueString = \(valueString)")
            }
            
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
            
        }
        
    }
    
}
