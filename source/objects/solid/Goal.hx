package objects.solid;

import characters.player.Adel;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxTimer; // wait until cutscene is added
import states.MainMenuState;
import states.PlayState;

class Goal extends FlxSprite
{
    public function new(x:Float, y:Float, width:Int, height:Int)
    {
        super(x, y);
        makeGraphic(width, height, FlxColor.TRANSPARENT);
        solid = true;
        immovable = true;
    }

    public function reach(adel:Adel)
    {
        if (solid) // TODO: Add cutscene
        {
            solid = false;

            Global.currentLevel += 1;
            Global.adelState = adel.currentState;

            // if (!Global.completedLevels.contains(Global.currentLevel))
            // {
            //     Global.completedLevels.push(Global.currentLevel);
            // }

            if (FlxG.sound.music != null) // Check if song is playing, if it is, stop song. This if statement is here just to avoid a really weird crash. May be useless now but wait until the level end cutscene is added and it wont be useless.
            {
                FlxG.sound.music.stop();
            }

            // Global.saveProgress();

            if (Global.currentLevel >= Global.levels.length)
            {
                FlxG.switchState(MainMenuState.new);
            }
            else
            {
                FlxG.switchState(PlayState.new);
            }
        }
    }
}