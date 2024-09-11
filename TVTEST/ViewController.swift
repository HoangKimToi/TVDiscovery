//
//  ViewController.swift
//  TVTEST
//
//  Created by Hoàng Kim Tới on 29/8/24.
//

import UIKit
import GCDWebServer

class ViewController: UIViewController {
    
    private let discovery: SSDPDiscovery = SSDPDiscovery.defaultDiscovery
    fileprivate var session: SSDPDiscoverySession?
    
    var webServer: GCDWebServer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //         Khởi tạo GCDWebServer
        webServer = GCDWebServer()
        
        // Định nghĩa endpoint cho phép trả về dữ liệu dạng HTML
        webServer.addDefaultHandler(forMethod: "GET", request: GCDWebServerRequest.self) { request in
            return GCDWebServerDataResponse(html:"<html><body><p>Hello, World!</p></body></html>")
        }
        
        if let videoData = getFileData() {
            webServer.addHandler(forMethod: "GET", path: "/video1", request: GCDWebServerRequest.self) { request in
                return GCDWebServerDataResponse(data: videoData, contentType: "video/mp4")
            }
        }
        
        if let videoPath = getFilePath() {
            webServer.addGETHandler(forBasePath: "/video/", directoryPath: (videoPath as NSString).deletingLastPathComponent, indexFilename: nil, cacheAge: 3600, allowRangeRequests: true)
        }
        
        // Bắt đầu server trên cổng 8584
        do {
            try webServer.start(options: [
                GCDWebServerOption_AutomaticallySuspendInBackground: false,
                GCDWebServerOption_Port: 8584,
                GCDWebServerOption_BonjourName: "GCD Web Server"
            ])
            
            //            print("Server đang chạy tại \(webServer?.serverURL?.port ?? 0)")
            // In ra địa chỉ IP và cổng
            if let ipAddress = webServer.serverURL {
                print("Server đang chạy tại \(ipAddress)")
            } else {
                print("Không tìm thấy địa chỉ IP")
            }
        } catch {
            print("Server đang NOT chạy")
        }
        
    }
    
    func getFilePath() -> String? {
        if let videoURL = Bundle.main.path(forResource: "Video1", ofType: "mp4") {
            print("Đường dẫn file video: \(videoURL)")
            // Thực hiện thao tác với videoURL, như phát video
            return videoURL
        } else {
            print("Không tìm thấy file video trong project.")
            return nil
        }
    }
    
    func getFileData() -> Data? {
        if let videoURL = Bundle.main.path(forResource: "Video1", ofType: "mp4") {
            do {
                let videoData = try Data(contentsOf: URL(fileURLWithPath: videoURL))
                
                print("Video data size: \(videoData.count) bytes")
                return videoData
            } catch {
                print("Không thể chuyển đổi video thành Data: \(error)")
                return nil
            }
        } else {
            print("Không tìm thấy file video trong project.")
            return nil
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Dừng server khi không còn sử dụng
        webServer.stop()
    }
    
    @IBAction func startScan(sender: AnyObject) {
        //        let zonePlayerTarget = SSDPSearchTarget.deviceType(schema: SSDPSearchTarget.upnpOrgSchema, deviceType: "Samsung", version: 1)
        let request = SSDPMSearchRequest(delegate: self, searchTarget: SSDPSearchTarget.rootDevice, maxWait: 5)
        
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
