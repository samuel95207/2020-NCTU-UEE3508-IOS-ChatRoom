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
    var socket: SocketIOClient? = nil
    var manager: SocketManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    
    func anyEventCallBack( anyEvent: SocketAnyEvent )
    {

    }
    
    func connectCallBack( data:[Any], ack:SocketAckEmitter)
    {
        print("--- socket connected ---")
        
        let deadLine = DispatchTime.now() + .milliseconds(500)
        DispatchQueue.main.asyncAfter(deadline: deadLine) {
            self.socket!.emit("user send out name", self.nameTextField.text!)
        }
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
    
    func serverMembersCallBack( data:[Any], ack:SocketAckEmitter) {
        print("--- receive \"show members on screen\" event ---")
        let message: String = (data[0] as! String)
        print("received:\n\n" + "\(message)" + "\n")
        self.userListTextView.text = "\(message)"
    }
    
    
    // UI
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var chatContentTextView: UITextView!
    @IBOutlet weak var userListTextView: UITextView!
    
    @IBOutlet weak var connectSwitch: UISwitch!
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        let message = self.messageTextField.text!
        self.socket!.emit("user send out message", message)
        self.messageTextField.text = ""
    }
    
    @IBAction func connectSwitchChange(_ sender: Any) {
        let value = connectSwitch.isOn
        
        if(value){
            self.addressTextField.isEnabled = false
            self.nameTextField.isEnabled = false
            
            
            let hostUrl = URL(string: self.addressTextField.text!)
            
            self.manager = SocketManager(socketURL: hostUrl!)

            self.socket = self.manager?.defaultSocket

            self.socket!.onAny(anyEventCallBack)

            self.socket!.on("connect",callback: connectCallBack)

            self.socket!.on("show message on screen", callback: serverMsgCallBack)
            
            self.socket!.on("show members on screen", callback: serverMembersCallBack)

            print("--- connecting to \(self.addressTextField.text!) -")

            self.socket!.connect()
            
        }else{
            self.socket!.disconnect()
            
            self.userListTextView.text = ""
            self.chatContentTextView.text = ""
            self.addressTextField.isEnabled = true
            self.nameTextField.isEnabled = true
        }
        
    }
}

