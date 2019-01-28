//
//  GameButton.swift
//  Hello-AR
//
//  Created by Onurcan YURT on 8/10/17.
//  Copyright © 2017 Onurcan YURT. All rights reserved.
//

import Foundation
import UIKit



class GameButton : UIButton {
    
    var callback :() -> ()
    private var timer :Timer!
    
    init(frame: CGRect, callback: @escaping () -> ()) {
        self.callback = callback
        super.init(frame: frame)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [weak self] (timer :Timer) in
            self?.callback()
        })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.timer.invalidate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
