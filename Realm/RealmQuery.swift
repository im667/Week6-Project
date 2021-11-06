//
//  RealmQuery.swift
//  Week6-Project
//
//  Created by mac on 2021/11/05.
//

import Foundation
import UIKit
import RealmSwift

extension UIViewController {
    
    func searchQuearyFromUserDiary(text:String) -> Results<UserDiary> {
        let localRealm = try! Realm()
        let search = localRealm.objects(UserDiary.self).filter("diratTitle CONTAINS[c] '\(text)' OR CONTAINS[c] '\(text)'")
        
        return search
    }
    func getAllDiaryCountFormUserDiary() -> Int{
        let localRealm = try! Realm()
        
        return localRealm.objects(UserDiary.self).count
    }
}
