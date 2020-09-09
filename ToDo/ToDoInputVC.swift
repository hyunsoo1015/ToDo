//
//  ToDoInputVC.swift
//  ToDo
//
//  Created by 김현수 on 08/09/2020.
//  Copyright © 2020 Hyun Soo Kim. All rights reserved.
//

import UIKit

class ToDoInputVC: UIViewController {

    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tvContents: UITextView!
    @IBOutlet weak var dpRuntime: UIDatePicker!
    
    @IBAction func cancel(_ sender: Any) {
        //현재 화면 제거
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        //자신을 호출한 ToDoViewController 에 대한 참조를 생성
        let naviVC = self.presentingViewController as! UINavigationController
        let toDoListVC = naviVC.topViewController as! ToDoListVC
        
        //삽입할 내용 가져오기
        let title = tfTitle.text
        let contents = tvContents.text
        let runtime = dpRuntime.date
        
        //데이터 삽입하고 결과 가져오기
        let result = toDoListVC.save(title: title!, contents: contents!, runtime: runtime)
        toDoListVC.dismiss(animated: true){() -> Void in
            //삽입에 성공했으면 데이터 다시 출력
            if result == true {
                toDoListVC.tableView.reloadData()
            } else {
                let alert = UIAlertController(title: "데이터 삽입", message: "실패", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
