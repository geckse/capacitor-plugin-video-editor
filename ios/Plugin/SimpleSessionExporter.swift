//
//  SimpleSessionExporter.swift
//  CapacitorPluginVideoEditor
//
//  Created by Manuel Rodríguez on 28/10/21.
//

import Foundation
import AVFoundation


// MARK: - SimpleSessionExporter

/// SimpleSessionExporter, export and transcode media in Swift
open class SimpleSessionExporter: NSObject {
    
    public var asset: AVAsset?
    public var outputURL: URL?
    public var outputFileType: AVFileType? = AVFileType.mp4
    public var timeRange: CMTimeRange
    public var optimizeForNetworkUse: Bool = false
    public var videoOutputConfiguration: [String : Any]?
    
    public var overlay: OverlaySettings? = nil;
    
    
    /// Initializes a session with an asset to export.
    ///
    /// - Parameter asset: The asset to export.
    public convenience init(withAsset asset: AVAsset) {
        self.init()
        self.asset = asset
    }
    
    public override init() {
        self.timeRange = CMTimeRange(start: CMTime.zero, end: CMTime.positiveInfinity)
        super.init()
    }
    
    deinit {
        self.asset = nil
    }
}

// MARK: - export

extension SimpleSessionExporter {
    
    /// Completion handler type for when an export finishes.
    public typealias CompletionHandler = (_ status: AVAssetExportSession.Status) -> Void
    
    /// Initiates an export session.
    ///
    /// - Parameter completionHandler: Handler called when an export session completes.
    /// - Throws: Failure indication thrown when an error has occurred during export.
    public func export(completionHandler: @escaping CompletionHandler) {
        guard let asset = self.asset,
              let outputURL = self.outputURL,
              let outputFileType = self.outputFileType else {
            print("SimpleSessionExporter, an asset and output URL are required for encoding")
            completionHandler(.failed)
            return
        }
        
        let composition = AVMutableComposition()
        
        guard
            let compositionTrack = composition.addMutableTrack(
                withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid),
            let assetTrack = asset.tracks(withMediaType: .video).first
        else {
            print("Something is wrong with the asset.")
            completionHandler(.failed)
            return
        }
        
        // Time Range
        do {
            let timeRange = self.timeRange
            try compositionTrack.insertTimeRange(timeRange, of: assetTrack, at: .zero)
            
            if let audioAssetTrack = asset.tracks(withMediaType: .audio).first,
               let compositionAudioTrack = composition.addMutableTrack(
                withMediaType: .audio,
                preferredTrackID: kCMPersistentTrackID_Invalid) {
                try compositionAudioTrack.insertTimeRange(
                    timeRange,
                    of: audioAssetTrack,
                    at: .zero)
            }
        } catch {
            print(error)
            completionHandler(.failed)
            return
        }
        
        // Video size
        compositionTrack.preferredTransform = assetTrack.preferredTransform
        
        let videoWidth = self.videoOutputConfiguration![AVVideoWidthKey] as? NSNumber
        let videoHeight = self.videoOutputConfiguration![AVVideoHeightKey] as? NSNumber
        
        // validated to be non-nil byt this point
        let width = videoWidth!.intValue
        let height = videoHeight!.intValue
        
        let videoSize = CGSize(width: width, height: height)
        let transformedVideoSize = assetTrack.naturalSize.applying(assetTrack.preferredTransform)
        let mediaSize = CGSize(width: abs(transformedVideoSize.width), height: abs(transformedVideoSize.height))
        let scale = videoSize.width / mediaSize.width
        
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = videoSize
        videoComposition.frameDuration = CMTime(value: 1, timescale: 30)
        
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(
            start: .zero,
            duration: composition.duration)

        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionTrack)
        /* layerInstruction.setTransform(asset.scaleTransform(scaleFactor: scale), at: CMTime.zero)*/
        // TODO: maybe the scaling is important for proper downscaling, need to test that
        let transform = asset.preferredTransform.concatenating(assetTrack.preferredTransform)
        layerInstruction.setTransform(transform, at: CMTime.zero)

        // overlay image
        if let overlay, overlay.getPath().absoluteString != "file:///"  {
            
            
            var data = Data();
            do {
                data = try Data(contentsOf: overlay.getPath())
                print("found the data");
            } catch {
                print("no data found");
            }
            
            guard let image = UIImage(data: data) else {
                print("image data not found")
                completionHandler(.failed)
                return
            }
            
            let cgImage = image.cgImage;
            
            // layering
            let parentLayer = CALayer()
            parentLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
            
            // image layer
            let imageLayer = CALayer()
            imageLayer.contents = cgImage
            if overlay.getFillBehaviour() != "none" {
                imageLayer.frame = parentLayer.bounds
                if overlay.getFillBehaviour() == "cover" {
                    imageLayer.contentsGravity = CALayerContentsGravity.resizeAspect
                }
                if overlay.getFillBehaviour() == "contain" {
                    imageLayer.contentsGravity = CALayerContentsGravity.resizeAspectFill
                }
                // todo other options from CALayerContentsGravity
            } else {
                imageLayer.frame = CGRect(x: overlay.getLeft(), y: overlay.getTop(), width: overlay.getWidth(), height: overlay.getHeight())
            }
            imageLayer.opacity = overlay.getOpacity()
            
            // video layer
            let videoLayer = CALayer()
            videoLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
            
            parentLayer.addSublayer(videoLayer)
            parentLayer.addSublayer(imageLayer)
            
            // let layerComposition = AVMutableVideoComposition()
            videoComposition.frameDuration = CMTime(value: 1, timescale: 30)
            videoComposition.renderSize = videoSize
            videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
            
        }

        videoComposition.instructions = [instruction]
        instruction.layerInstructions = [layerInstruction]
        
        // Export
        guard let export = AVAssetExportSession(
            asset: composition,
            presetName: AVAssetExportPresetHighestQuality)
        else {
            print("Cannot create export session.")
            completionHandler(.failed)
            return
        }
        
        export.videoComposition = videoComposition
        export.outputFileType = outputFileType
        export.outputURL = outputURL
        
        export.exportAsynchronously {
            DispatchQueue.main.async {
                switch export.status {
                case .completed:
                    completionHandler(.completed)
                default:
                    print("Something went wrong during export.")
                    print(export.error ?? "unknown error")
                    completionHandler(.failed)
                    break
                }
            }
        }
    }
}

// MARK: - AVAsset extension

extension AVAsset {
    
    /// Initiates a SimpleSessionExport on the asset
    ///
    /// - Parameters:
    ///   - outputFileType: type of resulting file to create
    ///   - outputURL: location of resulting file
    ///   - videoOutputConfiguration: video output configuration
    ///   - completionHandler: completion handler
    public func simple_export(outputFileType: AVFileType? = AVFileType.mp4,
                              outputURL: URL,
                              videoOutputConfiguration: [String : Any],
                              completionHandler: @escaping SimpleSessionExporter.CompletionHandler) {
        let exporter = SimpleSessionExporter(withAsset: self)
        exporter.outputFileType = outputFileType
        exporter.outputURL = outputURL
        exporter.videoOutputConfiguration = videoOutputConfiguration
        exporter.export(completionHandler: completionHandler)
    }
    
    private var g_naturalSize: CGSize {
        return tracks(withMediaType: AVMediaType.video).first?.naturalSize ?? .zero
    }
    
    var g_correctSize: CGSize {
        return g_isPortrait ? CGSize(width: g_naturalSize.height, height: g_naturalSize.width) : g_naturalSize
    }
    
    var g_isPortrait: Bool {
        let portraits: [UIInterfaceOrientation] = [.portrait, .portraitUpsideDown]
        return portraits.contains(g_orientation)
    }
    
    // Same as UIImageOrientation
    var g_orientation: UIInterfaceOrientation {
        guard let transform = tracks(withMediaType: AVMediaType.video).first?.preferredTransform else {
            return .portrait
        }
        
        switch (transform.tx, transform.ty) {
        case (0, 0):
            return .landscapeRight
        case (g_naturalSize.width, g_naturalSize.height):
            return .landscapeLeft
        case (0, g_naturalSize.width):
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }
    
    public func scaleTransform(scaleFactor: CGFloat) -> CGAffineTransform {
        let offset: CGPoint
        let angle: Double

        switch g_orientation {
        case .landscapeLeft:
          offset = CGPoint(x: g_correctSize.width, y: g_correctSize.height)
          angle = Double.pi / 2
        case .landscapeRight:
          offset = CGPoint.zero
          angle = 0
        case .portraitUpsideDown:
          offset = CGPoint(x: 0, y: g_correctSize.height)
          angle = -Double.pi / 2
        default:
          offset = CGPoint(x: g_correctSize.width, y: 0)
          angle = Double.pi / 2
        }

        let scale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        let translation = scale.translatedBy(x: offset.x, y: offset.y)
        let rotation = translation.rotated(by: CGFloat(angle))

        return rotation
      }
}
