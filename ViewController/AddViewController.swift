//
//  ContentViewController.swift
//  Week6-Project
//
//  Created by mac on 2021/11/01.
//

import UIKit
import RealmSwift
import MobileCoreServices //포토앨범,카메라기능도 쓸 수 있게 만들어주는 프레임워크

class AddViewController: UIViewController{
    
    static let identifier = "AddViewController"
    let localRealm = try! Realm()
    let imagePickerVC: UIImagePickerController! = UIImagePickerController()
    //선택된 이미지 데이터
    var captureImage: UIImage!
    
    @IBOutlet weak var addImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UITextField!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var dateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(isClickedBackBtn))
        
        let saveBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(isClickedSaveBtn))
        
        let addImageButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(isClickedAddBtn))
        
        self.navigationItem.leftBarButtonItem = backBarButtonItem
        
        self.navigationItem.rightBarButtonItems = [saveBarButtonItem,addImageButtonItem]
        print("Realm is located at:", localRealm.configuration.fileURL!)
        
       
    }
    
 
    
    
    @objc func isClickedBackBtn (){
        navigationController?.dismiss(animated: true, completion: nil)
    }
    

 
    @objc func isClickedSaveBtn () {
        
      
//        let format = DateFormatter()
//        format.dateFormat = "yyyy년 MM월 dd일"
        
//        let date =  dateButton.currentTitle!
//        let value = format.date(from: date)!
        
        guard let date =  dateButton.currentTitle, let value = DateFormatter.customFormat.date(from: date) else {return}
        
        let task = UserDiary(diaryTitle: titleLabel.text! , content: contentTextView.text!, writeDate: value, regDate: Date())

        if let image = addImageView.image {
            try! localRealm.write {
                localRealm.add(task)
                saveImageToDocumentDirectory(imageName: "\(task._id).jpg", image: image)
            }
        } else {
            try! localRealm.write{
                localRealm.add(task)
                saveImageToDocumentDirectory(imageName: "\(task._id).jpg", image: UIImage(systemName: "photo")!)
            }
        }
    
        
        
        print("Realm is located at:", localRealm.configuration.fileURL!)
    }
    
    func saveImageToDocumentDirectory(imageName:String, image:UIImage) {
        //이미지 저장 경로 설정: 도큐먼트 폴더(위치:.documentDirectory)
        //1. Desktop/user/mac~~~~~/folder/222.png
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        //2.이미지 파일 이름
        let imageURL = documentDirectory.appendingPathComponent(imageName)
        
        //3.이미지 압축 (image.pngDage())
//        guard let data = image.pngData() else { return }
                
        
        guard let data = image.jpegData(compressionQuality: 0.3) else { return }
        
        
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
        
        //5. 이미지를 도큐먼트에 저장
        do{
            try data.write(to: imageURL)
        } catch {
            print("이미지 저장 못함")
        }
    }
    
    
    
    @IBAction func isClickedDateButton(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "날짜 선택", message: "날짜를 선택해주세요", preferredStyle: .alert)
        //얼럿 커스터마이징
        //1.얼럿안에 안에 들어와서 그른가,,,
        //2,,스토리보드 인식이 안되나 DatePickerViewController()
        //3.스토리보드 씬 + 클래스 -> 화면 전환 코드
        
//        let contentView = DatePickerViewController()
        
        guard let contentView = self.storyboard?.instantiateViewController(withIdentifier: "DatePickerViewController")as? DatePickerViewController else {
            print("DatePickerViewController error")
            return
        }
        contentView.view.backgroundColor = .green
//        contentView.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height) //녹색괴물이 나온다~
        contentView.preferredContentSize.height = 200
        alert.setValue(contentView, forKey: "contentViewController")
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        let ok = UIAlertAction(title: "확인", style: .default){ _ in
            
            let format = DateFormatter()
            format.dateFormat = "yyyy년 MM월 dd일"
            let value = format.string(from: contentView.datePicker.date)
            
            //확인 버튼을 눌렀을 때 버튼의 타이틀 변경
            self.dateButton.setTitle(value, for: .normal)
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}


extension AddViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @objc func isClickedAddBtn(){
        let alert = UIAlertController(title: "사진추가", message: "사진을 선택해주세요", preferredStyle: .actionSheet)
       
        let openCamera = UIAlertAction(title: "사진 촬영", style: .default){ action
            in
            self.imagePickerVC.sourceType = .camera
            self.present(self.imagePickerVC, animated: true, completion: nil)
           
        }
        let albumImage = UIAlertAction(title: "앨범에서 찾기", style: .default){ action
            in
            if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
                self.imagePickerVC.delegate = self
                self.imagePickerVC.sourceType = .photoLibrary
                self.imagePickerVC.mediaTypes = [kUTTypeImage as String]
                //잘라내기 편집 기능 지원
                self.imagePickerVC.allowsEditing = true
                
            } else {
                print("포토앨범에 접근할 수 없습니다")
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler:nil)
        
        alert.addAction(openCamera)
        alert.addAction(albumImage)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //선택된 이미지를 받아오는 함수
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! String
        
        if mediaType.isEqual(kUTTypeImage as NSString as String){
            if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as?
                UIImage {
                addImageView.image = editedImage
                captureImage = editedImage
            } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                addImageView.image = originalImage
                captureImage = originalImage
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //취소버튼 클릭시
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
