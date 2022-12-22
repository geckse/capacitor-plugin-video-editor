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
    private var fillBehaviour: String = "none";
    private var opacity: Float = 1;
    
    init(path: URL, top: Int, left: Int, height: Int, width: Int, fillBehaviour: String, opacity: Float) throws
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
        self.top = top;
        self.left = left;
        self.fillBehaviour = fillBehaviour;
        self.opacity = opacity;
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
    
    
    func getTop()->Int
    {
        return self.top;
    }
    
    func setTop(_ top: Int) throws
    {
        self.top = top;
    }

    func getLeft()->Int
    {
        return self.left;
    }
    
    func setLeft(_ left: Int) throws
    {
        self.left = left;
    }

    func getFillBehaviour()->String
    {
        return self.fillBehaviour;
    }
    
    func setFillBehaviour(_ fill: String) throws
    {
        self.fillBehaviour = fill;
    }
    
    
    func getOpacity()->Float
    {
        return self.opacity;
    }
    
    func setOpacity(_ opacity: Float) throws
    {
        self.opacity = opacity;
    }
    
}
