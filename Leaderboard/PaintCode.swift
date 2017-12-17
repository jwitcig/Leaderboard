//
//  PaintCode.swift
//  Leaderboard
//
//  Created by Developer on 7/31/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

protocol PaintCodable {
    var drawRect: ((CGRect) -> Void)? { get set }
    
    func draw(_ rect: CGRect)
}

class PaintCodeView: UIView, PaintCodable {
    var drawRect: ((CGRect) -> Void)?
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    init(drawRect: @escaping (CGRect)->Void) {
        super.init(frame: .zero)
        backgroundColor = .clear
        
        self.drawRect = drawRect
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        drawRect?(rect)
    }
}

class PaintCodeButton: UIButton, PaintCodable {
    var drawRect: ((CGRect) -> Void)?
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    init(drawRect: @escaping (CGRect)->Void) {
        super.init(frame: .zero)
        backgroundColor = .clear
        
        self.drawRect = drawRect
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        drawRect?(rect)
    }
}
