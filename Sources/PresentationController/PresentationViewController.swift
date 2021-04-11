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
    
    public let backgroundColor: UIColor?
    
    // MARK: Initializers
    
    public init(backgroundColor: UIColor? = nil) {
        self.backgroundColor = backgroundColor
        
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    public required init?(coder: NSCoder) {
        nil
    }
}

extension PresentationViewController {
    @objc open func frame(containerView: UIView) -> CGRect {
        .zero
    }
    
    @objc open func onTap() -> Void {}
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
            backgroundColor: self.backgroundColor,
            frame: { [weak self] in self?.frame(containerView: $0) ?? .zero },
            onTap: { [weak self] in self?.onTap() }
        )
    }
}
