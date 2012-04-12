package org.haxe.bubble;
import nme.display.Graphics;
class RenderUtil {
    public static function drawCircle(graphics:Graphics, x:Float, y:Float, size:Float, color:Int) {
        graphics.beginFill(color);
        graphics.drawCircle(x, y, size);
        graphics.endFill();
    }
}
