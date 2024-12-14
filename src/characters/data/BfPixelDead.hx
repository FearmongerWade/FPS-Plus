package characters.data;

@charList(false)
class BfPixelDead extends CharacterInfoBase
{

    override public function new(){

        super();

        info.name = "bf-pixel-dead";
        info.spritePath = "week6/bfPixelsDEAD";
        info.frameLoadType = sparrow;
        
        info.iconName = "bf-pixel";
        info.facesLeft = true;
		info.antialiasing = false;

		addByPrefix('firstDeath', offset(), "BF Dies pixel", 24, loop(false));
		addByPrefix('deathLoop', offset(-6), "Retry Loop", 24, loop(true));
		addByPrefix('deathConfirm', offset(-6), "RETRY CONFIRM", 24, loop(false));

		addExtraData("scale", 6);
		addExtraData("deathSound", "gameOver/fnf_loss_sfx-pixel");
		addExtraData("deathSong", "gameOver/gameOver-pixel");
		addExtraData("deathSongEnd", "gameOver/gameOverEnd-pixel");
    }

}