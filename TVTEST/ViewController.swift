//
//  ViewController.swift
//  TVTEST
//
//  Created by Hoàng Kim Tới on 29/8/24.
//

import UIKit

class ViewController: UIViewController {
    
    private let discovery: SSDPDiscovery = SSDPDiscovery.defaultDiscovery
    fileprivate var session: SSDPDiscoverySession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startScan(sender: AnyObject) {
//        let zonePlayerTarget = SSDPSearchTarget.deviceType(schema: SSDPSearchTarget.upnpOrgSchema, deviceType: "Samsung", version: 1)
        let request = SSDPMSearchRequest(delegate: self, searchTarget: SSDPSearchTarget.all, maxWait: 1)
        
        // Start a discovery session for the request and timeout after 10 seconds of searching.
        self.session = try! discovery.startDiscovery(request: request, timeout: 10.0)
    }
    
    @IBAction func stopScan(sender: AnyObject) {
        self.session?.close()
        self.session = nil
    }
    
    
}

extension ViewController: SSDPDiscoveryDelegate {
    
    public func discoveredDevice(response: SSDPMSearchResponse, session: SSDPDiscoverySession) {
        print("Found device \(response)\n")
    }
    
    public func discoveredService(response: SSDPMSearchResponse, session: SSDPDiscoverySession) {
    }
    
    public func closedSession(_ session: SSDPDiscoverySession) {
        print("Session closed\n")
    }
    
}
