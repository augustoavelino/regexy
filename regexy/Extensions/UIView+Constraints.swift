//
//  UIView+Constraints.swift
//  regexy
//
//  Created by Augusto Avelino on 20/03/24.
//

import UIKit

// An extension on UIView to simplify Auto Layout constraint creation.
extension UIView {
    
    /// Represents a collection of constraints for a UIView.
    class Constraints {
        typealias YAxisConfig = (anchor: NSLayoutYAxisAnchor, constant: CGFloat)
        typealias XAxisConfig = (anchor: NSLayoutXAxisAnchor, constant: CGFloat)
        typealias DimensionConfig = (anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat)
        
        var centerX: NSLayoutConstraint?
        var centerY: NSLayoutConstraint?
        var top: NSLayoutConstraint?
        var leading: NSLayoutConstraint?
        var trailing: NSLayoutConstraint?
        var bottom: NSLayoutConstraint?
        var width: NSLayoutConstraint?
        var height: NSLayoutConstraint?
        
        /// Activates the constraints.
        func activate() {
            centerX?.isActive = true
            centerY?.isActive = true
            top?.isActive = true
            leading?.isActive = true
            trailing?.isActive = true
            bottom?.isActive = true
            width?.isActive = true
            height?.isActive = true
        }
    }
    
    /**
        Creates constraints for the view based on provided parameters.
     
        - Parameters:
            - top: The top anchor configuration.
            - leading: The leading anchor configuration.
            - trailing: The trailing anchor configuration.
            - bottom: The bottom anchor configuration.
            - width: The width dimension configuration.
            - height: The height dimension configuration.
            - widthValue: The constant width value.
            - heightValue: The constant height value.
        
        - Returns: A Constraints object containing the created constraints.
    */
    @discardableResult
    func constraint(
        centerX: Constraints.XAxisConfig? = nil,
        centerY: Constraints.YAxisConfig? = nil,
        top: Constraints.YAxisConfig? = nil,
        leading: Constraints.XAxisConfig? = nil,
        trailing: Constraints.XAxisConfig? = nil,
        bottom: Constraints.YAxisConfig? = nil,
        width: Constraints.DimensionConfig? = nil,
        height: Constraints.DimensionConfig? = nil,
        widthValue: CGFloat? = nil,
        heightValue: CGFloat? = nil
    ) -> Constraints {
        let constraints = Constraints()
        translatesAutoresizingMaskIntoConstraints = false
        if let centerX = centerX {
            constraints.centerX = centerXAnchor.constraint(equalTo: centerX.anchor, constant: centerX.constant)
        }
        if let centerY = centerY {
            constraints.centerY = centerYAnchor.constraint(equalTo: centerY.anchor, constant: centerY.constant)
        }
        if let top = top {
            constraints.top = topAnchor.constraint(equalTo: top.anchor, constant: top.constant)
        }
        if let leading = leading {
            constraints.leading = leadingAnchor.constraint(equalTo: leading.anchor, constant: leading.constant)
        }
        if let trailing = trailing {
            constraints.trailing = trailingAnchor.constraint(equalTo: trailing.anchor, constant: trailing.constant)
        }
        if let bottom = bottom {
            constraints.bottom = bottomAnchor.constraint(equalTo: bottom.anchor, constant: bottom.constant)
        }
        if let width = width {
            constraints.width = widthAnchor.constraint(equalTo: width.anchor, multiplier: width.multiplier, constant: width.constant)
        } else if let widthValue = widthValue {
            constraints.width = widthAnchor.constraint(equalToConstant: widthValue)
        }
        if let height = height {
            constraints.height = heightAnchor.constraint(equalTo: height.anchor, multiplier: height.multiplier, constant: height.constant)
        } else if let heightValue = heightValue {
            constraints.height = heightAnchor.constraint(equalToConstant: heightValue)
        }
        constraints.activate()
        return constraints
    }
    
    /**
        Creates constraints to fill the entire superview with optional constant insets for each edge.

        - Parameters:
            - useSafeArea: Whether to use the safe area layout guide.
            - constant: The constant value for all edges. (When applying to trailing and bottom, this value multiplied by -1 to account for direction).

        - Returns: A Constraints object containing the created constraints.
    */
    @discardableResult
    func constraintToFill(
        useSafeArea: Bool = false,
        constant: CGFloat = 0.0
    ) -> Constraints? {
        return constraintToFill(
            useSafeArea: useSafeArea,
            top: constant,
            leading: constant,
            trailing: constant,
            bottom: constant
        )
    }
    
    /**
        Creates constraints to fill the entire superview with optional constant insets for each edge.

        - Parameters:
            - useSafeArea: Whether to use the safe area layout guide.
            - horizontalPadding: The constant value for horizontal padding (applied to leading and trailing edges).
            - verticalPadding: The constant value for vertical padding (applied to top and bottom edges).

        - Returns: A Constraints object containing the created constraints.
    */
    @discardableResult
    func constraintToFill(
        useSafeArea: Bool = false,
        horizontalPadding: CGFloat = 0.0,
        verticalPadding: CGFloat = 0.0
    ) -> Constraints? {
        return constraintToFill(
            useSafeArea: useSafeArea,
            top: verticalPadding,
            leading: horizontalPadding,
            trailing: horizontalPadding,
            bottom: verticalPadding
        )
    }
    
    /**
        Creates constraints to fill the entire superview with optional constant insets for each edge.

        - Parameters:
            - useSafeArea: Whether to use the safe area layout guide.
            - top: The constant value for the top edge.
            - leading: The constant value for the leading edge.
            - trailing: The constant value for the trailing edge (multiplied by -1 to account for direction).
            - bottom: The constant value for the bottom edge (multiplied by -1 to account for direction).

        - Returns: A Constraints object containing the created constraints.
    */
    @discardableResult
    func constraintToFill(
        useSafeArea: Bool = false,
        top: CGFloat = 0.0,
        leading: CGFloat = 0.0,
        trailing: CGFloat = 0.0,
        bottom: CGFloat = 0.0
    ) -> Constraints? {
        if useSafeArea {
            return _constraintToFillSafeArea(top: top, leading: leading, trailing: trailing, bottom: bottom)
        }
        return _constraintToFill(top: top, leading: leading, trailing: trailing, bottom: bottom)
    }
    
    private func _constraintToFill(
        top: CGFloat = 0.0,
        leading: CGFloat = 0.0,
        trailing: CGFloat = 0.0,
        bottom: CGFloat = 0.0
    ) -> Constraints? {
        guard let superview = superview else { return nil }
        return constraint(
            top: (superview.topAnchor, top),
            leading: (superview.leadingAnchor, leading),
            trailing: (superview.trailingAnchor, -trailing),
            bottom: (superview.bottomAnchor, -bottom)
        )
    }
    
    private func _constraintToFillSafeArea(
        top: CGFloat = 0.0,
        leading: CGFloat = 0.0,
        trailing: CGFloat = 0.0,
        bottom: CGFloat = 0.0
    ) -> Constraints? {
        guard let superview = superview else { return nil }
        return constraint(
            top: (superview.safeAreaLayoutGuide.topAnchor, top),
            leading: (superview.safeAreaLayoutGuide.leadingAnchor, leading),
            trailing: (superview.safeAreaLayoutGuide.trailingAnchor, -trailing),
            bottom: (superview.safeAreaLayoutGuide.bottomAnchor, -bottom)
        )
    }
}
