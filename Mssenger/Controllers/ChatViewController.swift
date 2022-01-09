//
//  ChatViewController.swift
//  Mssenger
//
//  Created by administrator on 09/01/2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView
// message model
struct Msg: MessageType {
    
    public var sender: SenderType
    public var messageId: String
    public var sentDate: Date
    public var kind: MessageKind
}
struct Sender: SenderType {
    public var photourl: String
    public var senderId: String
    public var displayName: String
    
    
}
class ChatViewController: MessagesViewController {
    
    private var msgsArray = [Msg]()//
    
    //
    private let slfSendr = Sender(photourl: "", senderId: "1", displayName: "Faten Ghamdi")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        
        messagesCollectionView.messagesDataSource = self//
        messagesCollectionView.messagesLayoutDelegate = self//
        messagesCollectionView.messagesDisplayDelegate = self//
//        messageInputBar.delegate = self
        
        msgsArray.append(Msg(sender: slfSendr, messageId: "1", sentDate: Date(), kind: .text("Hello there")))
        msgsArray.append(Msg(sender: slfSendr, messageId: "1", sentDate: Date(), kind: .text("How ARE YOU AND WHAT ARE YOU DOING ? ")))
        
    }
    
   
    
  
}



//
extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        // show the chat bubble on right or left?
       return slfSendr
    }
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return msgsArray[indexPath.section] // message kit framework uses section to separate every
       
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        msgsArray.count
    }
    
    
}
