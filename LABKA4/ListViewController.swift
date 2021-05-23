//
//  ListViewController.swift
//  LABKA3
//
//  Created by Aplyn on 04.05.2021.
//

import Foundation
import UIKit

class ListViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBAction func addBook(_ sender: Any) {
        let addingVC = storyboard?.instantiateViewController(withIdentifier: "BookAdd") as? BookAdd
        self.navigationController?.pushViewController(addingVC!, animated: true)
    }
    
    lazy var jsonBooks = get_books()
    lazy var booksArr:[Book] = jsonBooks!.books
    lazy var searchedBooks = booksArr
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
               super.viewDidAppear(animated)
               tableView.reloadData()
           }

    
    func get_books() -> Books? {
        if let fileLocation = Bundle.main.url(forResource: "BooksList", withExtension: "txt") {
            do {
                let data = try Data(contentsOf: fileLocation)
                let jsonDecoder = JSONDecoder()
                let dataFromJson = try jsonDecoder.decode(Books.self, from: data)
                return dataFromJson
            } catch {
                print(error)
            }
        }
        return nil
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchedBooks = self.booksArr
        } else {
            searchedBooks = self.booksArr.filter(){$0.title.lowercased().contains(searchText.lowercased())}
        }
        self.tableView.reloadData()
    }
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        if searchedBooks.count == 0 {
            let emptyView = UIView(
                frame: CGRect(
                    x: tableView.center.x,
                    y: tableView.center.y, width: tableView.bounds.size.width,
                    height: tableView.bounds.size.height
                )
            )
            let label = UILabel()
            emptyView.addSubview(label)

            label.translatesAutoresizingMaskIntoConstraints = false
            label.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
            label.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
            
            label.text = "No books found"
            label.textColor = .black
            label.numberOfLines = 0
            label.textAlignment = .center
            
            tableView.backgroundView = emptyView
            tableView.separatorStyle = .none
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .none
        }
        return searchedBooks.count
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if (editingStyle == .delete) {
                self.booksArr = self.booksArr.filter(){$0.isbn13 != self.searchedBooks[indexPath.row].isbn13}
                self.searchedBooks.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .none)
            }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let book = searchedBooks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell") as! UnderclassUITableViewCell
        cell.setImageAndLabel(book: book)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier:
            "BooksDetails") as? BooksDetails
        let data = ContentStore().getText(searchedBooks[indexPath.row].isbn13, type: Book.self)
        if data == nil || data?.image == "" {
            self.tableView.deselectRow(at: indexPath, animated: true)
        } else {
            vc!.data = data
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    func addNewBook(book: Book) {
        self.booksArr.append(book)
        self.searchedBooks.append(book)
    }
    
}
