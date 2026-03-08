package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
#if desktop
import Discord.DiscordClient;
#end

typedef OptionEntry =
{
	var getLabel:Void->String;

	var onToggle:Void->Void;
}

class OptionsMenu extends MusicBeatState
{
	static inline var ITEM_SPACING:Float  = 80;
	static inline var ITEM_START_Y:Float  = 60;
	static inline var ALPHA_IDLE:Float    = 0.40;
	static inline var ALPHA_SELECTED:Float = 1.0;

	var curSelected:Int = 0;
	var options:Array<OptionEntry>;

	var grpControls:FlxTypedGroup<Alphabet>;
	var selectorBar:FlxSprite;
	var offsetText:FlxText;
	var titleText:FlxText;

	override function create():Void
	{
		super.create();

		#if desktop
		DiscordClient.changePresence("In the Options Menu", null);
		#end

		buildOptions();
		buildUI();
		changeSelection(0);
	}

	function buildOptions():Void
	{
		options = [
			{
				getLabel: () -> 'Controls: ' + (FlxG.save.data.dfjk ? 'DFJK' : 'WASD'),
				onToggle: () ->
				{
					FlxG.save.data.dfjk = !FlxG.save.data.dfjk;
					controls.setKeyboardScheme(
						FlxG.save.data.dfjk ? KeyboardScheme.Solo : KeyboardScheme.Duo(true),
						true
					);
				}
			},
			{
				getLabel: () -> 'Ghost Tapping: ' + boolLabel(FlxG.save.data.newInput),
				onToggle: () -> FlxG.save.data.newInput = !FlxG.save.data.newInput
			},
			{
				getLabel: () -> (FlxG.save.data.downscroll ? 'Downscroll' : 'Upscroll'),
				onToggle: () -> FlxG.save.data.downscroll = !FlxG.save.data.downscroll
			},
			{
				getLabel: () -> 'Accuracy Display: ' + boolLabel(FlxG.save.data.accuracyDisplay),
				onToggle: () -> FlxG.save.data.accuracyDisplay = !FlxG.save.data.accuracyDisplay
			},
			{
				getLabel: () -> 'Eyesores: '   + boolLabel(FlxG.save.data.eyesores),
				onToggle: () -> FlxG.save.data.eyesores = !FlxG.save.data.eyesores
			},
			{
				getLabel: () -> 'Hitsounds: '  + boolLabel(FlxG.save.data.donoteclick),
				onToggle: () -> FlxG.save.data.donoteclick = !FlxG.save.data.donoteclick
			},
			{
				getLabel: () -> 'Freeplay Cutscenes: ' + boolLabel(FlxG.save.data.freeplayCuts),
				onToggle: () -> FlxG.save.data.freeplayCuts = !FlxG.save.data.freeplayCuts
			}
		];
	}

	function buildUI():Void
	{
		var bg:FlxSprite = new FlxSprite().loadGraphic(MainMenuState.randomizeBG());
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		var overlay:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xBB000000);
		overlay.scrollFactor.set();
		add(overlay);

		titleText = new FlxText(0, 14, FlxG.width, "OPTIONS", 52);
		titleText.setFormat("VCR OSD Mono", 52, FlxColor.WHITE, CENTER,
		                    FlxTextBorderStyle.OUTLINE, 0xFF222222);
		titleText.scrollFactor.set();
		titleText.alpha = 0;
		add(titleText);
		FlxTween.tween(titleText, {alpha: 1, y: 20}, 0.45, {ease: FlxEase.quartOut});

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...options.length)
		{
			var label:Alphabet = new Alphabet(0, (ITEM_SPACING * i) + ITEM_START_Y,
			                                  options[i].getLabel(), true, false);
			label.screenCenter(X);
			label.itemType   = 'Vertical';
			label.isMenuItem = true;
			label.targetY    = i;
			label.alpha      = ALPHA_IDLE;
			grpControls.add(label);
		}

		var hintBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xDD000000);
		hintBG.scrollFactor.set();
		add(hintBG);

		offsetText = new FlxText(8, FlxG.height - 21, 0, buildOffsetString(), 12);
		offsetText.scrollFactor.set();
		offsetText.setFormat("VCR OSD Mono", 12, FlxColor.WHITE, LEFT);
		add(offsetText);
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (controls.BACK)
		{
			FlxG.save.flush();
			FlxG.switchState(new MainMenuState());
			return;
		}

		if (controls.UP_P)   changeSelection(-1);
		if (controls.DOWN_P) changeSelection(1);

		if (controls.RIGHT_R) adjustOffset(1);
		if (controls.LEFT_R)  adjustOffset(-1);

		if (controls.ACCEPT)  toggleCurrentOption();
	}

	function changeSelection(delta:Int):Void
	{
		if (delta != 0)
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected = FlxMath.wrap(curSelected + delta, 0, grpControls.length - 1);

		var i:Int = 0;
		for (item in grpControls.members)
		{
			item.targetY = i - curSelected;
			item.alpha   = (item.targetY == 0) ? ALPHA_SELECTED : ALPHA_IDLE;
			i++;
		}
	}

	function toggleCurrentOption():Void
	{
		var opt:OptionEntry = options[curSelected];
		opt.onToggle();
		refreshLabel(curSelected);

		FlxG.camera.flash(0x44FFFFFF, 0.12);
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.55);
	}

	function refreshLabel(index:Int):Void
	{
		var old:Alphabet = grpControls.members[index];
		if (old == null) return;

		var fresh:Alphabet = new Alphabet(0, 0, options[index].getLabel(), true, false);
		fresh.screenCenter(X);
		fresh.itemType   = 'Vertical';
		fresh.isMenuItem = true;
		fresh.targetY    = old.targetY;
		fresh.alpha      = old.alpha;

		grpControls.remove(old, true);
		grpControls.insert(index, fresh);
	}

	function adjustOffset(delta:Int):Void
	{
		FlxG.save.data.offset += delta;
		offsetText.text = buildOffsetString();
	}

	override function beatHit():Void
	{
		super.beatHit();
		FlxTween.tween(FlxG.camera, {zoom: 1.04}, 0.25,
		               {ease: FlxEase.quadOut, type: BACKWARD});
	}

	static inline function boolLabel(v:Bool):String
		return v ? 'ON' : 'OFF';

	function buildOffsetString():String
		return 'Note Offset: ${FlxG.save.data.offset} ms   [ ← / → to adjust ]   [ ENTER to toggle ]   [ ESC back ]';
}
