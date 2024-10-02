package;
import DialogueSystem.DialogueManager;
import bar.DataObjects;
import bar.DataParser;
import bar.Ingredients;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxSignal;
import flixel.util.FlxTimer;
import lime.utils.Assets;

class PlayState extends FlxState
{


	inline static final CAM_MODE_CUSTOMER = 0;
	inline static final CAM_MODE_DRINK = 1;
	var camMode:Int = CAM_MODE_CUSTOMER;
	var canMoveCamera:Bool = true;

	public static var instance:PlayState;

	var customerSpriteStartX:Float = 24;
	var customerSpriteEndX:Float = 391;
	var customerSpriteEndY:Float = 293;
	var camCustomerX:Float = 0;
	var camDrinkX:Float = 280;

	var serveIdx:Int = -1;
	var dayFinished:Bool = false;
	public var drinks:Map<String, DrinkObject> = [];
	public var customers:Array<CustomerObject> = [];
	
	var curCustomer:CustomerObject;
	var curCustomerSprite:FlxSprite;
	var customerInteractionsAllowed:Bool = false;

	public var servingCup:Map<String, Int> = [];
	var custDrinkRequest:DrinkRequest;
	var custDrinkIngr:Map<String, Int> = [];

	var curDrinkShaken:Bool;
	var curDrinkStirred:Bool;
	

	override public function create()
	{
		PlayState.instance = this;
		drinks = DataParser.parseDrinkFile(Assets.getText("assets/data/drinks.json"));
		customers = DataParser.parseCustomersFile(Assets.getText("assets/data/customers.json"));
		super.create();
		tests();
		createScene();
	}

	function tests() {
	}

	var background:FlxSprite;
	var bartendingArea:FlxSprite;

	function createScene() {
		background = new FlxSprite().loadGraphic("assets/images/bar_background.png");
		add(background);
		bartendingArea = new FlxSprite().loadGraphic("assets/images/bartending_area.png");
		add(bartendingArea);
		nextCustomer();
		addIngredient("Water", 1);
		trace(checkDrink());
		customerArrived.add(() -> {
			var box = new DialogueBox(0, 0, curCustomer.beforeDialogue, "default");
			box.setPosition(80, FlxG.height - 20 - box.height);
			add(box);
			box.type();
		});
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (canMoveCamera) {
			if (FlxG.keys.justPressed.A && camMode != CAM_MODE_CUSTOMER) {
				FlxTween.tween(camera.scroll, {x: camCustomerX}, .5, {onComplete: _ -> {
					camMode = CAM_MODE_CUSTOMER;
				}});
			} else if (FlxG.keys.justPressed.D && camMode != CAM_MODE_DRINK) {
				FlxTween.tween(camera.scroll, {x: camDrinkX}, .5, {onComplete: _ -> {
					camMode = CAM_MODE_DRINK;
				}});
			} 
		}
	}

	public function addIngredient(ingredient:String, quantity:Int) {
		if (servingCup.exists(ingredient)) {
			servingCup[ingredient] += quantity;
		} else {
			servingCup[ingredient] = quantity;
		}
	}

	public inline function addSugar(quantity:Int) {
        addIngredient("Sugar", quantity);
    }

    public inline function addIce() {
		addIngredient("Ice", 1);
    }

	public function getIngredientFromCup(ingr:String) {
		return servingCup[ingr];
	}
	inline function getDrink(name:String) {
		return drinks[name];
	}

	function nextCustomer() {
		if (serveIdx < customers.length-1) {
			serveIdx++;
			curCustomer = customers[serveIdx];
			custDrinkRequest = curCustomer.request;
			custDrinkIngr = getDrink(custDrinkRequest.drink).ingredients;
			for (i => j in custDrinkRequest.extras) {
				if (custDrinkIngr.exists(i)) {
					custDrinkIngr[i] += j;
				} else {
					custDrinkIngr[i] = j;
				}
				
			}
			curDrinkShaken = false;
			curDrinkStirred = false;
			trace(curCustomer);
			customerStart(curCustomer.name);
		} else {
			dayFinished = true;
		}
	}

	function serveDrink() {
		trace(custDrinkIngr, servingCup);
		if (checkDrink()) {
			// good response
			trace("correct drink");
			servingCup = [];
		} else {
			// bad response
			trace("wrong drink");
		}
	}

	function checkDrink() {
		if (custDrinkRequest.shaken != curDrinkShaken || custDrinkRequest.stirred != curDrinkStirred) return false;
		for (i => j in servingCup) {
			if (!custDrinkIngr.exists(i) || custDrinkIngr[i] != j) return false;
		}

		return true;
	}

	var walkStepTime:Float = .65;
	var nextCustomerTime:Float = 1;

	var customerArrived:FlxSignal = new FlxSignal();
	function customerStart(character:String) {
		trace(Assets.exists("assets/images/"+character+".png"));
		curCustomerSprite = new FlxSprite().loadGraphic("assets/images/"+character+".png");
		add(curCustomerSprite);
		curCustomerSprite.y = customerSpriteEndY-curCustomerSprite.height; 
		curCustomerSprite.x = -curCustomerSprite.width;
		

		new FlxTimer().start(walkStepTime, _ -> {
			trace(curCustomerSprite.x);
		});
		new FlxTimer().start(walkStepTime*2, _ -> {
			curCustomerSprite.x = (customerSpriteEndX+customerSpriteStartX)/4-curCustomerSprite.width/2;
		});
		new FlxTimer().start(walkStepTime*3, _ -> {
			curCustomerSprite.x = (customerSpriteEndX+customerSpriteStartX)/2-curCustomerSprite.width/2;
			customerInteractionsAllowed = true;
			customerArrived.dispatch();
		});
		
	}

	var customerLeft:FlxSignal = new FlxSignal();
	function customerEnd() {
		new FlxTimer().start(walkStepTime, _ -> {
			customerInteractionsAllowed = false;
		});
		new FlxTimer().start(walkStepTime*2, _ -> {
			curCustomerSprite.x = (customerSpriteEndX+customerSpriteStartX)/4-curCustomerSprite.width/2;
		});
		new FlxTimer().start(walkStepTime*3, _ -> {
			remove(curCustomerSprite);
			new FlxTimer().start(nextCustomerTime, _ -> {
				nextCustomer();
			});
			customerLeft.dispatch();
		});
	}
}
