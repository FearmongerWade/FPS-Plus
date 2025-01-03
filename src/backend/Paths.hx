package backend;

import flixel.graphics.frames.FlxAtlasFrames;

class Paths
{

    static final audioExtension:String = "ogg";

    inline static public function file(key:String, location:String, extension:String):String{

        var data:String = 'assets/$location/$key.$extension';
        return data;

    }

    inline static public function image(key:String, forceLoadFromDisk:Bool = false):Dynamic{

        var data:String = file(key, "images", "png");

        if(ImageCache.exists(data) && !forceLoadFromDisk)
            return ImageCache.get(data);
        else
        {
            if(!ImageCache.trackedAssets.contains(data))
                ImageCache.trackedAssets.push(data);
            
            return data;
        }
            
    }

    inline static public function xml(key:String, ?location:String = "images")
        return file(key, location, "xml");

    inline static public function text(key:String, ?location:String = "")
        return file(key, location, 'txt');

    inline static public function json(key:String, ?location:String = "songs")
        return file(key, location, "json");

    inline static public function sound(key:String)
        return file(key, "audio/sounds", audioExtension);

    inline static public function music(key:String)
        return file(key, "audio/music", audioExtension);

    inline static public function voices(key:String, type:String = "")
    {
        if(type.length > 0) type = "-" + type; 
        return 'assets/songs/$key/music/Voices$type.ogg';
    }

    inline static public function inst(key:String)
        return 'assets/songs/$key/music/Inst.ogg';

    inline static public function getSparrowAtlas(key:String)
        return FlxAtlasFrames.fromSparrow(image(key), xml(key));

    inline static public function getPackerAtlas(key:String)
        return FlxAtlasFrames.fromSpriteSheetPacker(image(key), text(key, "images"));

    inline static public function getTextureAtlas(key:String)
        return 'assets/images/$key';

    inline static public function video(key:String)
        return file(key, "videos", "mp4");
    
    inline static public function font(key:String)
        return 'assets/fonts/$key';
}