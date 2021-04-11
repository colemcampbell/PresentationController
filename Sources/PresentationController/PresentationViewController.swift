//
//  PresentationViewController.swift
//  
//
//  Created by Cole Campbell on 4/10/21.
//

import Foundation
import UIKit

open class PresentationViewController: UIViewController {
    
    // MARK: Properties
    
    public let frame: (UIView) -> CGRect
    public let onTap: (() -> Void)?
    public let presentationBackgroundColor: UIColor?
    
    // MARK: Initializers
    
    public init(
        presentationBackgroundColor: UIColor? = nil,
        frame: @escaping (UIView) -> CGRect,
        onTap: (() -> Void)? = nil
    ) {
        self.presentationBackgroundColor = presentationBackgroundColor
        self.frame = frame
        self.onTap = onTap
        
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    public convenience init(
        frame: CGRect,
        presentationBackgroundColor: UIColor? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.init(presentationBackgroundColor: presentationBackgroundColor, frame: { _ in frame }, onTap: onTap)
    }
    
    public required init?(coder: NSCoder) {
        nil
    }
}

extension PresentationViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        PresentationController(
            presented: presented,
            presenting: presenting,
            backgroundColor: self.presentationBackgroundColor,
            frame: self.frame,
            onTap: self.onTap
        )
    }
}
