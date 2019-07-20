//
//  NFCWriter.swift
//  NFCMusic
//
//  Created by Nelida Velazquez on 7/19/19.
//  Copyright © 2019 Detroit Labs LLC. All rights reserved.
//

import CoreNFC

class NFCWriter: NSObject, NFCNDEFReaderSessionDelegate {
    private var session: NFCNDEFReaderSession? = nil
    private var message: NFCNDEFMessage? = nil
    
    func write(_ message: NFCNDEFMessage) {
        self.message = message
        beginSession()
    }
    
    // MARK: - NFCNDEFReaderSessionDelegate
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("The session was invalidated: \(error.localizedDescription)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        // This is never called when implementing `readerSession:didDetectTags`
    }
    
    @available(iOS 13.0, *)
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        guard let tag = tags.first else {
            session.invalidate(errorMessage: "Couldn't read tag")
            return
        }
        guard let message = self.message else {
            session.invalidate(errorMessage: "Invalid Message")
            return
        }
        
        session.connect(to: tag) { (error: Error?) in
            if error != nil {
                session.invalidate(errorMessage: "Connection error. Please try again.")
                return
            }
            self.write(message, to: tag)
        }
    }
    
    // MARK: - Private
    
    private func beginSession() {
        session = NFCNDEFReaderSession(delegate: self,
                                       queue: DispatchQueue.main,
                                       invalidateAfterFirstRead: true)
        session?.begin()
    }
    
    @available(iOS 13.0, *)
    private func write(_ message: NFCNDEFMessage, to tag: NFCNDEFTag) {
        tag.queryNDEFStatus() { (status: NFCNDEFStatus, _, error: Error?) in
            guard status == .readWrite else {
                self.session?.invalidate(errorMessage: "Tag is invalid.")
                return
            }
            
            tag.writeNDEF(message) { (error: Error?) in
                if (error != nil) {
                    self.session?.invalidate(errorMessage: error?.localizedDescription ?? "There was an error")
                }
                self.session?.alertMessage = "Message successfully saved"
                self.session?.invalidate()
            }
        }
    }
}
