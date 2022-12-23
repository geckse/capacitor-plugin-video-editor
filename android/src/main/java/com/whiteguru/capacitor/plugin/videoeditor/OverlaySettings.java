package com.whiteguru.capacitor.plugin.videoeditor;

public class OverlaySettings {

    private String path = "";
    private int top = 0;
    private int left = 0;
    private int height = 0;
    private int width = 0;
    private String fillBehaviour = "none";
    private float opacity = 1.0f;

    public OverlaySettings() {
    }

    public OverlaySettings(String path, int top, int left, int height, int width, String fillBehaviour, float opacity) {
        if (height < 0) {
            throw new IllegalArgumentException("Parameter height cannot be negative");
        }

        if (width < 0) {
            throw new IllegalArgumentException("Parameter width cannot be negative");
        }
        this.path = path;
        this.top = top;
        this.left = left;
        this.height = height;
        this.width = width;
        this.fillBehaviour = fillBehaviour;
        this.opacity = opacity;
    }

    public final String getPath(){ return path; }
    public void setPath(String path){
      this.path = path;
    }

    public int getTop() {
      return top;
    }
    public void setTop(int top) {
      this.top = top;
    }

    public int getLeft() {
      return left;
    }
    public void setLeft(int left) {
      this.left = left;
    }

    public int getHeight() {
        return height;
    }

    public void setHeight(int height) {
        if (height < 0) {
            throw new IllegalArgumentException("Parameter height cannot be negative");
        }

        this.height = height;
    }

    public int getWidth() {
        return width;
    }

    public void setWidth(int width) {
        if (width < 0) {
            throw new IllegalArgumentException("Parameter width cannot be negative");
        }

        this.width = width;
    }

    public final String getFillBehaviour(){ return fillBehaviour; }
    public void setFillBehaviour(String fillBehaviour){
      this.fillBehaviour = fillBehaviour;
    }

    public float getOpacity() {
      return opacity;
    }
    public void setOpacity(float opacity) {
      this.opacity = opacity;
    }


}
