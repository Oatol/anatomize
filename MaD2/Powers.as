package
{
   import com.bit101.components.HUISlider;
   import com.yahoo.astra.fl.controls.AutoComplete;
   import com.yahoo.astra.fl.controls.Tree;
   import com.yahoo.astra.fl.controls.treeClasses.TreeDataProvider;
   import com.yahoo.astra.fl.events.DropdownEvent;
   import fl.data.DataProvider;
   import fl.events.ListEvent;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class Powers
   {
      
      public static var settingsNeedSaving:Boolean = false;
      
      public static var favPowers:Array = [];
      
      public static var scrollPos:Number = -1;
      
      public function Powers()
      {
         super();
      }
      
      public static function updatePowerProperties(param1:XML = null) : void
      {
         var searchOffset:Number;
         var listIcon:Sprite;
         var prevIcon:Sprite;
         var nextIcon:Sprite;
         var pind:int;
         var icon:Bitmap;
         var random:BitmapData;
         var list:BitmapData;
         var powW:Number;
         var icons:Array;
         var xp:Number;
         var yp:Number;
         var powerIcon:Sprite = null;
         var randomIcon:Sprite = null;
         var prevPower:String = null;
         var nextPower:String = null;
         var item:DisplayObject = null;
         var actf:TextFormat = null;
         var tf:TextField = null;
         var format:TextFormat = null;
         var acLib:AutoComplete = null;
         var j:int = 0;
         var radfield:HUISlider = null;
         var tadfield:HUISlider = null;
         var spdfield:HUISlider = null;
         var sprfield:HUISlider = null;
         var profield:HUISlider = null;
         var node:XML = param1;
         if(!node)
         {
            node = R.xml_powers.node.(@func == Tool.current)[0];
         }
         GameState.ui.menuTools.title = node.@label;
         GameState.ui.menuTools.collapseInsteadOfMinimising = false;
         if(GameState.ui.menuTools.isMinimised)
         {
            GameState.ui.menuTools.expand();
         }
         GameState.ui.menuTools.removeAllChildren();
         GameState.ui.menuTools.movePosition(48);
         searchOffset = 24;
         powerIcon = new Sprite();
         randomIcon = new Sprite();
         listIcon = new Sprite();
         prevIcon = new Sprite();
         nextIcon = new Sprite();
         pind = favPowers.indexOf(Tool.currentPower);
         if(pind != -1)
         {
            if(pind == 0)
            {
               pind = int(favPowers.length);
            }
            prevPower = favPowers[pind - 1];
            pind = favPowers.indexOf(Tool.currentPower);
            if(pind == favPowers.length - 1)
            {
               pind = -1;
            }
            nextPower = favPowers[pind + 1];
         }
         icon = new Bitmap(R.getSprite("tool_" + Tool.current));
         icon.scaleX = icon.scaleY = 2.5;
         icon.name = "icon";
         powerIcon.addChild(icon);
         powerIcon.x = (GameState.ui.menuTools.maxWidth - powerIcon.width) * 0.5;
         powerIcon.y = 56 + searchOffset;
         random = new BitmapData(20,20,true,0);
         random.copyPixels(R.getSprite("iconiteminfomed"),new Rectangle(0,0,20,20),new Point(0,0),null,null,true);
         icon = randomIcon.addChild(new Bitmap(random)) as Bitmap;
         icon.y = -10;
         icon.x = -10;
         icon.name = "icon";
         list = new BitmapData(20,20,true,0);
         list.copyPixels(R.getSprite("iconlist"),new Rectangle(0,0,20,20),new Point(0,0),null,null,true);
         icon = listIcon.addChild(new Bitmap(list)) as Bitmap;
         icon.y = -10;
         icon.x = -10;
         icon.name = "icon";
         powW = icon.width;
         if(prevPower)
         {
            icon = new Bitmap(R.getSprite("tool_" + prevPower));
            icon.x = -16;
            icon.y = -16;
            prevIcon.addChildAt(icon,0).name = "prevIcon";
         }
         if(nextPower)
         {
            icon = new Bitmap(R.getSprite("tool_" + nextPower));
            icon.x = -16;
            icon.y = -16;
            nextIcon.addChildAt(icon,0).name = "nextIcon";
         }
         new BigJuicyMenuButton(prevIcon,null,1.2);
         new BigJuicyMenuButton(listIcon,null,1.2);
         new BigJuicyMenuButton(randomIcon,null,1.2);
         new BigJuicyMenuButton(nextIcon,null,1.2);
         GameState.ui.menuTools.addOther(powerIcon);
         GameState.ui.menuTools.addOther(prevIcon);
         GameState.ui.menuTools.addOther(listIcon);
         GameState.ui.menuTools.addOther(randomIcon);
         GameState.ui.menuTools.addOther(nextIcon);
         randomIcon.name = "random";
         listIcon.name = "list";
         prevIcon.name = "prev";
         nextIcon.name = "next";
         powerIcon.addEventListener(MouseEvent.MOUSE_DOWN,powerIconPressed);
         powerIcon.addEventListener(MouseEvent.MOUSE_OVER,powerIconHovered);
         randomIcon.addEventListener(MouseEvent.MOUSE_DOWN,powerRandomPressed);
         randomIcon.addEventListener(MouseEvent.MOUSE_OVER,powerRandomHovered);
         listIcon.addEventListener(MouseEvent.MOUSE_DOWN,powerListPressed);
         listIcon.addEventListener(MouseEvent.MOUSE_OVER,powerListHovered);
         prevIcon.addEventListener(MouseEvent.MOUSE_DOWN,powerPrevPressed);
         prevIcon.addEventListener(MouseEvent.MOUSE_OVER,powerPrevHovered);
         nextIcon.addEventListener(MouseEvent.MOUSE_DOWN,powerNextPressed);
         nextIcon.addEventListener(MouseEvent.MOUSE_OVER,powerNextHovered);
         icons = [prevIcon,listIcon,randomIcon,nextIcon];
         xp = GameState.ui.menuTools.actualWidth * 0.5 + 10;
         yp = powerIcon.y + powerIcon.height + 4 + searchOffset;
         for each(item in icons)
         {
            if(item.visible)
            {
               item.x = xp;
               item.y = yp;
               xp += 26;
               j = 0;
               while(j < icons.length)
               {
                  icons[j].x -= 20;
                  j++;
               }
            }
         }
         nextIcon.x -= 4;
         prevIcon.x += 4;
         nextIcon.y -= 60;
         prevIcon.y -= 60;
         actf = new TextFormat(Tweak.FONT,12,GameState.ui.menuTools.FONTCOLOUR,true);
         actf.align = TextFormatAlign.CENTER;
         actf.bold = true;
         tf = new TextField();
         tf.width = GameState.ui.menuTools.maxWidth - 2;
         tf.height = 28 * 2;
         tf.multiline = true;
         tf.wordWrap = true;
         tf.backgroundColor = 16711680;
         tf.setTextFormat(actf);
         tf.defaultTextFormat = actf;
         tf.name = "powertext";
         tf.mouseEnabled = false;
         tf.text = node.@tooltip;
         GameState.ui.menuTools.addOther(tf);
         tf.y = 24 + searchOffset;
         GameState.ui.menuTools.movePosition(48 + searchOffset);
         if(!Tool.power.noPressRadius)
         {
            radfield = GameState.ui.menuTools.addSlider("Press Radius",Tweak.toolRadius,10,200,150);
            radfield.originalValueSnap = 5;
            radfield.addEventListener(Event.CHANGE,powerRadiusChanged);
         }
         if(!Tool.power.noThrow)
         {
            if(!Tool.power.noThrowRadius)
            {
               tadfield = GameState.ui.menuTools.addSlider("Throw Radius",Tweak.toolThrowRadius,10,100,150);
               tadfield.originalValueSnap = 5;
               tadfield.addEventListener(Event.CHANGE,powerThrowRadiusChanged);
            }
            if(!Tool.power.noThrowSpeed)
            {
               spdfield = GameState.ui.menuTools.addSlider("Throw Speed",Tweak.toolSpeed,1,50,150);
               spdfield.originalValueSnap = 0;
               spdfield.addEventListener(Event.CHANGE,powerSpeedChanged);
            }
            if(!Tool.power.noThrowSpread)
            {
               sprfield = GameState.ui.menuTools.addSlider("Throw Spread",Tweak.toolSpread,1,100,150);
               sprfield.originalValueSnap = 5;
               sprfield.addEventListener(Event.CHANGE,powerSpreadChanged);
            }
            if(!Tool.power.noThrowAmount)
            {
               profield = GameState.ui.menuTools.addSlider("Throw Projectiles",Tweak.toolProjectiles,1,12,150);
               profield.originalValueSnap = 0;
               profield.addEventListener(Event.CHANGE,powerProjectilesChanged);
            }
         }
         if(!Tool.power.noDuration)
         {
            profield = GameState.ui.menuTools.addSlider("Effect Duration",Tweak.toolDuration,1,30);
            profield.originalValueSnap = 0;
            profield.addEventListener(Event.CHANGE,powerDurationChanged);
         }
         if(!Tool.power.noEffectRadius)
         {
            profield = GameState.ui.menuTools.addSlider("Effect Radius",Tweak.toolEffectRadius,10,150);
            profield.originalValueSnap = 0;
            profield.addEventListener(Event.CHANGE,powerEffectRadiusChanged);
         }
         if(!Tool.power.noEffectForce)
         {
            profield = GameState.ui.menuTools.addSlider("Effect Force",Tweak.toolEffectForce,10,200);
            profield.originalValueSnap = 0;
            profield.addEventListener(Event.CHANGE,powerEffectForceChanged);
         }
         GameState.ui.menuTools.addTooltip("Press Radius","Area of effect on press.\n\n");
         GameState.ui.menuTools.addTooltip("Throw Radius","Thrown projectiles spawn in the radius randomly.\n\n\n");
         GameState.ui.menuTools.addTooltip("Throw Speed","Throwing speed multiplier.\n\n");
         GameState.ui.menuTools.addTooltip("Throw Spread","Throwing spread.\n\n");
         GameState.ui.menuTools.addTooltip("Throw Projectiles","Projectile count when throwing.\n\n");
         GameState.ui.menuTools.addTooltip("Effect Duration","Duration of the power\'s effect in seconds.\n\n");
         GameState.ui.menuTools.addTooltip("Effect Radius","Radius of the power\'s effect.\n\n");
         GameState.ui.menuTools.addTooltip("Effect Force","Force of the power\'s effect.\n\n");
         if(!GameState.ui.menuTools.undocked)
         {
            GameState.ui.menuTools.x = GameState.ui.menuControls.x - GameState.ui.menuTools.maxWidth - 4;
            GameState.ui.menuTools.y = GameState.ui.menuControls.y;
         }
         format = new TextFormat(Tweak.FONT,14,GameState.ui.menuTools.FONTCOLOUR,true);
         format.align = TextFormatAlign.CENTER;
         actf = new TextFormat(Tweak.FONT,14,GameState.ui.menuTools.FONTCOLOUR,true);
         actf.align = TextFormatAlign.CENTER;
         actf.bold = true;
         acLib = new AutoComplete();
         acLib.name = "autoComplete";
         acLib.textField.name = "autoCompleteField";
         acLib.textField.text = "Search...";
         acLib.textField.embedFonts = true;
         acLib.textField.defaultTextFormat = format;
         acLib.textField.setTextFormat(format);
         acLib.setStyle("textFormat",format);
         acLib.textField.background = true;
         acLib.textField.backgroundColor = GameState.ui.menuTools.FIELDBACKGROUNDCOLOUR;
         acLib.textField.cacheAsBitmap = true;
         acLib.setStyle("borderThickness",-2);
         acLib.tabEnabled = false;
         acLib.tabChildren = false;
         acLib.keysEnabled = false;
         acLib.textField.addEventListener(FocusEvent.FOCUS_IN,function(param1:FocusEvent):*
         {
            param1.currentTarget.text = "";
            acLib.setStyle("textFormat",actf);
            acLib.rowCount = int((GameState.ui.menuLibrary.height - 50) / 24);
         });
         acLib.textField.addEventListener(FocusEvent.FOCUS_OUT,function(param1:FocusEvent):*
         {
            if(param1.currentTarget.text == "")
            {
               param1.currentTarget.text = "Search...";
               acLib.setStyle("textFormat",format);
            }
         });
         acLib.x = Window.BUFFER * 2;
         acLib.width = GameState.ui.menuTools.actualWidth - Window.BUFFER * 4;
         acLib.dropdown.rowHeight = 24;
         acLib.addEventListener(DropdownEvent.CLOSE,GameState.ui.autocompletePowers);
         acLib.dataProvider = new DataProvider(R.xml_powers);
         GameState.ui.menuTools.addOther(acLib);
         GameState.ui.menuTools.maximiseHeight = GameState.ui.menuTools.fieldPosition;
         GameState.ui.menuTools.maximise();
      }
      
      private static function powerSpeedChanged(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuTools.getValue("Throw Speed"));
         if(_loc2_ > 50)
         {
            _loc2_ = 50;
            GameState.ui.menuTools.setValue("Throw Speed",int(_loc2_));
         }
         else if(_loc2_ < 0)
         {
            _loc2_ = 0;
            GameState.ui.menuTools.setValue("Throw Speed",int(_loc2_));
         }
         Tweak.toolSpeed = _loc2_;
         settingsNeedSaving = true;
      }
      
      private static function powerRadiusChanged(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuTools.getValue("Press Radius"));
         if(_loc2_ < 10)
         {
            _loc2_ = 10;
         }
         Tweak.toolRadius = _loc2_;
         settingsNeedSaving = true;
      }
      
      private static function powerThrowRadiusChanged(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuTools.getValue("Throw Radius"));
         if(_loc2_ < 10)
         {
            _loc2_ = 10;
         }
         Tweak.toolThrowRadius = _loc2_;
         settingsNeedSaving = true;
      }
      
      private static function powerSpreadChanged(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuTools.getValue("Throw Spread"));
         Tweak.toolSpread = _loc2_;
         settingsNeedSaving = true;
      }
      
      private static function powerProjectilesChanged(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuTools.getValue("Throw Projectiles"));
         Tweak.toolProjectiles = _loc2_;
         settingsNeedSaving = true;
      }
      
      private static function powerDurationChanged(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuTools.getValue("Effect Duration"));
         if(_loc2_ < 1)
         {
            _loc2_ = 1;
         }
         if(_loc2_ > 30)
         {
            _loc2_ = 30;
         }
         Tweak.toolDuration = _loc2_;
         settingsNeedSaving = true;
      }
      
      private static function powerEffectRadiusChanged(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuTools.getValue("Effect Radius"));
         if(_loc2_ < 1)
         {
            _loc2_ = 1;
         }
         if(_loc2_ > 150)
         {
            _loc2_ = 150;
         }
         Tweak.toolEffectRadius = _loc2_;
         settingsNeedSaving = true;
      }
      
      private static function powerEffectForceChanged(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuTools.getValue("Effect Force"));
         if(_loc2_ < 1)
         {
            _loc2_ = 1;
         }
         if(_loc2_ > 200)
         {
            _loc2_ = 200;
         }
         Tweak.toolEffectForce = _loc2_;
         settingsNeedSaving = true;
      }
      
      public static function powerListPressed(param1:MouseEvent) : void
      {
         UpdatePowerMenu();
      }
      
      public static function powerListHovered(param1:MouseEvent) : void
      {
         GameState.ui.showTooltip(GameState.ui.menuTools,"Power list",0,-1,GameState.ui.menuTools.actualWidth);
      }
      
      public static function powerIconPressed(param1:MouseEvent) : void
      {
         Tool.setTool(Tool.currentPower);
         GameState.ui.updateControls();
      }
      
      public static function powerIconHovered(param1:MouseEvent) : void
      {
         if(Tool.current == Tool.currentPower)
         {
            return;
         }
         GameState.ui.showTooltip(GameState.ui.menuTools,"Reselect Power",0,-1,GameState.ui.menuTools.actualWidth);
      }
      
      public static function powerPrevPressed(param1:MouseEvent) : void
      {
         var _loc2_:int = favPowers.indexOf(Tool.currentPower);
         if(_loc2_ == -1)
         {
            return;
         }
         if(_loc2_ == 0)
         {
            _loc2_ = int(favPowers.length);
         }
         Tool.setTool(favPowers[_loc2_ - 1]);
         GameState.ui.updateControls();
         updatePowerProperties();
      }
      
      public static function powerPrevHovered(param1:MouseEvent) : void
      {
         GameState.ui.showTooltip(GameState.ui.menuTools,"Previous Power",0,-1,GameState.ui.menuTools.actualWidth);
      }
      
      public static function powerNextPressed(param1:MouseEvent) : void
      {
         var _loc2_:int = favPowers.indexOf(Tool.currentPower);
         if(_loc2_ == -1)
         {
            return;
         }
         if(_loc2_ == favPowers.length - 1)
         {
            _loc2_ = -1;
         }
         Tool.setTool(favPowers[_loc2_ + 1]);
         GameState.ui.updateControls();
         updatePowerProperties();
      }
      
      public static function powerNextHovered(param1:MouseEvent) : void
      {
         GameState.ui.showTooltip(GameState.ui.menuTools,"Next Power",0,-1,GameState.ui.menuTools.actualWidth);
      }
      
      public static function powerRandomPressed(param1:MouseEvent) : void
      {
         var _loc2_:XMLList = R.xml_powers.node.@func;
         var _loc3_:String = _loc2_[int(Math.random() * _loc2_.length())];
         Tool.setTool(_loc3_);
         GameState.ui.updateControls();
         updatePowerProperties();
      }
      
      public static function powerRandomHovered(param1:MouseEvent) : void
      {
         GameState.ui.showTooltip(GameState.ui.menuTools,"Random power",0,-1,GameState.ui.menuTools.actualWidth);
      }
      
      public static function UpdatePowerMenu() : void
      {
         var isPower:Boolean;
         var wascollapsed:Boolean;
         var scrollpos:Number;
         var toolTree:Tree;
         var format:TextFormat = null;
         var actf:TextFormat = null;
         var acLib:AutoComplete = null;
         if(!GameState.ui.menuTools.visible)
         {
            return;
         }
         isPower = Tool.isPower;
         wascollapsed = false;
         scrollpos = 0;
         if(GameState.ui.menuTools.getTree("buttons"))
         {
            wascollapsed = GameState.ui.menuTools.isMinimised;
            GameState.ui.menuTools.getTree("buttons").removeEventListener(ListEvent.ITEM_CLICK,Main.instance.toolTreeClick);
         }
         GameState.ui.menuTools.removeAllChildren();
         GameState.ui.menuTools.movePosition(24);
         toolTree = GameState.ui.menuTools.addTree("buttons",R.xml_powers);
         toolTree.selectable = false;
         toolTree.addEventListener(ListEvent.ITEM_CLICK,Main.instance.toolTreeClick);
         toolTree.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,Main.instance.toolTreeDoubleClick);
         GameState.ui.menuTools.title = "Powers";
         GameState.ui.menuTools.maximiseHeight = 28 + 14 * 32;
         GameState.ui.menuTools.minWidth = 58;
         GameState.ui.menuTools.redraw();
         if(wascollapsed)
         {
            GameState.ui.menuTools.collapse();
         }
         updatePowersList();
         toolTree.verticalScrollPosition = scrollPos;
         format = new TextFormat(Tweak.FONT,14,GameState.ui.menuTools.FONTCOLOUR,true);
         format.align = TextFormatAlign.CENTER;
         actf = new TextFormat(Tweak.FONT,14,GameState.ui.menuTools.FONTCOLOUR,true);
         actf.align = TextFormatAlign.CENTER;
         actf.bold = true;
         acLib = new AutoComplete();
         acLib.name = "autoComplete";
         acLib.textField.name = "autoCompleteField";
         acLib.textField.text = "Search...";
         acLib.textField.embedFonts = true;
         acLib.textField.defaultTextFormat = format;
         acLib.textField.setTextFormat(format);
         acLib.setStyle("textFormat",format);
         acLib.textField.background = true;
         acLib.textField.backgroundColor = GameState.ui.menuTools.FIELDBACKGROUNDCOLOUR;
         acLib.textField.cacheAsBitmap = true;
         acLib.setStyle("borderThickness",-2);
         acLib.tabEnabled = false;
         acLib.tabChildren = false;
         acLib.keysEnabled = false;
         acLib.textField.addEventListener(FocusEvent.FOCUS_IN,function(param1:FocusEvent):*
         {
            param1.currentTarget.text = "";
            acLib.setStyle("textFormat",actf);
            acLib.rowCount = int((GameState.ui.menuLibrary.height - 50) / 24);
         });
         acLib.textField.addEventListener(FocusEvent.FOCUS_OUT,function(param1:FocusEvent):*
         {
            if(param1.currentTarget.text == "")
            {
               param1.currentTarget.text = "Search...";
               acLib.setStyle("textFormat",format);
            }
         });
         acLib.x = Window.BUFFER * 2;
         acLib.width = GameState.ui.menuTools.actualWidth - Window.BUFFER * 4;
         acLib.dropdown.rowHeight = 24;
         acLib.addEventListener(DropdownEvent.CLOSE,GameState.ui.autocompletePowers);
         acLib.dataProvider = new DataProvider(R.xml_powers);
         GameState.ui.menuTools.addOther(acLib);
      }
      
      public static function updatePowersList() : void
      {
         var fin:int = 0;
         var power:String = null;
         var toolstree:Tree = null;
         var thing:XMLList = null;
         var item:XML = null;
         var favxml:XML = <node label="Root Node"></node>;
         var powxml:XML = R.xml_powers;
         var funcs:XMLList = powxml.node.@func;
         var all:XMLList = powxml.node;
         var i:int = 0;
         favxml.appendChild(<node label="Reset Properties" func="resetpowers" center="true" tooltip="Reset power properties to default.&#10;&#10;"/>);
         for each(power in Powers.favPowers)
         {
            if(Tool.elementals.indexOf(power) != -1)
            {
               try
               {
                  thing = all.(@func == power);
                  fin = thing.childIndex();
                  if(fin != -1)
                  {
                     item = <node/>;
                     item.@func = "fav";
                     item.@label = all.@label[fin];
                     item.@func = all.@func[fin];
                     item.@ico = all.@ico[fin];
                     item.@tooltip = all.@tooltip[fin];
                     favxml.appendChild(item);
                  }
               }
               catch(e:Error)
               {
               }
               i++;
            }
         }
         favxml.appendChild(<node label="Modify List" func="modpowers" center="true" tooltip="Modify which powers are visible in the menu.&#10;&#10;"/>);
         toolstree = GameState.ui.menuTools.getTree("buttons");
         if(toolstree)
         {
            toolstree.dataProvider = new TreeDataProvider(favxml);
         }
      }
      
      public static function updatePowers() : void
      {
         var fin:int = 0;
         var power:String = null;
         var untickedpower:String = null;
         var thing:XMLList = null;
         var item:XML = null;
         var favxml:XML = <node label="Root Node"></node>;
         var powxml:XML = R.xml_powers;
         var funcs:XMLList = powxml.node.@func;
         var all:XMLList = powxml.node;
         var i:int = 0;
         var added:Array = [];
         for each(power in favPowers)
         {
            if(Tool.elementals.indexOf(power) != -1)
            {
               if(power != "modpowers")
               {
                  thing = all.(@func == power);
                  if(!(Boolean(thing) && thing.length == 0))
                  {
                     if(added.indexOf(power) == -1)
                     {
                        fin = thing.childIndex();
                        item = <node/>;
                        item.@func = "fav";
                        item.@label = all.@label[fin];
                        item.@power = all.@func[fin];
                        item.@toggleValue = fin == -1 ? 0 : 1;
                        favxml.appendChild(item);
                     }
                  }
               }
            }
         }
         for each(untickedpower in funcs)
         {
            if(favPowers.indexOf(untickedpower) == -1)
            {
               item = <node/>;
               item.@func = "fav";
               item.@label = all.@label[i];
               item.@power = all.@func[i];
               item.@toggleValue = "0";
               favxml.appendChild(item);
            }
            i++;
         }
         favxml.appendChild(<node label="Done" func="powback" center="true"/>);
         GameState.ui.menuTools.getTree("buttons").dataProvider = new TreeDataProvider(favxml);
      }
   }
}

