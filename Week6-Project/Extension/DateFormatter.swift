//
//  DateFormatter.swift
//  Week6-Project
//
//  Created by mac on 2021/11/05.
//

import Foundation

extension DateFormatter {
   static var customFormat: DateFormatter {
       
        let date = DateFormatter()
        date.dateFormat = "yyyy년 MM월 dd일"
        
       return date
    }
    
}
