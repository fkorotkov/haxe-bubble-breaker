package org.haxe.bubble;
class ExtendedGame {
    var bar(getBar, setBar):Int;
    function foo():String {}

    @:setter(bar)
    public function setBar(value:Int) {
        this.bar = value;
    }

    @:getter(bar)
    public function getBar():Int {
        return bar;
    }
}
