//
//  ViewController.swift
//  TrojanGFWDemo
//
//  Created by tk on 2023/02/02.
//

import UIKit
import NetworkExtension
import ProxyConfig

class ViewController: UIViewController {
    var manager = VPNManager.shared()
    @IBOutlet weak var toggleSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        toggleSwitch.setOn(false, animated: true)
        ProxyConfig.storeStringConfig(name: ProxyConfig.ConfigKey.Host.rawValue, value: "jptar.sevp1.com")
        ProxyConfig.storeIntConfig(name: ProxyConfig.ConfigKey.Port.rawValue, value: 443)
        ProxyConfig.storeStringConfig(name: ProxyConfig.ConfigKey.Password.rawValue, value: "sk138538wyed37fd")

        manager.loadVPNPreference() { error in
            guard error == nil else {
                fatalError("load VPN preference failed: \(error.debugDescription)")
            }
            NotificationCenter.default.addObserver(self, selector: #selector(self.updateStatus), name: NSNotification.Name.NEVPNStatusDidChange, object: self.manager.manager.connection)
        }

    }
    
    @IBAction func toggle(_ sender: UISwitch) {
        print("toggle")
        /*
        if(toggleSwitch.isOn){
            do {
                print("toggle ON")
                try self.manager.manager.connection.startVPNTunnel()
            } catch {
                print(error)
            }
        }else{
            print("toggle OFF")
            self.manager.manager.connection.stopVPNTunnel()
        }
*/

        manager.enableVPNManager() { error in
            guard error == nil else {
                fatalError("enable VPN failed: \(error.debugDescription)")
            }
            self.manager.toggleVPNConnection() { error in
                guard error == nil else {
                    fatalError("toggle VPN connection failed: \(error.debugDescription)")
                }
            }
        }

    }

    @objc func updateStatus() {
        print(manager.manager.connection.status)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NEVPNStatusDidChange, object: self.manager.manager.connection)
    }


}

