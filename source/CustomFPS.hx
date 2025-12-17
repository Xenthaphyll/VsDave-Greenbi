package;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.Font;

#if sys
import sys.io.Process;
import StringTools;
#end

@:font("assets/fonts/comic.ttf")
class ComicSansFont extends Font {}

class CustomFPS extends TextField {
	var lastTime:Float = 0;
	var frameCount:Int = 0;
	var elapsedTime:Float = 0;

	var staticInfo:String = "";

	public function new() {
		super();

		Font.registerFont(ComicSansFont);
		var fontInstance = new ComicSansFont();

		var format = new TextFormat();
		format.font = fontInstance.fontName;
		format.size = 12;
		format.color = 0x11FF00;

		defaultTextFormat = format;
		embedFonts = true;
		selectable = false;

		x = 10;
		y = 3;
		width = 600;
		height = 140;

		staticInfo = buildSystemInfo();
		text = "FPS: 0\n" + staticInfo;

		lastTime = Lib.getTimer();
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	function onEnterFrame(e:Event):Void {
		var now = Lib.getTimer();
		var delta = now - lastTime;
		lastTime = now;

		elapsedTime += delta;
		frameCount++;

		if (elapsedTime >= 100) {
			var fps = Math.round((frameCount * 1000) / elapsedTime);
			text = "FPS: " + fps + "\n" + staticInfo;
			frameCount = 0;
			elapsedTime = 0;
		}
	}

	#if sys
	function buildSystemInfo():String {
		var user = getCmd(
			#if windows
				"cmd", ["/c", "echo %USERNAME%"]
			#else
				"whoami", []
			#end
		);

		var kernel = getCmd(
			#if windows
				"cmd", ["/c", "ver"]
			#else
				"uname", ["-r"]
			#end
		);

		var cpu = getCmd(
			#if windows
				"wmic", ["cpu", "get", "name"]
			#else
				"sh", ["-c", "cat /proc/cpuinfo | grep 'model name' | head -1 | cut -d ':' -f2"]
			#end
		);

		return
			"User: " + user + "\n" +
			"Kernel: " + kernel + "\n" +
			"CPU: " + cpu;
	}

	function getCmd(cmd:String, args:Array<String>):String {
		var p = new Process(cmd, args);
		var out = p.stdout.readAll().toString();
		p.close();
		return StringTools.trim(out);
	}
	#else
	function buildSystemInfo():String {
		return "system info unavailable";
	}
	#end
}
