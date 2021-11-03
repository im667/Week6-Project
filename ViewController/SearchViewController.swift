//
//  SearchViewController.swift
//  Week6-Project
//
//  Created by mac on 2021/11/01.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController {
    
    @IBOutlet weak var SearchTableView: UITableView!
    
    
    let localRealm = try! Realm()
    var tasks: Results<UserDiary>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: SearchTableViewCell.identifier, bundle: nil)
        SearchTableView.register(nibName, forCellReuseIdentifier: SearchTableViewCell.identifier)
        
        title = "검색"
        SearchTableView.delegate = self
        SearchTableView.dataSource = self
    
        SearchTableView.estimatedRowHeight = 150
        SearchTableView.rowHeight = UITableView.automaticDimension
        
        tasks = localRealm.objects(UserDiary.self)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        tasks = localRealm.objects(UserDiary.self)
        
        
        SearchTableView.reloadData()
    }
    
    //폴더경로 -> 이미지찾기->UIImage ->UIimageView
    func loadImageFromDocumentDiretory(imageName:String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let directoryPath = path.first {
            let imageURL = URL(fileURLWithPath: directoryPath).appendingPathComponent(imageName)
            return UIImage(contentsOfFile: imageURL.path)
        }
        
        return nil
    }

    func deleteImageFromDocumentDirectory( imageName:String ){
        //1. Desktop/user/mac~~~~~/folder/222.png
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        //2.이미지 파일 이름
        let imageURL = documentDirectory.appendingPathComponent(imageName)
        
        //3.이미지 압축 (image.pngDage())
//        guard let data = image.pngData() else { return }
                
        
        //4.이미지 저장: 동일한 경로에 이미지를 저장하게 될 경우, 덮어쓰기
        //4-1. 이미지 경로 여부 확인
        
        if FileManager.default.fileExists(atPath: imageURL.path){
            
            //4-2.기존경로에 있는 이미지 삭제
            do{
                try FileManager.default.removeItem(at: imageURL)
                print("이미지 삭제완료")
            } catch {
                print("이미지를 삭제하지 못했습니다.")
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return tasks.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for:indexPath)as? SearchTableViewCell else {
            return UITableViewCell()
        }
        let row = tasks[indexPath.row]

        cell.contentImage.image = loadImageFromDocumentDiretory(imageName:"\(row._id).jpg")
        
        cell.titleLabel.text = row.diaryTitle
        cell.contentLabel.text = row.content
        cell.dateLabel.text = "\(row.writeDate)"

        cell.titleLabel.sizeToFit()
        cell.contentLabel.sizeToFit()
        cell.dateLabel.sizeToFit()
        cell.contentImage.sizeToFit()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
  


    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let row = tasks[indexPath.row]
        try! localRealm.write {
            localRealm.delete(row)
            deleteImageFromDocumentDirectory(imageName: "\(row._id).jpg")
            SearchTableView.reloadData()
        }
    }
    //본래는 화면전환  + 값 전달 후 새로운 화면에서 수정이 적합
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskToUpdate = tasks[indexPath.row]
//         수정 - 레코드에 대한 값
        try! localRealm.write{
            taskToUpdate.diaryTitle = "수정해봅시다"
            taskToUpdate.content = "수정을 한다"
            SearchTableView.reloadData()
        }
//        일괄수정
//        try! localRealm.write{
//            tasks.setValue(Date(), forKey: "writeDate")
//            tasks.setValue("새롭게 일기쓰기", forKey: "diaryTitle")
//            SearchTableView.reloadData()
//        }
        //Pk기준으로 수정할 때 사용(권장x)
//        try! localRealm.write{
//            let update = UserDiary(value: ["_id":taskToUpdate._id, "diaryTitle":"얘만바꾸고시펐어"])
//            localRealm.add(update, update: .modified)
//            SearchTableView.reloadData()
//        }
        
//        try! localRealm.write{
//            localRealm.create(UserDiary.self, value: ["_id":taskToUpdate._id, "diaryTitle":"얘만바꾸고시펐어"], update: .modified)
//            SearchTableView.reloadData()
//        }
    }
    
    
   
}
