import Foundation;

enum OverlaySettingsError: Error {
    case invalidArgument(message: String)
}

public class OverlaySettings: NSObject
{
    private var path: URL;
    private var top: Int = 0;
    private var left: Int = 0;
    private var height: Int = 0;
    private var width: Int = 0;
    private var keepAspectRatio: Bool = true;
    
    init(path: URL, top: Int, left: Int, height: Int, width: Int, keepAspectRatio: Bool) throws
    {
        
        if (height < 0)
        {
            throw OverlaySettingsError.invalidArgument(message: "Parameter height cannot be negative");
        }
        if (width < 0)
        {
            throw OverlaySettingsError.invalidArgument(message: "Parameter width cannot be negative");
        }
        
        self.path = path;
        self.height = height;
        self.width = width;
        self.keepAspectRatio = keepAspectRatio;
    }
    
    func getPath()->URL
    {
        return self.path;
    }
    
    func getHeight()->Int
    {
        return self.height;
    }
    
    func setHeight(_ height: Int) throws
    {
        if (height < 0)
        {
            throw OverlaySettingsError.invalidArgument(message: "Parameter height cannot be negative");
        }
        self.height = height;
    }
    
    func getWidth()->Int
    {
        return self.width;
    }
    
    func setWidth(_ width: Int) throws
    {
        if (width < 0)
        {
            throw OverlaySettingsError.invalidArgument(message: "Parameter width cannot be negative");
        }
        self.width = width;
    }
    
    func isKeepAspectRatio()->Bool
    {
        return self.keepAspectRatio;
    }
    
    func setKeepAspectRatio(_ keepAspectRatio: Bool)
    {
        self.keepAspectRatio = keepAspectRatio;
    }
}
