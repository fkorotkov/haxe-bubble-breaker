package org.haxe.bubble.field;
import nme.events.TouchEvent;
import nme.events.MouseEvent;
import nme.events.Event;
import org.haxe.bubble.RenderUtil;
import org.haxe.bubble.UIElement;
class Field extends UIElement {
    private var colors:Array<CellType>;
    private var cells:Array<Array<CellType>>;

    public function new(n:Int) {
        super();
        colors = [CellType.BLUE, CellType.GREEN, CellType.PURPLE, CellType.RED, CellType.YELLOW];
        refill(n, n);
        addEventListener(MouseEvent.MOUSE_DOWN, clickHandler);
        addEventListener(TouchEvent.TOUCH_TAP, clickHandler);
    }

    public function clickHandler(event:MouseEvent) {
        trace(event.localX + " <> " + event.localY);
    }

    public function clear() {
        refill(cells.length, cells[0].length);
    }

    private function refill(n:Int, m:Int) {
        cells = new Array<Array<CellType>>();
        for (i in 0...n) {
            var row = new Array<CellType>();
            for (j in 0...m) {
                row.push(colors[Math.floor(Math.random() * colors.length)]);
            }
            cells.push(row);
        }
    }

    public override function resize(w:Float, h:Float) {
        render(w, h);
    }

    public function render(w:Float, h:Float) {
        graphics.clear();
        graphics.beginFill(0, 0);
        graphics.drawRect(0, 0, w, h);
        graphics.endFill();
        for (i in 0...cells.length) {
            for (j in 0...cells[i].length) {
                renderCell(i, j, w / cells.length, cells[i][j]);
            }
        }
    }

    public function renderCell(rowIndex:Int, columnIndex:Int, size:Float, type:CellType) {
        if(type == CellType.EMPTY) return;
        var color = CellColorUtil.get(type);
        var circleX = columnIndex * size + size / 2;
        var circleY = rowIndex * size + size / 2;
        circleY = height - circleY;
        size -= Math.max(2, size / 10);
        RenderUtil.drawCircle(graphics, circleX, circleY, size / 2, color);
    }
}
