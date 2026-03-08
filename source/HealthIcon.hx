package;

import flixel.FlxSprite;
import flixel.math.FlxMath;

class HealthIcon extends FlxSprite
{
	static inline final ICON_SIZE:Int = 150;
	public var sprTracker:FlxSprite;

	static final CHAR_FRAMES:Map<String, Array<Int>> = [
		'bf'                          => [0, 1],
		'bf-christmas'                => [0, 1],
		'bf-pixel'                    => [2, 3],
		'bf-old'                      => [3, 4],
		'face'                        => [5, 6],
		'gf'                          => [7, 7],
		'gf-pixel'                    => [7, 7],
		'dave'                        => [8, 9],
		'dave-annoyed'                => [8, 9],
		'dave-splitathon'             => [8, 9],
		'dave-angey'                  => [10, 11],
		'dave-3d-standing-bruh-what'  => [28, 29],
		'dave-annoyed-3d'             => [38, 39],
		'dave-old'                    => [36, 37],
		'marcello-dave'               => [8, 9],
		'bambi'                       => [12, 13],
		'bambi-splitathon'            => [12, 13],
		'bambi-new'                   => [12, 13],
		'bambi-farmer-beta'           => [12, 13],
		'bambi-loser'                 => [13, 13],
		'bambi-stupid'                => [18, 19],
		'bambi-3d'                    => [20, 21],
		'bambi-unfair'                => [40, 41],
		'bambi-old'                   => [18, 19],
		'bambi-angey'                 => [24, 25],
		'bambi-bevel'                 => [30, 31],
		'tristan'                     => [14, 15],
		'tristan-golden'              => [22, 23],
		'tristan-beta'                => [34, 35],
		'the-duo'                     => [16, 17],
		'what-lmao'                   => [18, 19],
		'senpai'                      => [26, 27],
		'senpai-angry'                => [26, 27],
		'spirit'                      => [32, 33],
		'greenbi'                     => [42, 43],
		'greenbi-mad'                 => [42, 43],
		'tave'                        => [44, 45],
	];

	static final NO_ANTIALIAS:Array<String> = [
		'dave-angey',
		'dave-annoyed-3d',
		'bambi-3d',
		'senpai',
		'senpai-angry',
		'spirit',
		'bf-pixel',
		'gf-pixel',
		'bambi-unfair',
		'tave',
	];

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		loadGraphic(Paths.image('iconGrid'), true, ICON_SIZE, ICON_SIZE);

		for (name => frames in CHAR_FRAMES)
			animation.add(name, frames, 0, false, isPlayer);

		antialiasing = !NO_ANTIALIAS.contains(char);

		var anim = CHAR_FRAMES.exists(char) ? char : 'face';
		animation.play(anim);

		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		offset.set(
			Std.int(FlxMath.bound(width  - ICON_SIZE, 0)),
			Std.int(FlxMath.bound(height - ICON_SIZE, 0))
		);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}