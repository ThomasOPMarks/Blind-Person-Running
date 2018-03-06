//
//  ViewController.swift
//  Blind Person Running App
//
//  Created by student on 2/16/18.
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
    @IBOutlet weak var Lane1: UIButton!
    @IBOutlet weak var Lane2: UIButton!
    @IBOutlet weak var Lane3: UIButton!
    @IBOutlet weak var Lane4: UIButton!
    @IBOutlet weak var Lane5: UIButton!
    @IBOutlet weak var Lane6: UIButton!
    var CurrentLane: Int = 1
    
    
    var connection = NetworkBuffer()
    var MessageBack: String = " "
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
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

    @IBAction func ConnectPushed(_ sender: Any) {
        ConnectButton.isEnabled = false;
        ConnectButton.accessibilityHint = "A session is already taking place";
        StatusLabel.text = "Status: Connected";
        DisconnectButton.isEnabled = true;
        DisconnectButton.accessibilityHint = "Double tap to end the current running session and disconnect from the grid";
        connection.delegate = self
        connection.setupNetworkCommunication();
    }
    
    @IBAction func EndSessionPushed(_ sender: Any) {
        ConnectButton.isEnabled = true;
        ConnectButton.accessibilityHint = "Double tap to connect to the grid and start a running session";
        StatusLabel.text = "Status: Not Connected";
        DisconnectButton.isEnabled = false;
        DisconnectButton.accessibilityHint = "There is no current running session to end";
        connection.stopChatSession()
        
    }
    
    func SendBackText(returnString: String){
        MessageBack = returnString
        print(MessageBack)
    }
    
    @IBAction func Lane1Pushed(_ sender: Any) {
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
    }
}

extension ViewController: NetworkBufferDelegate{
    func receivedMessage(message string: String) {
        SendBackText(returnString: string)
    }

}
