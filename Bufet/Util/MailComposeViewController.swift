//
//  MailComposeViewController.swift
//  Bufet
//
//  Created by Razvan Rujoiu on 05.12.2021.
//

import UIKit
import MessageUI
import SwiftUI

struct MailComposeViewController: UIViewControllerRepresentable {
    
    var toRecipients: [String]
    var mailBody: String?
    var imageAttachment: UIImage?
    
    var didFinish: ()->()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailComposeViewController>) -> MFMailComposeViewController {
        
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = context.coordinator
     
        mail.setToRecipients(self.toRecipients)
        if let body = mailBody {
            mail.setMessageBody(body, isHTML: true)
        }
        if let image = imageAttachment {
            if let imageData = image.pngData() {
                mail.addAttachmentData(imageData, mimeType: "image/png", fileName: "image.png")
            }
        }
        return mail
    }
    
    final class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        
        var parent: MailComposeViewController
        
        init(_ mailController: MailComposeViewController) {
            self.parent = mailController
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            parent.didFinish()
            controller.dismiss(animated: true)
        }
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailComposeViewController>) {
        
    }
}
