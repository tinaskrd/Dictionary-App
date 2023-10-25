//
//  WelcomeViewController.swift
//  DictionaryUDPApp
//
//  Created by Tina  on 22.06.23.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var portNumberTextField: UITextField!
    @IBOutlet weak var ipAddressTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBActions
    
    @IBAction func connectButtonHit() {
        guard let portNumber = portNumberTextField.text, let ipAddress = ipAddressTextField.text else { return }
        if portNumber == "10001" && ipAddress == "localhost" || ipAddress == "127.0.0.1" {
            performSegue(withIdentifier: "showmain", sender: nil)
        } else {
            showFalseAlert()
        }
    }
}

extension WelcomeViewController {
    func showEmptyFieldAlert() {
        let alert = UIAlertController(title: "ERROR", message: "Empty TextField! Please check that you have filled both textfields and try again...", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showFalseAlert() {
        let alert = UIAlertController(title: "ERROR", message: "Wrong port number or ip address. Please try again", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
