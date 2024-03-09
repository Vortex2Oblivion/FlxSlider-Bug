package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.ui.FlxUISlider;
import flixel.addons.ui.FlxUITooltip.FlxUITooltipStyle;
import flixel.addons.ui.FlxUITooltipManager.FlxUITooltipData;
import flixel.addons.ui.FlxUITooltipManager;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	var gridBG:FlxSprite;
	var boyfriend:FlxSprite;

	var bfAngleSpeed:Float = 1;

	var camHUD:FlxCamera;

	var zoomText:FlxText;

	var sliderSpeed:FlxUISlider;

	override public function create()
	{
		camHUD = new FlxCamera();
		FlxG.cameras.add(camHUD, false); // false so it's not a default camera
		camHUD.bgColor.alpha = 0;

		gridBG = FlxGridOverlay.create(10, 10, 6400, 4800);
		gridBG.scrollFactor.set(0, 0);
		gridBG.screenCenter();
		add(gridBG);

		boyfriend = new FlxSprite(85, 40);
		boyfriend.frames = FlxAtlasFrames.fromSparrow('Boyfriend_Assets.png', 'Boyfriend_Assets.xml');
		boyfriend.animation.addByPrefix('idle', 'BF idle dance', 24, true);
		boyfriend.animation.play('idle', true);
		boyfriend.antialiasing = true;
		add(boyfriend);

		zoomText = new FlxText();
		zoomText.cameras = [camHUD];
		zoomText.size = 16;
		zoomText.color = FlxColor.BLACK;
		add(zoomText);

		var infoText:FlxText = new FlxText();
		infoText.cameras = [camHUD];
		infoText.size = 16;
		infoText.color = FlxColor.BLACK;
		infoText.text = "Press 'E' to zoom in\nPress 'Q' to zoom out\n
		The bug is that the hitbox of the slider is not on the same\ncamera as the slider itself.
		This issue seems to have been fixed in a Psych Engine \npull request, shadowing the class
		Press SPACE to view this pull request.";
		add(infoText);
		infoText.y = 250;

		sliderSpeed = new FlxUISlider(this, 'bfAngleSpeed', 480, 0, 0.1, 100);
		sliderSpeed.cameras = [camHUD];
		sliderSpeed.nameLabel.text = 'Boyfriend Rotation Speed';
		add(sliderSpeed);
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		boyfriend.angle += elapsed * bfAngleSpeed;

		FlxG.watch.addQuick("boyfriend.x", boyfriend.x);
		FlxG.watch.addQuick("boyfriend.y", boyfriend.y);
		FlxG.watch.addQuick("boyfriend.angle", boyfriend.angle);
		FlxG.watch.addQuick("FlxG.camera.zoom", FlxG.camera.zoom);

		if (FlxG.keys.pressed.Q && FlxG.camera.zoom >= 0.1)
			FlxG.camera.zoom -= elapsed;
		else if (FlxG.keys.pressed.E && FlxG.camera.zoom < 1)
			FlxG.camera.zoom += elapsed;

		zoomText.text = 'FlxG.camera.zoom: ${FlxMath.roundDecimal(FlxG.camera.zoom, 2)}';

		if (FlxG.keys.anyJustPressed([ENTER, SPACE]))
			FlxG.openURL("https://github.com/ShadowMario/FNF-PsychEngine/pull/13795");
	}
}
