//
//  Utils.swift
//  JCalc
//
//  Created by Soonkyu Jeong on 2019/06/25.
//  Copyright © 2019 Soonkyu Jeong. All rights reserved.
//

import Foundation

extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
}
