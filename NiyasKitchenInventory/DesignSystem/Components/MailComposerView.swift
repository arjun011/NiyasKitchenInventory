//
//  MailComposerView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 11/09/25.
//

import SwiftUI
import MessageUI


struct MailComposerView: UIViewControllerRepresentable {
    let to: String
    let subject: String
    let body: String
    var onResult: (Result<Void, Error>) -> Void

    @MainActor
    final class Coordinator: NSObject, @preconcurrency MFMailComposeViewControllerDelegate {
        let parent: MailComposerView
        init(_ parent: MailComposerView) { self.parent = parent }
       
        @MainActor
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer { controller.dismiss(animated: true) }
            if let error { parent.onResult(.failure(error)); return }
            switch result {
            case .sent: parent.onResult(.success(()))
            default: parent.onResult(.failure(NSError(domain: "Mail", code: 1,
                                  userInfo: [NSLocalizedDescriptionKey:"Not sent"])))
            }
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients([to])
        vc.setSubject(subject)
        vc.setMessageBody(body, isHTML: false)
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    static func dismantleUIViewController(_ uiViewController: MFMailComposeViewController, coordinator: Coordinator) {}
}

