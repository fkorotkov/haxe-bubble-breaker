package org.haxe.bubble.field;
import nme.events.TouchEvent;
import nme.events.MouseEvent;
import nme.events.Event;
import org.haxe.bubble.RenderUtil;
import org.haxe.bubble.UIElement;
class Field extends UIElement {
    public var data:FieldData;

    public function new(n:Int) {
        super();
        data = new FieldData(n);
        addEventListener(MouseEvent.MOUSE_DOWN, clickHandler);
        addEventListener(TouchEvent.TOUCH_TAP, clickHandler);
    }

    public function getCellSize():Float {
        return width / data.cells.length;
    }

    private function clickHandler(event:MouseEvent) {
        var i = Math.floor(event.localX / getCellSize());
        var j = data.cells[i].length - 1 - Math.floor(event.localY / getCellSize());
        data.doClick(i, j);
        redraw();
    }

    public function clearField() {
        data.clearField();
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
        for (i in 0...data.cells.length) {
            for (j in 0...data.cells[i].length) {
                renderCell(i, j, data.cells[i][j]);
            }
        }

        if (data.selected) {
            data.searchInSelection(drawSelectionBorderCallback);
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

    private function drawSelectionBorderCallback(i:Int, j:Int, side:Side):Void {
        if (side == null) return;
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
}
