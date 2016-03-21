//
//  ViewController.swift
//  DiceRoller
//
//  Created by Sam Salvail on 2016-02-15.
//  Copyright © 2016 Sam Salvail. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var DiceNumber: UIPickerView!
    @IBOutlet weak var DiceSides: UIPickerView!
    
    // Initial variables
    let pickerData1 = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    let pickerData2 = ["4", "6", "8", "10", "12", "20", "21", "100"]
    var total = 0
    var numberOfDice = 1
    var sideOfDice = 4
    var rolls = [Int]()
    @IBOutlet weak var sideOfDiceLabel: UILabel!
    @IBOutlet weak var numberOfDiceLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var rollsLabel: UILabel!
    
    var audioPlayer:AVAudioPlayer!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize strings and set dataSources + delegates
        numberOfDiceLabel.text = "You are rolling 1 die"
        sideOfDiceLabel.text = "Which is 4-sided"
        totalLabel.text = "Total: 0"
        rollsLabel.text = "Rolls:"
        DiceNumber.dataSource = self
        DiceNumber.delegate = self
        DiceSides.dataSource = self
        DiceSides.delegate = self
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)  
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // function that plays sound from root folder
    func playSound() throws -> Bool{
        
        let audioFilePath = NSBundle.mainBundle().pathForResource("DiceRoll", ofType: "wav")
        
        if audioFilePath != nil {
            
            let audioFileUrl = NSURL.fileURLWithPath(audioFilePath!)
            
            try audioPlayer = AVAudioPlayer(contentsOfURL: audioFileUrl, fileTypeHint: nil)
            
            audioPlayer.play()
            
        } else {
            print("audio file is not found")
            return false
        }
        return true
    }
    
    // Picker function for count
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 0){
            return pickerData1.count
        } else {
            return pickerData2.count
        }
    }
    
    // Picker function for row
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 0){
            return pickerData1[row]
        } else {
            return pickerData2[row]
        }
    }
    
    // Picker logic depending on how many dice are being rolled
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 0){
            numberOfDice = Int(pickerData1[row])!
            if(numberOfDice > 1){
                numberOfDiceLabel.text = "You are rolling " + pickerData1[row] + " dice"
            } else {
                numberOfDiceLabel.text = "You are rolling " + pickerData1[row] + " die"
            }
        } else {
            sideOfDice = Int(pickerData2[row])!
            if(numberOfDice > 1){
                sideOfDiceLabel.text = "Which are " + pickerData2[row] + "-sided"
            } else {
                sideOfDiceLabel.text = "Which is " + pickerData2[row] + "-sided"
            }
        }
        
    }
    
    // Roll button
    @IBAction func RollButton(sender: AnyObject) {
        var index = 0
        for index = 0; index < numberOfDice; ++index {
            let diceRoll = Int(arc4random_uniform(UInt32(sideOfDice)) + 1)
            rolls.append(diceRoll)
            total += diceRoll
        }
        rollsLabel.text = "Rolls: " + String(rolls)
        totalLabel.text = "Total: " + String(total)
        rolls.removeAll()
        total = 0
        do{
            try playSound()
        } catch{
            //oops
        }
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    // Roll with shake gesture
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            var index = 0
            for index = 0; index < numberOfDice; ++index {
                let diceRoll = Int(arc4random_uniform(UInt32(sideOfDice)) + 1)
                rolls.append(diceRoll)
                total += diceRoll
            }
            rollsLabel.text = "Rolls: " + String(rolls)
            totalLabel.text = "Total: " + String(total)
            rolls.removeAll()
            total = 0
            do{
                try playSound()
            } catch{
                //oops
            }        }
    }
    
}

