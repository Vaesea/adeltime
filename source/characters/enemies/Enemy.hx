package characters.enemies;

// Very simple Jumping Enemy fix by AnatolyStev
// Holding Enemy code originally by AnatolyStev, improved by Vaesea.

import characters.player.Adel;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.sound.FlxSound;
import flixel.util.FlxTimer;

enum EnemyStates
{
    Alive;
    Dead;
}

enum CarryableEnemyStates
{
    Normal;
    Squished;
    MovingSquished;
    Held; // Holding Enemy added by AnatolyStev
}

class Enemy extends FlxSprite
{
    var fallForce = 128;
    var dieFall = false;

    var currentState = Alive;

    // Koopa-Like Enemy stuff
    public var canBeHeld = false;
    public var currentHeldEnemyState = Normal;
    public var held:Adel = null;
    var waitToCollide:Float = 0;
    var damageOthers = false;
    var jumpsWhenHittingWall = false;
    var hitWallJumpHeight = 256;

    var canFireballDamage = true;

    var gravity = 1000;
    var walkSpeed = 120;
    var jumpHeight = 128;
    var scoreAmount = 50;
    var loadWhenLevelLoads = false;
    public var direction = -1;
    var appeared = false;

    var fallSound:FlxSound;

    public function new(x:Float, y:Float)
    {
        super(x, y);
        immovable = false;
        acceleration.y = gravity;
        
        fallSound = FlxG.sound.load("assets/sounds/snare2.ogg");
        fallSound.proximity(x, y, FlxG.camera.target, FlxG.width * 0.6);
    }

    override public function update(elapsed: Float)
    {
        if (waitToCollide > 0)
        {
            waitToCollide -= elapsed;
        }

        if (!loadWhenLevelLoads)
        {
            if (isOnScreen())
            {
                appeared = true;
            }

            if (appeared && alive)
            {
                move();

                if (justTouched(WALL))
                {
                    flipDirection();
                }
            }
        }

        if (loadWhenLevelLoads)
        {
            exists = true;
            appeared = true;
            move();
        }

        if (canBeHeld)
        {
            if (currentHeldEnemyState == Held && held != null)
            {
                if (held.flipX)
                {
                    x = held.x + 16; // no matter what i do this wont actually change where the snail is when tux is holding it and facing left
                }
                else if (!held.flipX)
                {
                    x = held.x + 16;
                }

                y = held.y;
                flipX = !held.flipX;
            }

            if (justTouched(WALL) && isOnScreen() && currentHeldEnemyState == MovingSquished)
            {
                FlxG.sound.play("assets/sounds/snare.ogg", 1.0, false);
            }
        }

        super.update(elapsed);
    }

    function flipDirection()
    {
        flipX = !flipX;
        direction = -direction;

        // TODO: make an enemy that uses this snail-like code
        if (jumpsWhenHittingWall && currentHeldEnemyState == MovingSquished)
        {
            velocity.y = -hitWallJumpHeight;
        }
    }

    function move()
    {
    }

    public function interact(adel:Adel)
    {
        checkIfInvincible(adel);

        var adelStomp = (adel.velocity.y > 0 && adel.y + adel.height < y + 10); // This checks for Adel stomping the enemy.

        if (!alive || waitToCollide > 0)
        {
            return;
        }

        if (currentHeldEnemyState == MovingSquished)
        {
            damageOthers = true;
        }

        FlxObject.separateY(adel, this);

        if (adelStomp) // Can't just do the simple isTouching UP thing because then if the player hits the corner of the enemy, they take damage. That's not exactly fair.
        {
            adel.y -= 1; // TODO: remove this when haxeflixel is good

            if (FlxG.keys.anyPressed([SPACE, UP, W]))
            {
                adel.velocity.y = -adel.maxJumpHeight;
            }
            else
            {
                adel.velocity.y = -adel.minJumpHeight / 2;
            }

            if (!canBeHeld)
            {
                kill();
            }
            else
            {
                waitToCollide = 0.25;

                if (currentHeldEnemyState == MovingSquished)
                {
                    currentHeldEnemyState = Squished;
                    animation.play("flat");
                    velocity.x = 0;
                }
                else if (currentHeldEnemyState == Squished)
                {
                    direction = adel.direction;
                    flipX = !adel.flipX;
                    currentHeldEnemyState = MovingSquished;
                    damageOthers = true;
                }
                else
                {
                    animation.play("flat");
                    currentHeldEnemyState = Squished;
                    velocity.x = 0;
                }
            }

            return;
        }

        if (canBeHeld && currentHeldEnemyState == Squished)
        {
            if (!isTouching(UP) && FlxG.keys.pressed.CONTROL && adel.heldEnemy == null)
            {
               adel.holdEnemy(this);
               return;
            }

            if (!adelStomp)
            {
                direction = adel.direction;
                flipX = !adel.flipX;
                currentHeldEnemyState = MovingSquished;
                damageOthers = true;
                FlxG.sound.play("assets/sounds/kick.ogg");
                waitToCollide = 0.25;
                return;
            }
        }

        // Shouldn't get this far unless Tux should actually be damaged.
        adel.takeDamage(1);
    }

    override public function kill()
    {
        currentState = Dead;
        
        if (dieFall == false)
        {
            FlxG.sound.play('assets/sounds/hit.ogg');
            alive = false;
            velocity.x = 0;
            acceleration.x = 0;
            immovable = true;
            animation.play("squished");

            new FlxTimer().start(2.0, function(_)
            {
                exists = false;
                visible = false;
            }, 1);
        }
        else
        {
            fallSound.setPosition(x + width / 2, y + height);
            fallSound.play();
            flipY = true;
            acceleration.x = 0;
            velocity.y = -fallForce;
            solid = false;
        }
    }

    public function killFall()
    {
        dieFall = true;
        kill();
    }

    public function collideOtherEnemy(otherEnemy:Enemy)
    {
        if (otherEnemy.damageOthers == true)
        {
            killFall();
        }
    }

    /*
    public function collideFireball(fireball:Fireball)
    {
        fireball.kill();
        if (canFireballDamage)
        {
            killFall();
        }
    }
    */

    public function pickUp(adel:Adel)
    {
        if (canBeHeld)
        {
            if (currentHeldEnemyState != Squished || held != null)
            {
                return;
            }

            currentHeldEnemyState = Held;
            held = adel;
            solid = false;
            velocity.x = 0;
            velocity.y = 0;
            animation.play("flat");
        }
    }

    public function enemyThrow()
    {
        if (canBeHeld == true)
        {
            if (currentHeldEnemyState != Held || held == null)
            {
                return;
            }

            currentHeldEnemyState = MovingSquished;
            direction = held.direction;
            flipX = !held.flipX;
            solid = true;
            damageOthers = true;
            held = null;
            waitToCollide = 0.25;
            FlxG.sound.play("assets/sounds/kick.ogg");
        }
    }

    function checkIfInvincible(adel:Adel)
    {
        if (adel.invincible)
        {
            killFall();
        }
    }
}