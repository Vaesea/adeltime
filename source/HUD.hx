package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class HUD extends FlxState
{
    var coinText:FlxText;
    var healthText:FlxText;

    public function new()
    {
        super();

        coinText = new FlxText(4, 4, FlxG.width, "Coins: " + Global.coins, 18);
        coinText.setFormat("assets/fonts/Oswald-Medium.ttf", 18, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        coinText.scrollFactor.set();
        coinText.borderSize = 1.25;

        add(coinText);

        healthText = new FlxText(-4, 4, FlxG.width, "Health: " + Global.health + " / " + Global.maxHealth, 18);
        healthText.setFormat("assets/fonts/Oswald-Medium.ttf", 18, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        healthText.scrollFactor.set();
        healthText.borderSize = 1.25;
        
        add(healthText);
    }

    override public function update(elapsed:Float)
    {
        // Update coin text
        coinText.text = "Coins: " + Global.coins;

        // Update health text
        healthText.text = "Health: " + Global.health + " / " + Global.maxHealth;
        
        super.update(elapsed);
    }
}