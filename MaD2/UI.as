package
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   import com.bit101.components.HUISlider;
   import com.bit101.components.Style;
   import com.hybrid.ui.ToolTip;
   import com.yahoo.astra.fl.controls.AutoComplete;
   import com.yahoo.astra.fl.controls.Tree;
   import com.yahoo.astra.fl.controls.treeClasses.TNode;
   import com.yahoo.astra.fl.controls.treeClasses.TreeDataProvider;
   import com.yahoo.astra.fl.events.DropdownEvent;
   import fl.data.DataProvider;
   import fl.events.ListEvent;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import triggers.Gun;
   
   public class UI
   {
      
      public var menuMain:Window;
      
      public var menuSettings:Window;
      
      public var menuObject:Window;
      
      public var menuKeymap:Window;
      
      public var menuKeyConfig:Window;
      
      public var menuPrompt:Window;
      
      public var menuSave:Window;
      
      public var menuSpawn:Window;
      
      public var menuLibrary:Window;
      
      public var menuEffects:Window;
      
      public var menuTools:Window;
      
      public var menuFavourite:Window;
      
      public var menuWorld:Window;
      
      public var menuColour:Window;
      
      public var menuControls:Window;
      
      public var menuDetails:Window;
      
      public var menuChallenge:Window;
      
      public var console:Console;
      
      public var genericToolTip:ToolTip;
      
      public function UI()
      {
         super();
      }
      
      public function init() : void
      {
         this.menuMain = new Window(172,28 + Window.BUFFER * 2,"Main",false);
         this.menuControls = new Window(136,28 + Window.BUFFER * 2,"Toolbox",false);
         this.menuSettings = new Window(200,28 + Window.BUFFER * 2,"Settings",true,true);
         this.menuWorld = new Window(200,28 + Window.BUFFER * 2,"Environment");
         this.menuObject = new Window(196,28 + Window.BUFFER * 2,"Properties",true,true,false,true);
         this.menuKeymap = new Window(136,28 + Window.BUFFER * 2,"Controls");
         this.menuKeyConfig = new Window(224,28 + Window.BUFFER * 2,"Keymapping");
         this.menuPrompt = new Window(400,28 + Window.BUFFER * 2,"Prompt",false,false);
         this.menuSave = new Window(248,28 + Window.BUFFER * 2,"Save");
         this.menuSpawn = new Window(300,28 + Window.BUFFER * 2,"Spawn",true,true,false,true);
         this.menuLibrary = new Window(250,28 + Window.BUFFER * 2,"Library",true,true,false,true);
         this.menuFavourite = new Window(200,28 + Window.BUFFER * 2,"Favourites",false,false);
         this.menuTools = new Window(164,280 + Window.BUFFER * 2,"Tools",true,true,false,true);
         this.menuColour = new Window(164,28 + Window.BUFFER * 2,"Colour",true,true);
         this.menuDetails = new Window(164,28 + Window.BUFFER * 2,"Details",true,true);
         this.menuEffects = new Window(200,28 + Window.BUFFER * 2,"Effects",true,true);
         this.menuChallenge = new Window(200,28 + Window.BUFFER * 2,"Contract",true,true);
         this.UpdateMenuStyle();
         this.menuPrompt.title = "Error";
         this.menuSave.title = "Content";
         this.genericToolTip = new ToolTip();
         this.genericToolTip.autoCleanUp = false;
      }
      
      public function initSpawnMenu(param1:Number, param2:Boolean = false) : void
      {
         var itemHolder:Sprite;
         var itempicsize:Number;
         var browsespr:Sprite;
         var itemPrev:MovieClip;
         var itemNext:MovieClip;
         var labicon:MovieClip;
         var labiconbmd:BitmapData;
         var flipicon:MovieClip;
         var flipiconbmd:BitmapData;
         var infoicon:MovieClip;
         var infoiconbmd:BitmapData;
         var favicon:MovieClip;
         var faviconbmd:BitmapData;
         var randomicon:MovieClip;
         var randomiconbmd:BitmapData;
         var searchicon:MovieClip;
         var searchiconbmd:BitmapData;
         var armouricon:MovieClip;
         var armouriconbmd:BitmapData;
         var settingicon:MovieClip;
         var settingiconbmd:BitmapData;
         var propertyicon:MovieClip;
         var propertyiconbmd:BitmapData;
         var skinicon:MovieClip;
         var skiniconbmd:BitmapData;
         var linkicon:MovieClip;
         var linkiconbmd:BitmapData;
         var customicon:MovieClip;
         var customiconbmd:BitmapData;
         var dollicon:MovieClip;
         var dolliconbmd:BitmapData;
         var gunicon:MovieClip;
         var guniconbmd:BitmapData;
         var tff:TextFormat;
         var tf:TextField;
         var actf:TextFormat;
         var ico:DisplayObject = null;
         var fontSize:Number = NaN;
         var ac:AutoComplete = null;
         var esiz:Number = NaN;
         var width:Number = param1;
         var preview:Boolean = param2;
         if(width < 160)
         {
            width = 160;
         }
         if(width > 400)
         {
            width = 400;
         }
         this.menuSpawn.removeAllChildren();
         if(preview)
         {
            this.menuSpawn.setSize(width - 56,width);
            this.menuSpawn.dulin = new Rectangle(4,22,width - 64,this.menuSpawn.height - 24);
            this.menuSpawn.redraw();
            return;
         }
         this.menuSpawn.setSize(width,width);
         itemHolder = new Sprite();
         itempicsize = width - Window.BUFFER * 4;
         itemHolder.graphics.beginFill(0,0);
         itemHolder.graphics.drawRect(0,0,itempicsize,itempicsize);
         itemHolder.name = "itemHolder";
         itemHolder.addEventListener(MouseEvent.MOUSE_DOWN,Main.instance.dragSpawn);
         itemHolder.x = Window.BUFFER * 2;
         itemHolder.y = Window.BUFFER * 2;
         browsespr = new Sprite();
         browsespr.name = "browsebuttons";
         browsespr.graphics.lineStyle(2,this.menuSpawn.BUTTONCOLOUR);
         browsespr.graphics.beginFill(this.menuSpawn.BACKGROUNDCOLOUR);
         browsespr.graphics.moveTo(8,itemHolder.height * 0.5 - 16);
         browsespr.graphics.lineTo(24,itemHolder.height * 0.5 - 8);
         browsespr.graphics.lineTo(24,itemHolder.height * 0.5 - 24);
         browsespr.graphics.lineTo(8,itemHolder.height * 0.5 - 16);
         browsespr.graphics.endFill();
         browsespr.graphics.lineStyle(2,this.menuSpawn.BUTTONCOLOUR);
         browsespr.graphics.beginFill(this.menuSpawn.BACKGROUNDCOLOUR);
         browsespr.graphics.moveTo(itemHolder.width - 8,itemHolder.height * 0.5 - 16);
         browsespr.graphics.lineTo(itemHolder.width - 24,itemHolder.height * 0.5 - 8);
         browsespr.graphics.lineTo(itemHolder.width - 24,itemHolder.height * 0.5 - 24);
         browsespr.graphics.lineTo(itemHolder.width - 8,itemHolder.height * 0.5 - 16);
         browsespr.graphics.endFill();
         itemPrev = new MovieClip();
         itemPrev.name = "itemprev";
         itemPrev.x = itemHolder.width - 29;
         itemPrev.y = itemHolder.height * 0.5;
         itemPrev.graphics.beginFill(0,0);
         itemPrev.graphics.drawRect(-25,-25,50,50);
         itemPrev.filters = [new DropShadowFilter(4,45,0,0.5,0,0)];
         itemNext = new MovieClip();
         itemNext.name = "itemnext";
         itemNext.x = 29;
         itemNext.y = itemHolder.height * 0.5;
         itemNext.graphics.beginFill(0,0);
         itemNext.graphics.drawRect(-25,-25,50,50);
         itemNext.filters = [new DropShadowFilter(4,45,0,0.5,0,0)];
         labicon = new MovieClip();
         labicon.name = "labicon";
         labicon.visible = false;
         labiconbmd = new BitmapData(20,20,true,0);
         labiconbmd.copyPixels(R.getSprite("iconmadlabmed"),new Rectangle(0,0,20,20),new Point(0,0),null,null,true);
         ico = labicon.addChild(new Bitmap(labiconbmd));
         ico.x = -10;
         ico.y = -10;
         ico.name = "icon";
         labicon.addEventListener(MouseEvent.MOUSE_OVER,this.labiconhovered);
         labicon.addEventListener(MouseEvent.MOUSE_DOWN,this.labiconpressed);
         flipicon = new MovieClip();
         flipicon.name = "flipicon";
         flipiconbmd = new BitmapData(20,20,true,0);
         flipiconbmd.copyPixels(R.getSprite("iconflipleft"),new Rectangle(0,0,20,20),new Point(0,0),null,null,true);
         ico = flipicon.addChild(new Bitmap(flipiconbmd));
         ico.x = -10;
         ico.y = -10;
         ico.name = "icon";
         flipicon.addEventListener(MouseEvent.MOUSE_DOWN,this.flipiconpressed);
         flipicon.addEventListener(MouseEvent.MOUSE_OVER,this.flipiconhovered);
         infoicon = new MovieClip();
         infoicon.name = "infoicon";
         infoicon.visible = false;
         infoiconbmd = new BitmapData(20,20,true,0);
         infoiconbmd.copyPixels(R.getSprite("iconiteminfomed"),new Rectangle(0,0,20,20),new Point(0,0),null,null,true);
         ico = infoicon.addChild(new Bitmap(infoiconbmd));
         ico.x = -10;
         ico.y = -10;
         ico.name = "icon";
         infoicon.addEventListener(MouseEvent.MOUSE_OVER,this.displayItemDetails);
         favicon = new MovieClip();
         favicon.name = "favicon";
         faviconbmd = new BitmapData(20,20,true,0);
         faviconbmd.copyPixels(R.getSprite("iconfavmed"),new Rectangle(0,0,20,20),new Point(0,0),null,null,true);
         ico = favicon.addChild(new Bitmap(faviconbmd));
         ico.x = -10;
         ico.y = -10;
         ico.name = "icon";
         favicon.visible = false;
         favicon.addEventListener(MouseEvent.MOUSE_DOWN,this.faviconpressed);
         favicon.addEventListener(MouseEvent.MOUSE_OVER,this.faviconhovered);
         randomicon = new MovieClip();
         randomicon.name = "randomicon";
         randomiconbmd = new BitmapData(20,20,true,0);
         randomiconbmd.copyPixels(R.getSprite("iconrandom"),new Rectangle(0,0,20,20),new Point(0,0),null,null,true);
         ico = randomicon.addChild(new Bitmap(randomiconbmd));
         ico.x = -10;
         ico.y = -10;
         ico.name = "icon";
         randomicon.addEventListener(MouseEvent.MOUSE_DOWN,this.randomiconpressed);
         randomicon.addEventListener(MouseEvent.MOUSE_OVER,this.randomiconhovered);
         searchicon = new MovieClip();
         searchicon.name = "searchicon";
         searchiconbmd = new BitmapData(20,20,true,0);
         searchiconbmd.copyPixels(R.getSprite("iconsearch"),new Rectangle(0,0,20,20),new Point(0,0),null,null,true);
         ico = searchicon.addChild(new Bitmap(searchiconbmd));
         ico.x = -10;
         ico.y = -10;
         ico.name = "icon";
         searchicon.addEventListener(MouseEvent.MOUSE_DOWN,this.searchiconpressed);
         searchicon.addEventListener(MouseEvent.MOUSE_OVER,this.searchiconhovered);
         armouricon = new MovieClip();
         armouricon.name = "armouricon";
         armouriconbmd = new BitmapData(20,20,true,0);
         armouriconbmd.copyPixels(R.getSprite("iconarmour"),new Rectangle(0,0,20,20),new Point(0,0),null,null,true);
         ico = armouricon.addChild(new Bitmap(armouriconbmd));
         ico.x = -10;
         ico.y = -10;
         ico.name = "icon";
         armouricon.addEventListener(MouseEvent.MOUSE_DOWN,this.armouriconpressed);
         armouricon.addEventListener(MouseEvent.MOUSE_OVER,this.armouriconhovered);
         settingicon = new MovieClip();
         settingicon.name = "settingicon";
         settingiconbmd = new BitmapData(20,20,true,0);
         settingiconbmd.copyPixels(R.getSprite("iconsettingsmed"),new Rectangle(0,0,20,20),new Point(0,0),null,null,true);
         ico = settingicon.addChild(new Bitmap(settingiconbmd));
         ico.x = -10;
         ico.y = -10;
         ico.name = "icon";
         settingicon.addEventListener(MouseEvent.MOUSE_DOWN,this.settingiconpressed);
         settingicon.addEventListener(MouseEvent.MOUSE_OVER,this.settingiconhovered);
         propertyicon = new MovieClip();
         propertyicon.name = "propertyicon";
         propertyiconbmd = new BitmapData(20,20,true,0);
         propertyiconbmd.copyPixels(R.getSprite("iconproperties"),new Rectangle(0,0,20,20),new Point(0,0),null,null,true);
         ico = propertyicon.addChild(new Bitmap(propertyiconbmd));
         ico.x = -10;
         ico.y = -10;
         ico.name = "icon";
         propertyicon.addEventListener(MouseEvent.MOUSE_DOWN,this.propertyiconpressed);
         propertyicon.addEventListener(MouseEvent.MOUSE_OVER,this.propertyiconhovered);
         skinicon = new MovieClip();
         skinicon.name = "skinicon";
         skiniconbmd = new BitmapData(20,20,true,0);
         skiniconbmd.copyPixels(R.getSprite("iconskin"),new Rectangle(0,0,20,20),new Point(0,0),null,null,true);
         ico = skinicon.addChild(new Bitmap(skiniconbmd));
         ico.x = -10;
         ico.y = -10;
         ico.name = "icon";
         skinicon.addEventListener(MouseEvent.MOUSE_DOWN,this.skiniconpressed);
         skinicon.addEventListener(MouseEvent.MOUSE_OVER,this.skiniconhovered);
         linkicon = new MovieClip();
         linkicon.name = "linkicon";
         linkiconbmd = new BitmapData(20,20,true,0);
         linkiconbmd.copyPixels(R.getSprite("iconlinkmed"),new Rectangle(0,0,20,20),new Point(0,0),null,null,true);
         ico = linkicon.addChild(new Bitmap(linkiconbmd));
         ico.x = -10;
         ico.y = -10;
         ico.name = "icon";
         linkicon.visible = false;
         linkicon.addEventListener(MouseEvent.MOUSE_OVER,this.linkiconhovered);
         customicon = new MovieClip();
         customicon.name = "customicon";
         customiconbmd = new BitmapData(20,20,true,0);
         customiconbmd.copyPixels(R.getSprite("iconcustommed"),new Rectangle(0,0,20,20),new Point(0,0),null,null,true);
         ico = customicon.addChild(new Bitmap(customiconbmd));
         ico.x = -10;
         ico.y = -10;
         ico.name = "icon";
         customicon.visible = false;
         customicon.addEventListener(MouseEvent.MOUSE_DOWN,this.customiconpressed);
         customicon.addEventListener(MouseEvent.MOUSE_OVER,this.customiconhovered);
         dollicon = new MovieClip();
         dollicon.name = "dollicon";
         dolliconbmd = new BitmapData(20,20,true,0);
         dolliconbmd.copyPixels(R.getSprite("iconskinblood"),new Rectangle(0,0,20,20),new Point(0,0),null,null,true);
         ico = dollicon.addChild(new Bitmap(dolliconbmd));
         ico.x = -10;
         ico.y = -10;
         ico.name = "icon";
         dollicon.visible = false;
         dollicon.addEventListener(MouseEvent.MOUSE_DOWN,this.dolliconpressed);
         dollicon.addEventListener(MouseEvent.MOUSE_OVER,this.dolliconhovered);
         gunicon = new MovieClip();
         gunicon.name = "gunicon";
         guniconbmd = new BitmapData(20,20,true,0);
         guniconbmd.copyPixels(R.getSprite("icongunsmith"),new Rectangle(0,0,20,20),new Point(0,0),null,null,true);
         ico = gunicon.addChild(new Bitmap(guniconbmd));
         ico.x = -10;
         ico.y = -10;
         ico.name = "icon";
         gunicon.visible = false;
         gunicon.addEventListener(MouseEvent.MOUSE_DOWN,this.guniconpressed);
         gunicon.addEventListener(MouseEvent.MOUSE_OVER,this.guniconhovered);
         new BigJuicyMenuButton(settingicon,null,1.2);
         new BigJuicyMenuButton(labicon,null,1.2);
         new BigJuicyMenuButton(flipicon,null,1.2);
         new BigJuicyMenuButton(favicon,null,1.2);
         new BigJuicyMenuButton(randomicon,null,1.2);
         new BigJuicyMenuButton(searchicon,null,1.2);
         new BigJuicyMenuButton(propertyicon,null,1.2);
         new BigJuicyMenuButton(skinicon,null,1.2);
         new BigJuicyMenuButton(customicon,null,1.2);
         new BigJuicyMenuButton(dollicon,null,1.2);
         new BigJuicyMenuButton(gunicon,null,1.2);
         new BigJuicyMenuButton(itemPrev,Main.instance.selectPrevItem,1.2);
         new BigJuicyMenuButton(itemNext,Main.instance.selectNextItem,1.2);
         tff = new TextFormat(Tweak.FONT,14,this.menuSpawn.FONTCOLOUR,true);
         tff.align = TextFormatAlign.CENTER;
         tf = new TextField();
         tf.embedFonts = true;
         tf.width = 48;
         tf.height = 24;
         tf.defaultTextFormat = tff;
         tf.setTextFormat(tff);
         tf.name = "favtf";
         favicon.addChild(tf);
         tf.y -= 10;
         tf.x -= 24;
         tf.selectable = false;
         tf.cacheAsBitmap = true;
         tf.mouseEnabled = false;
         actf = new TextFormat(Tweak.FONT,16,this.menuSpawn.FONTCOLOUR,true,false,false,null,null,"center");
         fontSize = 16;
         if(width < 200)
         {
            fontSize = 12;
         }
         actf.size = fontSize;
         ac = new AutoComplete();
         ac.name = "autoComplete";
         ac.textField.name = "autoCompleteField";
         ac.textField.text = "Search...";
         ac.textField.embedFonts = true;
         ac.textField.defaultTextFormat = actf;
         ac.textField.setTextFormat(actf);
         ac.textField.background = true;
         ac.textField.backgroundColor = this.menuSpawn.FIELDBACKGROUNDCOLOUR;
         ac.textField.cacheAsBitmap = true;
         ac.setStyle("borderThickness",-2);
         ac.tabEnabled = false;
         ac.tabChildren = false;
         ac.keysEnabled = false;
         ac.x = Window.BUFFER * 2 + 24;
         ac.y = 24 + itemHolder.y + itemHolder.height;
         ac.width = width - 56;
         ac.height = 28;
         ac.dropdown.rowHeight = 32;
         ac.textField.addEventListener(FocusEvent.FOCUS_IN,function(param1:FocusEvent):*
         {
            param1.currentTarget.text = "";
            ac.setStyle("textFormat",new TextFormat(Tweak.FONT,fontSize,menuSpawn.FONTCOLOUR,true,false,false,null,null,"center"));
         });
         ac.textField.addEventListener(FocusEvent.FOCUS_OUT,function(param1:FocusEvent):*
         {
            if(param1.currentTarget.text == "")
            {
               param1.currentTarget.text = "Search...";
               ac.setStyle("textFormat",new TextFormat(Tweak.FONT,fontSize,menuSpawn.FONTCOLOUR,true,false,false,null,null,"center"));
            }
         });
         ac.dataProvider = new DataProvider(Main.instance.acData);
         ac.addEventListener(DropdownEvent.CLOSE,this.autocompleter);
         searchicon.x = 14;
         searchicon.y = ac.y + 14;
         randomicon.x = ac.x + ac.width + 14;
         randomicon.y = ac.y + 14;
         if(World.toggleSpawnBG == 1)
         {
            esiz = width - Window.BUFFER * 4;
            this.menuSpawn.dulin = new Rectangle(Window.BUFFER * 2,22,esiz,esiz);
         }
         else
         {
            this.menuSpawn.dulin = null;
         }
         this.menuSpawn.addOther(itemHolder);
         this.menuSpawn.ignorePosition = true;
         this.menuSpawn.addOther(ac);
         this.menuSpawn.addOther(labicon);
         this.menuSpawn.addOther(favicon);
         this.menuSpawn.addOther(infoicon);
         this.menuSpawn.addOther(flipicon);
         this.menuSpawn.addOther(linkicon);
         this.menuSpawn.addOther(customicon);
         this.menuSpawn.addOther(dollicon);
         this.menuSpawn.addOther(gunicon);
         this.menuSpawn.addOther(settingicon);
         this.menuSpawn.addOther(propertyicon);
         this.menuSpawn.addOther(skinicon);
         this.menuSpawn.addOther(searchicon);
         this.menuSpawn.addOther(armouricon);
         this.menuSpawn.addOther(itemPrev);
         this.menuSpawn.addOther(itemNext);
         this.menuSpawn.addOther(randomicon);
         this.menuSpawn.ignorePosition = false;
         this.menuSpawn.movePosition(36);
         this.menuSpawn.redraw();
         Main.instance.updateSpawnPic();
         if(GameState.objects.spawnName)
         {
            Main.instance.librarySelect(GeneralUtils.objectToName(GameState.objects.spawnName),true);
         }
      }
      
      public function showEnvironments(param1:Event) : void
      {
         if(this.menuWorld.getSlider("Gravity"))
         {
            this.menuWorld.getSlider("Gravity").removeEventListener(Event.CHANGE,this.updateGravity);
            if(this.menuWorld.getSlider("Wind"))
            {
               this.menuWorld.getSlider("Wind").removeEventListener(Event.CHANGE,this.updateWind);
            }
            this.menuWorld.getSlider("Temperature").removeEventListener(Event.CHANGE,this.updateTemp);
            if(this.menuWorld.getField("Seed"))
            {
               this.menuWorld.getField("Seed").removeEventListener(Event.CHANGE,this.updateSeed);
            }
         }
         this.menuWorld.removeAllChildren();
         var _loc2_:Tree = this.menuWorld.addTree("environments",R.xml_environments,400,0,24);
         _loc2_.selectable = false;
         _loc2_.addEventListener(ListEvent.ITEM_CLICK,Main.instance.changeEnvironmentOnMenu);
         var _loc3_:TNode = _loc2_.findNode("label",GameState.environment.contentName);
         var _loc4_:int = _loc2_.showNode(_loc3_);
         if(_loc4_ != -1)
         {
            _loc2_.scrollToSelected();
         }
         else
         {
            _loc2_.openAllNodes();
         }
         this.menuWorld.title = "Environments";
      }
      
      public function showEnvironmentInfo() : void
      {
         if(GameState.environment.name == "custom")
         {
            return;
         }
         this.menuWorld.removeAllChildren();
         this.menuWorld.title = "Environment";
         this.showEnvironmentButtons();
         this.menuWorld.addSlider("Gravity",GameState.environment.gravity,-100,100);
         if(GameState.environment.enableWind)
         {
            this.menuWorld.addSlider("Wind",GameState.environment.wind,-100,100);
            this.menuWorld.getSlider("Wind").addEventListener(Event.CHANGE,this.updateWind);
         }
         this.menuWorld.addSlider("Temperature",GameState.environment.temperature,-200,200);
         if(GameState.environment.name.indexOf("lab") == -1)
         {
            if(GameState.environment.enableClutter)
            {
               this.menuWorld.addSlider("Clutter",100,0,300);
               this.menuWorld.addTooltip("Clutter","Background clutter density.\n\n");
               this.menuWorld.getSlider("Clutter").addEventListener(Event.CHANGE,this.updateClutterDensity);
            }
            if(GameState.environment.enableSeed)
            {
               this.menuWorld.addInput("Seed",Vars.seed,80,null,"0-9",6);
               this.menuWorld.getField("Seed").addEventListener(Event.CHANGE,this.updateSeed);
            }
         }
         this.menuWorld.addTooltip("Gravity","Gravity in m/s^2. Default: 20.\n\n");
         this.menuWorld.addTooltip("Wind","Wind force in m/s. Defaul: 0.\n\n");
         this.menuWorld.addTooltip("Temperature","Temperature in degrees. Default: 20.\n\n");
         this.menuWorld.addTooltip("Seed","Background random seed.\n\n");
         this.menuWorld.getSlider("Gravity").addEventListener(Event.CHANGE,this.updateGravity);
         this.menuWorld.getSlider("Temperature").addEventListener(Event.CHANGE,this.updateTemp);
         var _loc1_:XML = R.xml_environment.copy();
         var _loc2_:Tree = this.menuWorld.addTree("environment",_loc1_,100,0,24);
         _loc2_.selectable = false;
         _loc2_.addEventListener(ListEvent.ITEM_CLICK,Main.instance.handleTreeClick);
         this.updateEnvironmentInfo();
      }
      
      private function addButton(param1:Window, param2:String, param3:String, param4:b2Vec2) : void
      {
         var _loc5_:Sprite = new Sprite();
         var _loc6_:BitmapData = R.getSprite(param2);
         var _loc7_:BitmapData = new BitmapData(_loc6_.width,_loc6_.height,true,0);
         _loc7_.copyPixels(_loc6_,new Rectangle(0,0,_loc6_.width,_loc6_.height),new Point(0,0),null,null,true);
         var _loc8_:Bitmap = new Bitmap(_loc7_);
         _loc8_.name = "icon";
         _loc8_.x -= _loc7_.width * 0.5;
         _loc8_.y -= _loc7_.height * 0.5;
         _loc5_.addChild(_loc8_);
         _loc5_.x = param4.x;
         _loc5_.y = param4.y;
         _loc5_.name = param3;
         param1.addOther(_loc5_);
      }
      
      private function showEnvironmentButtons() : void
      {
         var icons:Array = null;
         var i:int = 0;
         var pos:b2Vec2 = null;
         var centre:b2Vec2 = new b2Vec2(this.menuWorld.actualWidth * 0.5,64);
         this.addButton(this.menuWorld,"iconworld","iconworld",centre);
         if(GameState.environment.enableWalls)
         {
            icons = ["iconwallR","iconwallD","iconwallL","iconwallU"];
            i = 0;
            while(i < icons.length)
            {
               pos = GeneralUtils.pointOnCircle(centre.x,centre.y,30,90 * i);
               this.addButton(this.menuWorld,icons[i],icons[i],pos);
               i++;
            }
         }
         icons = [];
         if(GameState.environment.enableWalls)
         {
            icons.push("iconskinwalls");
         }
         else
         {
            this.menuWorld.movePosition(24);
         }
         if(GameState.environment.enableBackground)
         {
            icons.push("iconskinbg");
         }
         i = 0;
         while(i < icons.length)
         {
            pos = new b2Vec2();
            pos.x = this.menuWorld.actualWidth * 0.5 - 28 + i * 56;
            pos.y = centre.y + 30;
            this.addButton(this.menuWorld,icons[i],icons[i],pos);
            i++;
         }
         new BigJuicyMenuButton(this.menuWorld.getChildByName("iconworld"),this.showEnvironments,1.2,"Change Environment\n");
         new BigJuicyMenuButton(this.menuWorld.getChildByName("iconwallR"),function():*
         {
            GameState.environment.wallR = !GameState.environment.wallR;
         },1.2,"Right Wall Toggle\n");
         new BigJuicyMenuButton(this.menuWorld.getChildByName("iconwallD"),function():*
         {
            GameState.environment.floor = !GameState.environment.floor;
         },1.2,"Floor Toogle\n");
         new BigJuicyMenuButton(this.menuWorld.getChildByName("iconwallL"),function():*
         {
            GameState.environment.wallL = !GameState.environment.wallL;
         },1.2,"Left Wall Toggle\n");
         new BigJuicyMenuButton(this.menuWorld.getChildByName("iconwallU"),function():*
         {
            GameState.environment.roof = !GameState.environment.roof;
         },1.2,"Roof Toggle\n");
         new BigJuicyMenuButton(this.menuWorld.getChildByName("iconskinwalls"),this.ColourEnvironmentWalls,1.2,"Wall Colour\n");
         new BigJuicyMenuButton(this.menuWorld.getChildByName("iconskinbg"),this.ColourEnvironmentBackground,1.2,"Background Colour\n");
         this.menuWorld.ignoreDrag("iconworld");
         this.menuWorld.ignoreDrag("iconwallR");
         this.menuWorld.ignoreDrag("iconwallD");
         this.menuWorld.ignoreDrag("iconwallL");
         this.menuWorld.ignoreDrag("iconwallU");
         this.menuWorld.ignoreDrag("iconskinwalls");
         this.menuWorld.ignoreDrag("iconskinbg");
      }
      
      internal function ColourEnvironmentWalls(param1:Event) : *
      {
         this.ColourEnvironment("walls",GraphicUtils.hexToString(GameState.environment.wallColour));
      }
      
      internal function ColourEnvironmentBackground(param1:Event) : *
      {
         this.ColourEnvironment("background",GraphicUtils.hexToString(GameState.environment.backgroundColour));
      }
      
      internal function ColourEnvironment(param1:String, param2:String) : *
      {
         if(this.menuColour.visible)
         {
            this.menuColour.toggle();
            return;
         }
         Main.instance.BeginColouring(param1,param2);
      }
      
      public function updateEnvironmentInfo() : void
      {
         var bgstr:String;
         var wallstr:String;
         var environmentXML:XML;
         var dataProvider:TreeDataProvider;
         if(this.menuWorld.title != "Environment")
         {
            return;
         }
         this.menuWorld.setValue("Gravity",GameState.environment.gravity);
         this.menuWorld.setValue("Wind",GameState.environment.wind);
         this.menuWorld.setValue("Temperature",GameState.environment.temperature);
         if(GameState.environment.enableSeed)
         {
            this.menuWorld.setValue("Seed",Vars.seed);
         }
         if(GameState.environment.enableClutter)
         {
            this.menuWorld.setValue("Clutter",GameState.environment.clutterDensity);
         }
         bgstr = "#" + uint(GameState.environment.backgroundColour).toString(16).toUpperCase();
         wallstr = "#" + uint(GameState.environment.wallColour).toString(16).toUpperCase();
         if(bgstr == "#0")
         {
            bgstr = "#000001";
         }
         if(wallstr == "#0")
         {
            wallstr = "#000001";
         }
         environmentXML = R.xml_environment.copy();
         environmentXML.appendChild(<node label="Loop" toggleValue="0" tooltip="Items exiting from one side enter on the opposite one.&#10;&#10;&#10;"/>);
         if(GameState.environment.enableWind)
         {
            environmentXML.appendChild(<node label="Auto Wind" tooltip="Wind direction changes randomly.&#10;&#10;"/>);
         }
         if(GameState.environment.enableFiller)
         {
            environmentXML.appendChild(<node label="Filler" tooltip="Enable filler colliders to make environments look less empty.&#10;&#10;&#10;"/>);
         }
         if(GameState.environment.enableParticles)
         {
            environmentXML.appendChild(<node label="Particles" tooltip="Toggles environment particle spawning.&#10;&#10;"/>);
         }
         if(GameState.environment.enableBackground)
         {
            environmentXML.node.(@label == "Background").@background = bgstr;
         }
         if(GameState.environment.enableWalls)
         {
            environmentXML.node.(@label == "Walls").@background = wallstr;
            environmentXML.node.(@label == "Floor").@toggleValue = GameState.environment.floor ? "1" : "0";
            environmentXML.node.(@label == "Roof").@toggleValue = GameState.environment.roof ? "1" : "0";
            environmentXML.node.(@label == "Left").@toggleValue = GameState.environment.wallL ? "1" : "0";
            environmentXML.node.(@label == "Right").@toggleValue = GameState.environment.wallR ? "1" : "0";
         }
         environmentXML.node.(@label == "Change Environment").@background = "#068210";
         environmentXML.node.(@label == "Sides").@toggleValue = GameState.environment.walls ? "1" : "0";
         environmentXML.node.(@label == "Particles").@toggleValue = GameState.environment.particles ? "1" : "0";
         environmentXML.node.(@label == "Loop").@toggleValue = GameState.environment.loop ? "1" : "0";
         environmentXML.node.(@label == "Auto Wind").@toggleValue = GameState.environment.autoWind ? "1" : "0";
         environmentXML.node.(@label == "Filler").@toggleValue = GameState.environment.filler ? "1" : "0";
         dataProvider = new TreeDataProvider(environmentXML);
         this.menuWorld.getTree("environment").dataProvider = dataProvider;
         if(!this.menuWorld.isMinimised)
         {
            this.menuWorld.maximiseHeight = 132 + this.menuWorld.sliders.length * 36 + (dataProvider.length + 1) * 24;
         }
      }
      
      public function updateJointProperties(param1:String) : void
      {
         var favxml:XML;
         var widfield:HUISlider;
         var items:int = 0;
         var radfield:HUISlider = null;
         var frefield:HUISlider = null;
         var damfield:HUISlider = null;
         var lowfield:HUISlider = null;
         var uppfield:HUISlider = null;
         var spdfield:HUISlider = null;
         var forfield:HUISlider = null;
         var joint:String = param1;
         this.menuTools.collapseInsteadOfMinimising = false;
         if(this.menuTools.isMinimised)
         {
            this.menuTools.expand();
         }
         this.menuTools.removeAllChildren();
         this.menuTools.addTree("buttons",R.xml_joints).selectable = false;
         this.menuTools.getTree("buttons").addEventListener(ListEvent.ITEM_CLICK,Main.instance.jointTreeClick);
         this.menuTools.getTree("buttons").height = 32;
         this.menuTools.title = "Joints";
         this.menuTools.maximiseHeight = 28 + 8 * 32;
         this.menuTools.minWidth = 42;
         if(Tool.isAJoint)
         {
            Tool.currentJointTool = Tool.current;
         }
         Tool.currentJoint = joint;
         favxml = <node label="Root Node">
							<node label="Back" func="togglejoints" center="true"/>
							<node label="Rejoint" func={Tool.currentJointTool} joint={joint} center="true" tooltip="Selects this joint again. Useful for changing tools without closing this window.&#10;&#10;&#10;"/>
						</node>;
         this.menuTools.fieldPosition = 24 + 26 * 2;
         if(joint != "weldjoint" && Tool.currentJointTool != "piston" && Tool.currentJointTool != "revolute")
         {
            favxml.appendChild(<node label="Center" func="center" toggleValue={Tweak.jointCenter ? "1" : "0"} tooltip="Place joint on the center of the body (default is cursor position).&#10;&#10;"/>);
            this.menuTools.movePosition(24);
         }
         this.menuTools.movePosition(24);
         if(joint != "bgjoint" && joint != "weldjoint")
         {
            favxml.appendChild(<node label="Collide" func="collide" toggleValue={Tweak.jointCollide ? "1" : "0"} tooltip="The two connected bodies are able to collide with each other.&#10;&#10;"/>);
            this.menuTools.movePosition(24);
         }
         if(joint == "revolute")
         {
            favxml.appendChild(<node label="Limited" func="limited" toggleValue={Tweak.jointLimited ? "1" : "0"} tooltip="Toggle joint/motor rotation limits."/>);
            favxml.appendChild(<node label="Motor" func="motor" toggleValue={Tweak.jointMotor ? "1" : "0"}/>);
            this.menuTools.movePosition(48);
         }
         if(Tool.currentJointTool == "piston")
         {
            items = 1;
            favxml.appendChild(<node label="Motor" func="motor" toggleValue={Tweak.jointMotor ? "1" : "0"}/>);
            favxml.appendChild(<node label="Length Limit" func="limited" toggleValue={Tweak.jointLimited ? "1" : "0"} tooltip="Toggle joint translation limit."/>);
            if(Tweak.jointLimited)
            {
               favxml.appendChild(<node label="Lower Limit" func="limitedLower" toggleValue={Tweak.jointLimitedLower ? "1" : "0"}/>);
               favxml.appendChild(<node label="Upper Limit" func="limitedUpper" toggleValue={Tweak.jointLimitedUpper ? "1" : "0"}/>);
               items += 2;
            }
            this.menuTools.movePosition(24 * items);
         }
         favxml.appendChild(<node label="Visible" func="visible" toggleValue={Tweak.jointVisible ? "1" : "0"} tooltip="Joint is visible when unpaused. Visibility may be toggled off globally in the Settings.&#10;&#10;"/>);
         this.menuTools.movePosition(24);
         favxml.appendChild(<node label="Colour" func="colour" center="true"/>);
         if(Tweak.jointColour)
         {
            favxml.node.(@label == "Colour").@background = "#" + Tweak.jointColour.toString(16);
         }
         else
         {
            favxml.node.(@label == "Colour").@background = "#" + Main.instance.skinOriginal;
         }
         widfield = this.menuTools.addSlider("Width",Tweak.jointWidth,2,10);
         widfield.addEventListener(Event.CHANGE,Main.instance.jointWidthChanged);
         widfield.originalValueSnap = 0;
         this.menuTools.addTooltip("Width","Joint draw line width.\n\n");
         if(Tool.currentJointTool != "somethingwithbreakforcedisabled")
         {
            radfield = this.menuTools.addSlider("Break",Tweak.jointForce * 0.001 >> 0,0,500);
            radfield.addEventListener(Event.CHANGE,Main.instance.jointBreakChanged);
            radfield.originalValueSnap = 0;
            this.menuTools.addTooltip("Break","Break force. 0 is unbreakable.\n\n");
         }
         if(joint == "ropejoint")
         {
            frefield = this.menuTools.addSlider("Frequency",Tweak.jointFrequency * 100 >> 0,0,500);
            damfield = this.menuTools.addSlider("Damping",Tweak.jointDamping * 100 >> 0,0,100);
            frefield.addEventListener(Event.CHANGE,Main.instance.jointFrequencyChanged);
            damfield.addEventListener(Event.CHANGE,Main.instance.jointDampingChanged);
            this.menuTools.addTooltip("Frequency","Springiness. Lower is stretchier.\n\n");
            this.menuTools.addTooltip("Damping","The damping ratio. 0 = no damping.\n\n");
         }
         else if(joint == "revolute")
         {
            if(Tweak.jointLimited)
            {
               lowfield = this.menuTools.addSlider("-Angle",Tweak.jointLower == -9000 ? 0 : Tweak.jointLower,-360,0);
               uppfield = this.menuTools.addSlider("+Angle",Tweak.jointUpper == 9000 ? 0 : Tweak.jointUpper,0,360);
               lowfield.addEventListener(Event.CHANGE,Main.instance.jointLowerAngleChanged);
               uppfield.addEventListener(Event.CHANGE,Main.instance.jointUpperAngleChanged);
            }
         }
         if(Tweak.jointMotor)
         {
            spdfield = this.menuTools.addSlider("Speed",Tweak.jointMotorSpeed,-100,100);
            forfield = this.menuTools.addSlider("Force",Tweak.jointMotorForce * 0.01 >> 0,0,100);
            spdfield.addEventListener(Event.CHANGE,Main.instance.jointMotorSpeedChanged);
            forfield.addEventListener(Event.CHANGE,Main.instance.jointMotorForceChanged);
            this.menuTools.addTooltip("Speed","Speed/Direction of the motor. Negative reverses direction. 0 is disabled.\n\n\n");
            this.menuTools.addTooltip("Force","Force/Torque of the motor. Requires non-zero speed.\n\n\n");
         }
         this.menuTools.getTree("buttons").dataProvider = new TreeDataProvider(favxml);
         this.menuTools.getTree("buttons").rowHeight = 24;
         this.menuTools.redraw();
      }
      
      public function itemtoname(... rest) : void
      {
         var _loc2_:String = rest.join(" ");
         this.console.setConsoleText(GeneralUtils.nameToObject(_loc2_));
      }
      
      public function itemtoxml(... rest) : void
      {
         var _loc7_:XMLList = null;
         var _loc8_:XML = null;
         var _loc9_:String = null;
         var _loc2_:String = rest.join(" ");
         var _loc3_:String = GeneralUtils.nameToObject(_loc2_);
         var _loc4_:XMLList = R.xml_objects.node.node;
         var _loc5_:XMLList = R.xml_objects.node.node.node;
         var _loc6_:int = 0;
         while(_loc6_ < 2)
         {
            if(_loc6_ == 0)
            {
               _loc7_ = _loc4_;
            }
            else
            {
               _loc7_ = _loc5_;
            }
            for each(_loc8_ in _loc7_)
            {
               if(String(_loc8_.@func) == "")
               {
                  if(String(_loc8_.@object) != "")
                  {
                     _loc9_ = _loc8_.@object;
                     if(_loc9_ == _loc3_)
                     {
                        this.console.setConsoleText(_loc8_.toXMLString());
                        return;
                     }
                     _loc9_ = _loc8_.@label;
                     _loc9_ = _loc9_.toLowerCase().replace(/\s/g,"");
                     _loc2_ = _loc2_.toLowerCase().replace(/\s/g,"");
                     if(_loc9_ == _loc2_)
                     {
                        this.console.setConsoleText(_loc8_.toXMLString());
                        return;
                     }
                  }
               }
            }
            _loc6_++;
         }
      }
      
      public function updateControls() : void
      {
         var _loc6_:String = null;
         var _loc1_:XML = <node label="Root Node">
								</node>;
         var _loc2_:String = "           Reset\n\nDeletes all items and spawns a new doll." + (Main.instance.loadedLevel == "" ? "" : " And unload the loaded locked level.\n\n");
         _loc1_.appendChild(<node label="Reset" func="reset" ico="iconreset" tooltip={_loc2_}/>);
         if(GameState.paused)
         {
            _loc1_.appendChild(<node label="Play" func="togglemode" ico="mode_play" tooltip="Resume playing."/>);
         }
         else
         {
            _loc1_.appendChild(<node label="Pause" func="togglemode" ico="mode_edit" tooltip="           Pause&#10;&#10;Disables physics, allowing building things."/>);
         }
         if(GameState.slomo)
         {
            _loc1_.appendChild(<node label="SlowMo Off" func="unslomo" ico="mode_unslomo" tooltip="Disable slow motion.&#10;"/>);
         }
         else
         {
            _loc1_.appendChild(<node label="SlowMo" func="slomo" ico="mode_slomo" tooltip="      Slow Motion&#10;&#10;Lowers simulation speed. Modify via settings."/>);
         }
         if(Main.instance.loadedLevel != "")
         {
            _loc1_.appendChild(<node label="Restart Level" func="restartLevel" ico="icon_restart" tooltip="Click to restart the loaded level.&#10;"/>);
         }
         var _loc3_:XML = <node label="Tools" func="toggletools" tooltip="           Tools&#10;&#10;Modify keys via settings."/>;
         var _loc4_:XML = <node label="Joints" func="togglejoints" tooltip="           Joints&#10;&#10;Connect items together, or to the background."/>;
         var _loc5_:XML = <node label="Powers" func="togglepowers" tooltip="           Powers&#10;&#10;Unleash destructive powers."/>;
         if(Tool.isPower)
         {
            _loc5_.@ico = "tool_" + Tool.current;
            _loc3_.@ico = "icontools";
            _loc4_.@ico = "iconjoints";
         }
         else if(Tool.isAJoint)
         {
            _loc5_.@ico = "iconpowers";
            _loc3_.@ico = "icontools";
            _loc4_.@ico = "tool_" + Tool.current;
         }
         else
         {
            _loc6_ = "tool_" + Tool.current;
            if(Tool.isDrag && GameState.roleplaying)
            {
               _loc6_ = "tool_roleplay";
            }
            _loc3_.@ico = _loc6_;
            _loc5_.@ico = "iconpowers";
            _loc4_.@ico = "iconjoints";
         }
         _loc1_.appendChild(_loc3_);
         _loc1_.appendChild(_loc4_);
         _loc1_.appendChild(_loc5_);
         if(GameState.paused)
         {
            _loc1_.appendChild(<node label="Pause" func="pausesettings" ico="tool_detail" tooltip="Pause settings."/>);
         }
         this.menuControls.getTree("buttons").dataProvider = new TreeDataProvider(_loc1_);
         this.menuControls.maximiseHeight = 28 + this.menuControls.getTree("buttons").dataProvider.length * 32;
         this.menuControls.redraw();
      }
      
      private function selectPower(param1:XML) : void
      {
         Tool.setTool(param1.@func);
         Main.instance.toolSprite.graphics.clear();
         GameState.ui.updateControls();
         Powers.updatePowerProperties(param1);
      }
      
      private function selectProperty(param1:Object) : void
      {
         var _loc2_:ListEvent = new ListEvent("fake",false,false,-1,-1,-1,param1);
         if(GameState.ui.menuObject.title == "Detail Properties")
         {
            Main.instance.detailTreeClick(_loc2_);
         }
         else
         {
            Main.instance.handleTreeClick(_loc2_);
         }
      }
      
      public function selectItemByName(param1:String) : *
      {
         var _loc2_:Tree = GameState.ui.menuLibrary.getTree("buttons");
         var _loc3_:TNode = _loc2_.findNode("object",param1);
         var _loc4_:int = _loc2_.showNode(_loc3_);
         if(_loc4_ != -1)
         {
            _loc2_.selectedIndex = _loc4_;
            GameState.ui.selectItem(_loc2_.selectedItem);
         }
      }
      
      public function selectItem(param1:Object) : void
      {
         var _loc2_:Item = null;
         if(!param1.object)
         {
            param1.object = "ragdoll";
         }
         Main.instance.spawnPos = null;
         GameState.objects.spawnSkin = new Vector.<Array>();
         GameState.objects.spawnNode = param1;
         GameState.objects.spawnName = param1.object;
         if(param1.lab)
         {
            _loc2_ = O.getItem(GameState.objects.spawnName);
            if(Boolean(_loc2_) && Boolean(_loc2_.creator))
            {
               GameState.objects.spawnCreator = _loc2_.creator;
            }
            else
            {
               GameState.objects.spawnCreator = "";
            }
         }
         else
         {
            GameState.objects.spawnCreator = "";
         }
         if(param1.tooltip)
         {
            GameState.objects.spawnDetails = param1.tooltip + "\n";
            if(!GameState.quickspawning && GameState.ui.menuSpawn.visible && GameState.ui.menuSpawn.title == "Spawn")
            {
               GameState.ui.showTooltip(GameState.ui.menuSpawn,GameState.objects.spawnDetails,500,3000,GameState.ui.menuSpawn.actualWidth);
            }
         }
         else
         {
            GameState.objects.spawnDetails = "";
            GameState.ui.genericToolTip.hide();
         }
         if(GameState.ui.menuSpawn.title == "Spawn")
         {
            GameState.objects.spawnLinks = param1.links != null;
            GameState.objects.spawnCustom = param1.custom != null;
            GameState.objects.spawnLocal = param1.local != null;
            GameState.objects.spawnCustomContent = param1.custom;
         }
         if(param1.label)
         {
            Main.instance.stageFocus(AutoComplete(GameState.ui.menuSpawn.getChildByName("autoComplete")).textField);
            AutoComplete(GameState.ui.menuSpawn.getChildByName("autoComplete")).text = param1.label;
            Main.instance.stageUnfocus();
            AutoComplete(GameState.ui.menuLibrary.getChildByName("autoComplete")).text = "Search...";
         }
         Main.instance.updateSkin();
         Main.instance.updateSpawnPic();
         if(GameState.ui.menuSpawn.title == "VIEW CARD")
         {
            this.DisableTradingCardStyle();
         }
         if(GameState.ui.menuObject.title == "Skin")
         {
            Main.instance.updateSkin();
         }
      }
      
      public function autocompleter(param1:DropdownEvent) : void
      {
         var _loc2_:AutoComplete = AutoComplete(GameState.ui.menuSpawn.getChildByName("autoComplete"));
         if(_loc2_.text == "")
         {
            return;
         }
         if(GameState.spawning && Boolean(GameState.objects.spawnTitle))
         {
            _loc2_.text = GameState.objects.spawnTitle;
            Main.instance.stageUnfocus();
            return;
         }
         var _loc3_:String = AutoComplete(param1.currentTarget).text;
         AutoComplete(GameState.ui.menuSpawn.getChildByName("autoComplete")).text = _loc3_;
         AutoComplete(GameState.ui.menuLibrary.getChildByName("autoComplete")).text = _loc3_;
         var _loc4_:Tree = GameState.ui.menuLibrary.getTree("buttons");
         _loc4_.closeAllNodes();
         var _loc5_:TNode = _loc4_.findNode("label",_loc3_);
         var _loc6_:int = _loc4_.showNode(_loc5_);
         if(_loc6_ != -1)
         {
            _loc4_.selectedIndex = _loc6_;
            _loc4_.scrollToSelected();
            this.selectItem(_loc4_.selectedItem);
            Main.instance.stageUnfocus();
         }
      }
      
      public function autocompleteProperties(param1:DropdownEvent) : void
      {
         var _loc2_:String = AutoComplete(param1.currentTarget).text;
         if(_loc2_ == "")
         {
            return;
         }
         var _loc3_:Tree = GameState.ui.menuObject.getTree("buttons");
         _loc3_.closeAllNodes();
         var _loc4_:TNode = _loc3_.findNode("label",_loc2_);
         var _loc5_:int = _loc3_.showNode(_loc4_);
         if(_loc5_ != -1)
         {
            _loc3_.selectedIndex = _loc5_;
            _loc3_.scrollToSelected();
            this.selectProperty(_loc4_);
            Main.instance.stageUnfocus();
         }
      }
      
      public function autocompletePowers(param1:DropdownEvent) : void
      {
         var node:XML;
         var acText:String = null;
         var libraryTree:Tree = null;
         var foundNode:TNode = null;
         var nodeIndex:int = 0;
         var e:DropdownEvent = param1;
         acText = AutoComplete(e.currentTarget).text;
         if(acText == "")
         {
            return;
         }
         AutoComplete(GameState.ui.menuTools.getChildByName("autoComplete")).text = acText;
         node = R.xml_powers.node.(@label == acText)[0];
         if(node != null)
         {
            this.selectPower(node);
         }
         Main.instance.stageUnfocus();
      }
      
      public function DisableTradingCardStyle() : *
      {
         GameState.ui.menuSpawn.getChildByName("itemHolder").visible = true;
         GameState.ui.menuSpawn.title = "Spawn";
         GameState.ui.menuSpawn.setColourBackground(GameState.ui.menuMain.BACKGROUNDCOLOUR);
         GameState.ui.menuSpawn.setColourTopbar(GameState.ui.menuMain.TOPBARCOLOUR);
         GameState.ui.menuSpawn.setColourBorder(GameState.ui.menuMain.BORDERCOLOUR);
         GameState.ui.menuSpawn.setColourButtons(GameState.ui.menuMain.BUTTONCOLOUR);
         GameState.ui.menuSpawn.setColourFont(GameState.ui.menuMain.FONTCOLOUR);
         GameState.ui.menuSpawn.LINEWIDTH = GameState.ui.menuMain.LINEWIDTH;
         var _loc1_:* = GameState.ui.menuSpawn.getChildByName("FOOLTEXT");
         var _loc2_:* = GameState.ui.menuSpawn.getChildByName("FOOLTEXT2");
         var _loc3_:* = GameState.ui.menuSpawn.getChildByName("RARITYICON");
         if(_loc1_)
         {
            GameState.ui.menuSpawn.removeChild(_loc1_);
         }
         if(_loc2_)
         {
            GameState.ui.menuSpawn.removeChild(_loc2_);
         }
         if(_loc3_)
         {
            GameState.ui.menuSpawn.removeChild(_loc3_);
         }
         var _loc4_:AutoComplete = AutoComplete(GameState.ui.menuSpawn.getChildByName("autoComplete"));
         _loc4_.visible = true;
         GameState.ui.menuSpawn.getChildByName("flipicon").visible = true;
         GameState.ui.menuSpawn.getChildByName("favicon").visible = true;
         GameState.ui.menuSpawn.getChildByName("randomicon").visible = true;
         GameState.ui.menuSpawn.getChildByName("settingicon").visible = true;
         GameState.ui.menuSpawn.getChildByName("propertyicon").visible = true;
         GameState.ui.menuSpawn.getChildByName("skinicon").visible = true;
         GameState.ui.menuSpawn.getChildByName("searchicon").visible = true;
         GameState.ui.menuSpawn.getChildByName("armouricon").visible = true;
         GameState.ui.menuSpawn.getChildByName("resize").visible = true;
         GameState.ui.menuSpawn.getChildByName("itemprev").visible = true;
         GameState.ui.menuSpawn.getChildByName("itemnext").visible = true;
         if(!GameState.ui.menuSpawn.undocked)
         {
            GameState.ui.menuSpawn.x = GameState.ui.menuMain.x + GameState.ui.menuMain.actualWidth + 4;
            GameState.ui.menuSpawn.y = GameState.ui.menuMain.y;
         }
         GameState.ui.menuSpawn.maximiseHeight = _loc4_.y + _loc4_.height + 4;
         GameState.ui.menuSpawn.redraw();
         Main.instance.updateSpawnPic();
      }
      
      public function openFavouriteSaves() : void
      {
         this.menuFavourite.unlock();
         this.menuFavourite.moveToTop();
         this.menuFavourite.center();
         this.menuFavourite.lock();
         this.menuFavourite.open();
         this.menuFavourite.getTree("buttons").openAllNodes();
         this.menuFavourite.title = "Remove Favourite Save";
         this.updateFavouriteSaves();
      }
      
      public function openResetSaves() : void
      {
         this.menuFavourite.unlock();
         this.menuFavourite.moveToTop();
         this.menuFavourite.center();
         this.menuFavourite.lock();
         this.menuFavourite.open();
         this.menuFavourite.getTree("buttons").openAllNodes();
         this.menuFavourite.title = "Select Reset Save";
         this.updateResetSaves();
      }
      
      public function openLocalItems() : void
      {
         this.menuFavourite.unlock();
         this.menuFavourite.moveToTop();
         this.menuFavourite.center();
         this.menuFavourite.lock();
         this.menuFavourite.open();
         this.menuFavourite.getTree("buttons").openAllNodes();
         this.menuFavourite.title = "Manage Local Models";
         this.updateLocals();
      }
      
      public function updateLocals() : void
      {
         var _loc3_:XML = null;
         var _loc4_:* = undefined;
         var _loc1_:XML = <node label="Root Node">
				<node label="Back" func="favback" center="true"/>
			</node>;
         _loc1_.appendChild(<node label="Save" func="localSave" center="true" tooltip="Saves imported local models.&#10;Please keep manual backups of the file if you use them a lot.&#10;&#10;&#10;"/>);
         _loc1_.appendChild(<node label="Reload" func="localLoad" center="true" tooltip="Reloads removed models as long as changes are not saved.&#10;&#10;"/>);
         var _loc2_:int = 0;
         while(_loc2_ < Main.instance.localItems.length)
         {
            _loc3_ = <node/>;
            _loc3_.@func = "removelocal";
            _loc3_.@id = _loc2_;
            _loc3_.@tooltip = "Click to remove.\nRemember to save.";
            _loc4_ = _loc2_ + 1;
            _loc3_.@label = Main.instance.localNames[_loc2_];
            _loc1_.appendChild(_loc3_);
            _loc2_++;
         }
         this.menuFavourite.getTree("buttons").dataProvider = new TreeDataProvider(_loc1_);
      }
      
      public function updateResetSaves() : void
      {
         var _loc3_:XML = null;
         var _loc1_:XML = <node label="Root Node">
				<node label="Back" func="favback" center="true"/>
				<node label="None" func="selectresetsave" id={-1} center="true"/>
			</node>;
         var _loc2_:int = 0;
         while(_loc2_ < Main.instance.favouriteSaveNames.length)
         {
            _loc3_ = <node/>;
            _loc3_.@func = "selectresetsave";
            _loc3_.@id = _loc2_;
            _loc3_.@label = Main.instance.favouriteSaveNames[_loc2_];
            _loc1_.appendChild(_loc3_);
            _loc2_++;
         }
         this.menuFavourite.getTree("buttons").dataProvider = new TreeDataProvider(_loc1_);
      }
      
      public function updateFavouriteSaves() : void
      {
         var _loc3_:XML = null;
         var _loc4_:* = undefined;
         var _loc1_:XML = <node label="Root Node">
				<node label="Back" func="favback" center="true"/>
			</node>;
         _loc1_.appendChild(<node label="Save" func="favouriteSaveSave" center="true" tooltip="Saves favourited saves.&#10;Please keep manual backups of the file if you use them a lot.&#10;&#10;&#10;"/>);
         _loc1_.appendChild(<node label="Reload" func="favouriteSaveLoad" center="true" tooltip="Reloads removed saves from the file as long as changes are not saved.&#10;&#10;"/>);
         var _loc2_:int = 0;
         while(_loc2_ < Main.instance.favouriteSaveNames.length)
         {
            _loc3_ = <node/>;
            _loc3_.@func = "removefavourite";
            _loc3_.@id = _loc2_;
            _loc3_.@tooltip = "Click to remove.\nRemember to save.";
            _loc4_ = _loc2_ + 1;
            _loc3_.@label = Main.instance.favouriteSaveNames[_loc2_];
            _loc1_.appendChild(_loc3_);
            _loc2_++;
         }
         this.menuFavourite.getTree("buttons").dataProvider = new TreeDataProvider(_loc1_);
      }
      
      public function getCustom() : void
      {
         this.openCustomItems("share");
      }
      
      public function openCredits() : void
      {
         this.menuPrompt.unlock();
         this.menuPrompt.getField("info").type = TextFieldType.DYNAMIC;
         this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_done);
         this.menuPrompt.visible = true;
         this.menuPrompt.title = "Credits";
         this.menuPrompt.moveToTop();
         this.menuPrompt.center();
         this.menuPrompt.lock();
         this.menuPrompt.getField("info").text = "Design, programming, and a bunch of other things by rava (rava.games).\n\nMaD2 runs on Box2D physics engine (Box2D.org)\n\nItem Design: See attributions by clicking on the flask symbol in the Spawn Menu.\n\nAudio: qubodup, p0ss, Bart K., WillHiccups, ztrees1, thecluegeek, Slave2theLight, harri, LloydEvans09, Halleck, sandyrb, CGEffex, sgtmurphy, kwandalist, kMoon, jorickhoofd, dobroide, Headphaze, tehlordoswag420. (Freesound.org/people/<name>)\n\nOpen World Background Music:\n\'Music Elevator\' by Jay_You (Freesound.org)\n\nHalloween Background Music: DARK FANTASY STUDIO by Nicolas Jeudy.\n\nAdditional audio: Kwaji, Calciumtrice, The Chayed, KnoblePersona, withthelove. (OpenGameArt.com)";
      }
      
      public function showTooltip(param1:DisplayObject, param2:String, param3:Number = 100, param4:* = 350, param5:Number = 100, param6:Number = 22) : ToolTip
      {
         if(!param1)
         {
            return null;
         }
         var _loc7_:String = param2;
         var _loc8_:ToolTip = this.genericToolTip;
         _loc8_.delay = param3;
         _loc8_.hideDelay = param4;
         _loc8_.reset();
         _loc8_.colors = [this.menuMain.BACKGROUNDCOLOUR,this.menuMain.BACKGROUNDCOLOUR];
         _loc8_.bgAlpha = 0.9;
         _loc8_.border = this.menuMain.BORDERCOLOUR;
         _loc8_.cornerRadius = 8;
         _loc8_.buffer = Window.BUFFER * 3;
         _loc8_.tipPosition = "bottom";
         _loc8_.hookSize = 0;
         _loc8_.followMouse = false;
         if(param4 != -1)
         {
            _loc8_.hideOnMouseOut = false;
            _loc8_.hideOnMouseDown = false;
         }
         else
         {
            _loc8_.hideOnMouseDown = true;
            _loc8_.hideOnMouseOut = true;
         }
         _loc8_.tipWidth = param5;
         _loc8_.tipHeight = 48;
         var _loc9_:Number = 36;
         if(_loc7_.split("\n").length > 0)
         {
            _loc9_ = 24 * _loc7_.split("\n").length;
         }
         if(_loc9_ < 36)
         {
            _loc9_ = 36;
         }
         _loc8_.tipHeight = _loc9_;
         var _loc10_:TextFormat = new TextFormat(Window.FONT,Window.FONTSIZE,this.menuMain.FONTCOLOUR,null,null,null,null,null,TextFormatAlign.CENTER);
         _loc8_.contentFormat = _loc10_;
         _loc8_.show(param1,"",_loc7_);
         return _loc8_;
      }
      
      private function settingiconpressed(param1:MouseEvent) : void
      {
         this.itemSettings();
      }
      
      private function propertyiconpressed(param1:MouseEvent) : void
      {
         Properties.itemProperties();
      }
      
      private function skiniconpressed(param1:MouseEvent) : void
      {
         Main.instance.itemSkin();
      }
      
      private function randomiconpressed(param1:MouseEvent) : void
      {
         Main.instance.selectRandomItem();
      }
      
      private function searchiconpressed(param1:MouseEvent) : void
      {
         Main.instance.itemSearch();
      }
      
      private function armouriconpressed(param1:MouseEvent) : void
      {
         Main.instance.itemArmour();
      }
      
      private function faviconpressed(param1:MouseEvent) : void
      {
         this.updateFavs();
         this.menuFavourite.unlock();
         this.menuFavourite.moveToTop();
         this.menuFavourite.center();
         this.menuFavourite.lock();
         this.menuFavourite.open();
         this.menuFavourite.getTree("buttons").openAllNodes();
         if(GameState.objects.spawnName)
         {
            this.menuFavourite.title = "Favourite " + GeneralUtils.objectToName(GameState.objects.spawnName);
         }
         else
         {
            this.menuFavourite.title = "Favourites";
         }
      }
      
      public function dockItemMenu() : void
      {
         if(!this.menuObject.undocked)
         {
            if(this.menuSpawn.x + this.menuSpawn.width + this.menuLibrary.width + 4 < GameState.width)
            {
               this.menuObject.x = this.menuSpawn.x + this.menuSpawn.actualWidth + 4;
               this.menuObject.y = this.menuSpawn.y;
            }
            else
            {
               this.menuObject.x = this.menuSpawn.x - this.menuObject.actualWidth - 4;
               this.menuObject.y = this.menuSpawn.y;
            }
         }
      }
      
      public function dockEffectsMenu() : void
      {
         if(!this.menuObject.undocked)
         {
            if(this.menuEffects.x + this.menuEffects.width < GameState.width)
            {
               this.menuObject.x = this.menuEffects.x + this.menuEffects.actualWidth + 4;
               this.menuObject.y = this.menuEffects.y;
            }
            else
            {
               this.menuObject.x = this.menuEffects.x - this.menuObject.actualWidth - 4;
               this.menuObject.y = this.menuEffects.y;
            }
         }
      }
      
      public function dockItemMenuDetail() : void
      {
         if(!this.menuObject.undocked)
         {
            if(this.menuDetails.x > GameState.width * 0.5)
            {
               this.menuObject.x = this.menuDetails.x + this.menuDetails.actualWidth + 4;
               this.menuObject.y = this.menuDetails.y;
            }
            else
            {
               this.menuObject.x = this.menuDetails.x - this.menuObject.actualWidth - 4;
               this.menuObject.y = this.menuDetails.y;
            }
         }
         if(this.menuObject.y < 10)
         {
            this.menuObject.y = 10;
         }
         if(this.menuObject.y + this.menuObject.maxHeight > GameState.height - 10)
         {
            this.menuObject.y = GameState.height - this.menuObject.height - 10;
         }
         if(this.menuObject.x < 10)
         {
            this.menuObject.x = this.menuDetails.x + this.menuObject.actualWidth + 4;
         }
         if(this.menuObject.x + this.menuObject.actualWidth > GameState.width - 10)
         {
            this.menuObject.x = this.menuDetails.x - this.menuObject.actualWidth - 4;
         }
      }
      
      public function effectParticlesList(param1:Boolean = false) : void
      {
         if(!param1)
         {
            if(this.menuObject.visible && this.menuObject.title == "Particles")
            {
               this.menuObject.close();
               return;
            }
         }
         if(!this.menuObject.visible)
         {
            this.dockEffectsMenu();
            this.menuObject.open();
         }
         this.menuObject.removeAllChildren();
         this.menuObject.title = "Particles";
         var _loc2_:XML = R.xml_effectElements;
         var _loc3_:int = _loc2_.node.length();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_.node[_loc4_].@label = _loc2_.node[_loc4_].@baseLabel;
            _loc2_.node[_loc4_].@element = _loc2_.node[_loc4_].@baseElement;
            _loc4_++;
         }
         var _loc5_:Tree = this.menuObject.addTree("buttons",_loc2_,296,0,24);
         _loc5_.selectable = false;
         _loc5_.addEventListener(ListEvent.ITEM_CLICK,Main.instance.effectTreeClick);
         _loc5_.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,Main.instance.effectTreeClick);
         this.menuObject.maximiseHeight = 300;
         this.menuObject.maximise();
      }
      
      public function effectEffectsList() : void
      {
         if(this.menuObject.visible && this.menuObject.title == "Behaviours")
         {
            this.menuObject.close();
            return;
         }
         if(!this.menuObject.visible)
         {
            this.dockEffectsMenu();
            this.menuObject.open();
         }
         this.menuObject.removeAllChildren();
         this.menuObject.title = "Behaviours";
         var _loc1_:Tree = this.menuObject.addTree("buttons",R.xml_effectTypes,400,0,32);
         this.menuObject.maximiseHeight = 300;
         this.menuObject.maximise();
         _loc1_.selectable = false;
         _loc1_.addEventListener(ListEvent.ITEM_CLICK,Main.instance.effectTreeClick);
         _loc1_.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,Main.instance.effectTreeClick);
      }
      
      public function updateFavs() : void
      {
         var _loc4_:XML = null;
         var _loc5_:* = undefined;
         var _loc6_:String = null;
         var _loc1_:XML = <node label="Root Node">
				<node label="Back" func="favback" center="true"/>
			</node>;
         var _loc2_:Array = Main.instance.favourites;
         if(GameState.objects.spawnName)
         {
            if(_loc2_.indexOf(GameState.objects.spawnName) == -1)
            {
               _loc1_.appendChild(<node label="    Library" func="libfav" tooltip="Add the item to your Favourites category in the Library without adding a hotkey for it.&#10;&#10;"/>);
            }
            if(_loc2_.indexOf(GameState.objects.spawnName) != -1)
            {
               _loc1_.appendChild(<node label="    Unfavourite" func="unfav"/>);
            }
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = <node/>;
            _loc4_.@func = "fav";
            _loc4_.@id = _loc3_;
            _loc5_ = _loc3_ + 1;
            if(_loc5_ > 20)
            {
               _loc4_.@label = "[Lib] " + String(_loc2_[_loc3_]).toUpperCase();
            }
            else if(_loc2_[_loc3_] == "")
            {
               _loc4_.@label = "[" + Keymap.codeToKeyname(Keymap.nameToCode("Favourite" + _loc5_)) + "] EMPTY SLOT";
            }
            else
            {
               _loc6_ = "";
               if(Main.instance.customNames.indexOf(_loc2_[_loc3_]) != -1)
               {
                  _loc6_ = _loc2_[_loc3_];
               }
               else
               {
                  _loc6_ = GeneralUtils.objectToName(_loc2_[_loc3_]);
               }
               _loc4_.@label = "[" + Keymap.codeToKeyname(Keymap.nameToCode("Favourite" + _loc5_)) + "] " + _loc6_;
            }
            _loc1_.appendChild(_loc4_);
            _loc3_++;
         }
         this.menuFavourite.getTree("buttons").dataProvider = new TreeDataProvider(_loc1_);
      }
      
      private function customiconpressed(param1:MouseEvent) : void
      {
         this.openCustomItems("manage");
      }
      
      public function openCustomItems(param1:String) : void
      {
         if(param1 == "manage")
         {
            this.menuFavourite.title = "Manage Custom Items";
         }
         else if(param1 == "remove")
         {
            this.menuFavourite.title = "Remove Custom Items";
         }
         else if(param1 == "rename")
         {
            this.menuFavourite.title = "Rename Custom Items";
         }
         else if(param1 == "share")
         {
            this.menuFavourite.title = "Share Custom Item";
         }
         this.updateCustoms(param1);
      }
      
      public function updateCustomCategory(param1:Event) : void
      {
         if(this.genericToolTip.alpha == 0)
         {
            this.genericToolTip = this.showTooltip(this.menuDetails,"Optional category: Doll, Apparel, Melee, Gun, Environment.\nEverything else marked as Misc.\n\n\n",0,-1,this.menuDetails.actualWidth);
         }
      }
      
      public function updateCustoms(param1:String = "remove") : void
      {
         var treeFavs:Tree;
         var favxml:XML;
         var customItems:Array;
         var l:int;
         var i:int;
         var catfield:TextField = null;
         var item:XML = null;
         var keyid:* = undefined;
         var func:String = param1;
         if(this.menuFavourite.alpha == 0)
         {
            this.menuFavourite.open();
         }
         this.menuFavourite.unlock();
         this.menuFavourite.moveToTop();
         this.menuFavourite.center();
         this.menuFavourite.lock();
         this.menuFavourite.removeAllChildren();
         treeFavs = this.menuFavourite.addTree("buttons",R.xml_empty,288,0,24);
         treeFavs.selectable = false;
         treeFavs.addEventListener(ListEvent.ITEM_CLICK,Main.instance.handleTreeClick);
         favxml = <node label="Root Node">
			</node>;
         if(func == "manage")
         {
            favxml.appendChild(<node label="Back" func="customBack" center="true"/>);
            favxml.appendChild(<node label="Share" center="true" func="custom_share" tooltip="Share custom items.&#10;&#10;"/>);
            favxml.appendChild(<node label="Remove" center="true" func="custom_remove" tooltip="Remove custom items.&#10;&#10;"/>);
            favxml.appendChild(<node label="Rename" center="true" func="custom_rename" tooltip="Rename custom items.&#10;&#10;"/>);
            this.menuFavourite.getTree("buttons").dataProvider = new TreeDataProvider(favxml);
            return;
         }
         favxml.appendChild(<node label="Back" func="custom_manage" center="true"/>);
         if(func != "share")
         {
            favxml.appendChild(<node label="Save" func="customSave" center="true" tooltip="Saves custom items locally.&#10;Please keep manual backups of the file if you use custom items a lot.&#10;&#10;&#10;"/>);
            favxml.appendChild(<node label="Reload" func="customLoad" center="true" tooltip="Reloads removed items as long as changes are not saved.&#10;&#10;"/>);
         }
         if(func == "share" && false)
         {
            this.menuFavourite.addInput("Category","Category",this.menuDetails.actualWidth - Window.BUFFER * 6,null,"a-zA-Z",24,false).addEventListener(Event.CHANGE,this.updateCustomCategory);
            catfield = this.menuFavourite.getField("Category");
            this.genericToolTip = this.showTooltip(this.menuFavourite,"Optional category: Doll, Apparel, Melee, Gun, Environment.\nEverything else marked as Misc.\n\n\n",0,-1,this.menuDetails.actualWidth);
            catfield.addEventListener(FocusEvent.FOCUS_IN,function(param1:FocusEvent):*
            {
               param1.currentTarget.text = "";
            });
            catfield.addEventListener(FocusEvent.FOCUS_OUT,function(param1:FocusEvent):*
            {
               if(genericToolTip)
               {
                  genericToolTip.hide();
               }
               var _loc2_:String = String(param1.currentTarget.text).toLowerCase();
               if(_loc2_ != "doll" && _loc2_ != "apparel" && _loc2_ != "melee" && _loc2_ != "gun" && _loc2_ != "environment")
               {
                  param1.currentTarget.text = "Misc";
               }
            });
         }
         customItems = Main.instance.customItems;
         if(customItems.length == 0)
         {
            item = <node/>;
            item.@label = "Empty!";
            item.@tooltip = "Use the Custom Items category in the Library to create one.\n\n\n";
            favxml.appendChild(item);
         }
         l = int(customItems.length);
         i = 0;
         for(; i < l; i++)
         {
            item = <node/>;
            if(func == "share")
            {
               item.@func = "shareCustomWorkshop";
            }
            else if(func == "remove")
            {
               item.@func = "removecustom";
            }
            else if(func == "rename")
            {
               item.@func = "renamecustom";
               if(Main.instance.customNames[i].indexOf(" by ") != -1)
               {
                  continue;
               }
            }
            item.@id = i;
            if(func == "share")
            {
               item.@tooltip = "Click to share.\n";
            }
            else if(func == "remove")
            {
               item.@tooltip = "Click to remove this item. Save when finished.\n";
            }
            else if(func == "rename")
            {
               item.@tooltip = "Click to rename.\nRemember to save.";
            }
            keyid = i + 1;
            item.@label = Main.instance.customNames[i];
            favxml.appendChild(item);
         }
         this.menuFavourite.getTree("buttons").dataProvider = new TreeDataProvider(favxml);
      }
      
      private function labiconpressed(param1:MouseEvent) : void
      {
         this.menuPrompt.unlock();
         this.menuPrompt.getField("info").type = TextFieldType.DYNAMIC;
         this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_promptLab);
         this.menuPrompt.visible = true;
         this.menuPrompt.title = "MaD Lab";
         this.menuPrompt.moveToTop();
         this.menuPrompt.center();
         this.menuPrompt.lock();
         this.menuPrompt.getField("info").text = "This item model was created in MaD Lab\nby " + GameState.objects.spawnCreator + ".\n\nMaD Lab is the item design tool for MaD2 that is used in designing all the items that end up in the game.\n";
      }
      
      private function flipiconpressed(param1:MouseEvent) : void
      {
         Main.instance.flip();
      }
      
      public function OpenWorkshopShareDialogue(param1:String, param2:String) : *
      {
         var _loc4_:Tree = null;
         this.menuDetails.open();
         this.menuDetails.unlock();
         this.menuDetails.title = "Sharing " + param2;
         this.menuDetails.removeAllChildren();
         var _loc3_:String = param2 + " Name";
         if(param1)
         {
            _loc3_ = param1;
         }
         this.menuDetails.addInput("Name",_loc3_,this.menuDetails.actualWidth - Window.BUFFER * 6,null,"a-zA-Z0-9 -",24,false);
         this.menuDetails.addInput("Description",param2 + " Description",this.menuDetails.actualWidth - Window.BUFFER * 6,null,"a-zA-Z0-9 -",300,false);
         if(param2 == "Item")
         {
            _loc4_ = this.menuDetails.addTree("buttons",R.xml_workshopShareItem);
         }
         else
         {
            _loc4_ = this.menuDetails.addTree("buttons",R.xml_workshopShareLevel);
         }
         _loc4_.addEventListener(ListEvent.ITEM_CLICK,Main.instance.handleSaveTree);
         _loc4_.selectable = false;
         _loc4_.openAllNodes();
         this.menuDetails.maximiseHeight = 364;
         this.menuDetails.maximise();
         this.menuDetails.redraw();
         this.menuDetails.center();
         this.menuDetails.lock();
      }
      
      public function itemSettings() : void
      {
         if(this.menuObject.visible && this.menuObject.title == "Settings")
         {
            this.menuObject.close();
            return;
         }
         if(!this.menuObject.visible)
         {
            this.dockItemMenu();
            this.menuObject.open();
         }
         this.UpdateItemSettings();
         this.dockItemMenu();
      }
      
      public function UpdateItemSettings() : *
      {
         this.menuObject.allowInputDrag = true;
         this.menuObject.removeAllChildren();
         this.menuObject.title = "Settings";
         this.menuObject.addSlider("% Scale",100 * Vars.objSize,Tweak.ScaleMin * 100,Tweak.ScaleMax * 100);
         this.menuObject.addSlider("° Angle",Vars.objAngle,-360,360);
         this.menuObject.addSlider("% Weight",100 * Vars.objDensity,0,9999);
         this.menuObject.addSlider("% Friction",100 * Vars.objFriction,0,999);
         this.menuObject.addSlider("% Bounce",100 * Vars.objRestitution,0,200);
         this.menuObject.addSlider("Damp Speed",Vars.objDampLinear,0,999);
         this.menuObject.addSlider("Damp Spin",Vars.objDampAngular,0,999);
         var _loc1_:Number = 316;
         var _loc2_:XML = <node label="Root Node">
				<node label="Reset to Default" func="defaultSettings" center="true" noReadabilityTint="true"/>
			</node>;
         var _loc3_:Tree = this.menuObject.addTree("buttons",_loc2_,22 * _loc2_.children().length(),this.menuObject.actualWidth - Window.BUFFER * 4);
         _loc3_.addEventListener(ListEvent.ITEM_CLICK,Main.instance.handleTreeClick);
         _loc3_.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,Main.instance.handleTreeClick);
         this.menuObject.addTooltip("% Scale","Scale multiplier.");
         this.menuObject.addTooltip("% Weight","Mass multiplier.\n0% for static item.");
         this.menuObject.addTooltip("% Friction","Friction multiplier\n0% for infinite sliding.\n");
         this.menuObject.addTooltip("% Bounce","Bounciness on collision.\n100% for infinite bouncing.\n\n");
         this.menuObject.addTooltip("° Angle","Angle of the item in degrees.\n");
         this.menuObject.addTooltip("Damp Speed","Velocity damping. Slows velocity even midair.\n\n");
         this.menuObject.addTooltip("Damp Spin","Rotation damping. Slows rotation.\n");
         this.menuObject.movePosition(Window.BUFFER * 2);
         if(this.menuObject.alpha > 0)
         {
            this.menuObject.maximiseHeight = _loc1_;
            this.menuObject.maximise();
         }
         this.addSettingListeners();
      }
      
      public function gunSettings(param1:Boolean = false) : *
      {
         if(param1)
         {
            this.dockItemMenuDetail();
         }
         else
         {
            this.dockItemMenu();
         }
         if(this.menuObject.visible && this.menuObject.title == "Gun Settings")
         {
            this.menuObject.close();
            return;
         }
         if(!GameState.ui.menuObject.visible)
         {
            GameState.ui.menuObject.open();
         }
         if(this.menuObject.alpha == 0)
         {
            return;
         }
         this.menuObject.allowInputDrag = true;
         this.menuObject.title = "Gun Settings";
         if(param1)
         {
            this.menuObject.title = "Gun Settings";
         }
         this.addGunSettings(param1);
         if(this.menuObject.visible)
         {
            this.menuObject.maximiseHeight = 40 * R.gunSettings.setting.length();
            this.menuObject.maximise();
         }
      }
      
      public function stabSettings(param1:Boolean = false) : *
      {
         if(param1)
         {
            this.dockItemMenuDetail();
         }
         else
         {
            this.dockItemMenu();
         }
         if(this.menuObject.visible && this.menuObject.title == "Alive Settings")
         {
            this.menuObject.close();
            return;
         }
         if(!GameState.ui.menuObject.visible)
         {
            GameState.ui.menuObject.open();
         }
         if(this.menuObject.alpha == 0)
         {
            return;
         }
         this.menuObject.allowInputDrag = true;
         this.menuObject.title = "Alive Settings";
         if(param1)
         {
            this.menuObject.title = "Detail Alive";
         }
         this.addStabSettings(param1);
         if(this.menuObject.visible)
         {
            this.menuObject.maximiseHeight = 40 * R.stabSettings.setting.length();
            this.menuObject.maximise();
         }
      }
      
      public function addStabSettings(param1:Boolean = false) : void
      {
         var _loc3_:XML = null;
         var _loc4_:Number = NaN;
         var _loc2_:XMLList = R.stabSettings.setting;
         this.remStabSettings();
         this.menuObject.removeAllChildren();
         for each(_loc3_ in _loc2_)
         {
            if(this.menuObject.title == "Detail Alive")
            {
               if(_loc3_.@property == undefined)
               {
                  continue;
               }
            }
            _loc4_ = Number(_loc3_.@val);
            if(param1)
            {
               if(_loc3_.@property != undefined)
               {
                  _loc4_ = userData(Main.instance.detailBody.GetUserData())[_loc3_.@property] * 100;
               }
            }
            this.menuObject.addSlider(_loc3_.@name,_loc4_,Number(_loc3_.@min),Number(_loc3_.@max));
            this.menuObject.addTooltip(_loc3_.@name,_loc3_.@tooltip);
            this.menuObject.getGadget(_loc3_.@name).addEventListener(Event.CHANGE,this.updateStabSetting(_loc3_.@name,_loc3_.@property));
         }
         this.initStabSettings();
      }
      
      public function remStabSettings() : void
      {
         var _loc2_:XML = null;
         var _loc1_:XMLList = R.stabSettings.setting;
         for each(_loc2_ in _loc1_)
         {
            if(this.menuObject.getGadget(_loc2_.@name))
            {
               this.menuObject.getGadget(_loc2_.@name).removeEventListener(Event.CHANGE,this.updateStabSetting(_loc2_.@name,_loc2_.@property));
            }
         }
      }
      
      public function initStabSettings() : void
      {
         var _loc2_:XML = null;
         var _loc1_:XMLList = R.stabSettings.setting;
         for each(_loc2_ in _loc1_)
         {
            if(!(_loc2_.@name in Vars.stabSettings))
            {
               Vars.stabSettings[_loc2_.@name] = Number(_loc2_.@val) * 0.01;
            }
         }
      }
      
      public function addGunSettings(param1:Boolean = false) : void
      {
         var _loc3_:XML = null;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:userData = null;
         var _loc2_:XMLList = R.gunSettings.setting;
         this.remGunSettings();
         this.menuObject.removeAllChildren();
         for each(_loc3_ in _loc2_)
         {
            if(this.menuObject.title == "Gun Settings")
            {
               if(_loc3_.@property == undefined)
               {
                  continue;
               }
            }
            _loc4_ = Number(_loc3_.@val);
            if(param1)
            {
               if(Main.instance.detailBody)
               {
                  _loc6_ = userData(Main.instance.detailBody.GetUserData());
                  if((Boolean(_loc6_)) && Boolean(_loc6_.trigger) && _loc6_.trigger is Gun)
                  {
                     _loc4_ = Number(Gun(_loc6_.trigger).firearm[_loc3_.@property]);
                     if(_loc3_.@multi != undefined)
                     {
                        _loc4_ *= Number(_loc3_.@multi);
                     }
                  }
               }
            }
            _loc5_ = 5;
            if(Number(_loc3_.@snap))
            {
               _loc5_ = Number(_loc3_.@snap);
            }
            this.menuObject.addSlider(_loc3_.@name,_loc4_,Number(_loc3_.@min),Number(_loc3_.@max),100,16,_loc5_);
            this.menuObject.addTooltip(_loc3_.@name,_loc3_.@tooltip);
            this.menuObject.getGadget(_loc3_.@name).addEventListener(Event.CHANGE,this.updateGunSetting(_loc3_.@name,_loc3_.@property));
         }
      }
      
      public function remGunSettings() : void
      {
         var _loc2_:XML = null;
         var _loc1_:XMLList = R.gunSettings.setting;
         for each(_loc2_ in _loc1_)
         {
            if(this.menuObject.getGadget(_loc2_.@name))
            {
               this.menuObject.getGadget(_loc2_.@name).removeEventListener(Event.CHANGE,this.updateGunSetting(_loc2_.@name,_loc2_.@property));
            }
         }
      }
      
      public function initGunSettings() : void
      {
         var _loc2_:XML = null;
         Vars.gunSettings["modified"] = false;
         var _loc1_:XMLList = R.gunSettings.setting;
         for each(_loc2_ in _loc1_)
         {
            if(!(_loc2_.@name in Vars.gunSettings))
            {
               Vars.gunSettings[_loc2_.@property] = Number(_loc2_.@val);
            }
         }
      }
      
      public function addSettingListeners() : void
      {
         if(this.menuObject.getGadget("% Scale"))
         {
            this.menuObject.getGadget("% Scale").addEventListener(Event.CHANGE,this.updateObjSize);
         }
         if(this.menuObject.getGadget("° Angle"))
         {
            this.menuObject.getGadget("° Angle").addEventListener(Event.CHANGE,this.updateObjAngle);
         }
         if(this.menuObject.getGadget("% Weight"))
         {
            this.menuObject.getGadget("% Weight").addEventListener(Event.CHANGE,this.updateObjDensity);
         }
         if(this.menuObject.getGadget("% Friction"))
         {
            this.menuObject.getGadget("% Friction").addEventListener(Event.CHANGE,this.updateObjFriction);
         }
         if(this.menuObject.getGadget("% Bounce"))
         {
            this.menuObject.getGadget("% Bounce").addEventListener(Event.CHANGE,this.updateObjRestitution);
         }
         if(this.menuObject.getGadget("Damp Speed"))
         {
            this.menuObject.getGadget("Damp Speed").addEventListener(Event.CHANGE,this.updateObjLDamp);
         }
         if(this.menuObject.getGadget("Damp Spin"))
         {
            this.menuObject.getGadget("Damp Spin").addEventListener(Event.CHANGE,this.updateObjADamp);
         }
         if(this.menuObject.getGadget("Health"))
         {
            this.menuObject.getGadget("Health").addEventListener(Event.CHANGE,this.updateObjHealth);
         }
         if(this.menuObject.getGadget("Max Health"))
         {
            this.menuObject.getGadget("Max Health").addEventListener(Event.CHANGE,this.updateObjMaxHealth);
         }
      }
      
      public function remSettingListeners() : void
      {
         if(this.menuObject.getGadget("% Scale"))
         {
            this.menuObject.getGadget("% Scale").removeEventListener(Event.CHANGE,this.updateObjSize);
         }
         if(this.menuObject.getGadget("° Angle"))
         {
            this.menuObject.getGadget("° Angle").removeEventListener(Event.CHANGE,this.updateObjAngle);
         }
         if(this.menuObject.getGadget("% Weight"))
         {
            this.menuObject.getGadget("% Weight").removeEventListener(Event.CHANGE,this.updateObjDensity);
         }
         if(this.menuObject.getGadget("% Friction"))
         {
            this.menuObject.getGadget("% Friction").removeEventListener(Event.CHANGE,this.updateObjFriction);
         }
         if(this.menuObject.getGadget("% Bounce"))
         {
            this.menuObject.getGadget("% Bounce").removeEventListener(Event.CHANGE,this.updateObjRestitution);
         }
         if(this.menuObject.getGadget("Damp Speed"))
         {
            this.menuObject.getGadget("Damp Speed").removeEventListener(Event.CHANGE,this.updateObjLDamp);
         }
         if(this.menuObject.getGadget("Damp Spin"))
         {
            this.menuObject.getGadget("Damp Spin").removeEventListener(Event.CHANGE,this.updateObjADamp);
         }
         if(this.menuObject.getGadget("Health"))
         {
            this.menuObject.getGadget("Health").removeEventListener(Event.CHANGE,this.updateObjHealth);
         }
         if(this.menuObject.getGadget("Max Health"))
         {
            this.menuObject.getGadget("Max Health").removeEventListener(Event.CHANGE,this.updateObjMaxHealth);
         }
         this.remStabSettings();
      }
      
      public function detailSettings(param1:Boolean = true) : void
      {
         var _loc2_:Function = Main.instance.detailUpdate;
         var _loc3_:b2Body = Main.instance.detailBody;
         if(param1)
         {
            if(this.menuObject.visible && this.menuObject.title == "Detail Settings")
            {
               this.menuObject.close();
               return;
            }
         }
         this.menuObject.allowInputDrag = false;
         if(!this.menuObject.visible)
         {
            this.menuObject.open();
         }
         this.menuObject.removeAllChildren();
         this.menuObject.title = "Detail Settings";
         var _loc4_:userData = userData(_loc3_.GetUserData());
         this.menuObject.addInput("X Position",_loc3_.GetPosition().x * Physics.scale >> 0,null,null,"0-9\\-",6).addEventListener(Event.CHANGE,_loc2_);
         this.menuObject.addInput("Y Position",_loc3_.GetPosition().y * Physics.scale >> 0,null,null,"0-9\\-",6).addEventListener(Event.CHANGE,_loc2_);
         this.menuObject.addInput("Scale",_loc4_.size * 100 >> 0).addEventListener(Event.CHANGE,_loc2_);
         this.menuObject.addInput("Angle",_loc3_.GetAngle() * Vars.toDegrees >> 0,null,null,"0-9\\-",4).addEventListener(Event.CHANGE,_loc2_);
         if(_loc4_.conductivity > 0)
         {
            this.menuObject.addInput("Temperature",_loc4_.temperature >> 0,null,null,"0-9\\-",4).addEventListener(Event.CHANGE,_loc2_);
         }
         if(_loc4_.alive || Boolean(_loc4_.armour))
         {
            this.menuObject.addInput("Health",_loc4_.health >> 0,null,null,"0-9",6).addEventListener(Event.CHANGE,_loc2_);
            this.menuObject.addInput("Max Health",_loc4_.maxhealth >> 0,null,null,"0-9",6).addEventListener(Event.CHANGE,_loc2_);
         }
         var _loc5_:String = "0-9";
         if(_loc4_.triggerForceAllowNegative)
         {
            _loc5_ = "0-9\\-";
         }
         if(_loc4_.triggerRadius)
         {
            this.menuObject.addInput("Range",_loc4_.triggerRadius,null,null,"0-9").addEventListener(Event.CHANGE,_loc2_);
         }
         if(_loc4_.triggerForce)
         {
            this.menuObject.addInput("Force",_loc4_.triggerForce,null,null,_loc5_).addEventListener(Event.CHANGE,_loc2_);
         }
         if(_loc4_.originalTriggerDuration)
         {
            this.menuObject.addInput("Duration",_loc4_.originalTriggerDuration,null,null,"0-9").addEventListener(Event.CHANGE,_loc2_);
         }
         this.menuObject.addInput("X Velocity",_loc3_.GetLinearVelocity().x * Physics.scale >> 0,null,null,"0-9\\-").addEventListener(Event.CHANGE,_loc2_);
         this.menuObject.addInput("Y Velocity",_loc3_.GetLinearVelocity().y * Physics.scale >> 0,null,null,"0-9\\-").addEventListener(Event.CHANGE,_loc2_);
         this.menuObject.addInput("A Velocity",_loc3_.GetAngularVelocity() * Vars.toDegrees >> 0,null,null,"0-9\\-").addEventListener(Event.CHANGE,_loc2_);
         if(_loc4_.trigger)
         {
            this.menuObject.addInput("Contact",_loc4_.triggerContact,null,null,"0-9",String(_loc4_.triggerContact).length < 4 ? 4 : String(_loc4_.triggerContact).length).addEventListener(Event.CHANGE,_loc2_);
         }
         this.menuObject.addTooltip("Range","Trigger radius, used for area of effect.\n\n\n");
         this.menuObject.addTooltip("Force","Trigger force, used for damage or range of the item functionality.\n\n\n");
         this.menuObject.addTooltip("Duration","Trigger duration, used for timer-related things such as countdowns or looping.\n\n\n");
         this.menuObject.addTooltip("Contact","Trigger contact force, used for triggering the item on collisions. Zero means disabled.\n\n\n\n");
         this.menuObject.addTooltip("X Velocity","X velocity in Pixels/Second.\n");
         this.menuObject.addTooltip("Y Velocity","Y velocity in Pixels/Second.\n");
         this.menuObject.addTooltip("A Velocity","Angular velocity in Degrees/Second.\n");
         this.dockItemMenuDetail();
      }
      
      private function linkiconhovered(param1:MouseEvent) : void
      {
         this.showTooltip(this.menuSpawn,"Functionality requires or benefits from linking to other items with the Link Tool.\n\n",0,-1,this.menuSpawn.actualWidth);
      }
      
      public function faviconhovered(param1:MouseEvent) : void
      {
         this.showTooltip(this.menuSpawn,"This item has been favourited.\nQuickspawn it by pressing the key, if mapped.\n\n",0,-1,this.menuSpawn.actualWidth);
      }
      
      private function settingiconhovered(param1:MouseEvent) : void
      {
         this.showTooltip(this.menuSpawn,"Spawn Settings\n\nCan\'t be modified\nafter spawning.",0,-1,this.menuSpawn.actualWidth);
      }
      
      private function propertyiconhovered(param1:MouseEvent) : void
      {
         this.showTooltip(this.menuSpawn,"Properties",0,-1,this.menuSpawn.actualWidth);
      }
      
      private function skiniconhovered(param1:MouseEvent) : void
      {
         this.showTooltip(this.menuSpawn,"Item Skin",0,-1,this.menuSpawn.actualWidth);
      }
      
      private function randomiconhovered(param1:MouseEvent) : void
      {
         this.showTooltip(this.menuSpawn,"Random Item",0,-1,this.menuSpawn.actualWidth);
      }
      
      private function searchiconhovered(param1:MouseEvent) : void
      {
         this.showTooltip(this.menuSpawn,"Search Items",0,-1,this.menuSpawn.actualWidth);
      }
      
      private function armouriconhovered(param1:MouseEvent) : void
      {
         this.showTooltip(this.menuSpawn,"Dolls will equip this item automatically.\nAdd Vanilla property to disable equipping.\n\n",0,-1,this.menuSpawn.actualWidth);
      }
      
      private function customiconhovered(param1:MouseEvent) : void
      {
         this.showTooltip(this.menuSpawn,"Manage Custom Items\n",0,-1,this.menuSpawn.actualWidth);
      }
      
      private function dolliconpressed(param1:MouseEvent) : void
      {
         this.stabSettings();
      }
      
      private function dolliconhovered(param1:MouseEvent) : void
      {
         this.showTooltip(this.menuSpawn,"Fleshcraft\n",0,-1,this.menuSpawn.actualWidth);
      }
      
      private function guniconpressed(param1:MouseEvent) : void
      {
         this.showTooltip(this.menuSpawn,"Spawn the item and use the Detail tool to edit it.\n",100,1000,this.menuSpawn.actualWidth);
      }
      
      private function guniconhovered(param1:MouseEvent) : void
      {
         this.showTooltip(this.menuSpawn,"Spawn and use\n[Detail tool > Gunsmith]\nto edit gun settings.\n",0,2000,this.menuSpawn.actualWidth);
      }
      
      public function notfaviconhovered(param1:MouseEvent) : void
      {
         this.showTooltip(this.menuSpawn,"Click to favourite.\nFavourited items can be spawned with hotkeys.\n\n",0,-1,this.menuSpawn.actualWidth);
      }
      
      private function labiconhovered(param1:MouseEvent) : void
      {
         this.showTooltip(this.menuSpawn,"Model designed by\n" + GameState.objects.spawnCreator,0,-1,this.menuSpawn.actualWidth);
      }
      
      private function flipiconhovered(param1:MouseEvent) : void
      {
         this.showTooltip(this.menuSpawn,"Flip",0,-1,this.menuSpawn.actualWidth);
      }
      
      public function genericIconHovered(param1:String) : void
      {
         this.showTooltip(this.menuSpawn,param1,0,-1,this.menuSpawn.actualWidth);
      }
      
      private function displayItemDetails(param1:MouseEvent) : void
      {
         this.showTooltip(this.menuSpawn,GameState.objects.spawnDetails,100,-1,this.menuSpawn.actualWidth < 200 ? 200 : this.menuSpawn.actualWidth);
      }
      
      public function resetDocks(param1:Boolean = false) : void
      {
         GameState.menuHandler.setScale(1);
         GameState.menuHandler.resetDocks();
         this.menuSpawn.close();
         this.menuLibrary.close();
         this.menuWorld.close();
         this.menuSettings.close();
         this.menuSave.close();
         this.menuTools.close();
         this.menuFavourite.close();
         this.menuMain.x = 20;
         this.menuMain.y = 20;
         this.menuControls.x = GameState.width - this.menuControls.actualWidth;
         this.menuControls.y = 20;
         if(Tweak.UIScale == 1)
         {
            this.menuControls.x -= 22;
         }
         this.menuSettings.x = 0;
         this.menuWorld.x = 0;
         this.menuObject.x = GameState.width - this.menuObject.width - 4;
         this.menuObject.y = 4;
         this.menuSpawn.x = this.menuMain.x + 46;
         this.menuSpawn.y = GameState.ui.menuMain.y;
         this.initSpawnMenu(300);
         this.menuKeymap.center();
         this.menuKeyConfig.center();
         this.menuKeyConfig.y = 200;
         this.menuSave.center();
         this.menuSave.y = 200;
         this.menuPrompt.center();
         this.menuFavourite.center();
         this.menuTools.x = this.menuControls.x - this.menuTools.actualWidth + this.menuControls.actualWidth;
         this.menuTools.y = this.menuControls.y + this.menuControls.height + 2;
         this.menuChallenge.x = this.menuMain.x + this.menuMain.actualWidth + 4;
         this.menuChallenge.y = this.menuMain.y;
         this.menuEffects.x = this.menuMain.x + this.menuMain.actualWidth + 4;
         this.menuEffects.y = this.menuMain.y;
         if(param1)
         {
            Settings.defaultMenus();
         }
      }
      
      public function UpdateMenuStyle() : *
      {
         var _loc1_:Object = new Object();
         if(World.toggleDarkMode == 1)
         {
            _loc1_.ColourFont = 13553358;
            _loc1_.ColourButtons = 13553358;
            _loc1_.ColourBackground = 2236962;
            _loc1_.ColourFields = 1118481;
            _loc1_.ColourBorder = 3355443;
            _loc1_.ColourTopbar = 1381653;
         }
         else
         {
            _loc1_.ColourFont = 1118481;
            _loc1_.ColourButtons = 4473924;
            _loc1_.ColourBackground = 12829635;
            _loc1_.ColourFields = 15921906;
            _loc1_.ColourBorder = 10066329;
            _loc1_.ColourTopbar = 14079702;
         }
         this.menuMain.setStyle(_loc1_);
         Style.BACKGROUND = this.menuMain.TOPBARCOLOUR;
         Style.LABEL_TEXT = this.menuMain.FONTCOLOUR;
         Style.INPUT_TEXT = this.menuMain.FONTCOLOUR;
         if(World.toggleDarkMode == 1)
         {
            Style.BUTTON_FACE = 3355443;
         }
         else
         {
            Style.BUTTON_FACE = 15658734;
         }
         this.menuMain.setStyle(_loc1_);
         this.menuControls.setStyle(_loc1_);
         this.menuSettings.setStyle(_loc1_);
         this.menuWorld.setStyle(_loc1_);
         this.menuObject.setStyle(_loc1_);
         this.menuKeymap.setStyle(_loc1_);
         this.menuKeyConfig.setStyle(_loc1_);
         this.menuPrompt.setStyle(_loc1_);
         this.menuSave.setStyle(_loc1_);
         this.menuSpawn.setStyle(_loc1_);
         this.menuLibrary.setStyle(_loc1_);
         this.menuFavourite.setStyle(_loc1_);
         this.menuTools.setStyle(_loc1_);
         this.menuColour.setStyle(_loc1_);
         this.menuDetails.setStyle(_loc1_);
         this.menuEffects.setStyle(_loc1_);
         this.menuChallenge.setStyle(_loc1_);
      }
      
      public function closeAllMenus() : void
      {
         this.menuMain.close();
         this.menuSettings.close();
         this.menuObject.close();
         this.menuKeymap.close();
         this.menuKeyConfig.close();
         this.menuPrompt.unlock();
         this.menuPrompt.close();
         this.menuSave.close();
         this.menuSpawn.close();
         this.menuLibrary.close();
         this.menuEffects.close();
         this.menuFavourite.close();
         this.menuWorld.close();
         this.menuColour.close();
         this.menuDetails.close();
      }
      
      public function showIncompatiblePlayer() : void
      {
         this.menuControls.alpha = 0;
         this.menuMain.alpha = 0;
         Main.instance.m_sprite.alpha = 0;
         Main.instance.mainmenu.visible = false;
         this.menuPrompt.unlock();
         this.menuPrompt.getField("info").type = TextFieldType.DYNAMIC;
         this.menuPrompt.visible = true;
         this.menuPrompt.title = "Incompatible Player Detected";
         this.menuPrompt.moveToTop();
         this.menuPrompt.center();
         this.menuPrompt.lock();
         this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_promptEOL);
         this.menuPrompt.getField("info").text = "This player doesn\'t support MaD2 properly.\n\nGet MaD2 Download:\n[Itch.io]\nhttps://dashrava.itch.io/mutilate\n\n[Kartridge]\nwww.kartridge.com/games/0rava/mutilate-a-doll-2\n\n[Steam]\nhttps://store.steampowered.com/app/665370/";
         this.menuMain.visible = false;
         if(Main.instance.getChildByName("preloader"))
         {
            Main.instance.getChildByName("preloader").visible = false;
         }
         O.disableUpdating();
         this.menuControls.visible = false;
      }
      
      private function welcomePopup() : void
      {
         this.menuPrompt.title = "Welcome";
         this.menuPrompt.getField("info").text = "Welcome to MaD2!\n\nThe tutorial might be a good point to start, as the game can be a tad complex at parts.\n\nThis game is frequently updated, and suggestions are most welcome in the comments as well as social media.\n\nPlease read the FAQ before suggesting things.";
         this.menuPrompt.unlock();
         this.menuPrompt.getField("info").type = TextFieldType.DYNAMIC;
         this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_winter);
         this.menuPrompt.visible = true;
         this.menuPrompt.unlock();
         this.menuPrompt.moveToTop();
         this.menuPrompt.center();
         this.menuPrompt.lock();
      }
      
      public function resetPopup() : void
      {
         TimeLord.pause();
         this.menuPrompt.title = "Confirm Reset";
         this.menuPrompt.getField("info").text = "Reseting destroys all spawned items and\nspawns a new doll.\n\nThis can\'t be undone unless you\'ve saved recently.\n\nAre you sure you want to reset?";
         this.menuPrompt.unlock();
         this.menuPrompt.getField("info").type = TextFieldType.DYNAMIC;
         this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_promptReset);
         this.menuPrompt.visible = true;
         this.menuPrompt.unlock();
         this.menuPrompt.moveToTop();
         this.menuPrompt.center();
         this.menuPrompt.lock();
      }
      
      public function kongPopup() : void
      {
         this.menuPrompt.title = "";
         this.menuPrompt.getField("info").text = "Content sharing and browsing only available on Kongregate, as it relies on their API.\n\nLocal saves, and manual string exporting is still possible.\n";
         this.menuPrompt.unlock();
         this.menuPrompt.getField("info").type = TextFieldType.DYNAMIC;
         this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_promptKongShare);
         this.menuPrompt.visible = true;
         this.menuPrompt.unlock();
         this.menuPrompt.moveToTop();
         this.menuPrompt.center();
         this.menuPrompt.lock();
      }
      
      public function capabilityPopup() : void
      {
         this.menuPrompt.title = "";
         this.menuPrompt.getField("info").text = "The detected Flash Player version is not compatible with some of the features of this game.\n\nMaD2 requires Flash Player 14 or higher for some of the layering it uses for newer items.\nOn your version some items may turn invisible, or miss parts after cutting them.\n\nUpdate the player if possible, otherwise play at your own risk.\n";
         this.menuPrompt.unlock();
         this.menuPrompt.getField("info").type = TextFieldType.DYNAMIC;
         this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_done);
         this.menuPrompt.visible = true;
         this.menuPrompt.unlock();
         this.menuPrompt.moveToTop();
         this.menuPrompt.center();
         this.menuPrompt.lock();
      }
      
      public function menuStylePopup() : void
      {
         this.menuPrompt.title = "";
         this.menuPrompt.getField("info").textColor = this.menuMain.FONTCOLOUR;
         this.menuPrompt.getField("info").text = "Now previewing menu style toggle.\n\nFinalizing style change requires restarting\n(sorry.)\n\nFeel free to restart whenever, or toggle back if you don\'t like what you see.\n\nMenus will likely appear with mismatched styles until you do so.";
         this.menuPrompt.unlock();
         this.menuPrompt.getField("info").type = TextFieldType.DYNAMIC;
         this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_done);
         this.menuPrompt.visible = true;
         this.menuPrompt.moveToTop();
         this.menuPrompt.center();
      }
      
      public function errorPopup(param1:Error, param2:String) : void
      {
         if(param1.errorID == 1502)
         {
            this.menuPrompt.getField("info").text = "Script execution has timed out due to lack of performance, causing the game to fail to load.\n\nRestart the game to attempt loading again.\n\nIf restarting doesn\'t help, try closing any heavy software and pages/tabs you may have running, or try playing on a different browser.";
            this.menuPrompt.visible = true;
            this.menuPrompt.moveToTop();
            return;
         }
         this.menuPrompt.getField("info").text = "If you\'re seeing this, please submit it in Bug Reports:\n" + param2 + ": " + (param1.name + " " + param1.message + " " + param1.getStackTrace());
         this.menuPrompt.visible = true;
         this.menuPrompt.moveToTop();
      }
      
      public function updateSpawnSettings() : void
      {
         this.menuObject.setValue("% Scale",100 * Vars.objSize);
         this.menuObject.setValue("° Angle",100 * Vars.objAngle);
         this.menuObject.setValue("% Weight",100 * Vars.objDensity);
         this.menuObject.setValue("% Friction",100 * Vars.objFriction);
         this.menuObject.setValue("% Bounce",100 * Vars.objRestitution);
         this.menuObject.setValue("Damp Speed",Vars.objDampLinear);
         this.menuObject.setValue("Damp Spin",Vars.objDampAngular);
         this.UpdateItemSettings();
      }
      
      public function updateSpeed(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuSettings.getValue("% Simulation Speed")) * 0.01;
         if(_loc2_ > 5)
         {
            _loc2_ = 5;
            GameState.ui.menuSettings.setValue("% Simulation Speed",int(_loc2_ * 100));
         }
         else if(_loc2_ < 0.01)
         {
            _loc2_ = 0.01;
            GameState.ui.menuSettings.setValue("% Simulation Speed",int(_loc2_ * 100));
         }
         TimeLord.unpause();
         Vars.speed = _loc2_;
         TimeLord.speed = _loc2_;
      }
      
      public function updateSlowSpeed(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuSettings.getValue("% Slow Motion Speed")) * 0.01;
         TimeLord.unpause();
         Vars.slowspeed = _loc2_;
         if(GameState.slomo)
         {
            TimeLord.speed = _loc2_;
         }
      }
      
      public function updateIterations(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuSettings.getValue("Physics Iterations"));
         Tweak.m_iterations = int(Math.round(_loc2_));
      }
      
      public function updateIterations2(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuSettings.getValue("Physics Iterations [<10]"));
         Tweak.m_iterations = int(Math.round(_loc2_));
      }
      
      public function updateAntiFreeze(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuSettings.getValue("Anti-Freeze FPS [<10]"));
         Tweak.AntiFreezeFPS = int(Math.round(_loc2_));
      }
      
      public function updateMinShrapnelSize(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuSettings.getValue("Min Cut Length"));
         Tweak.MinShrapnelSize = _loc2_ * 0.01;
      }
      
      public function updateMaxCuts(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuSettings.getValue("Max Cuts / Frame"));
         Vars.cutlimit = _loc2_;
      }
      
      public function updateParticles(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuSettings.getValue("% Particles")) * 0.01;
         Vars.particles = _loc2_;
      }
      
      public function updateMaxParticles(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuSettings.getValue("Max Particles"));
         Vars.particlesMax = _loc2_;
      }
      
      public function updateLoadSpeed(param1:Event) : void
      {
         var _loc2_:int = int(GameState.ui.menuSave.getValue("Loading Speed"));
         Vars.loadSpeed = _loc2_;
      }
      
      public function updateBloodSmoothing(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuSettings.getValue("Smooth Blood Fluidity") * 0.01);
         Tweak.bloodSmoothing = _loc2_;
      }
      
      public function updateSmoothBloodSize(param1:Event) : void
      {
         var _loc2_:Number = Math.round(GameState.ui.menuSettings.getValue("Smooth Blood Size"));
         Tweak.smoothBloodSize = _loc2_;
         R.setSprite("smooth_blood_" + Tweak.bloodColour,Main.instance.updateSmoothBloodBMD(Tweak.bloodColour).clone());
      }
      
      public function updateMaxParticles2(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuSettings.getValue("Max Particles [<1000]"));
         Vars.particlesMax = _loc2_;
      }
      
      public function updateMaxCollisions(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuSettings.getValue("Max Collisions [<50]"));
         Vars.collisionsMax = _loc2_;
      }
      
      public function updateVolume(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuSettings.getValue("% Volume")) * 0.01;
         sounds.vol = _loc2_;
      }
      
      public function updateBarScale(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuSettings.getValue("% Healthbar Scale")) * 0.01;
         Vars.barscale = _loc2_;
      }
      
      public function updateDragForceEditor(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuSettings.getValue("% Drag Strength")) * 0.01;
         Vars.dragEditor = _loc2_;
      }
      
      public function updateWheelSpeed(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuSettings.getValue("% Wheel Rotation")) * 0.01;
         Vars.wheelSpeed = _loc2_;
      }
      
      public function updateUIScale(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuSettings.getValue("% Window Scale")) * 0.01;
         GameState.menuHandler.setScale(_loc2_);
      }
      
      public function updateDragForceDoll(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuSettings.getValue("% Roleplay Strength")) * 0.01;
         Vars.dragDoll = _loc2_;
      }
      
      public function updateCameraAcceleration(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuSettings.getValue("% Camera Acceleration")) * 0.01;
         Vars.cameraAcceleration = _loc2_;
      }
      
      public function updateEdgePanDelay(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuSettings.getValue("Edge Pan Delay"));
         Vars.edgePanDelay = _loc2_;
      }
      
      public function updateMenuAlpha(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuSettings.getValue("% Menu Alpha")) * 0.01;
         GameState.menuHandler.setAlpha(_loc2_);
      }
      
      public function updateGravity(param1:Event) : void
      {
         var _loc2_:Number = HUISlider(param1.currentTarget).value;
         if(!isNaN(_loc2_))
         {
            Vars.gravity = Math.round(_loc2_);
         }
      }
      
      public function updateWind(param1:Event) : void
      {
         var _loc2_:Number = HUISlider(param1.currentTarget).value;
         if(!isNaN(_loc2_))
         {
            Vars.wind = _loc2_;
            GameState.environment.windForce = _loc2_;
         }
      }
      
      public function updateTemp(param1:Event) : void
      {
         var _loc2_:Number = HUISlider(param1.currentTarget).value;
         if(!isNaN(Number(_loc2_)))
         {
            Vars.temperature = _loc2_;
         }
      }
      
      public function updateClutterDensity(param1:Event) : void
      {
         GameState.environment.seed = Vars.seed;
         var _loc2_:Number = HUISlider(param1.currentTarget).value;
         GameState.environment.clutterDensity = _loc2_;
         GameState.environment.setupBackground();
      }
      
      public function updateSeed(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuWorld.getValue("Seed"));
         Vars.seed = _loc2_;
         GameState.environment.seed = Vars.seed;
         GameState.environment.setupBackground();
      }
      
      public function updateStabSetting(param1:String, param2:String, param3:Boolean = false) : Function
      {
         var setting:String = param1;
         var property:String = param2;
         var updateSpawnPic:Boolean = param3;
         return function(param1:Event):void
         {
            var _loc4_:* = undefined;
            var _loc5_:* = undefined;
            var _loc2_:* = Number(GameState.ui.menuObject.getValue(setting)) * 0.01;
            var _loc3_:* = Main.instance.detailBody;
            if(_loc3_ != null)
            {
               _loc4_ = _loc3_.GetUserData();
               _loc4_[property] = _loc2_;
               for each(_loc5_ in Main.instance.selectedBodies)
               {
                  userData(_loc5_.GetUserData())[property] = _loc2_;
               }
            }
            else
            {
               Vars.stabSettings[setting] = _loc2_;
               if(updateSpawnPic && GameState.ui.menuSpawn.visible)
               {
                  Main.instance.updateSpawnPic();
               }
            }
         };
      }
      
      public function updateGunSetting(param1:String, param2:String, param3:Boolean = false) : Function
      {
         var setting:String = param1;
         var property:String = param2;
         var updateSpawnPic:Boolean = param3;
         return function(param1:Event):void
         {
            var _loc4_:* = undefined;
            var _loc5_:* = undefined;
            var _loc2_:* = Number(GameState.ui.menuObject.getValue(setting));
            if(property == "bulletSize")
            {
               _loc2_ *= 0.01;
            }
            var _loc3_:* = Main.instance.detailBody;
            if(_loc3_ != null)
            {
               _loc4_ = _loc3_.GetUserData();
               if(Boolean(_loc4_.trigger) && _loc4_.trigger is Gun)
               {
                  Gun(_loc4_.trigger).firearm.SetProperty(property,_loc2_);
               }
               for each(_loc5_ in Main.instance.selectedBodies)
               {
                  if(!(!_loc4_.trigger || !(_loc4_.trigger is Gun)))
                  {
                     Gun(_loc5_.GetUserData().trigger).firearm.SetProperty(property,_loc2_);
                  }
               }
            }
            else
            {
               Vars.gunSettings[setting] = _loc2_;
               Vars.gunSettings["modified"] = true;
               if(updateSpawnPic && GameState.ui.menuSpawn.visible)
               {
                  Main.instance.updateSpawnPic();
               }
            }
         };
      }
      
      public function updateObjSize(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuObject.getValue("% Scale")) / 100;
         Vars.objSize = _loc2_;
         if(GameState.ui.menuSpawn.visible)
         {
            Main.instance.updateSpawnPic();
         }
      }
      
      public function updateObjDensity(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuObject.getValue("% Weight")) / 100;
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
            GameState.ui.menuObject.setValue("% Weight",int(_loc2_ * 100));
         }
         Vars.objDensity = _loc2_;
      }
      
      public function updateObjFriction(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuObject.getValue("% Friction")) / 100;
         Vars.objFriction = _loc2_;
      }
      
      public function updateObjRestitution(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuObject.getValue("% Bounce")) / 100;
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
            GameState.ui.menuObject.setValue("% Bounce",int(_loc2_ * 100));
         }
         Vars.objRestitution = _loc2_;
      }
      
      public function updateObjAngle(param1:Event) : void
      {
         var _loc2_:String = GameState.ui.menuObject.getValue("° Angle");
         if(!_loc2_ || _loc2_ == "-")
         {
            return;
         }
         var _loc3_:Number = Number(_loc2_);
         if(_loc3_ > 360)
         {
            _loc3_ = 360;
         }
         else if(_loc3_ < -360)
         {
            _loc3_ = -360;
         }
         GameState.ui.menuObject.setValue("° Angle",_loc3_);
         Vars.objAngle = _loc3_;
         Main.instance.updateSpawnPic();
      }
      
      public function updateObjLDamp(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuObject.getValue("Damp Speed"));
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         GameState.ui.menuObject.setValue("Damp Speed",_loc2_);
         Vars.objDampLinear = _loc2_;
      }
      
      public function updateObjADamp(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuObject.getValue("Damp Spin"));
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         GameState.ui.menuObject.setValue("Damp Spin",_loc2_);
         Vars.objDampAngular = _loc2_;
      }
      
      public function updateObjHealth(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuObject.getValue("Health"));
         GameState.ui.menuObject.setValue("Health",_loc2_);
         Vars.objHealth = _loc2_;
      }
      
      public function updateObjMaxHealth(param1:Event) : void
      {
         var _loc2_:Number = Number(GameState.ui.menuObject.getValue("Max Health"));
         GameState.ui.menuObject.setValue("Max Health",_loc2_);
         Vars.objMaxHealth = _loc2_;
      }
   }
}

