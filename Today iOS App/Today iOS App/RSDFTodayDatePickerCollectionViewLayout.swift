//
//  RSDFTodayDatePickerCollectionViewLayout.swift
//  Today
//
//  Created by UetaMasamichi on 9/10/16.
//  Copyright © 2016 Masamichi Ueta. All rights reserved.
//

import UIKit

class RSDFTodayDatePickerCollectionViewLayout: RSDFDatePickerCollectionViewLayout {
    
    override func selfHeaderReferenceSize() -> CGSize {
        let size = super.selfHeaderReferenceSize()
        
        return CGSize(width: size.width, height: 32)
    }

}
