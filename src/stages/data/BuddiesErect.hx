package stages.data;

import stages.elements.*;

class BuddiesErect extends BaseStage
{

	var chartBlackBG:FlxSprite;

    public override function init(){

        name = "buddiesErect";
		startingZoom = 2.8;

		var lilStage = new FlxSprite(0, -34).loadGraphic(Paths.image("fpsPlus/lil/stageE"));
		addToBackground(lilStage);

		gf.visible = false;
		boyfriend.setPosition(0, -34);
		dad.setPosition(0, -34);

		useStartPoints = false;

		cameraMovementEnabled = false;
		extraCameraMovementAmount = 0;

		cameraStartPosition = new FlxPoint(256/2, 256/2);

    }

}