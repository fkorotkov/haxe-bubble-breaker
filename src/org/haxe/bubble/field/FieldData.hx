package org.haxe.bubble.field;
import haxe.remoting.DelayedConnection;
import nme.utils.Timer;
import org.haxe.bubble.events.ScoreEvent;
import nme.events.EventDispatcher;
class FieldData extends EventDispatcher {
    private var colors:Array<CellType>;
    private var selectedIndex:Array<Int>;
    public var cells:Array<Array<CellType>>;
    public var selected:Bool;

    public function new(n:Int) {
        super();
        colors = [CellType.BLUE, CellType.GREEN, CellType.PURPLE, CellType.RED, CellType.YELLOW];
        selected = false;
        refill(n, n);
    }

    public function doClick(i:Int, j:Int) {
        if (!checkRange(i, j)) return;
        if (selected) {
            var needRemove = false;
            searchInSelection(function(curI:Int, curJ:Int, side:Side):Void {
                if (i == curI && j == curJ) {
                    needRemove = true;
                }
            });
            if (needRemove) {
                doRemove();
            }
        }
        selected = !selected;
        selectedIndex = selected ? [i, j] : [-1, -1];
        var score = 0;
        searchInSelection(function(curI:Int, curJ:Int, side:Side):Void {
            if (side == null) ++score;
        });
        dispatchEvent(new ScoreEvent(score * (score - 1), true));
        if (score <= 1) {
            selected = false;
            selectedIndex = [-1, -1];
        }
    }

    public function clearField() {
        refill(cells.length, cells[0].length);
    }

    function refill(n:Int, m:Int) {
        cells = new Array<Array<CellType>>();
        for (i in 0...n) {
            var row = new Array<CellType>();
            for (j in 0...m) {
                row.push(colors[Math.floor(Math.random() * colors.length)]);
            }
            cells.push(row);
        }
    }

    public function searchInSelection(processor:Int -> Int -> Side -> Void):Void {
        if (!selected) {
            return;
        }
        var mark:Array<Array<Bool>> = new Array<Array<Bool>>();
        for (i in 0...cells.length) {
            var row = new Array<Bool>();
            for (j in 0...cells[i].length) {
                row.push(false);
            }
            mark.push(row);
        }
        var type = cells[selectedIndex[0]][selectedIndex[1]];
        var q = [selectedIndex];
        while (q.length > 0) {
            var i = q[0][0];
            var j = q[0][1];
            q.shift();
            if (mark[i][j]) continue;
            mark[i][j] = true;
            processor(i, j, null);

            if (canMove(i, j - 1, type)) {
                q.push([i, j - 1]);
            } else {
                processor(i, j, Side.BOTTOM);
            }
            if (canMove(i - 1, j, type)) {
                q.push([i - 1, j]);
            } else {
                processor(i, j, Side.LEFT);
            }
            if (canMove(i, j + 1, type)) {
                q.push([i, j + 1]);
            } else {
                processor(i, j, Side.TOP);
            }
            if (canMove(i + 1, j, type)) {
                q.push([i + 1, j]);
            } else {
                processor(i, j, Side.RIGHT);
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

    function doRemove() {
        var score = 0;
        searchInSelection(function(curI:Int, curJ:Int, side:Side):Void {
            if (side == null) ++score;
            cells[curI][curJ] = CellType.EMPTY;
        });
        dispatchEvent(new ScoreEvent(score * (score - 1), false));
        adjustField();
    }

    function adjustField() {
        for (i in 0...cells.length) {
            var j = 0;
            for (k in 0...cells[i].length) {
                if (cells[i][k] == CellType.EMPTY) continue;
                var tmp = cells[i][k];
                cells[i][k] = CellType.EMPTY;
                cells[i][j] = tmp;
                ++j;
            }
        }
        var i = cells.length - 1;
        while (i >= 0) {
            if (!isEmpty(cells[i]) || i == 0) {
                --i;
                continue;
            }
            for (j in 0...cells[i].length) {
                cells[i][j] = cells[i - 1][j];
                cells[i - 1][j] = CellType.EMPTY;
            }
            --i;
        }
    }

    function isEmpty(column:Array<CellType>) {
        for (type in column) {
            if (type != CellType.EMPTY) return false;
        }
        return true;
    }
}
