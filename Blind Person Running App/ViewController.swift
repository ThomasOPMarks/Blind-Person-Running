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
    @IBOutlet weak var TextForNetwork: UITextField!
    @IBOutlet weak var SendTheTextButton: UIButton!
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
    @IBAction func SendTheTextPushed(_ sender: Any) {
        let text = TextForNetwork.text!
        let sending = "\(text)".data(using: .ascii)!
        
        _ = sending.withUnsafeBytes { connection.outputStream.write($0, maxLength: sending.count) }
    }
    
    func SendBackText(returnString: String){
        MessageBack = returnString
        print(MessageBack)
    }
}

extension ViewController: NetworkBufferDelegate{
    func receivedMessage(message string: String) {
        SendBackText(returnString: string)
    }

}
