package bar;

import DialogueSystem.DialogueData;
import bar.DataObjects.CustomerObject;
import bar.DataObjects.DrinkObject;
import bar.Utils.DrinkObjectUtils;
import haxe.Json;

using StringTools;

// element example: [["A", "Description of A", ["ingredient 1", quantity_1]]]
typedef JSONDrinkData = Array<Array<Dynamic>>;

class DataParser {
    public static function parseDrinkFile(text:String):Map<String, DrinkObject> {
        var drinkMap:Map<String, DrinkObject> = [];
        var json:Array<Dynamic> = Json.parse(text).drinks;
        trace(json);
        for (i in json) {
            var name = i.name;
            var description = i.desc;
            var ingredients = i.ingredients;
            var shaken = i.shaken;
            var stirred = i.stirred;
            drinkMap.set(name, DrinkObjectUtils.createDrink(name, description, ingredients, shaken, stirred));    
        }
        
        return drinkMap;
    }

    public static function parseCustomersFile(text:String):Array<CustomerObject> {
        var custs:Array<CustomerObject> = [];
        var custData:Array<Dynamic> = cast Json.parse(text).customers;
        trace(custData);
        for (i in custData) {
            var custObj:CustomerObject = {
                name: i.name,
                beforeDialogue: i.beforeDialogue,
                afterDialogue: i.afterDialogue,
                request: {
                    drink: i.request.drink,
                    extras: [],
                    shaken: i.request?.shaken,
                    stirred: i.request?.stirred
                }
            }
            var extras:Array<Array<Dynamic>> = [];
            if (i.request.extras != null)
                extras = cast i.request.extras;
            for (j in extras) {
                custObj.request.extras[j[0]] = j[1];
            }

            custs.push(custObj);
        }
        return custs;
    }

    public static function parseDialogue(arr:Array<String>) {
        var dialogue:Array<DialogueData> = [];
        for (i in arr) {
            var idx = i.indexOf(':');
            var name = i.substring(0, idx);
            var text = i.substring(idx+1, i.length+1);
            var bracketLeftIdx = name.indexOf('<');
            var bracketRightIdx = name.indexOf('>');
            var expressionAndTime = name.substring(bracketLeftIdx+1, bracketRightIdx).split(',');
            var expression = "";
            var time = 0.06;
            if (expressionAndTime.length >= 1)
                expression = expressionAndTime[0];
            if (expressionAndTime.length >= 2)
                time = Std.parseFloat(expressionAndTime[1]);
                
            name = name.split('<')[0];

            dialogue.push({
                name: name,
                text: text,
                expression: expression,
                typeSpeed: time
            });
        }

        return dialogue;
    }
}