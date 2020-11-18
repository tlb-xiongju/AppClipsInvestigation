//
//  IndicatorDisplayable.swift
//  UIComponent
//
//  Created by 熊 炬 on 2020/06/09.
//  Copyright © 2020 teamLab. All rights reserved.
//

import UIKit

public protocol IndicatorDisplayable {
    func showIndicator(on view: UIView)
    func removeIndicator(from view: UIView)
}

class IndicatorContainerView: UIView {}

extension IndicatorDisplayable where Self: UIViewController {
    public func showIndicator() {
        showIndicator(on: view)
    }

    public func removeIndicator() {
        removeIndicator(from: view)
    }

    public func showIndicator(on view: UIView) {
        let container = IndicatorContainerView()

        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        container.addSubview(indicator)

        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        indicator.startAnimating()

        container.backgroundColor = .clear
        view.addSubview(container)
        
        container.frame = view.bounds
        container.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    public func removeIndicator(from view: UIView) {
        let holder = view.subviews.first { $0 is IndicatorContainerView }
        holder?.removeFromSuperview()
    }
}
