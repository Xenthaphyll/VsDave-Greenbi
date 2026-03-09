package;

import flixel.tweens.misc.ColorTween;
import flixel.math.FlxRandom;
import openfl.net.FileFilter;
import openfl.filters.BitmapFilter;
import Shaders.PulseEffect;
import Section.SwagSection;
import Song.SwagSong;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import flash.system.System;
import lime.app.Application;
#if desktop
import Discord.DiscordClient;
#end
#if sys
import sys.io.File;
import sys.io.Process;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var curStage:String = '';
	public static var characteroverride:String = "none";
	public static var formoverride:String = "none";
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	public var darkLevels:Array<String> = ['bambiFarmNight', 'daveHouse_night', 'unfairness'];
	public var sunsetLevels:Array<String> = ['bambiFarmSunset', 'daveHouse_Sunset'];

	var howManyPlayerNotes:Int = 0;
	var howManyEnemyNotes:Int = 0;

	public var stupidx:Float = 0;
	public var stupidy:Float = 0;
	public var songPercent:Float = 0;
	public var updatevels:Bool = false;

	public var hasTriggeredDumbshit:Bool = false;
	var AUGHHHH:String;
	var AHHHHH:String;

	public static var curmult:Array<Float> = [1, 1, 1, 1];

	public var curbg:FlxSprite;
	public static var screenshader:Shaders.PulseEffect = new PulseEffect();
	public var UsingNewCam:Bool = false;

	public var elapsedtime:Float = 0;

	var focusOnDadGlobal:Bool = true;

	var funnyFloatyBoys:Array<String> = [
		'dave-angey', 'bambi-3d', 'dave-annoyed-3d', 'dave-3d-standing-bruh-what', 'bambi-unfair', 'greenbi'
	];

	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";

	var boyfriendOldIcon:String = 'bf-old';

	private var vocals:FlxSound;

	private var dad:Character;
	private var dadmirror:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var daveExpressionSplitathon:Character;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;
	private var camFollowTween:FlxTween;
	private var lastFocusOnDad:Bool = true;
	private var camFollowTargetX:Float = 0;
	private var camFollowTargetY:Float = 0;

	public var sunsetColor:FlxColor = FlxColor.fromRGB(255, 143, 178);

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;

	public var playerStrums:FlxTypedGroup<FlxSprite>;
	public var dadStrums:FlxTypedGroup<FlxSprite>;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;

	public static var misses:Int = 0;

	private var accuracy:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;

	public static var eyesoreson:Bool = true;

	private var STUPDVARIABLETHATSHOULDNTBENEEDED:FlxSprite;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	private var timeBar:FlxBar;
	private var timeBarBG:FlxSprite;

	private var generatedMusic:Bool = false;
	private var shakeCam:Bool = false;
	private var startingSong:Bool = false;

	public var TwentySixKey:Bool = false;

	public static var amogus:Int = 0;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var BAMBICUTSCENEICONHURHURHUR:HealthIcon;
	private var camDialogue:FlxCamera;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;
	private var timeTxt:FlxText;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var notestuffs:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
	var fc:Bool = true;

	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var scoreTxt:FlxText;

	var GFScared:Bool = false;

	var scaryBG:FlxSprite;
	var showScary:Bool = false;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;

	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;

	public static var warningNeverDone:Bool = false;

	public var thing:FlxSprite = new FlxSprite(0, 250);
	public var splitathonExpressionAdded:Bool = false;

	var camX:Int = 0;
	var camY:Int = 0;
	var cameramove:Bool = FlxG.save.data.cammove;
	var tailscircle:String = '';

	public var backgroundSprites:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	var normalDaveBG:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	var canFloat:Bool = true;

	var nightColor:FlxColor = 0xFF878787;
	var spinCam:Bool = false;
	var resetCam:Bool = false;
	var username:String = Sys.getEnv("USERNAME");

	override public function create()
	{
		theFunne = FlxG.save.data.newInput;
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		eyesoreson = FlxG.save.data.eyesores;

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;
		misses = 0;

		storyDifficultyText = CoolUtil.difficultyString();

		switch (SONG.player2)
		{
			case 'dave' | 'dave-old' | 'dave-angey':
				iconRPC = 'icon_dave';
			case 'bambi-new' | 'bambi-angey' | 'bambi' | 'bambi-old' | 'bambi-bevel' | 'what-lmao' | 'bambi-farmer-beta' | 'bambi-3d' | 'bambi-unfair':
				iconRPC = 'icon_bambi';
			default:
				iconRPC = 'icon_none';
		}
		switch (SONG.song.toLowerCase())
		{
			case 'splitathon':
				iconRPC = 'icon_both';
		}

		detailsText = isStoryMode ? "Story Mode: Week " + storyWeek : "Freeplay Mode: ";
		detailsPausedText = "Paused - " + detailsText;

		curStage = "";

		#if desktop
		DiscordClient.changePresence(
			detailsText + " " + SONG.song + " (" + storyDifficultyText + ") ",
			"\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses,
			iconRPC
		);
		#end

		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camDialogue = new FlxCamera();
		camDialogue.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camDialogue);

        // offset
        final xenthicPuto:Int = 400;

        // extends the camera to get rid of goofy angle
		FlxG.camera.setSize(FlxG.width + Std.int(xenthicPuto), FlxG.height + Std.int(xenthicPuto));
		FlxG.camera.setPosition(-xenthicPuto / 2, -xenthicPuto / 2);

		FlxCamera.defaultCameras = [camGame];
		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		theFunne = theFunne && SONG.song.toLowerCase() != 'unfairness';

		switch (SONG.song.toLowerCase())
		{
			case 'tutorial':
				dialogue = [":gf:Hey, you're pretty cute.", ':gf:Use the arrow keys to keep up \nwith me singing.'];
			case 'house' | 'old-house':
				dialogue = CoolUtil.coolTextFile(Paths.txt('house/houseDialogue'));
			case 'insanity' | 'old-insanity':
				dialogue = CoolUtil.coolTextFile(Paths.txt('insanity/insanityDialogue'));
			case 'furiosity':
				dialogue = CoolUtil.coolTextFile(Paths.txt('furiosity/furiosityDialogue'));
			case 'polygonized':
				dialogue = CoolUtil.coolTextFile(Paths.txt('polygonized/polyDialogue'));
			case 'supernovae':
				dialogue = CoolUtil.coolTextFile(Paths.txt('supernovae/supernovaeDialogue'));
			case 'glitch':
				dialogue = CoolUtil.coolTextFile(Paths.txt('glitch/glitchDialogue'));
			case 'blocked' | 'old-blocked':
				dialogue = CoolUtil.coolTextFile(Paths.txt('blocked/retardedDialogue'));
			case 'corn-theft' | 'old-corn-theft':
				dialogue = CoolUtil.coolTextFile(Paths.txt('corn-theft/cornDialogue'));
			case 'cheating':
				dialogue = CoolUtil.coolTextFile(Paths.txt('cheating/cheaterDialogue'));
			case 'unfairness':
				dialogue = CoolUtil.coolTextFile(Paths.txt('unfairness/unfairDialogue'));
			case 'maze' | 'old-maze' | 'beta-maze':
				dialogue = CoolUtil.coolTextFile(Paths.txt('maze/mazeDialogue'));
			case 'splitathon' | 'old-splitathon':
				dialogue = CoolUtil.coolTextFile(Paths.txt('splitathon/splitathonDialogue'));
			case 'vs-dave-thanksgiving':
				dialogue = CoolUtil.coolTextFile(Paths.txt('vs-dave-thanksgiving/lmaoDialogue'));
			case 'tynmmmm':
				dialogue = CoolUtil.coolTextFile(Paths.txt('tynmmmm/greenbiDialogue'));
		}

		var stageCheck:String = 'stage';

		if (SONG.stage == null)
		{
			switch (SONG.song.toLowerCase())
			{
				case 'house' | 'insanity' | 'old-insanity' | 'supernovae' | 'old-house':
					stageCheck = 'house';
				case 'polygonized' | 'furiosity':
					stageCheck = 'red-void';
				case 'blocked' | 'corn-theft' | 'old-corn-theft' | 'old-maze' | 'beta-maze':
					stageCheck = 'farm';
				case 'maze':
					stageCheck = 'farm-sunset';
				case 'splitathon' | 'mealie' | 'old-splitathon':
					stageCheck = 'farm-night';
				case 'cheating':
					stageCheck = 'green-void';
				case 'unfairness':
					stageCheck = 'glitchy-void';
				case 'bonus-song' | 'glitch' | 'old-blocked':
					stageCheck = 'house-night';
				case 'secret' | 'vs-dave-thanksgiving':
					stageCheck = 'house-sunset';
				case 'tutorial':
					stageCheck = 'stage';
			}
		}
		else
		{
			stageCheck = SONG.stage;
		}

		backgroundSprites = createBackgroundSprites(stageCheck);

		if (SONG.song.toLowerCase() == 'polygonized' || SONG.song.toLowerCase() == 'furiosity')
		{
			normalDaveBG = createBackgroundSprites('house-night');
			for (bgSprite in normalDaveBG)
				bgSprite.alpha = 0;
		}

		var gfVersion:String = SONG.gf != null ? SONG.gf : 'gf';

		screenshader.waveAmplitude = 1;
		screenshader.waveFrequency = 2;
		screenshader.waveSpeed = 1;
		screenshader.shader.uTime.value[0] = new FlxRandom().float(-100000, 100000);

		var charoffsetx:Float = 0;
		var charoffsety:Float = 0;

		if (formoverride == "bf-pixel"
			&& (SONG.song != "Tutorial" && SONG.song != "Roses" && SONG.song != "Thorns" && SONG.song != "Senpai"))
		{
			gfVersion = 'gf-pixel';
			charoffsetx += 300;
			charoffsety += 300;
		}
		if (formoverride == "bf-christmas")
			gfVersion = 'gf-christmas';

		gf = new Character(400 + charoffsetx, 130 + charoffsety, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		if (!(formoverride == "bf" || formoverride == "none" || formoverride == "bf-pixel" || formoverride == "bf-christmas")
			&& SONG.song != "Tutorial")
		{
			gf.visible = false;
		}
		else if (FlxG.save.data.tristanProgress == "pending play" && isStoryMode)
		{
			gf.visible = false;
		}

		dad = new Character(100, 100, SONG.player2);
		dadmirror = new Character(100, 100, "dave-angey");

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}
			case "tristan" | 'tristan-beta' | 'tristan-golden':
				dad.y += 325;
				dad.x += 100;
			case 'dave' | 'dave-annoyed' | 'dave-splitathon':
				dad.y += 160;
				dad.x += 250;
			case 'dave-old':
				dad.y += 270;
				dad.x += 150;
			case 'dave-angey' | 'dave-annoyed-3d' | 'dave-3d-standing-bruh-what':
				dad.x += 150;
				camPos.set(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y + 150);
			case 'bambi-3d':
				dad.y += 35;
				camPos.set(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y + 150);
			case 'bambi-unfair':
				dad.y += 90;
				camPos.set(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y + 50);
			case 'bambi' | 'bambi-old' | 'bambi-bevel' | 'what-lmao':
				dad.y += 400;
			case 'bambi-new' | 'bambi-farmer-beta' | 'greenbi':
				dad.y += 450;
				dad.x += 200;
			case 'bambi-splitathon':
				dad.x += 175;
				dad.y += 400;
			case 'bambi-angey':
				dad.y += 450;
				dad.x += 100;
			case 'tave':
				dad.y += 160;
				dad.x += 180;
		}

		dadmirror.x += 150;
		dadmirror.visible = false;

		boyfriend = new Boyfriend(770, 450, (formoverride == "none" || formoverride == "bf") ? SONG.player1 : formoverride);

		switch (boyfriend.curCharacter)
		{
			case "tristan" | 'tristan-beta' | 'tristan-golden':
				boyfriend.y = 100 + 325;
				boyfriendOldIcon = 'tristan-beta';
			case 'dave' | 'dave-annoyed' | 'dave-splitathon':
				boyfriend.y = 100 + 160;
				boyfriendOldIcon = 'dave-old';
			case 'dave-old':
				boyfriend.y = 100 + 270;
				boyfriendOldIcon = 'dave';
			case 'dave-angey' | 'dave-annoyed-3d' | 'dave-3d-standing-bruh-what':
				boyfriend.y = 100;
				switch (boyfriend.curCharacter)
				{
					case 'dave-angey':
						boyfriendOldIcon = 'dave-annoyed-3d';
					case 'dave-annoyed-3d':
						boyfriendOldIcon = 'dave-3d-standing-bruh-what';
					case 'dave-3d-standing-bruh-what':
						boyfriendOldIcon = 'dave-old';
				}
			case 'bambi-3d':
				boyfriend.y = 100 + 350;
				boyfriendOldIcon = 'bambi-old';
			case 'bambi-unfair':
				boyfriend.y = 100 + 575;
				boyfriendOldIcon = 'bambi-old';
			case 'bambi' | 'bambi-old' | 'bambi-bevel' | 'what-lmao':
				boyfriend.y = 100 + 400;
				boyfriendOldIcon = 'bambi-old';
			case 'bambi-new' | 'bambi-farmer-beta':
				boyfriend.y = 100 + 450;
				boyfriendOldIcon = 'bambi-old';
			case 'bambi-splitathon':
				boyfriend.y = 100 + 400;
				boyfriendOldIcon = 'bambi-old';
			case 'bambi-angey':
				boyfriend.y = 100 + 450;
				boyfriendOldIcon = 'bambi-old';
		}

		if (darkLevels.contains(curStage) && SONG.song.toLowerCase() != "polygonized")
		{
			dad.color = nightColor;
			gf.color = nightColor;
			boyfriend.color = nightColor;
		}

		if (sunsetLevels.contains(curStage))
		{
			dad.color = sunsetColor;
			gf.color = sunsetColor;
			boyfriend.color = sunsetColor;
		}

		add(gf);
		add(dad);
		add(dadmirror);
		add(boyfriend);

		if (SONG.song.toLowerCase() == "unfairness")
			health = 2;

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();

		if (FlxG.save.data.downscroll || SONG.song.toLowerCase() == "unfairness")
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		dadStrums = new FlxTypedGroup<FlxSprite>();

		generateSong(SONG.song);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 1);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());
		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll || SONG.song.toLowerCase() == "unfairness")
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT,
			Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this, 'health', 0, 2);
		healthBar.scrollFactor.set();

		timeBarBG = new FlxSprite(0, 15).makeGraphic(FlxG.width - 200, 20, FlxColor.BLACK);
		timeBarBG.screenCenter(X);
		timeBarBG.scrollFactor.set();
		timeBarBG.cameras = [camHUD];
		add(timeBarBG);

		timeBar = new FlxBar(timeBarBG.x + 2, timeBarBG.y + 2, LEFT_TO_RIGHT,
			Std.int(timeBarBG.width - 4), Std.int(timeBarBG.height - 4),
			this, 'songPercent', 0, 1);
		timeBar.createFilledBar(0xFF000000, 0xFF3CFF00);
		timeBar.scrollFactor.set();
		timeBar.cameras = [camHUD];
		add(timeBar);

		timeTxt = new FlxText(0, timeBarBG.y + 25, 0, "0:00 / 0:00", 16);
		timeTxt.setFormat(Paths.font("comic.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.scrollFactor.set();
		timeTxt.borderSize = 1.25;
		timeTxt.cameras = [camHUD];
		add(timeTxt);
		timeTxt.alpha = 0;

		if (SONG.player2 == "tave")
			healthBar.createFilledBar(0xFFFF0000, 0xFF31B0D1);
		else
			healthBar.createFilledBar(0xFF31B0D1, 0xFF00FF3C);

		add(healthBar);

		var credits:String;
		switch (SONG.song.toLowerCase())
		{
			case 'supernovae':
				credits = 'Original Song made by ArchWk!';
			case 'glitch':
				credits = 'Original Song made by DeadShadow and PixelGH!';
			case 'mealie':
				credits = 'Original Song made by Alexander Cooper 19!';
			case 'unfairness':
				credits = "Ghost tapping is forced off! Screw you!";
			case 'cheating':
				credits = 'Screw you!';
			case 'vs-dave-thanksgiving':
				credits = 'What the hell!';
			case 'tynmmmm':
			credits = 'Greenbi';
			case 'its-tave-time':
				credits = "It's Tave time!";
			default:
				credits = '';
		}

		var creditsText:Bool = credits != '';
		var textYPos:Float = creditsText ? healthBarBG.y + 30 : healthBarBG.y + 50;

		var diffLabel:String = !curSong.toLowerCase().endsWith('splitathon')
			? (storyDifficulty == 3 ? "Legacy" : storyDifficulty == 2 ? "Hard" : storyDifficulty == 1 ? "Normal" : "Easy")
			: "Finale";

		var kadeEngineWatermark = new FlxText(4, textYPos, 0,
			SONG.song + " " + diffLabel + " - Greenbi Engine (KE 1.2)", 16);
		kadeEngineWatermark.setFormat(Paths.font("comic.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		kadeEngineWatermark.borderSize = 1.25;
		add(kadeEngineWatermark);

		if (creditsText)
		{
			var creditsWatermark = new FlxText(4, healthBarBG.y + 50, 0, credits, 16);
			creditsWatermark.setFormat(Paths.font("comic.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			creditsWatermark.scrollFactor.set();
			creditsWatermark.borderSize = 1.25;
			add(creditsWatermark);
			creditsWatermark.cameras = [camHUD];
		}

		switch (curSong.toLowerCase())
		{
			case 'splitathon' | 'old-splitathon':
				preload('splitathon/Bambi_WaitWhatNow');
				preload('splitathon/Bambi_ChillingWithTheCorn');
			case 'insanity':
				preload('dave/redsky');
				preload('dave/redsky_insanity');
		}

			scoreTxt = new FlxText(450, 685, 0, "", 20);

			scoreTxt.setFormat(Paths.font("comic.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			scoreTxt.scrollFactor.set();
			scoreTxt.borderSize = 1.5;

		iconP1 = new HealthIcon((formoverride == "none" || formoverride == "bf") ? SONG.player1 : formoverride, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2 == "bambi" ? "bambi-stupid" : SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		add(scoreTxt); 

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		kadeEngineWatermark.cameras = [camHUD];
		doof.cameras = [camDialogue];

		startingSong = true;

		if (isStoryMode || FlxG.save.data.freeplayCuts)
		{
			switch (curSong.toLowerCase())
			{
				case 'house' | 'insanity' | 'furiosity' | 'polygonized' | 'supernovae' | 'glitch'
					| 'blocked' | 'corn-theft' | 'maze' | 'splitathon' | 'cheating' | 'unfairness':
					schoolIntro(doof);
				default:
					startCountdown();
			}
		}
		else
		{
			startCountdown();
		}

		super.create();
	}

	function createBackgroundSprites(bgName:String):FlxTypedGroup<FlxSprite>
	{
		var sprites:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();

		switch (bgName)
		{
			case 'tave-field':
				defaultCamZoom = 0.65;
				var bgsky:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('tave/sky'));
				bgsky.scrollFactor.set(0.2, 0.2);
				var bg:FlxSprite = new FlxSprite(200, 600).loadGraphic(Paths.image('tave/grass'));
				bg.setGraphicSize(Std.int(bg.width * 2));
				bg.updateHitbox();
				var bg1:FlxSprite = new FlxSprite(200 - bg.width, 600).loadGraphic(Paths.image('tave/grass'));
				bg1.setGraphicSize(Std.int(bg1.width * 2));
				bg1.updateHitbox();
				var bg2:FlxSprite = new FlxSprite(200 + bg.width, 600).loadGraphic(Paths.image('tave/grass'));
				bg2.setGraphicSize(Std.int(bg2.width * 2));
				bg2.updateHitbox();
				add(bgsky);
				add(bg1);
				add(bg);
				add(bg2);
				var testshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
				testshader.waveAmplitude = 0.008;
				testshader.waveFrequency = 80;
				testshader.waveSpeed = 1.5;
				bgsky.shader = testshader.shader;
				curbg = bgsky;

			case 'greenbi-world':
				defaultCamZoom = 0.8;
				var bg:FlxSprite = new FlxSprite(-500, -720).loadGraphic(Paths.image('greenbi/greenbi1'));
				bg.scrollFactor.set(0, 0);
				add(bg);
				var testshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
				testshader.waveAmplitude = 0.02;
				testshader.waveFrequency = 15;
				testshader.waveSpeed = 1.5;
				bg.shader = testshader.shader;
				curbg = bg;

			case 'greenbi-world2':
				defaultCamZoom = 0.8;
				var bg:FlxSprite = new FlxSprite(-500, -720).loadGraphic(Paths.image('greenbi/greenbi2'));
				bg.scrollFactor.set(0, 0);
				add(bg);
				var testshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
				testshader.waveAmplitude = 0.1;
				testshader.waveFrequency = 5;
				testshader.waveSpeed = 2;
				bg.shader = testshader.shader;
				curbg = bg;

			case 'greenbi-world3':
				defaultCamZoom = 0.8;
				var bg:FlxSprite = new FlxSprite(-500, -720).loadGraphic(Paths.image('greenbi/greenbi3'));
				bg.scrollFactor.set(0, 0);
				add(bg);
				var testshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
				testshader.waveAmplitude = 0.1;
				testshader.waveFrequency = 5;
				testshader.waveSpeed = 2;
				bg.shader = testshader.shader;
				curbg = bg;

			case 'house':
				defaultCamZoom = 0.9;
				curStage = 'daveHouse';

				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('dave/sky'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.75, 0.75);
				bg.active = false;
				sprites.add(bg);
				add(bg);

				var stageHills:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/hills'));
				stageHills.setGraphicSize(Std.int(stageHills.width * 1.25));
				stageHills.updateHitbox();
				stageHills.antialiasing = true;
				stageHills.scrollFactor.set(0.8, 0.8);
				stageHills.active = false;
				sprites.add(stageHills);
				add(stageHills);

				var gate:FlxSprite = new FlxSprite(-200, -125).loadGraphic(Paths.image('dave/gate'));
				gate.setGraphicSize(Std.int(gate.width * 1.2));
				gate.updateHitbox();
				gate.antialiasing = true;
				gate.scrollFactor.set(0.9, 0.9);
				gate.active = false;
				sprites.add(gate);
				add(gate);

				var stageFront:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/grass'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.2));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.active = false;
				sprites.add(stageFront);
				add(stageFront);

				UsingNewCam = true;

				if (SONG.song.toLowerCase() == 'insanity')
				{
					var insanityBg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('dave/redsky_insanity'));
					insanityBg.alpha = 0.75;
					insanityBg.active = true;
					insanityBg.visible = false;
					add(insanityBg);
					var testshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
					testshader.waveAmplitude = 0.1;
					testshader.waveFrequency = 5;
					testshader.waveSpeed = 2;
					insanityBg.shader = testshader.shader;
					curbg = insanityBg;
				}

			case 'farm' | 'farm-night' | 'farm-sunset':
				defaultCamZoom = 0.9;

				switch (bgName.toLowerCase())
				{
					case 'farm-night':
						curStage = 'bambiFarmNight';
					case 'farm-sunset':
						curStage = 'bambiFarmSunset';
					default:
						curStage = 'bambiFarm';
				}

				var skyType:String = curStage == 'bambiFarmNight' ? 'dave/sky_night' : curStage == 'bambiFarmSunset' ? 'dave/sky_sunset' : 'dave/sky';

				var bg:FlxSprite = new FlxSprite(-700, 0).loadGraphic(Paths.image(skyType));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				sprites.add(bg);

				var hills:FlxSprite = new FlxSprite(-250, 200).loadGraphic(Paths.image('bambi/orangey hills'));
				hills.antialiasing = true;
				hills.scrollFactor.set(0.9, 0.7);
				hills.active = false;
				sprites.add(hills);

				var farm:FlxSprite = new FlxSprite(150, 250).loadGraphic(Paths.image('bambi/funfarmhouse'));
				farm.antialiasing = true;
				farm.scrollFactor.set(1.1, 0.9);
				farm.active = false;
				sprites.add(farm);

				var foreground:FlxSprite = new FlxSprite(-400, 600).loadGraphic(Paths.image('bambi/grass lands'));
				foreground.antialiasing = true;
				foreground.active = false;
				sprites.add(foreground);

				var cornSet:FlxSprite = new FlxSprite(-350, 325).loadGraphic(Paths.image('bambi/Cornys'));
				cornSet.antialiasing = true;
				cornSet.active = false;
				sprites.add(cornSet);

				var cornSet2:FlxSprite = new FlxSprite(1050, 325).loadGraphic(Paths.image('bambi/Cornys'));
				cornSet2.antialiasing = true;
				cornSet2.active = false;
				sprites.add(cornSet2);

				var fence:FlxSprite = new FlxSprite(-350, 450).loadGraphic(Paths.image('bambi/crazy fences'));
				fence.antialiasing = true;
				fence.active = false;
				sprites.add(fence);

				var sign:FlxSprite = new FlxSprite(0, 500).loadGraphic(Paths.image('bambi/Sign'));
				sign.antialiasing = true;
				sign.active = false;
				sprites.add(sign);

				if (curStage == 'bambiFarmNight')
				{
					for (s in [hills, farm, foreground, cornSet, cornSet2, fence, sign])
						s.color = nightColor;
				}

				if (curStage == 'bambiFarmSunset')
				{
					for (s in [hills, farm, foreground, cornSet, cornSet2, fence, sign])
						s.color = sunsetColor;
				}

				for (s in [bg, hills, farm, foreground, cornSet, cornSet2, fence, sign])
					add(s);

				UsingNewCam = true;

			case 'house-night':
				defaultCamZoom = 0.9;
				curStage = 'daveHouse_night';

				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('dave/sky_night'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.75, 0.75);
				bg.active = false;
				sprites.add(bg);
				add(bg);

				var stageHills:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/hills_night'));
				stageHills.setGraphicSize(Std.int(stageHills.width * 1.25));
				stageHills.updateHitbox();
				stageHills.antialiasing = true;
				stageHills.scrollFactor.set(0.8, 0.8);
				stageHills.active = false;
				sprites.add(stageHills);
				add(stageHills);

				var gate:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/gate_night'));
				gate.setGraphicSize(Std.int(gate.width * 1.2));
				gate.updateHitbox();
				gate.antialiasing = true;
				gate.scrollFactor.set(0.9, 0.9);
				gate.active = false;
				sprites.add(gate);
				add(gate);

				var stageFront:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/grass_night'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.2));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.active = false;
				sprites.add(stageFront);
				add(stageFront);

				UsingNewCam = true;

			case 'red-void' | 'green-void' | 'glitchy-void':
				defaultCamZoom = 0.9;
				var bg:FlxSprite = new FlxSprite(-600, -200);

				switch (bgName.toLowerCase())
				{
					case 'green-void':
						bg.loadGraphic(Paths.image('dave/cheater'));
						curStage = 'cheating';
					case 'glitchy-void':
						bg.loadGraphic(Paths.image('dave/scarybg'));
						curStage = 'unfairness';
					default:
						bg.loadGraphic(Paths.image('dave/redsky'));
						curStage = 'daveEvilHouse';
				}

				bg.active = true;
				sprites.add(bg);
				add(bg);

				var testshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
				testshader.waveAmplitude = 0.1;
				testshader.waveFrequency = 5;
				testshader.waveSpeed = 2;
				bg.shader = testshader.shader;
				curbg = bg;

				if (SONG.song.toLowerCase() == 'furiosity' || SONG.song.toLowerCase() == 'polygonized' || SONG.song.toLowerCase() == 'unfairness')
					UsingNewCam = true;

			case 'house-sunset':
				defaultCamZoom = 0.9;
				curStage = 'daveHouse_sunset';

				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('dave/sky_sunset'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.75, 0.75);
				bg.active = false;
				sprites.add(bg);
				add(bg);

				var stageHills:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/hills'));
				stageHills.setGraphicSize(Std.int(stageHills.width * 1.25));
				stageHills.updateHitbox();
				stageHills.antialiasing = true;
				stageHills.scrollFactor.set(0.8, 0.8);
				stageHills.active = false;
				sprites.add(stageHills);
				add(stageHills);

				var gate:FlxSprite = new FlxSprite(-200, -125).loadGraphic(Paths.image('dave/gate'));
				gate.setGraphicSize(Std.int(gate.width * 1.2));
				gate.updateHitbox();
				gate.antialiasing = true;
				gate.scrollFactor.set(0.9, 0.9);
				gate.active = false;
				sprites.add(gate);
				add(gate);

				var stageFront:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/grass'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.2));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.active = false;
				sprites.add(stageFront);
				add(stageFront);

				gate.color = sunsetColor;
				stageHills.color = sunsetColor;
				stageFront.color = sunsetColor;

			default:
				defaultCamZoom = 0.9;
				curStage = 'stage';

				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				sprites.add(bg);
				add(bg);

				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				sprites.add(stageFront);
				add(stageFront);

				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;
				sprites.add(stageCurtains);
				add(stageCurtains);
		}

		return sprites;
	}

	function schoolIntro(?dialogueBox:DialogueBox, isStart:Bool = true):Void
	{
		inCutscene = true;
		camFollow.setPosition(boyfriend.getGraphicMidpoint().x - 200, dad.getGraphicMidpoint().y - 10);

		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var delay:Float = 1;
		if (isStart)
		{
			FlxTween.tween(black, {alpha: 0}, delay);
		}
		else
		{
			black.alpha = 0;
			delay = 0;
		}

		new FlxTimer().start(delay, function(t:FlxTimer)
		{
			if (dialogueBox != null)
				add(dialogueBox);
			else
				startCountdown();
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle', true);

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);
			introAssets.set('schoolEvil', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)
			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3'), 0.6);
					focusOnDadGlobal = false;
					ZoomCam(false);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();
					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));
					ready.updateHitbox();
					ready.screenCenter();
					ready.cameras = [camHUD];
					add(ready);
					FlxTween.tween(ready, {y: ready.y + 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween) { ready.destroy(); }
					});
					FlxG.sound.play(Paths.sound('intro2'), 0.6);
					focusOnDadGlobal = true;
					ZoomCam(true);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();
					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));
					set.updateHitbox();
					set.screenCenter();
					set.cameras = [camHUD];
					add(set);
					FlxTween.tween(set, {y: set.y + 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween) { set.destroy(); }
					});
					FlxG.sound.play(Paths.sound('intro1'), 0.6);
					focusOnDadGlobal = false;
					ZoomCam(false);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();
					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));
					go.updateHitbox();
					go.screenCenter();
					go.cameras = [camHUD];
					add(go);
					FlxTween.tween(go, {y: go.y + 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween) { go.destroy(); }
					});
					FlxG.sound.play(Paths.sound('introGo'), 0.6);
					focusOnDadGlobal = true;
					ZoomCam(true);
			}

			swagCounter += 1;
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		vocals.play();

		if (FlxG.save.data.tristanProgress == "pending play" && isStoryMode && storyWeek != 10)
			FlxG.sound.music.volume = 0;

		#if desktop
		DiscordClient.changePresence(
			detailsText + " " + SONG.song + " (" + storyDifficultyText + ") ",
			"\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses,
			iconRPC
		);
		#end

		FlxG.sound.music.onComplete = endSong;
	}

	private function generateSong(dataPath:String):Void
	{
		var songData = SONG;
		Conductor.changeBPM(songData.bpm);
		curSong = songData.song;

		vocals = SONG.needsVoices
			? new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song))
			: new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection> = songData.notes;
		var lastNote:Note = null;

		for (section in noteData)
		{
			var mustHit = section.mustHitSection;

			for (songNotes in section.sectionNotes)
			{
				var strumTime:Float = songNotes[0];
				var lane:Int = Std.int(songNotes[1]);
				var noteLane:Int = lane % 4;
				var style:String = songNotes[3];

				var gottaHit = lane > 3 ? !mustHit : mustHit;

				var note = new Note(strumTime, noteLane, lastNote, false, gottaHit, style);
				note.sustainLength = songNotes[2];
				note.mustPress = gottaHit;
				note.scrollFactor.set(0, 0);

				if (note.mustPress)
					note.x += FlxG.width / 2;

				unspawnNotes.push(note);
				lastNote = note;

				var susSteps:Int = Std.int(note.sustainLength / Conductor.stepCrochet);

				for (i in 0...susSteps)
				{
					var sustain = new Note(
						strumTime + Conductor.stepCrochet * (i + 1),
						noteLane,
						lastNote,
						true,
						gottaHit
					);

					sustain.mustPress = gottaHit;
					sustain.scrollFactor.set();

					if (sustain.mustPress)
						sustain.x += FlxG.width / 2;

					unspawnNotes.push(sustain);
					lastNote = sustain;
				}
			}
		}

		unspawnNotes.sort(sortByShit);
		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		var isFloatyBoy:Bool = (player == 0 && funnyFloatyBoys.contains(dad.curCharacter))
			|| (player == 1 && funnyFloatyBoys.contains(boyfriend.curCharacter));

		var atlasName:String = isFloatyBoy ? 'NOTE_assets_3D' : 'NOTE_assets';

		var dirNames:Array<Array<String>> = [
			['arrowLEFT', 'left press', 'left confirm'],
			['arrowDOWN', 'down press', 'down confirm'],
			['arrowUP', 'up press', 'up confirm'],
			['arrowRIGHT', 'right press', 'right confirm']
		];

		for (i in 0...4)
		{
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);
			babyArrow.frames = Paths.getSparrowAtlas(atlasName);

			babyArrow.animation.addByPrefix('green', 'arrowUP');
			babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
			babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
			babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

			if (!isFloatyBoy)
				babyArrow.antialiasing = true;

			babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

			babyArrow.x += Note.swagWidth * i;
			babyArrow.animation.addByPrefix('static', dirNames[i][0]);
			babyArrow.animation.addByPrefix('pressed', dirNames[i][1], 24, false);
			babyArrow.animation.addByPrefix('confirm', dirNames[i][2], 24, false);

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			babyArrow.y -= 10;
			babyArrow.alpha = 0;
			FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});

			babyArrow.ID = i;
			babyArrow.animation.play('static');
			babyArrow.x += 94;
			babyArrow.x += ((FlxG.width / 2) * player);

			if (player == 1)
				playerStrums.add(babyArrow);
			else
				dadStrums.add(babyArrow);

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if desktop
			DiscordClient.changePresence(
				"PAUSED on " + SONG.song + " (" + storyDifficultyText + ") |",
				"Acc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses,
				iconRPC
			);
			#end

			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	public function throwThatBitchInThere(guyWhoComesIn:String = 'bambi', guyWhoFliesOut:String = 'dave')
	{
		hasTriggeredDumbshit = true;
		if (BAMBICUTSCENEICONHURHURHUR != null)
			remove(BAMBICUTSCENEICONHURHURHUR);

		BAMBICUTSCENEICONHURHURHUR = new HealthIcon(guyWhoComesIn, false);
		BAMBICUTSCENEICONHURHURHUR.y = healthBar.y - (BAMBICUTSCENEICONHURHURHUR.height / 2);
		add(BAMBICUTSCENEICONHURHURHUR);
		BAMBICUTSCENEICONHURHURHUR.cameras = [camHUD];
		BAMBICUTSCENEICONHURHURHUR.x = -100;
		FlxTween.linearMotion(BAMBICUTSCENEICONHURHURHUR, -100, BAMBICUTSCENEICONHURHURHUR.y, iconP2.x, BAMBICUTSCENEICONHURHURHUR.y, 0.3, true, {ease: FlxEase.expoInOut});
		AUGHHHH = guyWhoComesIn;
		AHHHHH = guyWhoFliesOut;
		new FlxTimer().start(0.3, FlingCharacterIconToOblivionAndBeyond);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
				resyncVocals();

			if (!startTimer.finished)
				startTimer.active = true;

			paused = false;

			if (startTimer.finished)
			{
				#if desktop
				DiscordClient.changePresence(
					detailsText + " " + SONG.song + " (" + storyDifficultyText + ") ",
					"\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses,
					iconRPC, true, FlxG.sound.music.length - Conductor.songPosition
				);
				#end
			}
			else
			{
				#if desktop
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") ", iconRPC);
				#end
			}
		}

		super.closeSubState();
	}

	function resyncVocals():Void
	{
		vocals.pause();
		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if desktop
		DiscordClient.changePresence(
			detailsText + " " + SONG.song + " (" + storyDifficultyText + ") ",
			"\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses,
			iconRPC
		);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	function truncateFloat(number:Float, precision:Int):Float
	{
		var num = number * Math.pow(10, precision);
		return Math.round(num) / Math.pow(10, precision);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

	if (!startingSong && FlxG.sound.music != null)
		{
			songPercent = Conductor.songPosition / FlxG.sound.music.length;

			var elapsed:Int    = Math.floor(Conductor.songPosition / 1000);
			var total:Int      = Math.floor(FlxG.sound.music.length / 1000);
			var elMins:Int     = Math.floor(elapsed / 60);
			var elSecs:String  = StringTools.lpad(Std.string(elapsed % 60), "0", 2);
			var totMins:Int    = Math.floor(total / 60);
			var totSecs:String = StringTools.lpad(Std.string(total % 60), "0", 2);

			timeTxt.text = '$elMins:$elSecs / $totMins:$totSecs';
			timeTxt.x = timeBarBG.x + (timeBarBG.width / 2) - (timeTxt.width / 2);
			timeTxt.y = timeBarBG.y + (timeBarBG.height / 2) - (timeTxt.height / 2);

			if (timeTxt.alpha < 1)
				timeTxt.alpha = Math.min(timeTxt.alpha + (FlxG.elapsed * 2), 1);
		}

		if (spinCam)
		{
			FlxG.camera.angle += 60 * elapsed;
		}
		else if (resetCam)
		{
			if (Math.abs(FlxG.camera.angle) <= 0.1)
			{
				FlxG.camera.angle = 0;
				resetCam = false;
			}
			else
			{
				FlxG.camera.angle = FlxMath.lerp(FlxG.camera.angle, 0, Math.min(1, elapsed * 5));
			}
		}

		elapsedtime += elapsed;

		if (curbg != null && curbg.active)
		{
			var shad = cast(curbg.shader, Shaders.GlitchShader);
			shad.uTime.value[0] += elapsed;
		}

		if (SONG.song.toLowerCase() == 'cheating' && !inCutscene)
		{
			playerStrums.forEach(function(spr:FlxSprite)
			{
				spr.x += Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1);
				spr.x -= Math.sin(elapsedtime) * 1.5;
			});
			dadStrums.forEach(function(spr:FlxSprite)
			{
				spr.x -= Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1);
				spr.x += Math.sin(elapsedtime) * 1.5;
			});
		}

		if (SONG.song.toLowerCase() == 'unfairness' && !inCutscene)
		{
			playerStrums.forEach(function(spr:FlxSprite)
			{
				spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin(elapsedtime + spr.ID) * 300);
				spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.cos(elapsedtime + spr.ID) * 300);
			});
			dadStrums.forEach(function(spr:FlxSprite)
			{
				spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin((elapsedtime + spr.ID) * 2) * 300);
				spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.cos((elapsedtime + spr.ID) * 2) * 300);
			});
		}

		FlxG.camera.setFilters([new ShaderFilter(screenshader.shader)]);

		if (shakeCam && eyesoreson)
			FlxG.camera.shake(0.015, 0.015);

		screenshader.shader.uTime.value[0] += elapsed;

		if (shakeCam && eyesoreson)
			screenshader.shader.uampmul.value[0] = 1;
		else
			screenshader.shader.uampmul.value[0] -= (elapsed / 2);

		screenshader.Enabled = shakeCam && eyesoreson;

		switch (SONG.song.toLowerCase())
		{
			case 'splitathon' | 'old-splitathon':
				switch (curStep)
				{
					case 4750:
						dad.canDance = false;
						dad.playAnim('scared', true);
						camHUD.shake(0.015, (Conductor.stepCrochet / 1000) * 50);
					case 4800:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						splitterThonDave('what');
						addSplitathonChar("bambi-splitathon");
						if (!hasTriggeredDumbshit)
							throwThatBitchInThere('bambi', 'dave');
					case 5824:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						splitathonExpression('bambi-what', -100, 550);
						addSplitathonChar("dave-splitathon");
						if (!hasTriggeredDumbshit)
							throwThatBitchInThere('dave', 'bambi');
					case 6080:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						splitterThonDave('happy');
						addSplitathonChar("bambi-splitathon");
						if (!hasTriggeredDumbshit)
							throwThatBitchInThere('bambi', 'dave');
					case 8384:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						splitathonExpression('bambi-corn', -100, 550);
						addSplitathonChar("dave-splitathon");
						if (!hasTriggeredDumbshit)
							throwThatBitchInThere('dave', 'bambi');
					case 5823 | 6079 | 8383 | 8750:
						hasTriggeredDumbshit = false;
						updatevels = false;
				}
			case 'insanity':
				switch (curStep)
				{
					case 660 | 680:
						FlxG.sound.play(Paths.sound('static'), 0.1);
						dad.visible = false;
						dadmirror.visible = true;
						curbg.visible = true;
						iconP2.animation.play(dadmirror.curCharacter);
					case 664 | 684:
						dad.visible = true;
						dadmirror.visible = false;
						curbg.visible = false;
						iconP2.animation.play(dad.curCharacter);
					case 1176:
						FlxG.sound.play(Paths.sound('static'), 0.1);
						dad.visible = false;
						dadmirror.visible = true;
						curbg.loadGraphic(Paths.image('dave/redsky'));
						curbg.alpha = 1;
						curbg.visible = true;
						iconP2.animation.play(dadmirror.curCharacter);
					case 1180:
						dad.visible = true;
						dadmirror.visible = false;
						iconP2.animation.play(dad.curCharacter);
						dad.canDance = false;
						dad.animation.play('scared', true);
				}
		}

		for (note in notes)
		{
			if (!note.finishedGenerating)
				continue;
			if (note.strumTime - Conductor.songPosition > 3000)
				continue;
			if (note.y > -100 && note.y < FlxG.height + 100)
				note.update(elapsed);
		}

		scoreTxt.text = "Score:" + songScore + " | Misses:" + misses + " | Accuracy:" + truncateFloat(accuracy, 2) + "% ";

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			if (FlxG.random.bool(1))
				FlxG.switchState(new YouCheatedSomeoneIsComing());
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			switch (curSong.toLowerCase())
			{
				case 'supernovae' | 'glitch' | 'vs-dave-thanksgiving':
					PlayState.SONG = Song.loadFromJson("cheating", "cheating");
					FlxG.save.data.cheatingFound = true;
					shakeCam = false;
					screenshader.Enabled = false;
					FlxG.switchState(new PlayState());
					return;
				case 'cheating':
					PlayState.SONG = Song.loadFromJson("unfairness", "unfairness");
					FlxG.save.data.unfairnessFound = true;
					shakeCam = false;
					screenshader.Enabled = false;
					FlxG.switchState(new PlayState());
					return;
				case 'unfairness':
					shakeCam = false;
					screenshader.Enabled = false;
					FlxG.switchState(new YouCheatedSomeoneIsComing());
				default:
					shakeCam = false;
					screenshader.Enabled = false;
					FlxG.switchState(new ChartingState());
					#if desktop
					DiscordClient.changePresence("Chart Editor", null, null, true);
					#end
			}
		}

		if (FlxG.keys.justPressed.SIX)
			FlxG.switchState(new YouCheatedSomeoneIsComing());

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.8)), Std.int(FlxMath.lerp(150, iconP1.height, 0.8)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.8)), Std.int(FlxMath.lerp(150, iconP2.height, 0.8)));
		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;
		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;

		iconP1.animation.curAnim.curFrame = healthBar.percent < 20 ? 1 : 0;
		iconP2.animation.curAnim.curFrame = healthBar.percent > 80 ? 1 : 0;

		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(dad.curCharacter));
		if (FlxG.keys.justPressed.TWO)
			FlxG.switchState(new AnimationDebug(boyfriend.curCharacter));
		if (FlxG.keys.justPressed.THREE)
			FlxG.switchState(new AnimationDebug(gf.curCharacter));

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong.toLowerCase() == 'furiosity')
		{
			switch (curBeat)
			{
				case 127:
					camZooming = true;
				case 159:
					camZooming = false;
				case 191:
					camZooming = true;
				case 223:
					camZooming = false;
			}
		}

		if (health <= 0)
		{
			if (!perfectMode)
			{
				boyfriend.stunned = true;
				persistentUpdate = false;
				persistentDraw = false;
				paused = true;
				vocals.stop();
				FlxG.sound.music.stop();
				screenshader.shader.uampmul.value[0] = 0;
				screenshader.Enabled = false;
			}

			if (shakeCam)
				FlxG.save.data.unlockedcharacters[7] = true;

			if (!shakeCam)
			{
				if (!perfectMode)
				{
					openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y,
						formoverride == "bf" || formoverride == "none" ? SONG.player1 : formoverride));
					#if desktop
					DiscordClient.changePresence(
						"GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") ",
						"\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses,
						iconRPC
					);
					#end
				}
			}
			else
			{
				if (isStoryMode)
				{
					switch (SONG.song.toLowerCase())
					{
						case 'blocked' | 'corn-theft' | 'maze':
							FlxG.openURL("https://www.youtube.com/watch?v=eTJOdgDzD64");
							System.exit(0);
						default:
							FlxG.switchState(new EndingState('rtxx_ending', 'badEnding'));
					}
				}
				else
				{
					if (!perfectMode)
					{
						openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y,
							formoverride == "bf" || formoverride == "none" ? SONG.player1 : formoverride));
						#if desktop
						DiscordClient.changePresence(
							"GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") ",
							"\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses,
							iconRPC
						);
						#end
					}
				}
			}
		}

		var spawnTime:Float = SONG.song.toLowerCase() == 'unfairness' ? 15000 : 1500;

		while (unspawnNotes.length > 0 && unspawnNotes[0].strumTime - Conductor.songPosition < spawnTime)
		{
			var note:Note = unspawnNotes.shift();
			note.finishedGenerating = true;
			notes.add(note);
		}

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.y > FlxG.height)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;

					var altAnim:String = "";
					var healthtolower:Float = 0.01;

					if (SONG.notes[Math.floor(curStep / 16)] != null && SONG.notes[Math.floor(curStep / 16)].altAnim)
					{
						if (SONG.song.toLowerCase() != "cheating")
							altAnim = '-alt';
						else
							healthtolower = 0.005;
					}

					var dir:String = notestuffs[Math.round(Math.abs(daNote.noteData)) % 4];
					if (dad.nativelyPlayable)
					{
						switch (dir)
						{
							case 'LEFT': dir = 'RIGHT';
							case 'RIGHT': dir = 'LEFT';
						}
					}

					if (dad.curCharacter == 'bambi-unfair' || dad.curCharacter == 'bambi-3d')
					{
						FlxG.camera.shake(0.0075, 0.1);
						camHUD.shake(0.0045, 0.1);
					}

					if (!daNote.isSustainNote)
					{
						dad.playAnim('sing' + dir + altAnim, true);
						dadmirror.playAnim('sing' + dir + altAnim, true);
					}

					if (SONG.song.toLowerCase() != 'senpai' && SONG.song.toLowerCase() != 'roses' && SONG.song.toLowerCase() != 'thorns')
					{
						dadStrums.forEach(function(sprite:FlxSprite)
						{
							if (Math.abs(Math.round(Math.abs(daNote.noteData)) % 4) == sprite.ID)
							{
								sprite.animation.play('confirm', true);
								if (sprite.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
								{
									sprite.centerOffsets();
									sprite.offset.x -= 13;
									sprite.offset.y -= 13;
								}
								else
								{
									sprite.centerOffsets();
								}
								sprite.animation.finishCallback = function(name:String)
								{
									sprite.animation.play('static', true);
									sprite.centerOffsets();
								};
							}
						});
					}

					if (UsingNewCam)
					{
						focusOnDadGlobal = true;
						ZoomCam(true);
					}

					switch (SONG.song.toLowerCase())
					{
						case 'cheating':
							health -= healthtolower;
						case 'unfairness':
							health -= (healthtolower / 6);
					}

					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}

				switch (SONG.song.toLowerCase())
				{
					case 'unfairness':
						if (daNote.MyStrum != null)
							daNote.y = (daNote.MyStrum.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(SONG.speed * daNote.LocalScrollSpeed, 2)));
					default:
						if (FlxG.save.data.downscroll)
							daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(SONG.speed * daNote.LocalScrollSpeed, 2)));
						else
							daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed * daNote.LocalScrollSpeed, 2)));
				}

				var strumliney:Float = daNote.MyStrum != null ? daNote.MyStrum.y : strumLine.y;

				var noteOffScreen:Bool = (FlxG.save.data.downscroll || SONG.song.toLowerCase() == "unfairness")
					? daNote.y >= strumliney + 106
					: daNote.y < -daNote.height;

				if (noteOffScreen)
				{
					if (daNote.isSustainNote && daNote.wasGoodHit)
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
					else
					{
						if (daNote.mustPress && daNote.finishedGenerating)
						{
							noteMiss(daNote.noteData);
							health -= 0.01;
							vocals.volume = 0;
						}

						daNote.active = false;
						daNote.visible = false;
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				}
			});
		}

		ZoomCam(focusOnDadGlobal);

		if (!inCutscene)
			keyShit();

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end

		if (updatevels)
		{
			stupidx *= 0.98;
			stupidy += elapsed * 6;
			if (BAMBICUTSCENEICONHURHURHUR != null)
			{
				BAMBICUTSCENEICONHURHURHUR.x += stupidx;
				BAMBICUTSCENEICONHURHURHUR.y += stupidy;
			}
		}
	}

	function FlingCharacterIconToOblivionAndBeyond(e:FlxTimer = null):Void
	{
		iconP2.animation.play(AUGHHHH, true);
		BAMBICUTSCENEICONHURHURHUR.animation.play(AHHHHH, true, false, 1);
		stupidx = -5;
		stupidy = -5;
		updatevels = true;
	}

	function ZoomCam(focusondad:Bool):Void
	{
		if (focusondad)
		{
			var bfplaying:Bool = false;
			notes.forEachAlive(function(daNote:Note)
			{
				if (!bfplaying && daNote.mustPress)
					bfplaying = true;
			});

			if (UsingNewCam && bfplaying)
				return;

			var targetX:Float = dad.getMidpoint().x + 150;
			var targetY:Float = dad.getMidpoint().y - 100;

			switch (dad.curCharacter)
			{
				case 'dave-angey' | 'dave-annoyed-3d' | 'dave-3d-standing-bruh-what':
					targetY = dad.getMidpoint().y;
			}

			tweenCamFollow(targetX, targetY);

			if (SONG.song.toLowerCase() == 'tutorial')
				tweenCamIn();
		}
		else
		{
			var targetX:Float = boyfriend.getMidpoint().x - 100;
			var targetY:Float = boyfriend.getMidpoint().y - 100;

			switch (boyfriend.curCharacter)
			{
				case 'dave-angey' | 'dave-annoyed-3d' | 'dave-3d-standing-bruh-what':
					targetY = boyfriend.getMidpoint().y;
				case 'bambi-3d' | 'bambi-unfair':
					targetY = boyfriend.getMidpoint().y - 350;
			}

			tweenCamFollow(targetX, targetY);

			if (SONG.song.toLowerCase() == 'tutorial')
				FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
		}
	}

	function tweenCamFollow(x:Float, y:Float):Void
	{
		if (Math.abs(camFollowTargetX - x) < 1 && Math.abs(camFollowTargetY - y) < 1)
			return;
		camFollowTargetX = x;
		camFollowTargetY = y;
		if (camFollowTween != null)
			camFollowTween.cancel();
		camFollowTween = FlxTween.tween(camFollow, {x: x, y: y}, 0.7, {ease: FlxEase.cubeOut});
	}

	function THROWPHONEMARCELLO(e:FlxTimer = null):Void
	{
		STUPDVARIABLETHATSHOULDNTBENEEDED.animation.play("throw_phone");
		new FlxTimer().start(5.5, function(timer:FlxTimer)
		{
			FlxG.switchState(new FreeplayState());
		});
	}

	function endSong():Void
	{
		inCutscene = false;
		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;

		if (SONG.validScore)
		{
			#if !switch
			Highscore.saveScore(SONG.song, songScore, storyDifficulty,
				characteroverride == "none" || characteroverride == "bf" ? "bf" : characteroverride);
			#end
		}

		if (curSong.toLowerCase() == 'bonus-song')
			FlxG.save.data.unlockedcharacters[3] = true;

		if (isStoryMode)
		{
			campaignScore += songScore;

			if (FlxG.save.data.songsCompleted == null)
				FlxG.save.data.songsCompleted = new Array<String>();

			var completedSongs:Array<String> = FlxG.save.data.songsCompleted;
			completedSongs.push(storyPlaylist[0]);

			var mustCompleteSongs:Array<String> = ['House', 'Insanity', 'Polygonized', 'Blocked', 'Corn-Theft', 'Maze', 'Splitathon'];
			var allSongsCompleted:Bool = true;
			for (song in mustCompleteSongs)
			{
				if (!completedSongs.contains(song))
				{
					allSongsCompleted = false;
					break;
				}
			}

			if (allSongsCompleted && !FlxG.save.data.unlockedcharacters[6])
				FlxG.save.data.unlockedcharacters[6] = true;

			FlxG.save.data.songsCompleted = completedSongs;
			FlxG.save.flush();

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0)
			{
				switch (curSong.toLowerCase())
				{
					case 'polygonized':
						FlxG.save.data.tristanProgress = "unlocked";
						if (health >= 0.1)
						{
							FlxG.save.data.unlockedcharacters[2] = true;
							if (storyDifficulty == 2)
								FlxG.save.data.unlockedcharacters[5] = true;
							FlxG.switchState(new EndingState('goodEnding', 'goodEnding'));
						}
						else
						{
							FlxG.save.data.unlockedcharacters[4] = true;
							FlxG.switchState(new EndingState('vomit_ending', 'badEnding'));
						}
					case 'maze' | 'old-maze' | 'beta-maze':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						generatedMusic = false;
						boyfriend.stunned = true;
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('maze/endDialogue')));
						doof.scrollFactor.set();
						doof.finishThing = function() { FlxG.switchState(new StoryMenuState()); };
						doof.cameras = [camDialogue];
						schoolIntro(doof, false);
					case 'splitathon' | 'old-splitathon':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						generatedMusic = false;
						boyfriend.stunned = true;
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('splitathon/splitathonDialogueEnd')));
						doof.scrollFactor.set();
						doof.finishThing = function() { FlxG.switchState(new StoryMenuState()); };
						doof.cameras = [camDialogue];
						schoolIntro(doof, false);
					default:
						FlxG.switchState(new StoryMenuState());
				}

				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;

				StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

				if (SONG.validScore)
				{
					NGio.unlockMedal(60961);
					Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty,
						characteroverride == "none" || characteroverride == "bf" ? "bf" : characteroverride);
				}

				FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
				FlxG.save.flush();
			}
			else
			{
				switch (SONG.song.toLowerCase())
				{
					case 'insanity' | 'old-insanity':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						generatedMusic = false;
						boyfriend.stunned = true;
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('insanity/endDialogue')));
						doof.scrollFactor.set();
						doof.finishThing = nextSong;
						doof.cameras = [camDialogue];
						schoolIntro(doof, false);
					case 'splitathon' | 'old-splitathon':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						generatedMusic = false;
						boyfriend.stunned = true;
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('splitathon/splitathonDialogueEnd')));
						doof.scrollFactor.set();
						doof.finishThing = nextSong;
						doof.cameras = [camDialogue];
						schoolIntro(doof, false);
					case 'glitch':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						_startGlitchCutscene(nextSong);
					default:
						nextSong();
				}
			}
		}
		else
		{
			if (FlxG.save.data.freeplayCuts)
			{
				switch (SONG.song.toLowerCase())
				{
					case 'glitch':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						_startGlitchCutscene(ughWhyDoesThisHaveToFuckingExist);
					case 'insanity' | 'old-insanity':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						generatedMusic = false;
						boyfriend.stunned = true;
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('insanity/endDialogue')));
						doof.scrollFactor.set();
						doof.finishThing = ughWhyDoesThisHaveToFuckingExist;
						doof.cameras = [camDialogue];
						schoolIntro(doof, false);
					case 'maze' | 'old-maze' | 'beta-maze':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						generatedMusic = false;
						boyfriend.stunned = true;
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('maze/endDialogue')));
						doof.scrollFactor.set();
						doof.finishThing = ughWhyDoesThisHaveToFuckingExist;
						doof.cameras = [camDialogue];
						schoolIntro(doof, false);
					case 'splitathon' | 'old-splitathon':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						generatedMusic = false;
						boyfriend.stunned = true;
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('splitathon/splitathonDialogueEnd')));
						doof.scrollFactor.set();
						doof.finishThing = ughWhyDoesThisHaveToFuckingExist;
						doof.cameras = [camDialogue];
						schoolIntro(doof, false);
					default:
						FlxG.switchState(new FreeplayState());
				}
			}
			else
			{
				FlxG.switchState(new FreeplayState());
			}
		}
	}

	function _startGlitchCutscene(callback:Void->Void):Void
	{
		var marcello:FlxSprite = new FlxSprite(dad.x - 170, dad.y);
		marcello.flipX = true;
		marcello.antialiasing = true;
		marcello.color = 0xFF878787;
		add(marcello);
		dad.visible = false;
		boyfriend.stunned = true;
		marcello.frames = Paths.getSparrowAtlas('dave/cutscene');
		marcello.animation.addByPrefix('throw_phone', 'bambi0', 24, false);
		FlxG.sound.play(Paths.sound('break_phone'), 1, false, null, true);
		boyfriend.playAnim('hit', true);
		STUPDVARIABLETHATSHOULDNTBENEEDED = marcello;
		new FlxTimer().start(5.5, function(t:FlxTimer)
		{
			marcello.animation.play("throw_phone");
			new FlxTimer().start(5.5, function(t2:FlxTimer)
			{
				callback();
			});
		});
	}

	function ughWhyDoesThisHaveToFuckingExist():Void
	{
		FlxG.switchState(new FreeplayState());
	}

	var endingSong:Bool = false;

	function nextSong():Void
	{
		var difficulty:String = "";
		if (storyDifficulty == 0)
			difficulty = '-easy';
		else if (storyDifficulty == 2 || storyDifficulty == 3)
			difficulty = '-hard';

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		prevCamFollow = camFollow;

		PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
		FlxG.sound.music.stop();

		switch (curSong.toLowerCase())
		{
			case 'corn-theft':
				LoadingState.loadAndSwitchState(new VideoState('assets/videos/mazeecutscenee.webm', new PlayState()), false);
			default:
				LoadingState.loadAndSwitchState(new PlayState());
		}
	}

	private function popUpScore(strumtime:Float, notedata:Int):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		vocals.volume = 1;

		var placement:String = Std.string(combo);
		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;
		var daRating:String = "sick";

		if (noteDiff > Conductor.safeZoneOffset * 2 || noteDiff < Conductor.safeZoneOffset * -2)
		{
			daRating = 'shit';
			totalNotesHit -= 2;
			score = -3000;
			ss = false;
			shits++;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.45)
		{
			daRating = 'bad';
			score = -1000;
			totalNotesHit += 0.2;
			ss = false;
			bads++;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.25)
		{
			daRating = 'good';
			totalNotesHit += 0.65;
			score = 200;
			ss = false;
			goods++;
		}

		if (daRating == 'sick')
		{
			totalNotesHit += 1;
			sicks++;
		}

		switch (notedata)
		{
			case 2: score = cast(FlxMath.roundDecimal(cast(score, Float) * curmult[2], 0), Int);
			case 3: score = cast(FlxMath.roundDecimal(cast(score, Float) * curmult[1], 0), Int);
			case 1: score = cast(FlxMath.roundDecimal(cast(score, Float) * curmult[3], 0), Int);
			case 0: score = cast(FlxMath.roundDecimal(cast(score, Float) * curmult[0], 0), Int);
		}

		if (daRating != 'shit' && daRating != 'bad')
		{
			songScore += score;

			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';

			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}

			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.x = coolText.x - 40;
			rating.y -= 60;
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);

			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = coolText.x;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;
			comboSpr.velocity.x += FlxG.random.int(1, 10);

			add(rating);

			if (!curStage.startsWith('school'))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}

			comboSpr.updateHitbox();
			rating.updateHitbox();

			var seperatedScore:Array<Int> = [];
			var comboSplit:Array<String> = (combo + "").split('');

			if (comboSplit.length == 2)
				seperatedScore.push(0);

			for (i in 0...comboSplit.length)
				seperatedScore.push(Std.parseInt(comboSplit[i]));

			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = coolText.x + (43 * daLoop) - 90;
				numScore.y += 80;

				if (!curStage.startsWith('school'))
				{
					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}

				numScore.updateHitbox();
				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);

				if (combo >= 0 || combo == 0)
					add(numScore);

				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween) { numScore.destroy(); },
					startDelay: Conductor.crochet * 0.002
				});

				daLoop++;
			}

			coolText.text = Std.string(seperatedScore);

			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});

			curSection += 1;
		}
	}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
	{
		return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
	}

	var upHold:Bool = false;
	var downHold:Bool = false;
	var rightHold:Bool = false;
	var leftHold:Bool = false;

	private function keyShit():Void
	{
		var up = controls.UP;
		var right = controls.RIGHT;
		var down = controls.DOWN;
		var left = controls.LEFT;

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var upR = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR = controls.DOWN_R;
		var leftR = controls.LEFT_R;

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		if ((upP || rightP || downP || leftP) && !boyfriend.stunned && generatedMusic)
		{
			boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !daNote.isSustainNote && daNote.finishedGenerating)
					possibleNotes.push(daNote);
			});

			possibleNotes.sort((a, b) -> Std.int(a.noteData - b.noteData));
			haxe.ds.ArraySort.sort(possibleNotes, function(a, b):Int
			{
				var notetypecompare:Int = Std.int(a.noteData - b.noteData);
				if (notetypecompare == 0)
					return Std.int(a.strumTime - b.strumTime);
				return notetypecompare;
			});

			if (possibleNotes.length > 0)
			{
				var daNote = possibleNotes[0];

				if (perfectMode)
					noteCheck(true, daNote);

				var lasthitnote:Int = -1;
				var lasthitnotetime:Float = -1;

				for (note in possibleNotes)
				{
					if (controlArray[note.noteData % 4])
					{
						if (lasthitnotetime > Conductor.songPosition - Conductor.safeZoneOffset
							&& lasthitnotetime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.2))
						{
							if ((note.noteData % 4) == (lasthitnote % 4))
								continue;
						}
						lasthitnote = note.noteData;
						lasthitnotetime = note.strumTime;
						goodNoteHit(note);
					}
				}

				if (daNote.wasGoodHit)
				{
					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			}
			else if (!theFunne)
			{
				if (!inCutscene)
					badNoteCheck(null);
			}
		}

		if ((up || right || down || left) && generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
				{
					switch (daNote.noteData)
					{
						case 2:
							if (up || upHold) goodNoteHit(daNote);
						case 3:
							if (right || rightHold) goodNoteHit(daNote);
						case 1:
							if (down || downHold) goodNoteHit(daNote);
						case 0:
							if (left || leftHold) goodNoteHit(daNote);
					}
				}
			});
		}

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
				boyfriend.playAnim('idle');
		}

		playerStrums.forEach(function(spr:FlxSprite)
		{
			switch (spr.ID)
			{
				case 2:
					if (upP && spr.animation.curAnim.name != 'confirm') spr.animation.play('pressed');
					if (upR) spr.animation.play('static');
				case 3:
					if (rightP && spr.animation.curAnim.name != 'confirm') spr.animation.play('pressed');
					if (rightR) spr.animation.play('static');
				case 1:
					if (downP && spr.animation.curAnim.name != 'confirm') spr.animation.play('pressed');
					if (downR) spr.animation.play('static');
				case 0:
					if (leftP && spr.animation.curAnim.name != 'confirm') spr.animation.play('pressed');
					if (leftR) spr.animation.play('static');
			}

			if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
			else
			{
				spr.centerOffsets();
			}
		});
	}

	function noteMiss(direction:Int = 1):Void
	{
		if (boyfriend.stunned)
			return;

		health -= 0.01;

		if (combo > 5 && gf.animOffsets.exists('sad'))
			gf.playAnim('sad');

		combo = 0;
		misses++;
		songScore -= 10;

		FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));

		var dir:String = notestuffs[Math.round(Math.abs(direction)) % 4];
		if (!boyfriend.nativelyPlayable)
		{
			switch (dir)
			{
				case 'LEFT': dir = 'RIGHT';
				case 'RIGHT': dir = 'LEFT';
			}
		}

		if (boyfriend.animation.getByName("singLEFTmiss") != null)
		{
			boyfriend.playAnim('sing' + dir + "miss", true);
		}
		else
		{
			boyfriend.color = 0xFF000084;
			boyfriend.playAnim('sing' + dir, true);
		}

		updateAccuracy();
	}

	function badNoteCheck(note:Note = null):Void
	{
		if (note != null)
		{
			if (note.mustPress && note.finishedGenerating)
				noteMiss(note.noteData);
			return;
		}

		if (controls.LEFT_P) noteMiss(0);
		if (controls.UP_P) noteMiss(2);
		if (controls.RIGHT_P) noteMiss(3);
		if (controls.DOWN_P) noteMiss(1);

		updateAccuracy();
	}

	function updateAccuracy():Void
	{
		fc = misses == 0 && accuracy >= 96;
		totalPlayed += 1;
		accuracy = totalNotesHit / totalPlayed * 100;
	}

	function noteCheck(keyP:Bool, note:Note):Void
	{
		if (keyP)
			goodNoteHit(note);
		else if (!theFunne)
			badNoteCheck(note);
	}

	function goodNoteHit(note:Note):Void
	{
		if (note.wasGoodHit)
			return;

		if (!note.isSustainNote)
		{
			popUpScore(note.strumTime, note.noteData);
			if (FlxG.save.data.donoteclick)
				FlxG.sound.play(Paths.sound('note_click'));
			combo += 1;
		}
		else
		{
			totalNotesHit += 1;
		}

		if (note.isSustainNote)
			health += 0.2;
		else
			health += 0.023;

		if (darkLevels.contains(curStage) && SONG.song.toLowerCase() != "polygonized")
			boyfriend.color = nightColor;
		else if (sunsetLevels.contains(curStage))
			boyfriend.color = sunsetColor;
		else
			boyfriend.color = FlxColor.WHITE;

		var dir:String = notestuffs[Math.round(Math.abs(note.noteData)) % 4];
		if (!boyfriend.nativelyPlayable)
		{
			switch (dir)
			{
				case 'LEFT': dir = 'RIGHT';
				case 'RIGHT': dir = 'LEFT';
			}
		}

		if (boyfriend.curCharacter == 'bambi-unfair' || boyfriend.curCharacter == 'bambi-3d')
		{
			FlxG.camera.shake(0.0075, 0.1);
			camHUD.shake(0.0045, 0.1);
		}

		if (!note.isSustainNote)
			boyfriend.playAnim('sing' + dir, true);

		if (UsingNewCam)
		{
			focusOnDadGlobal = false;
			ZoomCam(false);
		}

		playerStrums.forEach(function(spr:FlxSprite)
		{
			if (Math.abs(note.noteData) == spr.ID)
				spr.animation.play('confirm', true);
		});

		note.wasGoodHit = true;
		vocals.volume = 1;

		note.kill();
		notes.remove(note, true);
		note.destroy();

		updateAccuracy();
	}

	override function stepHit()
	{
		super.stepHit();

		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
			resyncVocals();

		switch (SONG.song.toLowerCase())
		{
			case 'furiosity':
				switch (curStep)
				{
					case 512 | 768:
						shakeCam = true;
					case 640 | 896:
						shakeCam = false;
					case 1305:
						boyfriend.canDance = false;
						gf.canDance = false;
						boyfriend.playAnim('hey', true);
						gf.playAnim('cheer', true);
						for (bgSprite in backgroundSprites)
							FlxTween.tween(bgSprite, {alpha: 0}, 1);
						for (bgSprite in normalDaveBG)
							FlxTween.tween(bgSprite, {alpha: 1}, 1);
						canFloat = false;
						var position = dad.getPosition();
						FlxG.camera.flash(FlxColor.WHITE, 0.25);
						remove(dad);
						dad = new Character(position.x, position.y, 'dave', false);
						add(dad);
						FlxTween.color(dad, 0.6, dad.color, nightColor);
						FlxTween.color(boyfriend, 0.6, boyfriend.color, nightColor);
						FlxTween.color(gf, 0.6, gf.color, nightColor);
						FlxTween.linearMotion(dad, dad.x, dad.y, 350, 260, 0.6, true);
				}
			case 'polygonized':
				switch (curStep)
				{
					case 1024 | 1312 | 1424 | 1552 | 1664:
						shakeCam = true;
						camZooming = true;
					case 1152 | 1408 | 1472 | 1600 | 2048 | 2176:
						shakeCam = false;
						camZooming = false;
					case 2432:
						boyfriend.canDance = false;
						gf.canDance = false;
						boyfriend.playAnim('hey', true);
						gf.playAnim('cheer', true);
				}
			case 'glitch':
				switch (curStep)
				{
					case 480 | 681 | 1390 | 1445 | 1515 | 1542 | 1598 | 1655:
						shakeCam = true;
						camZooming = true;
					case 512 | 688 | 1420 | 1464 | 1540 | 1558 | 1608 | 1745:
						shakeCam = false;
						camZooming = false;
				}
			case 'its-tave-time':
				switch (curStep)
				{
					case 1023:
						spinCam = true;
						resetCam = false;
						FlxG.camera.flash(FlxColor.WHITE, 1);
					case 1279:
						spinCam = false;
						resetCam = true;
						FlxG.camera.flash(FlxColor.WHITE, 1);
				}
		}

		#if desktop
		DiscordClient.changePresence(
			detailsText + " " + SONG.song + " (" + storyDifficultyText + ") ",
			"Acc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses,
			iconRPC, true, FlxG.sound.music.length - Conductor.songPosition
		);
		#end
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (!UsingNewCam)
		{
			if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
			{
				if (!PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
				{
					focusOnDadGlobal = true;
					ZoomCam(true);
				}

				if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
				{
					focusOnDadGlobal = false;
					ZoomCam(false);
				}
			}
		}

		if (generatedMusic)
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
		}

		if (dad.animation.finished)
		{
			switch (SONG.song.toLowerCase())
			{
				case 'tutorial':
					dad.dance();
					dadmirror.dance();
				default:
					if (dad.holdTimer <= 0 && curBeat % 2 == 0)
					{
						dad.dance();
						dadmirror.dance();
					}
			}
		}

		wiggleShit.update(Conductor.crochet);

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 8 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		switch (curSong.toLowerCase())
		{
			case 'furiosity':
				if ((curBeat >= 128 && curBeat < 160) || (curBeat >= 192 && curBeat < 224))
				{
					if (camZooming)
					{
						FlxG.camera.zoom += 0.015;
						camHUD.zoom += 0.03;
					}
				}
			case 'polygonized':
				switch (curBeat)
				{
					case 608:
						for (bgSprite in backgroundSprites)
							FlxTween.tween(bgSprite, {alpha: 0}, 1);
						for (bgSprite in normalDaveBG)
							FlxTween.tween(bgSprite, {alpha: 1}, 1);
						canFloat = false;
						var position = dad.getPosition();
						FlxG.camera.flash(FlxColor.WHITE, 0.25);
						remove(dad);
						dad = new Character(position.x, position.y, 'dave', false);
						add(dad);
						FlxTween.color(dad, 0.6, dad.color, nightColor);
						FlxTween.color(boyfriend, 0.6, boyfriend.color, nightColor);
						FlxTween.color(gf, 0.6, gf.color, nightColor);
						FlxTween.linearMotion(dad, dad.x, dad.y, 350, 260, 0.6, true);
				}
			case 'mealie':
				switch (curStep)
				{
					case 1776:
						var position = dad.getPosition();
						FlxG.camera.flash(FlxColor.WHITE, 0.25);
						remove(dad);
						dad = new Character(position.x, position.y, 'bambi-angey', false);
						dad.color = nightColor;
						add(dad);
				}
		}

		if (shakeCam)
			gf.playAnim('scared', true);

		var funny:Float = (healthBar.percent * 0.01) + 0.01;
		iconP1.setGraphicSize(Std.int(iconP1.width + (50 * funny)), Std.int(iconP2.height - (25 * funny)));
		iconP2.setGraphicSize(Std.int(iconP2.width + (50 * (2 - funny))), Std.int(iconP2.height - (25 * (2 - funny))));
		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0 && !shakeCam)
			gf.dance();

		if (curBeat % 2 == 0 && !boyfriend.animation.curAnim.name.startsWith("sing") && boyfriend.canDance)
		{
			boyfriend.playAnim('idle', true);
			if (darkLevels.contains(curStage) && SONG.song.toLowerCase() != "polygonized" && SONG.song.toLowerCase() != "furiosity")
				boyfriend.color = nightColor;
			else if (sunsetLevels.contains(curStage))
				boyfriend.color = sunsetColor;
			else
				boyfriend.color = FlxColor.WHITE;
		}

		if (curBeat % 8 == 7 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf')
		{
			dad.playAnim('cheer', true);
			boyfriend.playAnim('hey', true);
		}
	}

	public function addSplitathonChar(char:String):Void
	{
		boyfriend.stunned = true;
		remove(dad);
		dad = new Character(100, 100, char);
		add(dad);
		dad.color = nightColor;
		switch (dad.curCharacter)
		{
			case 'dave-splitathon':
				dad.y += 160;
				dad.x += 250;
			case 'bambi-splitathon':
				dad.x += 100;
				dad.y += 450;
		}
		boyfriend.stunned = false;
	}

	public function splitterThonDave(expression:String):Void
	{
		boyfriend.stunned = true;
		thing.x = -9000;
		thing.y = -9000;
		if (daveExpressionSplitathon != null)
			remove(daveExpressionSplitathon);
		daveExpressionSplitathon = new Character(-100, 260, 'dave-splitathon');
		add(daveExpressionSplitathon);
		daveExpressionSplitathon.color = nightColor;
		daveExpressionSplitathon.canDance = false;
		daveExpressionSplitathon.playAnim(expression, true);
		boyfriend.stunned = false;
	}

	public function preload(graphic:String):Void
	{
		if (boyfriend != null)
			boyfriend.stunned = true;
		var newthing:FlxSprite = new FlxSprite(9000, -9000).loadGraphic(Paths.image(graphic));
		add(newthing);
		remove(newthing);
		if (boyfriend != null)
			boyfriend.stunned = false;
	}

	public function splitathonExpression(expression:String, x:Float, y:Float):Void
	{
		if (SONG.song.toLowerCase() != 'splitathon')
			return;

		if (daveExpressionSplitathon != null)
			remove(daveExpressionSplitathon);

		if (expression != 'lookup')
			camFollow.setPosition(dad.getGraphicMidpoint().x + 100, boyfriend.getGraphicMidpoint().y + 150);

		boyfriend.stunned = true;
		thing.color = nightColor;
		thing.x = x;
		thing.y = y;
		remove(dad);

		switch (expression)
		{
			case 'bambi-what':
				thing.frames = Paths.getSparrowAtlas('splitathon/Bambi_WaitWhatNow');
				thing.animation.addByPrefix('uhhhImConfusedWhatsHappening', 'what', 24);
				thing.animation.play('uhhhImConfusedWhatsHappening');
			case 'bambi-corn':
				thing.frames = Paths.getSparrowAtlas('splitathon/Bambi_ChillingWithTheCorn');
				thing.animation.addByPrefix('justGonnaChillHereEatinCorn', 'cool', 24);
				thing.animation.play('justGonnaChillHereEatinCorn');
		}

		if (!splitathonExpressionAdded)
		{
			splitathonExpressionAdded = true;
			add(thing);
		}

		thing.antialiasing = true;
		boyfriend.stunned = false;
	}
}
