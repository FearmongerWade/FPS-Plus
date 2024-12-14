package characters.data;

class GuyLil extends CharacterInfoBase
{

    override public function new(){

        super();

        info.name = "guy-lil";
        info.spritePath = "chartEditor/lilOpp";
        info.frameLoadType = load(300, 256);
        
        info.iconName = "face-lil";
        info.antialiasing = false;

        add("idle", offset(), [0, 1], 12, loop(true));

		add("singLEFT", 	offset(),   [3, 4, 5], 		12, loop(true, 1));
		add("singDOWN", 	offset(),   [6, 7, 8], 		12, loop(true, 1));
		add("singUP", 	    offset(),   [9, 10, 11], 	12, loop(true, 1));
	    add("singRIGHT", 	offset(),   [12, 13, 14], 	12, loop(true, 1));

    }

}