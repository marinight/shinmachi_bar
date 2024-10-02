package;

import bar.DataParser;

typedef DialogueData = {
    var name:String;
    var text:String;
    var expression:String;
    var typeSpeed:Float;
}

class DialogueManager {

    public var dialogue:Array<DialogueData> = [];
    var idx:Int = 0;
    public var ended:Bool = false;

    public function new(data:Array<String>) {
        parseDialogue(data);
    }
    
    public inline function parseDialogue(data:Array<String>)
        return dialogue = DataParser.parseDialogue(data);

    public inline function getCurDialogue()
        return dialogue[idx];

    public inline function next()
        return ended = ++idx >= dialogue.length - 1;
    
    
}
