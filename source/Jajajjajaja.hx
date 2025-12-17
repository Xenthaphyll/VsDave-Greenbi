import sys.io.Process;
import StringTools;

class Jajajjajaja { // stupid name because we're charlie kirk
    public static function getUsername():String {
        #if windows
            return getWindowsUser();
        #else
            return getUnixUser();
        #end
    }

    static function getUnixUser():String {
        var p = new Process("whoami", []);
        var out = p.stdout.readAll().toString();
        p.close();
        return StringTools.trim(out);
    }

    static function getWindowsUser():String {
        var p = new Process("cmd", ["/c", "echo %USERNAME%"]);
        var out = p.stdout.readAll().toString();
        p.close();
        return StringTools.trim(out);
    }
}
