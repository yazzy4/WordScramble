//
//  ViewController.swift
//  WordScramble
//
//  Created by Yaz Burrell on 7/28/20.
//  Copyright © 2020 Yaz Burrell. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var usedWords = [String]()
    var allWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let startWordUrl = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordUrl){
                
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkWorm"]
        }
        
        startGame()
    }
    
    func startGame(){
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "word", for: indexPath)
        cell.textLabel?.text = allWords[indexPath.row]
        return cell
    }
    

}

