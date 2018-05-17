//
//  ViewController.swift
//  Blind Person Running App
//
//  Created by thomas on 2/16/18.
//  Copyright © 2018 Blind Institute of Technology. All rights reserved.
//

import UIKit
//Accessibility must be mainted on this app.


class ViewController: UIViewController {
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var StatusLabel: UILabel!
    @IBOutlet weak var ConnectButton: UIButton!
    @IBOutlet weak var DisconnectButton: UIButton!
    @IBOutlet weak var LaneNumberLabel: UILabel!
    @IBOutlet weak var ReverseButton: UIButton!
    
    var CurrentLane: Int = 1
    var reop = false
    var help = 10
    var direction = true
    
    var connection = NetworkBuffer()
    var MessageBack: String = " "
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = false
    }
    /*Send Message example
 @IBAction func SendTheTextPushed(_ sender: Any) {
 let text = TextForNetwork.text!
 let sending = "\(text)".data(using: .ascii)!
 
 _ = sending.withUnsafeBytes { connection.outputStream.write($0, maxLength: sending.count) }
 } */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func closeTemp() {
        connection.stopChatSession()
    }
    func reopen () {
        connection = NetworkBuffer()
        connection.delegate = self
        connection.setupNetworkCommunication()
        reop = true
        help = 20
    }
    

    @IBAction func ConnectPushed(_ sender: Any) {
        ConnectButton.isEnabled = false;
        reop = true
        ConnectButton.accessibilityHint = "A session is already taking place";
        StatusLabel.text = "Status: Connected";
        DisconnectButton.isEnabled = true;
        DisconnectButton.accessibilityHint = "Double tap to end the current running session and disconnect from the grid";
        connection.delegate = self
        connection.setupNetworkCommunication();
    }
    
    @IBAction func EndSessionPushed(_ sender: Any) {
        ConnectButton.isEnabled = true;
        reop = false
        ConnectButton.accessibilityHint = "Double tap to connect to the grid and start a running session";
        StatusLabel.text = "Status: Not Connected";
        DisconnectButton.isEnabled = false;
        DisconnectButton.accessibilityHint = "There is no current running session to end";
        let text = "Quit"
        let sending = "\(text)".data(using: .ascii)!
        
        _ = sending.withUnsafeBytes { connection.outputStream.write($0, maxLength: sending.count) }
        connection.stopChatSession()
        
    }
    
    func SendBackText(returnString: String){
        MessageBack = returnString
        print(MessageBack)
    }
    
    @IBAction func ReverseButtonPushed(_ sender: Any) {
        let text = "Reverse"
        let sending = "\(text)".data(using: .ascii)!
        if (ReverseButton.accessibilityHint == "Click to Reverse Direction. Current direction is clockwise."){
            ReverseButton.accessibilityHint = "Click to Reverse Direction. Current direction is counter clockwise."
        }
        else{
            ReverseButton.accessibilityHint = "Click to Reverse Direction. Current direction is clockwise."
        }
        _ = sending.withUnsafeBytes { connection.outputStream.write($0, maxLength: sending.count) }
        
    }
    /*@IBAction func Lane1Pushed(_ sender: Any) {
        if(reop){
            print("Changed it")
        }
        print(help)
        var lanes = [UIButton]()
        lanes.append(Lane1)
        lanes.append(Lane2)
        lanes.append(Lane3)
        lanes.append(Lane4)
        lanes.append(Lane5)
        lanes.append(Lane6)
        CurrentLane = 1
        LaneNumberLabel.text = "Lane Number: \(CurrentLane)"
        for i in 0...5{
            lanes[i].isEnabled = true;
            lanes[i].accessibilityHint = "Push to run in lane \(i + 1), currently set to run in lane \(CurrentLane)"
        }
    }
    
    @IBAction func Lane2Pushed(_ sender: Any) {
        var lanes = [UIButton]()
        lanes.append(Lane1)
        lanes.append(Lane2)
        lanes.append(Lane3)
        lanes.append(Lane4)
        lanes.append(Lane5)
        lanes.append(Lane6)
        CurrentLane = 2
        LaneNumberLabel.text = "Lane Number: \(CurrentLane)"
        for i in 0...5{
            lanes[i].isEnabled = true;
            lanes[i].accessibilityHint = "Push to run in lane \(i + 1), currently set to run in lane \(CurrentLane)"
        }
    }
    
    @IBAction func Lane3Pushed(_ sender: Any) {
        var lanes = [UIButton]()
        lanes.append(Lane1)
        lanes.append(Lane2)
        lanes.append(Lane3)
        lanes.append(Lane4)
        lanes.append(Lane5)
        lanes.append(Lane6)
        CurrentLane = 3
        LaneNumberLabel.text = "Lane Number: \(CurrentLane)"
        for i in 0...5{
            lanes[i].isEnabled = true;
            lanes[i].accessibilityHint = "Push to run in lane \(i + 1), currently set to run in lane \(CurrentLane)"
        }
    }
    
    @IBAction func Lane4Pushed(_ sender: Any) {
        var lanes = [UIButton]()
        lanes.append(Lane1)
        lanes.append(Lane2)
        lanes.append(Lane3)
        lanes.append(Lane4)
        lanes.append(Lane5)
        lanes.append(Lane6)
        CurrentLane = 4
        LaneNumberLabel.text = "Lane Number: \(CurrentLane)"
        for i in 0...5{
            lanes[i].isEnabled = true;
            lanes[i].accessibilityHint = "Push to run in lane \(i + 1), currently set to run in lane \(CurrentLane)"
        }
    }
    @IBAction func Lane5Pushed(_ sender: Any) {
        var lanes = [UIButton]()
        let text = "Quit"
        let sending = "\(text)".data(using: .ascii)!
        
        //_ = sending.withUnsafeBytes { connection.outputStream.write($0, maxLength: sending.count) }
        lanes.append(Lane1)
        lanes.append(Lane2)
        lanes.append(Lane3)
        lanes.append(Lane4)
        lanes.append(Lane5)
        lanes.append(Lane6)
        CurrentLane = 5
        LaneNumberLabel.text = "Lane Number: \(CurrentLane)"
        for i in 0...5{
            lanes[i].isEnabled = true;
            lanes[i].accessibilityHint = "Push to run in lane \(i + 1), currently set to run in lane \(CurrentLane)"
        }
    }
    
    @IBAction func Lane6Pushed(_ sender: Any) {
        var lanes = [UIButton]()
        let text = "Hello from lane 6"
        let sending = "\(text)".data(using: .ascii)!
        
        //_ = sending.withUnsafeBytes { connection.outputStream.write($0, maxLength: sending.count) }
        lanes.append(Lane1)
        lanes.append(Lane2)
        lanes.append(Lane3)
        lanes.append(Lane4)
        lanes.append(Lane5)
        lanes.append(Lane6)
        CurrentLane = 6
        LaneNumberLabel.text = "Lane Number: \(CurrentLane)"
        for i in 0...5{
            lanes[i].isEnabled = true;
            lanes[i].accessibilityHint = "Push to run in lane \(i + 1), currently set to run in lane \(CurrentLane)"
        }
    }*/
}

extension ViewController: NetworkBufferDelegate{
    func receivedMessage(message string: String) {
        SendBackText(returnString: string)
    }

}
