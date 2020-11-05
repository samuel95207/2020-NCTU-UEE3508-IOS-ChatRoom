//
//  ViewController.swift
//  ChatRoom
//
//  Created by Samuel Huang on 2020/10/28.
//

import UIKit
import SocketIO

class ViewController: UIViewController {
    
    // Socket
    public let hostIpStr: String = "http://localhost:4000"
    public var socket: SocketIOClient? = nil
    public var manager: SocketManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hostUrl = URL(string: self.hostIpStr)
        
        self.manager = SocketManager(socketURL: hostUrl!)
        
        self.socket = self.manager?.defaultSocket
        
        self.socket!.onAny(anyEventCallBack)
        
        self.socket!.on("connect",callback: connectCallBack)
        
        print("--- connecting to \(self.hostIpStr) --")
        
        self.socket!.connect()
    }
    
    
    func anyEventCallBack( anyEvent: SocketAnyEvent )
    {

    }
    
    func connectCallBack( data:[Any], ack:SocketAckEmitter)
    {
        print("--- socket connected ---")
        
        let deadLine = DispatchTime.now() + .milliseconds(500)
        DispatchQueue.main.asyncAfter(deadline: deadLine) {
            self.socket!.emit("user send out message", "Hello! I've connected!")
        }
    }
    
    func serverMsgCallBack( data:[Any], ack:SocketAckEmitter) {
        print("--- receive \"show message on screen\" event ---")
        let message: String = (data[0] as! String)
        print("received:\n\n" + "\(message)" + "\n")
        self.chatContentTextView.text = "\(message)\n\(self.chatContentTextView.text!)"
    }
    
    
    // UI
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var chatContentTextView: UITextView!
    var i = 0

    @IBAction func sendButtonPressed(_ sender: Any) {
        let message = self.messageTextField.text!
        self.i = self.i + 1
        let newChatContent = "[\(self.i)] \(message)\n\(self.chatContentTextView.text!)"
        self.chatContentTextView.text = newChatContent
        self.messageTextField.text = ""
    }
    
}

