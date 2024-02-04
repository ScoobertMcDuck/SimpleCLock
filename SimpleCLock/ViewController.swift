//
//  ViewController.swift
//  SimpleCLock
//
//  Created by Charlotte Norsworthy on 2/3/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var CurrentTime: UILabel!
    @IBOutlet weak var BackgroundImage: UIImageView!
    @IBOutlet weak var StartStopButton: UIButton!
    @IBOutlet weak var TimeRemaining: UILabel!
    @IBOutlet weak var DatePicker: UIDatePicker!
    var player: AVAudioPlayer?
    
    var timer: Timer?
    var totalTime = 5
    var myString = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Loop the Timer every second
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
        
            // Check if Day or Night Time
            self.checkTime()
            
            // Initlaize date formatter
            let formatter = DateFormatter();
            formatter.timeZone = .current
            formatter.locale = .current
            formatter.dateFormat = "EE, d MMM yyyy HH:mm:ss"
            
            // Replace label with current time
            let currentTime = formatter.string(from: Date())
            self.CurrentTime.text = currentTime
            
            
        }
        
        
    }
    
    // Checks for AM/PM
    func checkTime() {
        
        // Initialize current time
        let calendarObj = Calendar.current
        let now = Date()
        // Lower bound of Night
        let lowerBound = calendarObj.date(
          bySettingHour: 12,
          minute: 0,
          second: 0,
          of: now)!
        // Upper bound of Night
        let upperBound = calendarObj.date(
          bySettingHour: 23,
          minute: 59,
          second: 59,
          of: now)!
        // Change Image
        if now >= lowerBound && now <= upperBound {
            BackgroundImage.image = UIImage(named: "Night")
        }
        else {
            BackgroundImage.image = UIImage(named: "Day")
        }
    }
    
    // Button is Pressed
    @IBAction func ButtonPressed(_ sender: UIButton) {
        
        // If timer needs to be started
        if StartStopButton.currentTitle == "Start Timer" {
            
            // Set Time Interval
            let calendarObj = Calendar.current
            let now = Date()
            let zero = calendarObj.date(
              bySettingHour: 0,
              minute: 0,
              second: 0,
              of: now)!
            
            totalTime = Int(DatePicker.date.timeIntervalSince(zero))
           
            // Start Timer
            TimeRemaining.text = "Time Remaining: "
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
            
            
        }
        
        // If music needs to be stopped or timer reset
        else if StartStopButton.currentTitle == "Stop Music" {
            
            // Stop music early
            player?.stop()
            
            // Change status of button
            StartStopButton.setTitle("Start Timer", for: .normal)
            player?.stop()
            
            // Reset TimeRemaining
            TimeRemaining.text = "Time Remaining:"
        }
    }
    
    
    // Update Counter
    
    @objc func UpdateTimer() {
        
        // Disable Button until counter is done
        StartStopButton.isEnabled = false
        self.TimeRemaining.text = "Time Remaining: " + self.timeFormatted(self.totalTime) // will show timer
                    if totalTime > 0 {
                        totalTime -= 1  // decrease counter timer
                    } 
                    else {
                        if let timer = self.timer {
                              
                            timer.invalidate()
                            self.timer = nil
                            
                        }
                        // Enable button when counter finishes
                        StartStopButton.isEnabled = true;
                        
                        // Play Song when Timer Finishes
                        do{
                            let url = Bundle.main.path(forResource: "Song", ofType: "mp3")
                            guard let url = url else { return}
                            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: url))
                            guard let player = player else {return}
                            player.play()
                        }
                        catch {
                            print("error")
                        }
                        
                        // Change status of button
                        StartStopButton.setTitle("Stop Music", for: .normal)
        
                    }
        
    }
    
    // Convert Seconds to Desired output
    func timeFormatted(_ totalSeconds: Int) -> String {
            let seconds: Int = totalSeconds % 60
            let minutes: Int = (totalSeconds / 60) % 60
            let hours: Int = (totalSeconds / 60 / 60) % 60
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    
}

