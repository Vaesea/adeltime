package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

// Present Intro

class PresentIntroState extends FlxState
{
    var introText:FlxText;

    var speed = 20;
    var increaseOrDecreaseSpeed = 10;

    override public function create()
    {
        super.create();

        var bg = new FlxSprite();
        bg.loadGraphic("assets/images/cutscene/placeholder.png", false);
        add(bg);
        
        introText = new FlxText(-45, 440, FlxG.width, "
        -- The Beginning --
        
        Time is a powerful thing, especially because
        it's everywhere.
        
        However, now, a strange penguin wants to
        control time itself.
        He installs a time machine from a ruined
        temple into his base.
        
        He says to himself that creating his own
        personal future will be easy now!
        
        Another penguin named Adel learns of this
        base, and with her hatred for terrible
        factories that harm others, she decides
        to travel to destroy this base.

        She doesn't realize that her adventure
        will go through time itself.

        She hopes that turning this factory into 
        a clean shelter for penguins and other 
        animals will be easy.

        Adel visits Shelter Island to find this
        base, but she also finds enemies!

        Adel knows that only one penguin could've
        done this, that penguin being Volcanic 
        Penking!

        She thinks to herself that Volcanic Penking
        is up to no good, and must be stopped.

        So now, you must help Adel defeat Volcanic
        Penking, chasing him through different
        time periods to stop him!

        But beware, there are enemies that will try 
        to stop you on your way!
        
        Adel Time - Chapter 1 (PRESENT)
        
        Press SPACE to start.", 24);
        introText.setFormat("assets/fonts/Oswald-Medium.ttf", 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        introText.borderSize = 1.25;
        introText.moves = true;
        introText.velocity.y = -speed;
        add(introText);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.SPACE)
        {
            FlxG.switchState(PlayState.new); // Switch State
        }
        
        if (FlxG.keys.justPressed.DOWN)
        {
            introText.velocity.y -= increaseOrDecreaseSpeed;
        }
        else if (FlxG.keys.justPressed.UP)
        {
            introText.velocity.y += increaseOrDecreaseSpeed;
        }
    }
}