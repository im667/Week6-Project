//
//  RealmModel.swift
//  Week6-Project
//
//  Created by mac on 2021/11/02.
//

import Foundation
import RealmSwift


//Table 이름
//@Persisted 컬럼
class UserDiary: Object {
    
    @Persisted var diaryTitle: String = "" // 제목: 필수
    @Persisted var content: String? = "" // 내용 : 옵션
    @Persisted var writeDate = Date() //작성 날짜: 필수
    @Persisted var regDate = Date() //등록 날짜 :필수
    @Persisted var favorite: Bool // 즐찾 : 옵션
    
    
   //PK(필수) ObjectID 사용
    @Persisted(primaryKey: true) var _id: ObjectId // AutoIncreasement
   
    convenience init(diaryTitle:String, content:String?, writeDate:Date, regDate:Date){
        self.init()
        
        self.diaryTitle = diaryTitle
        self.content = content
        self.writeDate = writeDate
        self.regDate = regDate
        self.favorite = false
    }
}
