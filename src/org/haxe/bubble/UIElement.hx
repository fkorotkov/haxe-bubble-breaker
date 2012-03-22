package org.haxe.bubble;
import nme.display.Sprite;

/**
    Base ui class
**/
class UIElement extends Sprite {
    public function new() {
        super();
    }

    public function resize(w:Float, h:Float) {
        graphics.beginFill(0, 0);
        graphics.drawRect(0, 0, w, h);
        graphics.endFill();
    }
}
