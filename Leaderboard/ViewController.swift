//
//  ViewController.swift
//  Leaderboard
//
//  Created by Developer on 7/30/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

import Cartography
import Firebase

import JWSwiftTools

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let username = "jonah"
    
    var myScore = 0
    
    var scoreData: [String : Int] = [:] {
        didSet {
            let old = scores

            scores = scoreData.map { return ($0, $1) }
                              .sorted { return $0.1 > $1.1 }
            
            animateTableViewUpdates(oldScores: old, newScores: scores)
            centerScrollView()
        }
    }
    
    var scores: [(String, Int)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshListeners(forScore: myScore)
        
        let button = PaintCodeButton {
            LeaderboardStyleKit.drawTapButton(frame: $0, resizing: .stretch)
        }
        
        view.addSubview(button)
        
        constrain(button, view, tableView) {
            $0.top == $2.bottom + 20
            $0.bottom == $1.bottom - 20
            $0.leading == $1.leading + 20
            $0.trailing == $1.trailing - 20
        }
        
        button.addTarget(self, action: #selector(ViewController.buttonPressed(sender:)), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let username = UsernameViewController()
        present(username, animated: true, completion: nil)
    }
    
    func refreshListeners(forScore score: Int, withRadius radius: UInt = 20) {
        let databaseRef = Database.database().reference()
        let scoresRef = databaseRef.child("scores")
        
        scoresRef.removeAllObservers()
        
        let losersQuery = scoresRef.queryOrderedByValue()
                                   .queryEnding(atValue: score)
                                   .queryLimited(toLast: radius)
        
        let winnersQuery = scoresRef.queryOrderedByValue()
                                    .queryStarting(atValue: score)
                                    .queryLimited(toFirst: radius)

        let processScore: (DataSnapshot)->Void = {
            guard let score = $0.value as? Int else { return }
            self.process(score: score, for: $0.key)
        }
        
        [losersQuery, winnersQuery].forEach {
            $0.observe(.childChanged, with: processScore)
            $0.observeSingleEvent(of: .value, with: {
                for snapshot in $0.children.allObjects as! [DataSnapshot] {
                    processScore(snapshot)
                }
            })
        }
    }
    
    func process(score: Int, for uid: String) {
        scoreData[uid] = score
    }
    
    func centerScrollView() {
        let userCell = scores.enumerated().filter({
            $0.element.0 == self.username
        }).first
        
        guard let index = userCell?.offset else { return }
        
        tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: true)
    }
    
    func buttonPressed(sender: Any) {
        myScore += 1
        scoreData[username] = myScore
        
        guard myScore % 5 == 0 else { return }
        
        let databaseRef = Database.database().reference()
        databaseRef.child("scores/\(username)").setValue(myScore)

        refreshListeners(forScore: myScore)
    }
    
    func animateTableViewUpdates(oldScores: [(String, Int)], newScores: [(String, Int)]) {
        func oldRank(forCurrent current: (offset: Int, element: (String, Int))) -> (offset: Int, element: (String, Int))? {
            return oldScores.enumerated().filter({ $0.element.0 == current.element.0}).first
        }
        
        tableView.beginUpdates()
        for score in newScores.enumerated() {
            if let oldRank = oldRank(forCurrent: score) {
                tableView.moveRow(at: IndexPath(row: oldRank.offset, section: 0),
                                  to: IndexPath(row: score.offset, section: 0))
            } else {
                tableView.insertRows(at: [IndexPath(row: score.offset, section: 0)], with: .automatic)
            }
        }
        tableView.endUpdates()
        
        tableView.beginUpdates()
        for score in newScores.enumerated() {
            guard let oldRank = oldRank(forCurrent: score),
                oldRank.element.1 != score.element.1 else { continue }
            
            // score changed
            tableView.reloadRows(at: [IndexPath(row: score.offset, section: 0)], with: .none)
        }
        tableView.endUpdates()
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Reuse") ?? UITableViewCell(style: .value1, reuseIdentifier: "Reuse")
        
        let data = scores[indexPath.row]
        
        cell.textLabel?.text = data.0.truncate(toLength: 10)
        cell.detailTextLabel?.text = data.1.string
        
        if data.0 == username {
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        } else {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        }
        
        return cell
    }
    
}

extension ViewController: UITableViewDelegate { }

