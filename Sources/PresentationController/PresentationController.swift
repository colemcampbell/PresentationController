//
//  PresentationController.swift
//  
//
//  Created by Cole Campbell on 4/10/21.
//

import Foundation
import UIKit

open class PresentationController: UIPresentationController {
    
    // MARK: Properties
    
    public let frame: (UIView) -> CGRect
    public let onTap: (() -> Void)?
    public let backgroundView = UIView()
    
    // MARK: Initializers
    
    public init(
        presented: UIViewController,
        presenting: UIViewController?,
        backgroundColor: UIColor? = nil,
        frame: @escaping (UIView) -> CGRect,
        onTap: (() -> Void)? = nil
    ) {
        self.frame = frame
        self.onTap = onTap
        
        super.init(presentedViewController: presented, presenting: presenting)
        
        self.backgroundView.backgroundColor = backgroundColor
    }
    
    public convenience init(
        presented: UIViewController,
        presenting: UIViewController?,
        frame: CGRect,
        backgroundColor: UIColor? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.init(
            presented: presented,
            presenting: presenting,
            backgroundColor: backgroundColor,
            frame: { _ in frame },
            onTap: onTap
        )
    }
}

// MARK: - Transitions

extension PresentationController {
    public override func presentationTransitionWillBegin() {
        self.addBackgroundView()
        self.addBackgroundViewConstraints()
        
        self.presentedViewController.transitionCoordinator?.animate { [weak self] context in
            self?.backgroundView.alpha = 1
        }
    }
    
    public override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate { [weak self] context in
            self?.backgroundView.alpha = 0
        } completion: { [weak self] contect in
            self?.backgroundView.removeFromSuperview()
        }
    }
}

// MARK: - Presented View

extension PresentationController {
    public override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = self.containerView else { return .zero }
        
        return self.frame(containerView)
    }
    
    public override var presentedView: UIView? {
        let presentedView = super.presentedView
        
        presentedView?.frame = self.frameOfPresentedViewInContainerView
        
        return presentedView
    }
}

// MARK: - Background View

extension PresentationController {
    private func addBackgroundView() {
        self.backgroundView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(self.handleBackgroundViewTapEvent)
            )
        )
        
        self.backgroundView.alpha = 0
        self.backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView?.addSubview(self.backgroundView)
    }
    
    private func addBackgroundViewConstraints() {
        guard let containerView = self.containerView else { return }
        
        NSLayoutConstraint.activate([
            self.backgroundView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            self.backgroundView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            self.backgroundView.topAnchor.constraint(equalTo: containerView.topAnchor),
            self.backgroundView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    @objc private func handleBackgroundViewTapEvent() {
        self.onTap?()
    }
}
