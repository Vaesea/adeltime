package states;

import characters.enemies.Enemy;
import characters.player.Adel;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.group.FlxGroup.FlxTypedGroup; // wait until stuff like enemies are added
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import objects.solid.Goal;
import states.substates.IntroSubstate;

class PlayState extends FlxState
{
	public var map:FlxTilemap;
	public var uhoh = 1; // global ids are shit

	// Add things part 1
	public var adel(default, null):Adel;
	public var solidThings:FlxGroup;
	public var enemies(default, null):FlxTypedGroup<Enemy>;
	var hud:HUD;
	var entities:FlxGroup;

	public var checkpoint:FlxPoint;

	override public function create()
	{
		// Just so Global.PS actually works...
		Global.PS = this;

		Global.health = Global.maxHealth;

		// Add things part 2
		entities = new FlxGroup();
		solidThings = new FlxGroup(); // why is this not flxtypedgroup??????
		enemies = new FlxTypedGroup<Enemy>();
		adel = new Adel();
		hud = new HUD();

		// Set Adel's current state
		adel.currentState = Global.adelState;
		adel.reloadGraphics();

		var numberOfLevel = Global.levels[Global.currentLevel];

		LevelLoader.loadLevel(this, numberOfLevel);

		// Add things part 3
		entities.add(enemies);
		add(solidThings);
		add(map);
		add(entities);
		add(adel);
		add(hud);

		// Camera
		FlxG.camera.follow(adel, PLATFORMER);
		FlxG.camera.setScrollBoundsRect(0, 0, map.width, map.height, true);

		// Foreground Layer, just realized I added this in the worst way possible. Oh well, too bad!
		var foregroundLayer:TiledTileLayer = cast LevelLoader.tiledMap.getLayer("Foreground");
        
        var foregroundMap = new FlxTilemap();
        foregroundMap.loadMapFromArray(foregroundLayer.tileArray, LevelLoader.tiledMap.width, LevelLoader.tiledMap.height, "assets/images/tiles.png", 32, 32, uhoh);
        foregroundMap.solid = false;

		add(foregroundMap);

		// Start the Level Intro
		openSubState(new IntroSubstate(FlxColor.BLACK));

		trace(Global.checkpointReached);
		
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		updateCheckpoint();

		// Adel collision
		FlxG.collide(solidThings, adel, collideEntities);
		FlxG.overlap(entities, adel, collideEntities);

		// Entity collision
		FlxG.collide(solidThings, entities);
	}

	function collideEntities(entity:FlxSprite, adel:Adel)
	{
		if (Std.isOfType(entity, Goal))
		{
			(cast entity).reach(adel);
		}

		if (Std.isOfType(entity, Enemy))
		{
			(cast entity).interact(adel);
		}
	}

	function updateCheckpoint()
	{
		if (checkpoint == null || Global.checkpointReached)
		{
			return;
		}

		if (adel.x >= checkpoint.x)
		{
			trace("Checkpoint reached!");
			Global.checkpointReached = true;
			trace(Global.checkpointReached);
		}
	}
}