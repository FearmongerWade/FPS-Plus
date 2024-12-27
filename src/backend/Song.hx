package backend;

import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;

using StringTools;

typedef SwagSong =
{
	var song:String;
	var notes:Array<SwagSection>;
	var bpm:Float;
	var speed:Float;

	var player1:String;
	var player2:String;
	var stage:String;
	var gf:String;
}

typedef SongEvents =
{
	var events:Array<Dynamic>;
}

typedef SongWeek = 
{
	var songs:Array<String>;   				// Pretty self explanatory
	var ?storyName:String;              	// Name of the file that's at the bottom of the story menu (week1, week2, etc)
	var ?displayName:String;           		// Name of the week SHOWN AT THE TOP RIGHT of the story menu
	var ?menuChars:Array<String>;      		// The funny characters shown in the story menu
	var ?storyOnly:Bool;               		// Check if you want you week to be only show the story menu
	var ?freeplayOnly:Bool;            		// Ditto but freeplay
	var ?diffs:Array<String>;               // Difficulties
}

class Song
{
	public static var default_diffs:Array<String> = ['easy', 'normal', 'hard'];
	public static var data:Array<SongWeek> = [
		{
			songs: ['Tutorial'],
			storyName: 'tutorial',
			displayName: 'Teaching Time',
			menuChars: ['', 'bf', 'gf']
		},
		{
			songs: ['Bopeebo', 'Fresh', 'Dadbattle'],
			storyName: 'week1',
			displayName: 'Daddy Dearest',
			menuChars: ['dad', 'bf', 'gf']
		},
		{
			songs: ['Spookeez', 'South', 'Monster'],
			storyName: 'week2',
			displayName: 'Spooky Month',
			menuChars: ['spooky', 'bf', 'gf']
		},
		{
			songs: ['Pico', 'Philly', 'Blammed'],
			storyName: 'week3',
			displayName: 'Gay Sex',
			menuChars: ['pico', 'bf', 'gf']
		},
		{
			songs: ['Satin-Panties', 'High', 'Milf'],
			storyName: 'week4',
			displayName: 'Mommy Must Murder',
			menuChars: ['mom', 'bf', 'gf']
		},
		{
			songs: ['Cocoa', 'Eggnog', 'Winter-Horrorland'],
			storyName: 'week5',
			displayName: 'Merry crisis',
			menuChars: ['parents', 'bf', 'gf']
		},
		{
			songs: ['Senpai', 'Roses', 'Thorns'],
			storyName: 'week6',
			displayName: 'Hating Simulator',
			menuChars: ['senpai', 'bf', 'gf']
		},
		{
			songs: ['Ugh', 'Guns', 'Stress'],
			storyName: 'week7',
			displayName: 'Tankman',
			menuChars: ['senpai', 'bf', 'gf']
		}
	];

	public static function getData(huh:Int)
	{
		var week = data[huh];

		if (week == null) 						week = {songs: []};
		if (week.storyName == null) 			week.storyName = '$huh';
		if (week.displayName == null) 			week.displayName = '';
		if (week.menuChars == null) 			week.menuChars = ['', '', ''];
		if (week.storyOnly == null)				week.storyOnly = false;
		if (week.freeplayOnly == null) 			week.freeplayOnly = false;
		if (week.diffs == null) 				week.diffs = default_diffs;

		return week;
	}

	public static function loadFromJson(jsonInput:String, ?folder:String):SwagSong
	{
		var rawJson = Utils.getText(Paths.json(folder.toLowerCase() + '/charts/' + jsonInput.toLowerCase())).trim();

		while (!rawJson.endsWith("}")) {
			rawJson = rawJson.substr(0, rawJson.length - 1);
		}

		return parseJSONshit(rawJson);
	}

	public static function parseJSONshit(rawJson:String):SwagSong
	{
		var swagShit:SwagSong = cast Json.parse(rawJson).song;
		return swagShit;
	}
	public static function parseEventJSON(rawJson:String):SongEvents
	{
		var swagShit:SongEvents = cast Json.parse(rawJson).events;
		return swagShit;
	}
}
