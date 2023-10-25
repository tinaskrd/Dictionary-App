//
//  MainViewController.swift
//  DictionaryUDPApp
//
//  Created by Tina  on 7.05.23.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var userWordTextField: UITextField!
    @IBOutlet weak var translatedWordLabel: UILabel!

    var networkManager: NetworkManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager = NetworkManager(messageLabel: translatedWordLabel) 
        networkManager?.connect()
    }
    
    // MARK: - IBActions
    
    @IBAction func translateButtonHit() {
        guard let userText = userWordTextField.text
        else {
            showEmptyTextAlert()
            return
        }
        networkManager?.send(message: userText)
    }
    
    @IBAction func exitButtonHit() {
        networkManager?.send(message: "disconnect")
        dismiss(animated: true)
    }
}

extension MainViewController {
    func showEmptyTextAlert() {
        let alert = UIAlertController(title: "ERROR", message: "Empty TextField! Please enter your text and try again...", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
