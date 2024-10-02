package;

import DialogueSystem;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class DialogueBox extends FlxSpriteGroup {

    var dMgr:DialogueManager;
    var dNameBox:FlxSprite;
    var dNameText:FlxText;
    var dBox:FlxSprite;
    var dText:FlxTypeText;
    var dBoxWidth:Float = 480;
    var dBoxHeight:Float = 120;
    var skin:String = "default";
    var ended:Bool;
    var finishedTyping:Bool;

    public function new(?x:Float,?y:Float, dialogue:Array<String>, ?skin:String = "default") {
        super(x,y);
        dMgr = new DialogueManager(dialogue);
        this.skin = skin;
        if (skin == "default") {
            dBox = new FlxSprite().makeGraphic(Std.int(dBoxWidth), Std.int(dBoxHeight));
            dText = new FlxTypeText(10, 10, Std.int(dBox.width - 10), "", 12, false);
            dText.color=FlxColor.BLACK;
        }
        updateHitbox();
        add(dBox);
        add(dText);
        dText.completeCallback = () -> {
            finishedTyping = true;
        }
    }

    public function appear() {
        dBox.visible = dText.visible = true;
    }

    public function type() {
        var data = dMgr.getCurDialogue();
        dText.resetText(data.text);
        dText.start(data.typeSpeed);
    }

    public function next() {

    }

    override function update(elapsed:Float) {
        ended = dMgr.ended;
        trace(dText.textField.text.length, dText.text.length);
        super.update(elapsed);
    }
}