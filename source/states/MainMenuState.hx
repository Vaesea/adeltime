package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import openfl.system.System;

class MainMenuState extends FlxState
{
    var playButton:FlxButton;
    var eraseButton:FlxButton;

    override public function create()
    {
        super.create();
        
        // Check if song is playing, if it is, stop song. This if statement is here just to avoid a really weird crash.
        if (FlxG.sound.music != null)
        {
            FlxG.sound.music.stop();
        }

        // Play music
        FlxG.sound.playMusic("assets/music/misc/menu.ogg", 1);

        // Initialize save and load save file
        Global.initSave();
        Global.loadProgress();

        // Other stuff
        Global.health = Global.maxHealth;
        Global.currentLevel = 0;

        // If there's no save file, or there's no data in the save file, set everything to default.
        if (Global.saveFile.data == null)
        {
            Global.coins = 0;
            Global.saveProgress();
        }

        // Adding Title Screen background
        var bg = new FlxSprite();
        bg.loadGraphic("assets/images/menu/title.png", false);
        add(bg);

        // Adding button, will probably be replaced by an image?
        playButton = new FlxButton(0, 300, "Play Game", clickPlay);
        playButton.screenCenter(X);
        add(playButton);

        // Adding erase save data button
        eraseButton = new FlxButton(0, 350, "Erase Save", clickEraseSave);
        eraseButton.screenCenter(FlxAxes.X);
        // add(eraseButton);
    }

    function clickPlay()
    {
        // Remove button, may not be needed?
        remove(playButton, true);

        // Switch State
        FlxG.switchState(PresentIntroState.new);
    }

    function clickEraseSave()
    {
        // Remove buttons
        remove(eraseButton, true);
        remove(playButton, true);
        
        // Delete save file
        Global.eraseSave();

        // Exit game (Needed so deleting the save file works)
        System.exit(0);
    }
}