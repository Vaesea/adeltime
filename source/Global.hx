package;

// Softcoded levels by AnatolyStev
// Worldmap and saving stuff by AnatolyStev
// Worldmap and saving is for later

import characters.player.Adel.AdelStates;
import flixel.util.FlxSave;
import lime.utils.Assets;
import states.PlayState;
import worldmap.WorldmapState;

class Global
{
    // Adel
    public static var coins = 0;
    public static var maxHealth = 3;
    public static var health = 3;
    public static var adelState:AdelStates = Normal;

    // Music
    public static var currentSong:String;

    // States
    public static var PS:PlayState;
    public static var WMS:WorldmapState;

    // Levels
    public static var currentLevel = 0;
    public static var levelName:String;
    public static var levelCreator:String;
    public static var levels:Array<String> = [];
    public static var dotLevelName = ""; // dont be null

    // Checkpoints
    public static var checkpointReached = false;

    // Worldmaps
    public static var worldmaps:Array<String> = [];
    public static var currentWorldmap = 0;
    public static var worldmapName:String;
    public static var worldmapCreator:String;
    public static var currentSection:String;
    public static var adelWorldmapX:Float = 0; // These are floats, not ints.
    public static var adelWorldmapY:Float = 0; // These are floats, not ints.

    // Completed Levels and Sections
    public static var completedLevels:Array<String> = [];
    public static var completedSections:Array<String> = [];

    // Save File
    public static var saveVersion = 1;
    public static var saveFile:FlxSave = new FlxSave();
    public static var saveName = "AdelTimeSave";

    public static function initSave()
    {
        saveFile.bind(saveName);
    }

    public static function saveProgress()
    {
        if (!saveFile.bind(saveName))
        {
            return;
        }

        if (saveFile.data != null)
        {
            saveFile.data.saveVersion = saveVersion;
            saveFile.data.completedLevels = completedLevels;
            saveFile.data.currentWorldmap = currentWorldmap;
            saveFile.data.adelWorldmapX = adelWorldmapX;
            saveFile.data.adelWorldmapY = adelWorldmapY;
            saveFile.data.coins = coins;
            saveFile.data.adelState = adelState;

            saveFile.flush();
        }
    }

    public static function loadProgress()
    {
        if (saveFile.data != null)
        {
            if (Reflect.hasField(saveFile.data, "completedLevels"))
            {
                completedLevels = saveFile.data.completedLevels;
            }
            
            if (Reflect.hasField(saveFile.data, "currentWorldmap"))
            {
                currentWorldmap = saveFile.data.currentWorldmap;
            }

            if (Reflect.hasField(saveFile.data, "adelWorldmapX"))
            {
                adelWorldmapX = saveFile.data.adelWorldmapX;
            }

            if (Reflect.hasField(saveFile.data, "adelWorldmapY"))
            {
                adelWorldmapY = saveFile.data.adelWorldmapY;
            }

            if (Reflect.hasField(saveFile.data, "coins"))
            {
                coins = saveFile.data.coins;
            }

            if (Reflect.hasField(saveFile.data, "adelState"))
            {
                adelState = saveFile.data.adelState;
            }

            if (!Reflect.hasField(saveFile.data, "saveVersion"))
            {
                saveFile.data.saveVersion = saveVersion;
            }
        }
    }

    public static function eraseSave()
    {
        saveFile.erase();
        saveFile.flush();
        saveFile.bind(saveName);
        Global.completedLevels = [];
        Global.coins = 0;
        Global.currentWorldmap = 0;
    }

    public static function loadWorldmaps()
    {
        worldmaps = Assets.getText("assets/data/worldmaps.txt").split("\n").map(StringTools.trim).filter(function(l) return l != "");
    }

    // this code finally being used after like 4 months
    public static function loadLevels()
    {
        levels = Assets.getText("assets/data/levels.txt").split("\n").map(StringTools.trim).filter(function(l) return l != ""); // apparently this used to be two lines
    }
}