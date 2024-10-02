package bar;

typedef DrinkObject = {
    var name:String;
    var description:String;
    var ingredients:Map<String, Int>;
    var shaken:Bool;
    var stirred:Bool;
}

typedef DrinkRequest = {
    var drink:String;
    var extras:Map<String, Int>; // ice, sugar
    var shaken:Bool;
    var stirred:Bool;
}

typedef CustomerObject = {
    var name:String;
    var beforeDialogue:Array<String>;
    var afterDialogue:Array<String>;
    var request:DrinkRequest;
}

