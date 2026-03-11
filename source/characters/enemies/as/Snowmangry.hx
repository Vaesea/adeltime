package characters.enemies.as;

import flixel.graphics.frames.FlxAtlasFrames;

class Snowmangry extends Enemy
{
    // Spritesheet
    // IF ANYONE WANTS TO WORK ON ART FOR THIS GAME THAT WOULD BE APPRECIATED BECAUSE I DONT KNOW HOW TO ANIMATE, ONLY ART. I JUST USED THE FREE TRANSFORM THING IN FIREALPACA FOR THIS.
    // WHY AM I USING CAPITAL LETTERS
    // WHAT THE FUCK :33333333
    var image = FlxAtlasFrames.fromSparrow("assets/images/characters/enemies/snowmangry.png", "assets/images/characters/enemies/snowmangry.xml");

    public function new(x:Float, y:Float)
    {
        super(x, y);

        // Spritesheet
        frames = image;

        // Set flipX to true because I forgot to flip the frames
        flipX = true;

        // Animations
        animation.addByPrefix('walk', 'walk', 8, true);
        animation.addByPrefix('squished', 'squished', 8, false);
        animation.play('walk');

        // Hitbox
        setSize(26, 78);
        offset.set(21, 15);
    }

    override private function move()
    {
        // Make him move, Enemy.hx handles the rest of what Snowmangry does.
        velocity.x = direction * walkSpeed;
        
        // Because he's not entirely in the center of the image
        if (direction == 1)
        {
            offset.set(17, 15);
        }
        else
        {
            offset.set(21, 15);
        }
    }
}