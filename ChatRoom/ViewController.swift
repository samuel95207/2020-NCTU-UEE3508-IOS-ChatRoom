//
//  ViewController.swift
//  ChatRoom
//
//  Created by Samuel Huang on 2020/10/28.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var chatContentTextView: UITextView!
    var i = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func sendButtonPressed(_ sender: Any) {
        let message = self.messageTextField.text!
        self.i = self.i + 1
        let newChatContent = "[\(self.i)] \(message)\n\(self.chatContentTextView.text!)"
        self.chatContentTextView.text = newChatContent
        self.messageTextField.text = ""
    }
    
}

