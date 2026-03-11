package characters.player;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

enum AdelStates
{
    Normal;
    Bomb;
}

class Adel extends FlxSprite
{
    // Movement
    var adelAcceleration = 2000;
    var deceleration = 1600;
    var gravity = 1000; // same as supertux???
    public var minJumpHeight = 512; // public because enemies, same number as supertux???
    public var maxJumpHeight = 576; // public because enemies, same number as, you guessed it, supertux???
    var walkSpeed = 400;
    
    // Health System
    var canTakeDamage = true;
    var invFrames = 1.0; // time it takes to be damaged after being damaged

    // Direction
    public var direction = 1; // public because held enemies

    // Holding Enemies (thanks anatolystev) (dont uncomment until held enemies are added!!!!)
    // public var heldEnemy:Enemy = null;

    // Self-explanatory
    public var currentState = Normal;

    // Bomb throwing variables (i'm literally just copying code from my game tux platforming (haxe version), why the fuck are these public)
    public var canThrow = true;
    public var throwCooldown = 1.0;

    // Cutscene
    public var inCutscene = false;

    // Spritesheet
    var image = FlxAtlasFrames.fromSparrow("assets/images/characters/player/adel.png", "assets/images/characters/player/adel.xml");

    public function new()
    {
        super();

        // Spritesheet
        frames = image;
        animation.addByPrefix("stand", "stand", false);
        animation.addByPrefix("walk", "walk", 8, true);
        animation.addByPrefix("jump", "jump", 8, false);
        animation.addByPrefix("prepare", "prepare", 8, false);
        animation.addByPrefix("sit", "sit", 8, false);
        animation.addByPrefix("angry", "angry", 8, false);
        animation.addByPrefix("blink", "blink", 8, false);
        animation.addByPrefix("dash", "dash", 8, false);

        // Hitbox
        setSize(30, 58);
        offset.set(10, 22);

        // Acceleration, deceleration and max velocity
        drag.x = deceleration;
        acceleration.y = gravity;
        maxVelocity.x = walkSpeed;
    }

    override public function update(elapsed:Float)
    {
        if (!inCutscene)
        {
            // Stop Adel from falling off the map through the left
            if (x < 0)
            {
                x = 0;
            }

            // Kill Adel when she falls into the void
            if (y > Global.PS.map.height - height)
            {
                // die();
            }

            move();
        }
        
        animate();

        // Put this after everything
        super.update(elapsed);
    }

    // Animate Adel
    function animate()
    {
        // If Adel is on the floor and staying where she is, do stand animation
        if (velocity.x == 0 && isTouching(FLOOR))
        {
            animation.play("stand");
        }
        
        // If Adel is on the floor and not staying where she is, do walk animation
        if (velocity.x != 0 && isTouching(FLOOR))
        {
            animation.play("walk");
        }

        // If Adel is not on the floor, do jump animation
        // TODO: Is velocity.y != 0 needed?
        if (velocity.y != 0 && !isTouching(FLOOR))
        {
            animation.play("jump");
        }
    }

    function move()
    {
        // Speed is 0 at beginning
        acceleration.x = 0;

        // If player presses left keys, walk left
        if (FlxG.keys.anyPressed([LEFT, A]))
        {
            flipX = true;
            direction = -1;
            acceleration.x -= adelAcceleration;
        }
        // If player presses right keys, walk right
        else if (FlxG.keys.anyPressed([RIGHT, D]))
        {
            flipX = false;
            direction = 1;
            acceleration.x += adelAcceleration;
        }

        // If player pressing jump keys and is on ground, jump
        if (FlxG.keys.anyJustPressed([SPACE, W, UP]) && isTouching(FLOOR))
        {
            if (velocity.x == walkSpeed || velocity.x == -walkSpeed)
            {
                velocity.y = -maxJumpHeight;
            }
            else
            {
                velocity.y = -minJumpHeight;
            }

            FlxG.sound.play("assets/sounds/jump.ogg");
        }
        
        // Variable Jump Height
        if (velocity.y < 0 && FlxG.keys.anyJustReleased([SPACE, W, UP]))
        {
            velocity.y -= velocity.y * 0.5;
        }
    }

}