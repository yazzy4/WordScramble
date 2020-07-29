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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Start Game", style: .plain, target: self, action: #selector(startGame))
        
        if let startWordUrl = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordUrl) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkWorm"]
        }
        
        startGame()
    }
    
    
   @objc func startGame(){
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promptForAnswer(){
        let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else
            { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String){
        let lowerAnswer = answer.lowercased()
    
        if isPossible(lowerAnswer) {
            if isOriginal(lowerAnswer) {
                if isReal(lowerAnswer){
                    usedWords.insert(answer, at: 0)
                
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                    
                } else {
                    showErrorMessage("Word is either jibberish or 3 letter or less. Either way 🤷🏾‍♂️", title: "Word not recognized!")
                }
            } else {
                showErrorMessage("Be more orginal", title: "Word already used!")
            }
            
        } else {
            showErrorMessage("You cannot use \(title!.lowercased()) to spell that word", title: "Invalid word!")
        }
        
    }
    
    func showErrorMessage(_ errorMesssage: String, title: String) {
        let ac = UIAlertController(title: title, message: errorMesssage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        
        present(ac, animated: true)
        
    }
    
    func isPossible(_ word: String) -> Bool {
//        if the temp word matches the title go to next block of code
        
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    func isOriginal(_ word: String) -> Bool {
        guard word != title else { return false }
        
        return !usedWords.contains(word)
    }
    
    func isReal(_ word: String) -> Bool {
        guard  word.count > 3 else { return false }
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledWord = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledWord.location == NSNotFound
    }
    
    

}

