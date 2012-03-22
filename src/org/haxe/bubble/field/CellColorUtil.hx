package org.haxe.bubble.field;
class CellColorUtil {
    public static function get(type:CellType):UInt {
        switch (type) {
            case CellType.BLUE:
            return 0x0000FF;
            case CellType.GREEN:
            return 0x00FF00;
            case CellType.PURPLE:
            return 0xFF00FF;
            case CellType.RED:
            return 0xFF0000;
            case CellType.YELLOW:
            return 0xFFFF00;
            case CellType.EMPTY:
            return 0xFFFFFF;
        }
    }
}
