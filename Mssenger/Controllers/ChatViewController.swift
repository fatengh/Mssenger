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
extension MessageKind{
    var messageKindString: String{
        switch self {
        case .text(_):
            return "text"
        case .attributedText(_):
           return  "attributedText"
        case .photo(_):
            return "photo"
        case .video(_):
            return "photo"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .linkPreview(_):
            return "linkPreview"
        case .custom(_):
            return "custom"
        }
    }
}

struct Sender: SenderType {
    public var photourl: String
    public var senderId: String
    public var displayName: String
    
    
}
class ChatViewController: MessagesViewController {
    
    public var otherUserEmail: String = ""
    public var isNewConversation = false
    public static let dateFormatter: DateFormatter = {
          let formattre = DateFormatter()
          formattre.dateStyle = .medium
          formattre.timeStyle = .long
          formattre.locale = .current
          return formattre
      }()
    
    private var msgsArray = [Msg]()//
    
    //
    private var slfSendr: Sender?  {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else{
            return nil
        }
               return  Sender(photourl: "",
                       senderId: email ,
                       displayName: "Faten Ghamdi")
    }

    init(with email: String) {
//         self.conversationId = id
         self.otherUserEmail = email
         super.init(nibName: nil, bundle: nil)
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        
        messagesCollectionView.messagesDataSource = self//
        messagesCollectionView.messagesLayoutDelegate = self//
        messagesCollectionView.messagesDisplayDelegate = self//
        messageInputBar.delegate = self

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()

    }
    
  
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
        let slfSender = self.slfSendr,
        let messageId = createMessageId() else {
                      return
              }

              print("Sending: \(text)")
        
        if isNewConversation {
            let msgs = Msg(sender: slfSender,
                          messageId: messageId ,
                          sentDate: Date(),
                          kind: .text(text))
            DataBaseManger.shared.createNewConversation(with: otherUserEmail, firstMessage: msgs, completion: {success in
                if success{
                    print("massegs send")
                }else {
                    print("faield to send ")
                }
            })
        }
        else {
            
        }

    }
    private func createMessageId() -> String? {
            // date, otherUesrEmail, senderEmail, randomInt
        
            guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
                return nil
            }

             let safeCurrentEmail = DataBaseManger.safe(emailAdd: currentUserEmail)
        
              let dateString = Self.dateFormatter.string(from: Date())
      
            let newIdentifier = "\(otherUserEmail)_\(safeCurrentEmail)_\(dateString)"

            print("created message id: \(newIdentifier)")

            return newIdentifier
        }

}

//
extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        // show the chat bubble on right or left?
        if let sender = slfSendr{
            return sender
        }
        fatalError("self sender is nil ")
       return Sender(photourl: "", senderId: "12", displayName: "faten ghamdi")
    }
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return msgsArray[indexPath.section] // message kit framework uses section to separate every
       
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        msgsArray.count
    }
    
    
}
