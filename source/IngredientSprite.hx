package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

using StringTools;

class IngredientSprite extends FlxSprite {
    public var ingredient:String;
    public function new(x:Float, y:Float, ingredient:String) {
        super(x, y);
        this.ingredient = ingredient;
        loadGraphic('assets/images/' + ingredient.replace(' ', '_')+'.png');
        updateHitbox();
    }

    override function update(elapsed:Float) {
        if (FlxG.mouse.overlaps(this) && FlxG.mouse.justPressed)
            onClick();
        super.update(elapsed);
    }

    function onClick() {
        PlayState.instance.addIngredient(ingredient, 1);
        trace('Added ingredient ${ingredient}. Quantity: ${PlayState.instance.getIngredientFromCup(ingredient)}');
    }
}