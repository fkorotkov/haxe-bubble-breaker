package org.haxe.bubble;
import nme.text.TextField;
class CircleButton extends UIElement {
    var textField:TextField;
    public function new(text:String) {
        super();
        textField = new TextField();
        textField.text = text;
        textField.textColor = 0xFFFFFF;
        addChild(textField);
    }

    public override function resize(w:Float, h:Float) {
        graphics.clear();

        textField.x = (w - textField.textWidth) / 2;
        textField.y = (h - textField.textHeight - 4) / 2;

        graphics.beginFill(0, 1);
        graphics.drawRoundRect(0, 0, w, h, 5, 5);
    }
}
