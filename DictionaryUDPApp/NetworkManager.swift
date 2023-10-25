//
//  NetworkManager.swift
//  DictionaryUDPApp
//
//  Created by Viachaslau Kastsechka on 5/8/23.
//

import Foundation
import CocoaAsyncSocket
import UIKit

final class NetworkManager: NSObject {
    var messageLabel: UILabel
    init(messageLabel: UILabel) {
        self.messageLabel = messageLabel
    }
    private lazy var socketsManager: GCDAsyncUdpSocket = {
        GCDAsyncUdpSocket(delegate: self,
                          delegateQueue: DispatchQueue.global())
    }()

    func connect() {
        let serverAddress = "localhost"
        let serverPort = UInt16(10001)
        do {
            try socketsManager.connect(toHost: serverAddress, onPort: serverPort)
            try socketsManager.beginReceiving()
        } catch {
            print("Connection error: \(error.localizedDescription)")
        }
    }

    func send(message: String) {
        guard let data = message.data(using: .utf8) else { return }
        socketsManager.send(data, withTimeout: -1, tag: 0)
    }
}

// MARK: - GCDAsyncUdpSocketDelegate

extension NetworkManager: GCDAsyncUdpSocketDelegate {
    func udpSocket(_ sock: GCDAsyncUdpSocket, didConnectToAddress address: Data) {
        print("NetworkManager: did connect")
    }

    func udpSocket(_ sock: GCDAsyncUdpSocket,
                   didReceive data: Data,
                   fromAddress address: Data,
                   withFilterContext filterContext: Any?) {
        let message = String(data: data, encoding: .utf8)
        print(message ?? "unknown message")
        DispatchQueue.main.async {
            self.messageLabel.text = message ?? "unknown message"
        }
    }

    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotConnect error: Error?) {
        print("NetworkManager: did fail to connect. Error: \(error?.localizedDescription ?? "unknown error")")
    }

    func udpSocketDidClose(_ sock: GCDAsyncUdpSocket, withError error: Error?) {
        print("NetworkManager: did close with error: \(error?.localizedDescription ?? "unknown error")")
        DispatchQueue.main.async {
            self.messageLabel.text = "Failed to connect to server"
        }
    }

    func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
        print("NetworkManager: did send data with tag: \(tag)")
    }

    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?) {
        print("NetworkManager: did not send data with tag: \(tag), error: \(error?.localizedDescription ?? "unknown error")")
    }
}
