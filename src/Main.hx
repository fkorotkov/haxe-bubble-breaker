package ;
import org.haxe.bubble.Game;
import nme.Lib;
using StringTools;
class Main {
    public static function main() {
        Lib.current.addChild(new Game());
    }
}
