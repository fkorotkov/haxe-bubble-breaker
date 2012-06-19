package org.haxe.bubble;
class ExtendedGame {
    var bar(getBar, setBar):Int;
    function foo():String {}

    public function setBar(value:Int) {
        this.bar = value;
    }

    public function getBar():Int {
        return bar;
    }
}
