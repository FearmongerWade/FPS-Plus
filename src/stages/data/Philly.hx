package stages.data;

import stages.elements.*;

class Philly extends BaseStage
{

	var phillyCityLights:FlxSprite;
	var phillyCityLightsGlow:FlxSprite;

	var phillyTrain:FlxSprite;

	var trainSound:FlxSound;
	var unpauseSoundCheck:Bool = false;

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	var startedMoving:Bool = false;

	var windowColorIndex:Int = -1;
	final windowColors:Array<FlxColor> = [0x31A2FD, 0x31FD8C, 0xFB33F5, 0xFD4531, 0xFBA633];

    public override function init(){
        name = "philly";

		var bg:FlxSprite = new FlxSprite(-100, -20).loadGraphic(Paths.image('week3/philly/sky'));
		bg.antialiasing = true;
		bg.scrollFactor.set(0.1, 0.1);
		addToBackground(bg);

		var city:FlxSprite = new FlxSprite(-81, 52).loadGraphic(Paths.image('week3/philly/city'));
		city.scrollFactor.set(0.3, 0.3);
		city.setGraphicSize(Std.int(city.width * 0.85));
		city.updateHitbox();
		city.antialiasing = true;
		addToBackground(city);

		phillyCityLights = new FlxSprite(city.x + (71 * 0.85), city.y - (52 * 0.85)).loadGraphic(Paths.image("week3/philly/windowWhite"));
		phillyCityLights.scrollFactor.set(0.3, 0.3);
		phillyCityLights.setGraphicSize(Std.int(phillyCityLights.width * 0.85));
		phillyCityLights.updateHitbox();
		phillyCityLights.antialiasing = true;
		addToBackground(phillyCityLights);

		phillyCityLightsGlow = new FlxSprite(phillyCityLights.x, phillyCityLights.y).loadGraphic(Paths.image("week3/philly/windowWhiteGlow"));
		phillyCityLightsGlow.scrollFactor.set(0.3, 0.3);
		phillyCityLightsGlow.setGraphicSize(Std.int(phillyCityLightsGlow.width * 0.85));
		phillyCityLightsGlow.updateHitbox();
		phillyCityLightsGlow.antialiasing = true;
		phillyCityLightsGlow.blend = ADD;
		phillyCityLightsGlow.alpha = 0;
		addToBackground(phillyCityLightsGlow);

		changeLightColor();

		var streetBehind:FlxSprite = new FlxSprite(178, 50+97).loadGraphic(Paths.image('week3/philly/behindTrain'));
		streetBehind.antialiasing = true;
		addToBackground(streetBehind);

		phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('week3/philly/train'));
		phillyTrain.antialiasing = true;
		phillyTrain.visible = false;
		addToBackground(phillyTrain);

		trainSound = new FlxSound().loadEmbedded(Paths.sound('week3/train_passes'));
		FlxG.sound.list.add(trainSound);

		var street:FlxSprite = new FlxSprite(streetBehind.x-341, streetBehind.y-93).loadGraphic(Paths.image('week3/philly/street'));
		street.antialiasing = true;
		addToBackground(street);

		dadStart.set(450, 875);
		bfStart.x += 50;

		dadCameraOffset.set(-50, 0);
		bfCameraOffset.set(-75, 30);
    }

	public override function update(elapsed:Float){
		super.update(elapsed);

		if (trainMoving){
			trainFrameTiming += elapsed;

			if (trainFrameTiming >= 1 / 24){
				updateTrainPos();
				trainFrameTiming = 0;
			}
		}
	}

	public override function beat(curBeat){
		if (!trainMoving){
			trainCooldown += 1;
		}

		if (curBeat % 4 == 0){
			changeLightColor();
		}

		if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 12){
			trainCooldown = FlxG.random.int(0, 4);
			trainStart();
		}
	}

	public override function pause() {
		if(trainSound.playing){
			unpauseSoundCheck = true;
			trainSound.pause();
		}
	}

	public override function unpause() {
		if(unpauseSoundCheck){
			unpauseSoundCheck = false;
			trainSound.play(false);
		}
	}

	function changeLightColor(){
		windowColorIndex = FlxG.random.int(0, 4, [windowColorIndex]);
		phillyCityLights.color = windowColors[windowColorIndex];
		phillyCityLightsGlow.color = windowColors[windowColorIndex];
		FlxTween.cancelTweensOf(phillyCityLightsGlow);
		phillyCityLightsGlow.alpha = 0.9;
		FlxTween.tween(phillyCityLightsGlow, {alpha: 0}, (Conductor.crochet/1000) * 3.5, {ease: FlxEase.quadOut});
	}

	function trainStart():Void{
		trainMoving = true;
		trainSound.play(true);
	}

	function updateTrainPos():Void{
		if (trainSound.time >= 4700){
			startedMoving = true;
			gf.playAnim('hairBlow');
			phillyTrain.visible = true;
		}

		if (startedMoving){
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing){
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0){
					trainFinishing = true;
				}
			}

			if (phillyTrain.x < -4000 && trainFinishing){
				trainReset();
			}
		}
	}

	function trainReset():Void{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
		phillyTrain.visible = false;
	}
}