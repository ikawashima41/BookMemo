import UIKit
import RxSwift
import AVFoundation

final class CameraService: NSObject, AVCaptureMetadataOutputObjectsDelegate {

    private var metadataOutput: AVCaptureMetadataOutput?
    private var session: AVCaptureSession?
    private var preview: AVCaptureVideoPreviewLayer?
    private var readObject: [AVMetadataObject?] = []
    private var decodeRect: CGRect?
    private var screenRect: CGRect?

    func startRunning() {
        session?.startRunning()
    }

    func stopRunning() {
        session?.stopRunning()
    }

    func setup() -> Observable<Bool> {
        return AVCaptureDevice.authorize()
            .flatMap { [unowned self] _ in
                return self.createSession()
        }
    }

    private func createSession() -> Observable<Bool> {
        return Observable<Bool>.create { [unowned self] observer in
            guard
                let device = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera,
                                                     for: AVMediaType.video,
                                                     position: .back),
                let input = try? AVCaptureDeviceInput.init(device: device) else {
                    return Disposables.create()
            }

            self.metadataOutput = AVCaptureMetadataOutput()
            self.metadataOutput?.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)

            guard let output: AVCaptureMetadataOutput = self.metadataOutput else {
                return Disposables.create()
            }

            self.session = AVCaptureSession()
            self.session?.canSetSessionPreset(AVCaptureSession.Preset.high)
            self.session?.addInput(input)
            self.session?.addOutput(output)


            self.metadataOutput?.metadataObjectTypes = [AVMetadataObject.ObjectType.qr,
                                                            AVMetadataObject.ObjectType.interleaved2of5,
                                                            AVMetadataObject.ObjectType.code128,
                                                            AVMetadataObject.ObjectType.ean8,
                                                            AVMetadataObject.ObjectType.ean13]
            self.setupInterestArea()

            guard let session: AVCaptureSession = self.session else {
                return Disposables.create()
            }

            self.preview = AVCaptureVideoPreviewLayer(session: session)
            self.preview?.videoGravity = AVLayerVideoGravity.resizeAspectFill

            observer.onNext(true)

            return Disposables.create()
        }
    }

    func setDecodeRect(decodeRect: CGRect, screenRect: CGRect) {
        self.decodeRect = decodeRect
        self.screenRect = screenRect

        setupInterestArea()
    }

    private func setupInterestArea() {
        guard
            let metadataOutput: AVCaptureMetadataOutput = self.metadataOutput,
            let decodeRect: CGRect = self.decodeRect,
            let screenRect: CGRect = self.screenRect else {
                return
        }

        let posX: CGFloat = decodeRect.origin.x / screenRect.size.width
        let posY: CGFloat = decodeRect.origin.y / screenRect.size.height
        let width: CGFloat = decodeRect.size.width / screenRect.size.width
        let height: CGFloat = decodeRect.size.height / screenRect.size.height

        metadataOutput.rectOfInterest = CGRect(x: posY, y: 1.0 - posX - width, width: height, height: width)
    }
}

extension CameraService {
    func convertToMachineReadableCode(from object: AVMetadataObject) -> AVMetadataMachineReadableCodeObject? {
        return preview?.transformedMetadataObject(for: object) as? AVMetadataMachineReadableCodeObject
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        metadataObjects.forEach { [unowned self] in
            self.readObject.append($0)
        }
    }
}
