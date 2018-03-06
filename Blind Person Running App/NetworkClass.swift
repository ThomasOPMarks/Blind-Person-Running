//
//  NetworkClass.swift
//  Blind Person Running App
//
//  Created by student on 2/18/18.
//  Copyright © 2018 Blind Institute of Technology. All rights reserved.
//

import Foundation
protocol NetworkBufferDelegate: class {
    func receivedMessage(message string: String)
}


class NetworkBuffer: NSObject {
    
    weak var delegate: NetworkBufferDelegate?
    var inputStream: InputStream!
    var outputStream: OutputStream!
    
    let maxReadLength = 4096;
    
    func setupNetworkCommunication(){
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, "10.7.2.8" as CFString, 9876, &readStream, &writeStream)
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        inputStream.delegate = self
        inputStream.schedule(in: .current, forMode: .commonModes)
        outputStream.schedule(in: .current, forMode: .commonModes)
        inputStream.open()
        outputStream.open()
    }
    
    func stopChatSession() {
        inputStream.close()
        outputStream.close()
    }
    

}

extension NetworkBuffer: StreamDelegate{
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.hasBytesAvailable:
            readAvialableBytes(stream: inputStream)
            print("New message received")
            
        case Stream.Event.endEncountered:
            print("Has new message because end encountered")
            stopChatSession()
        case Stream.Event.errorOccurred:
            print("Error occured")
        case Stream.Event.hasSpaceAvailable:
            print("Has space avaliable")
        default:
            print("some other event...")
            break
        }
    }
    private func readAvialableBytes(stream: InputStream){
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxReadLength)
        
        while stream.hasBytesAvailable {
            let numberOfBytesRead = inputStream.read(buffer, maxLength: maxReadLength)
            if numberOfBytesRead < 0 {
                if let _ = stream.streamError {
                    break
                }
            }
            let message = processedMessageString(buffer: buffer, length: numberOfBytesRead)
            delegate?.receivedMessage(message: message)
        }
        
    }
    
    private func processedMessageString(buffer: UnsafeMutablePointer<UInt8>, length: Int) ->String{
        guard let stringArray = String(bytesNoCopy: buffer, length: length, encoding: .ascii, freeWhenDone: true)
            else{
                return "Couldn't read"
        }
        return stringArray
        
    }
}








