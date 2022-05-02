
import UIKit

class ViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Array
    var todoArray: [ToDoModel] = []
    
    //MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        fatchData()
    }
    private func fatchData() {
        // 1. Create request of GET type
        let urlString = "https://jsonplaceholder.typicode.com/todos"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Step2: Create session object
        let session = URLSession(configuration: .default)
        
        // Step3: Create Data task
        let dataTask = session.dataTask(with: request) { data, response, error in
            
            if error == nil {// No error
                guard let data = data else {
                    print("Data is Nil")
                    return
                }                
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
                        print("Invalid JSON")
                        return
                    }
                    
                    
                    for todoDictionary in json {
                        let uId = todoDictionary["userId"] as? Int
                        let id = todoDictionary["id"] as? Int
                        let todoTitle = todoDictionary["title"] as? String
                        let status = todoDictionary["completed"] as? Bool
                        
                        let todo = ToDoModel(userId: uId ?? 0,
                                             id: id ?? 0,
                                             title: todoTitle ?? "Invalid",
                                             completed: status ?? false)
                        self.todoArray.append(todo)
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }catch {
                    print(error.localizedDescription)
                }
                
                print(data)
            } else {
                print("We have error: \(error?.localizedDescription ?? "")")
            }
        }
        
        // Step4: Call API
        dataTask.resume()
    }
    
}

//MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "todocell") else {
            
            return UITableViewCell()
        }
        
        let todoObject = todoArray[indexPath.row]
        cell.textLabel?.text = "Task title: \(todoObject.title)"
        cell.detailTextLabel?.text = "Status: \(todoObject.completed)"
        
        if todoObject.completed == true {
            cell.backgroundColor = .green
        } else {
            cell.backgroundColor = .red
        }
        
        return cell
    }
    
    
}
