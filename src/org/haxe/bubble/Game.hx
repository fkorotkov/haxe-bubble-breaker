package org.haxe.bubble;
import flash.display.StageScaleMode;
import org.haxe.bubble.field.Field;
import nme.text.TextField;
import nme.display.StageAlign;
import nme.events.Event;
import nme.display.MovieClip;

class Game extends UIElement {
    var field:Field;
    var scoreField:TextField;
    var score:Int;
    public function new() {
        super();
        field = new Field(11);
        scoreField = new TextField();
        score = 0;
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(event:Event) {
        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.addEventListener(Event.RESIZE, onResize);
        addChild(field);
        addChild(scoreField);

        updateScore();
        resize(stage.stageWidth, stage.stageHeight);
    }

    private function onResize(event:Event) {
        resize(stage.stageWidth, stage.stageHeight);
    }

    override public function resize(w:Float, h:Float) {
        graphics.clear();
        super.resize(w, h);
        scoreField.x = 5;
        scoreField.y = 5;

        graphics.lineStyle(1);
        graphics.moveTo(0, 10 + scoreField.textHeight);
        graphics.lineTo(w, 10 + scoreField.textHeight);

        h -= 10 + scoreField.textHeight;
        var fieldSize = Math.min(w, h);
        var fieldX = (w - fieldSize) / 2;
        var fieldY = (h - fieldSize) / 2;

        field.x = fieldX;
        field.y = 10 + scoreField.textHeight + fieldY;

        field.resize(fieldSize, fieldSize);
    }

    private function updateScore() {
        scoreField.text = "Score: " + score;
        scoreField.height = scoreField.textHeight + 2; // gutter
    }
}
