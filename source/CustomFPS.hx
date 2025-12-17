package;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.Font;

@:font("assets/fonts/comic.ttf") class ComicSansFont extends Font {}

class CustomFPS extends TextField {
	var lastTime:Float = 0;
	var frameCount:Int = 0;
	var elapsedTime:Float = 0;

	public function new() {
		super();

		Font.registerFont(ComicSansFont);
		var fontInstance = new ComicSansFont();

		var format = new TextFormat();
		format.font = fontInstance.fontName;
		format.size = 16;
		format.color = 0x11FF00;

		defaultTextFormat = format;
		embedFonts = true;
		selectable = false;

		x = 10;
		y = 3;
		width = 150;
		height = 30;
		text = "FPS: 0";

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
			text = "FPS: " + fps;
			frameCount = 0;
			elapsedTime = 0;
		}
	}
}
