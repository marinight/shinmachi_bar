package bar;

import bar.DataObjects.DrinkObject;

class DrinkObjectUtils {
    public static function createDrink(name:String, description:String, ingredientsArray:Array<Array<Dynamic>>, shaken:Bool, stirred:Bool) {
        var drinkObject:DrinkObject = {
            name: name,
            description: description,
            ingredients: [],
            shaken: shaken,
            stirred: stirred
        }

        for (arr in ingredientsArray) {
            drinkObject.ingredients[arr[0]] = arr[1];
        }

        return drinkObject;
    }


}