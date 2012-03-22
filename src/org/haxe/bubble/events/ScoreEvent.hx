package org.haxe.bubble.events;
import nme.events.Event;
class ScoreEvent extends Event {
    public var score:Int;
    public var forSelection:Bool;
    public function new(score:Int, forSelection:Bool) {
        super("scoreEvent");
        this.score = score;
        this.forSelection = forSelection;
    }

    override public function clone():Event {
        return new ScoreEvent(score, forSelection);
    }
}
