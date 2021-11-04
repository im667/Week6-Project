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
        let task = UserDiary(diaryTitle: titleLabel.text! , content: contentTextView.text!, writeDate: Date(), regDate: Date())

        if let image = addImageView.image {
            try! localRealm.write {
                localRealm.add(task)
                saveImageToDocumentDirectory(imageName: "\(task._id).jpeg", image: image)
            }
        } else {
            try! localRealm.write{
                localRealm.add(task)
                saveImageToDocumentDirectory(imageName: "\(task._id)", image: UIImage(systemName: "photo")!)
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
                
        
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        
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
    
    
    
//    @IBAction func clickedDateButton(_ sender: UIButton) {
//    }
    
    
    
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
                
            }else {
                print("포토앨범에 접근할 수 없습니다")
            }
            
        }
        alert.addAction(openCamera)
        alert.addAction(albumImage)
       
        
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
