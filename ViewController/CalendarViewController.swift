//
//  CalendarViewController.swift
//  Week6-Project
//
//  Created by mac on 2021/11/01.
//

import UIKit
import FSCalendar
import RealmSwift

class CalendarViewController: UIViewController {

    @IBOutlet weak var calendarView: FSCalendar!
    
    
    @IBOutlet weak var allCountLabel: UILabel!
    
    
    let localRealm = try! Realm()
    var tasks: Results<UserDiary>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        calendarView.delegate = self
        calendarView.dataSource = self
    
        tasks = localRealm.objects(UserDiary.self)
        print(tasks)
        
        let allCount = getAllDiaryCountFormUserDiary()
        allCountLabel.text = "총\(allCount)개를 썼습니다."
        
//        let recent = localRealm.objects(UserDiary.self).sorted(byKeyPath: "writeDate", ascending: false).first?.diaryTitle
//
//        print("recent:\(recent)")
//        let full = localRealm.objects(UserDiary.self).filter("content != nil").count
//        print("full:\(full)")
//        let favorite = localRealm.objects(UserDiary.self).filter("favorite = false")
//        print("favorite:\(favorite)")
//        //문자열 필터링 할 때는 -> '' 써주고 AND,OR 조건을 사용할 수 있다
//        let search = localRealm.objects(UserDiary.self).filter("diratTitle CONTAINS[c] '일기' OR CONTAINS[c] '살아와'")
//        print("search:\(search)")
    
    }
    


}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        return "title"
//    }
//
//    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
//        return "sub"
//    }
//
//    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
//        return UIImage(systemName: "star")
//    }
    //Date: 시 분 초 까지 동일해야함
    //1. 영국 표준시 기준
    //2. 데이트 포맷터
    
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        let format = DateFormatter()
//        format.dateFormat = "yyyyMMdd"
//        let test = "2021103"
//
//        if format.date(from: test) == date {
//            return 3
//        }
//        return 1
//
//        print(date)
//        return 3
//    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return tasks.filter("writeDate = %@",date).count
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //응용해서 구현해보자! 응응!
    }
    
}
