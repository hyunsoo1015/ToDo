import UIKit
import CoreData

class ToDoListVC: UITableViewController {
    //전체 데이터를 저장하기 위한 변수
    //list를 처음 사용할 때 1번 fetch를 호출해서 결과를 저장
    lazy var list: [NSManagedObject] = {
        return self.fetch()
    }()
    
    //전체 데이터를 읽어오는 메소드
    func fetch() -> [NSManagedObject] {
        //1.AppDelegate 참조를 생성
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //2.관리 객체 참조 만들기
        let context = appDelegate.persistentContainer.viewContext
        //3.ToDo 테이블에 작업을 수행하기 위한 객체를 생성
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ToDo")
        //4.전체 데이터 가져오기
        let result = try! context.fetch(fetchRequest)
        
        return result
    }
    
    //데이터를 삽입하는 메소드
    func save(title: String, contents: String, runtime: Date) -> Bool {
        
        //1.데이터베이스 관리 객체 가져오기
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //2.추가할 데이터 생성
        let object = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: context)
        object.setValue(title, forKey: "title")
        object.setValue(contents, forKey: "contents")
        object.setValue(runtime, forKey: "runtime")
        
        do {
            //commit
            try context.save()
            //전체 데이터 다시 가져오기
            //여러 유저가 공유하는 데이터라면
            //다시 가져오는 것이 좋다.
            //self.list = self.fetch()
            
            //데이터를 list에 추가
            //ToDo 나 Email 처럼 혼자서만 사용하는 데이터라면
            //list에 바로 추가해도 된다.
            //self.list.append(object)
            
            //멘 앞에 추가
            self.list.insert(object, at: 0)
            
            return true
        } catch {
            //rollback
            context.rollback()
            return false
        }
    }
    
    //오른쪽 바 버튼이 호출할 메소드
    @objc func add(_ sender: Any) {
        //ToDoInputVC 를 화면에 출력
        let toDoInputVC = self.storyboard?.instantiateViewController(identifier: "ToDoInputVC") as! ToDoInputVC
        self.present(toDoInputVC, animated: true)
    }
    
    //데이터 삭제를 위한 메소드
    func delete(object: NSManagedObject) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //데이터 삭제
        context.delete(object)
        
        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            return false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "To Do"
        
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(_:)))
        self.navigationItem.rightBarButtonItem = addBtn
        
        //네비게이션 바의 왼쪽에 편집 버튼 추가
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    //편집 버튼을 누룰 때 보여질 아이콘 모양을 설정하는 메소드
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    //삭제 버튼을 눌렀을 때 호출되는 메소드
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //삭제할 데이터 찾기
        let object = self.list[indexPath.row]
        //삭제를 하고 성공하면
        if self.delete(object: object) {
            self.list.remove(at: indexPath.row)
            //self.tableView.reloadData()
            self.tableView.deleteRows(at: [indexPath], with: .right)
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //출력할 데이터 찾아오기
        let record = list[indexPath.row]
        //셀 만들기
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        
        cell!.textLabel!.text = record.value(forKey: "title") as? String
        cell!.detailTextLabel!.text = record.value(forKey: "contents") as? String
        
        return cell!
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
