package org.haxe.bubble.field;
import nme.events.TouchEvent;
import nme.events.MouseEvent;
import nme.events.Event;
import org.haxe.bubble.RenderUtil;
import org.haxe.bubble.UIElement;
class Field extends UIElement {
    private var colors:Array<CellType>;
    private var cells:Array<Array<CellType>>;
    private var selected:Bool;
    private var selectedIndex:Array<Int>;

    public function new(n:Int) {
        super();
        colors = [CellType.BLUE, CellType.GREEN, CellType.PURPLE, CellType.RED, CellType.YELLOW];
        selected = false;
        refill(n, n);
        addEventListener(MouseEvent.MOUSE_DOWN, clickHandler);
        addEventListener(TouchEvent.TOUCH_TAP, clickHandler);
    }

    public function getCellSize():Float {
        return width / cells.length;
    }

    private function clickHandler(event:MouseEvent) {
        if (selected) {
            doRemove(selectedIndex[0], selectedIndex[1]);
        } else {
            var i = Math.floor(event.localX / getCellSize());
            selectedIndex = [i, cells[i].length - 1 - Math.floor(event.localY / getCellSize())];
        }
        selected = !selected;
        redraw();
    }

    public function clearField() {
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

    public function redraw() {
        render(width, height);
    }

    private function render(w:Float, h:Float) {
        graphics.clear();
        graphics.beginFill(0, 0);
        graphics.drawRect(0, 0, w, h);
        graphics.endFill();
        for (i in 0...cells.length) {
            for (j in 0...cells[i].length) {
                renderCell(i, j, cells[i][j]);
            }
        }

        if (selected) {
            var x = selectedIndex[0];
            var y = selectedIndex[1];
            drawSelection(x, y, cells[x][y]);
        }
    }

    private function renderCell(columnIndex:Int, rowIndex:Int, type:CellType) {
        if (type == CellType.EMPTY) return;
        var color = CellColorUtil.get(type);
        var size = getCellSize();
        var circleX = columnIndex * size + size / 2;
        var circleY = rowIndex * size + size / 2;
        circleY = height - circleY;
        size -= Math.max(2, size / 10);
        RenderUtil.drawCircle(graphics, circleX, circleY, size / 2, color);
    }

    private function drawSelection(startI:Int, startJ:Int, type:CellType) {
        var mark:Array<Array<Bool>> = new Array<Array<Bool>>();
        for (i in 0...cells.length) {
            var row = new Array<Bool>();
            for (j in 0...cells[i].length) {
                row.push(false);
            }
            mark.push(row);
        }

        var q = [[startI, startJ]];
        while (q.length > 0) {
            var i = q[0][0];
            var j = q[0][1];
            q.shift();
            if (mark[i][j]) continue;
            mark[i][j] = true;

            if (canMove(i, j - 1, type)) {
                q.push([i, j - 1]);
            } else {
                drawSelectionBorder(i, j, Side.BOTTOM);
            }
            if (canMove(i - 1, j, type)) {
                q.push([i - 1, j]);
            } else {
                drawSelectionBorder(i, j, Side.LEFT);
            }
            if (canMove(i, j + 1, type)) {
                q.push([i, j + 1]);
            } else {
                drawSelectionBorder(i, j, Side.TOP);
            }
            if (canMove(i + 1, j, type)) {
                q.push([i + 1, j]);
            } else {
                drawSelectionBorder(i, j, Side.RIGHT);
            }
        }
    }

    private function checkRange(i:Int, j:Int):Bool {
        var correctI = 0 <= i && i < cells.length;
        var correctJ = 0 <= j && (correctI && j < cells[i].length);
        return correctI && correctJ;
    }

    private function canMove(i:Int, j:Int, type:CellType):Bool {
        return checkRange(i, j) && cells[i][j] == type;
    }

    private function drawSelectionBorder(i:Int, j:Int, side:Side) {
        var bottomLeftX = i * getCellSize() + 1;
        var bottomLeftY = height - j * getCellSize();
        bottomLeftX = Math.max(1, bottomLeftX);
        bottomLeftX = Math.min(width - 1, bottomLeftX);
        bottomLeftY = Math.max(1, bottomLeftY);
        bottomLeftY = Math.min(height - 1, bottomLeftY);
        graphics.lineStyle(1);
        switch (side) {
            case Side.LEFT:
            moveToInField(bottomLeftX, bottomLeftY);
            lineToInField(bottomLeftX, bottomLeftY - getCellSize());
            case Side.RIGHT:
            moveToInField(bottomLeftX + getCellSize(), bottomLeftY);
            lineToInField(bottomLeftX + getCellSize(), bottomLeftY - getCellSize());
            case Side.TOP:
            moveToInField(bottomLeftX, bottomLeftY - getCellSize());
            lineToInField(bottomLeftX + getCellSize(), bottomLeftY - getCellSize());
            case Side.BOTTOM:
            moveToInField(bottomLeftX, bottomLeftY);
            lineToInField(bottomLeftX + getCellSize(), bottomLeftY);
        }
    }

    private function moveToInField(x:Float, y:Float) {
        x = Math.max(1, Math.min(x, width - 1));
        y = Math.max(1, Math.min(y, height - 1));
        graphics.moveTo(x, y);
    }

    private function lineToInField(x:Float, y:Float) {
        x = Math.max(1, Math.min(x, width - 1));
        y = Math.max(1, Math.min(y, height - 1));
        graphics.lineTo(x, y);
    }

    private function doRemove(i:Int, j:Int) {
        // todo
    }
}
