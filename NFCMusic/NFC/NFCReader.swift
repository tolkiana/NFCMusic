//
//  NFCReader.swift
//  NFCMusic
//
//  Created by Nelida Velazquez on 7/19/19.
//  Copyright © 2019 Detroit Labs LLC. All rights reserved.
//

import CoreNFC

class NFCReader: NSObject, NFCNDEFReaderSessionDelegate {
    private var session: NFCNDEFReaderSession? = nil
    private var message: NFCNDEFMessage? = nil
    private var successReading: ((NFCNDEFMessage) -> ())?
    
    func read(succes: ((NFCNDEFMessage) -> ())?) {
        beginSession()
        successReading = succes
    }
    
    // MARK: - NFCNDEFReaderSessionDelegate
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("The session was invalidated: \(error.localizedDescription)")
    }
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        print("Session is Active!");
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        // This method is never called when implementing iOS 13
        // method `readerSession:didDetectTags`
        // Implment this method for devices running iOS 11 or 12
        guard let message = messages.first else {
            self.session?.invalidate(errorMessage: "There's no message")
            return
        }
        self.successReading?(message)
        self.session?.alertMessage = "Message successfully read"
        self.session?.invalidate()
    }
    
    @available(iOS 13.0, *)
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        guard let tag = tags.first else {
            session.invalidate(errorMessage: "Couldn't read tag")
            return
        }
        session.connect(to: tag) { (error: Error?) in
            if error != nil {
                session.invalidate(errorMessage: "Connection error. Please try again.")
                return
            }
            self.read(tag)
        }
    }
    
    // MARK: - Private
    
    private func beginSession() {
        session = NFCNDEFReaderSession(delegate: self,
                                       queue: nil,
                                       invalidateAfterFirstRead: true)
        session?.begin()
    }
    
    private func read(_ tag: NFCNDEFTag) {
        tag.readNDEF { (message: NFCNDEFMessage?, error: Error?) in
            guard error == nil else {
                self.session?.invalidate(errorMessage: error!.localizedDescription)
                return
            }
            guard let message = message else {
                self.session?.invalidate(errorMessage: "There's no message")
                return
            }
            self.successReading?(message)
            self.session?.alertMessage = "Message successfully read"
            self.session?.invalidate()
        }
    }
}
