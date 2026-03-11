package;

// SUPERTUX FONT IS A PLACEHOLDER

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class HUD extends FlxState
{
    var distroText:FlxText;

    public function new()
    {
        super();

        distroText = new FlxText(0, 4, FlxG.width, "Coins: " + Global.coins, 18);
        distroText.setFormat("assets/fonts/SuperTux-Medium.ttf", 18, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        distroText.scrollFactor.set();
        distroText.borderSize = 1.25;

        add(distroText);
    }

    override public function update(elapsed:Float)
    {
        // Update coin... uhhhh distro? Text
        distroText.text = "Coins: " + (Global.coins);
        
        super.update(elapsed);
    }
}