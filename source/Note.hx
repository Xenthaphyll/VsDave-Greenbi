package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxRandom;

using StringTools;

class Note extends FlxSprite
{

	public static var swagWidth:Float = 160 * 0.7;

	public static inline var PURP_NOTE:Int = 0;
	public static inline var BLUE_NOTE:Int = 1;
	public static inline var GREEN_NOTE:Int = 2;
	public static inline var RED_NOTE:Int  = 3;

	private static final CHAOS_SONGS:Array<String> = ['cheating', 'unfairness'];

	private static final CHARS_3D:Array<String> = [
		'dave-angey', 'bambi-3d', 'dave-annoyed-3d',
		'dave-3d-standing-bruh-what', 'bambi-unfair'
	];

	private static final NOTE_ANIMS:Array<String>       = ['purpleScroll', 'blueScroll', 'greenScroll', 'redScroll'];
	private static final HOLD_END_ANIMS:Array<String>   = ['purpleholdend', 'blueholdend', 'greenholdend', 'redholdend'];
	private static final HOLD_PIECE_ANIMS:Array<String> = ['purplehold',    'bluehold',    'greenhold',    'redhold'];


	public var strumTime:Float     = 0;
	public var noteData:Int        = 0;
	public var sustainLength:Float = 0;
	public var noteScore:Float     = 1;
	public var rating:String       = "shit";
	public var LocalScrollSpeed:Float = 1;

	public var mustPress:Bool         = false;
	public var isSustainNote:Bool     = false;
	public var canBeHit:Bool          = false;
	public var tooLate:Bool           = false;
	public var wasGoodHit:Bool        = false;
	public var finishedGenerating:Bool = false;

	public var prevNote:Note;
	public var MyStrum:FlxSprite;


	private var _strumID:Int   = 0;
	private var _inPlayState:Bool = false;


	public function new(
		strumTime:Float,
		noteData:Int,
		?prevNote:Note,
		sustainNote:Bool   = false,
		mustHit:Bool       = true,
		noteStyle:String   = "normal"
	) {
		super();

		this.prevNote    = prevNote ?? this;
		this.isSustainNote = sustainNote;
		this.mustPress   = mustHit;
		this.noteData    = noteData;
		this.strumTime   = Math.max(0, strumTime + FlxG.save.data.offset);


		x += 94;
		y -= 2000;

		_loadGraphics(mustHit, noteStyle);
		_applyNoteData(noteStyle);
		_handleSpecialSongs(mustHit);
		_setupSustain();
	}



	private function _loadGraphics(mustHit:Bool, noteStyle:String):Void
	{
		final song   = PlayState.SONG;
		final is3D   =
			(CHARS_3D.contains(song.player2) && !mustHit) ||
			(CHARS_3D.contains(song.player1) && mustHit)  ||
			(PlayState.characteroverride == "dave-angey"  && mustHit) ||
			((CHARS_3D.contains(song.player1) || CHARS_3D.contains(song.player2)) &&
			 (strumTime / 50) % 20 > 10);

		final atlas:String = is3D ? 'NOTE_assets_3D' : _getAtlasForStyle(noteStyle);
		frames = Paths.getSparrowAtlas(atlas);


		animation.addByPrefix('purpleScroll', 'purple0');
		animation.addByPrefix('blueScroll',   'blue0');
		animation.addByPrefix('greenScroll',  'green0');
		animation.addByPrefix('redScroll',    'red0');


		animation.addByPrefix('purpleholdend', 'pruple end hold');
		animation.addByPrefix('blueholdend',   'blue hold end');
		animation.addByPrefix('greenholdend',  'green hold end');
		animation.addByPrefix('redholdend',    'red hold end');


		animation.addByPrefix('purplehold', 'purple hold piece');
		animation.addByPrefix('bluehold',   'blue hold piece');
		animation.addByPrefix('greenhold',  'green hold piece');
		animation.addByPrefix('redhold',    'red hold piece');

		setGraphicSize(Std.int(width * 0.7));
		updateHitbox();
		antialiasing = true;
	}

	private inline function _getAtlasForStyle(style:String):String
	{
		return switch (style)
		{
			case 'phone': 'NOTE_phone';
			default:      'NOTE_assets';
		}
	}

	private function _applyNoteData(noteStyle:String):Void
	{
		final isCheating = PlayState.SONG.song.toLowerCase() == 'cheating';

		final colRemap:Array<Int> = isCheating ? [3, 1, 0, 2] : [0, 1, 2, 3];

		_strumID = colRemap[noteData];
		x += swagWidth * _strumID;
		animation.play(NOTE_ANIMS[noteData]);

		if (isCheating)
		{
			flipY = (Math.round(Math.random()) == 0);
			flipX = (Math.round(Math.random()) == 1);
		}
	}

	private function _handleSpecialSongs(mustHit:Bool):Void
	{
		final songName = PlayState.SONG.song.toLowerCase();

		if (CHAOS_SONGS.contains(songName) && (FlxG.state is PlayState))
		{
			final state:PlayState = cast FlxG.state;
			_inPlayState = true;
			_attachToStrum(state, mustHit);
		}

		if (songName == 'unfairness')
		{
			final rng = new FlxRandom();
			LocalScrollSpeed = (rng.int(0, 120) == 1) ? 0.1 : rng.float(1, 3);
		}
	}

	private function _attachToStrum(state:PlayState, mustHit:Bool):Void
	{
		final group = mustHit ? state.playerStrums : state.dadStrums;
		group.forEach(function(spr:FlxSprite)
		{
			if (spr.ID == _strumID)
			{
				x = spr.x;
				MyStrum = spr;
			}
		});
	}

	private function _setupSustain():Void
	{
		if (!isSustainNote) return;

		noteScore *= 0.2;

		if (FlxG.save.data.downscroll)
			flipY = true;

		x += width / 2;
		animation.play(HOLD_END_ANIMS[noteData]);
		updateHitbox();
		x -= width / 2;

		if (PlayState.curStage.startsWith('school'))
			x += 30;

		if (prevNote != null && prevNote.isSustainNote)
		{
			prevNote.animation.play(HOLD_PIECE_ANIMS[prevNote.noteData]);
			prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.8 * PlayState.SONG.speed;
			prevNote.updateHitbox();
		}
	}


	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		_updateStrumX();
		_updateHitWindow();
	}

	private function _updateStrumX():Void
	{
		if (MyStrum != null)
		{
			x = MyStrum.x + (isSustainNote ? width : 0);
			return;
		}

		if (!_inPlayState) return;

		final state:PlayState = cast FlxG.state;
		final group = mustPress ? state.playerStrums : state.dadStrums;

		group.forEach(function(spr:FlxSprite)
		{
			if (spr.ID == _strumID)
			{
				x = spr.x;
				MyStrum = spr;
			}
		});
	}

	private function _updateHitWindow():Void
	{
		if (!mustPress)
		{
			canBeHit = false;
			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
			return;
		}

		final pos    = Conductor.songPosition;
		final safe   = Conductor.safeZoneOffset;

		canBeHit = strumTime > pos - safe && strumTime < pos + (safe * 0.5);

		if (!wasGoodHit && strumTime < pos - safe)
			tooLate = true;

		if (tooLate && alpha > 0.3)
			alpha = 0.3;
	}
}
