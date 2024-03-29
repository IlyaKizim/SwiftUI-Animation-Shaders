//
//  CustomLayout.swift
//  SwiftUI Animation+Shaders
//
//  Created by Кизим Илья on 29.03.2024.
//

import SwiftUI

struct VerticleLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let height = bounds.height / CGFloat(subviews.count)
        
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: CGFloat(index) * (bounds.width - height) / CGFloat(subviews.count - 1) + bounds.minX, y: (bounds.maxY - height) - (height * CGFloat(index))),
                          proposal: ProposedViewSize(width: height, height: height))
        }
    }
}

struct CircleLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let radius = bounds.width / 3
        let andgle = Angle.degrees(360.0 / Double(subviews.count)).radians
        
        for (index, subview) in subviews.enumerated() {
            var point = CGPoint(x: 0, y: -radius).applying(CGAffineTransform(rotationAngle: andgle * Double(index)))
            point.x += bounds.midX
            point.y += bounds.midY
            subview.place(at: point, anchor: .center, proposal: .unspecified)
        }
    }
}
