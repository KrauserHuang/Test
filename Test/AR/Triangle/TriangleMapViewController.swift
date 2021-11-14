//
//  TriangleMapViewController.swift
//  Test
//
//  Created by Tai Chin Huang on 2021/11/11.
//

import UIKit
import AVFoundation
import CoreLocation

protocol TriangleMapViewControllerDelegate: AnyObject {
    func toCouponList(_ viewController: TriangleMapViewController)
}

class TriangleMapViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, CLLocationManagerDelegate {
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var currentLat = ""
    var currentLong = ""
    
//    var arArray = [ARInfo]()
    weak var delegate: TriangleMapViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setQRCodeScan() {
        captureSession = AVCaptureSession()
        // AVCaptureDevice可以抓到相機和其屬性
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch let error {
            print(error)
            return
        }
        captureSession?.addInput(videoInput)
        // AVCaptureMetaDataOutput輸出影音資料，先實體化AVCaptureMetaDataOutput物件
        let metadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(metadataOutput)
        // 執行緒處理QRCode
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        // 看要處理哪些類型的資料
        metadataOutput.metadataObjectTypes = [.qr]
        // AVCaptureVideoPreviewLayer負責呈現Session捕捉的資料
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        // 顯示size
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        // 呈現在view上面
        videoPreviewLayer?.frame.size = view.bounds.size
        // 加入畫面
        view.layer.insertSublayer(videoPreviewLayer!, at: 0)
        // 開始影像擷取呈現鏡頭畫面
        captureSession?.startRunning()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation: CLLocation = locations[0] as CLLocation
        currentLat = "\(currentLocation.coordinate.latitude)"
        currentLong = "\(currentLocation.coordinate.longitude)"
    }
    
    //Hello
}
