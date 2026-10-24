package
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.net.SharedObject;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   
   public class Console extends Sprite
   {
      
      public static var _inputField:TextField;
      
      private var _openKey:int;
      
      private var _executeKey:int;
      
      private var _prevHistoryKey:int;
      
      private var _nextHistoryKey:int;
      
      private var _commandHistory:Array;
      
      private var _historyMax:Number;
      
      private var _showing:Boolean;
      
      private var _currHistoryIndex:int;
      
      private var _numCommandsInHistory:Number;
      
      private var _commandDelegates:Dictionary;
      
      private var _shared:SharedObject;
      
      public function Console(param1:Number, param2:Number)
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this._shared = SharedObject.getLocal("history");
         this._openKey = 0;
         this._executeKey = Keyboard.ENTER;
         this._prevHistoryKey = Keyboard.UP;
         this._nextHistoryKey = Keyboard.DOWN;
         this._historyMax = 20;
         this._showing = false;
         this._currHistoryIndex = 0;
         this._numCommandsInHistory = 0;
         if(this._shared.data.history)
         {
            this._commandHistory = this._shared.data.history as Array;
            this._numCommandsInHistory = this._commandHistory.length;
         }
         else
         {
            this._commandHistory = new Array();
            this._shared.data.history = this._commandHistory;
         }
         this._commandDelegates = new Dictionary();
         _inputField = addChild(new TextField()) as TextField;
         _inputField.type = TextFieldType.INPUT;
         _inputField.addEventListener(FocusEvent.FOCUS_OUT,this.onConsoleFocusOut);
         _inputField.defaultTextFormat = new TextFormat("Arial",14,16777215,false,false,false);
         graphics.beginFill(6710886,1);
         graphics.drawRect(0,0,param1,param2);
         graphics.endFill();
         _inputField.width = param1 - 4;
         _inputField.height = param2 - 4;
         _inputField.y = 4;
         _inputField.x = 4;
         _inputField.name = "console";
         this.makeConsoleInvisible();
      }
      
      public function clearStoredHistory() : void
      {
         this._shared.clear();
      }
      
      public function addCommand(param1:String, param2:Function) : void
      {
         this._commandDelegates[param1] = param2;
      }
      
      public function addCommandToHistory(param1:String) : void
      {
         var _loc2_:int = this._commandHistory.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._commandHistory.splice(_loc2_,1);
            --this._numCommandsInHistory;
         }
         this._commandHistory.push(param1);
         ++this._numCommandsInHistory;
         if(this._commandHistory.length > this._historyMax)
         {
            this._commandHistory.shift();
            --this._numCommandsInHistory;
         }
         this._shared.flush();
      }
      
      public function getPreviousHistoryCommand() : String
      {
         if(this._currHistoryIndex > 0)
         {
            --this._currHistoryIndex;
         }
         return this.getCurrentCommand();
      }
      
      public function getNextHistoryCommand() : String
      {
         if(this._currHistoryIndex < this._numCommandsInHistory)
         {
            ++this._currHistoryIndex;
         }
         return this.getCurrentCommand();
      }
      
      public function getCurrentCommand() : String
      {
         var _loc1_:String = this._commandHistory[this._currHistoryIndex];
         if(!_loc1_)
         {
            return "";
         }
         return _loc1_;
      }
      
      public function toggleConsole() : void
      {
         if(this._showing)
         {
            this.hideConsole();
         }
         else
         {
            this.showConsole();
         }
      }
      
      public function showConsole() : void
      {
         if(!this._showing)
         {
            this._showing = true;
            this.makeConsoleVisible();
            stage.focus = _inputField;
            stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyPressInConsole);
            this._currHistoryIndex = this._numCommandsInHistory;
         }
      }
      
      public function hideConsole() : void
      {
         if(this._showing)
         {
            this._showing = false;
            this.makeConsoleInvisible();
            stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyPressInConsole);
         }
      }
      
      public function clearConsole() : void
      {
         _inputField.text = "";
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         stage.addEventListener(KeyboardEvent.KEY_UP,this.onToggleKeyPress);
      }
      
      private function onConsoleFocusOut(param1:FocusEvent) : void
      {
      }
      
      private function onToggleKeyPress(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == this._openKey)
         {
            this.toggleConsole();
         }
      }
      
      private function onKeyPressInConsole(param1:KeyboardEvent) : void
      {
         var args:Array = null;
         var command:String = null;
         var func:Function = null;
         var expected:Number = NaN;
         var event:KeyboardEvent = param1;
         if(event.keyCode == this._executeKey)
         {
            if(_inputField.text == "" || _inputField.text == " ")
            {
               return;
            }
            this.addCommandToHistory(_inputField.text);
            args = _inputField.text.split(" ");
            command = args.shift();
            this.clearConsole();
            func = this._commandDelegates[command];
            if(this._commandDelegates[command] == undefined)
            {
               _inputField.text = "Unknown command: " + command;
            }
            if(func != null)
            {
               try
               {
                  func.apply(this,args);
               }
               catch(e:ArgumentError)
               {
                  expected = Number(e.message.slice(e.message.indexOf("Expected ") + 9,e.message.lastIndexOf(",")));
                  _inputField.text = expected + " parameters required for function: " + command;
               }
            }
         }
         else if(event.keyCode == this._prevHistoryKey)
         {
            _inputField.text = this.getPreviousHistoryCommand();
            event.preventDefault();
            _inputField.setSelection(_inputField.text.length,_inputField.text.length);
         }
         else if(event.keyCode == this._nextHistoryKey)
         {
            _inputField.text = this.getNextHistoryCommand();
            event.preventDefault();
            _inputField.setSelection(_inputField.text.length,_inputField.text.length);
         }
      }
      
      public function setConsoleText(param1:String) : void
      {
         _inputField.text = param1;
      }
      
      private function makeConsoleVisible() : void
      {
         this.visible = true;
      }
      
      private function makeConsoleInvisible() : void
      {
         this.visible = false;
      }
   }
}

