package
{
   import Box2D.Collision.b2AABB;
   import Box2D.Collision.b2Segment;
   import Box2D.Common.Math.b2Math;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2DistanceJoint;
   import Box2D.Dynamics.Joints.b2Joint;
   import Box2D.Dynamics.Joints.b2JointEdge;
   import Box2D.Dynamics.Joints.b2MouseJoint;
   import Box2D.Dynamics.Joints.b2MouseJointDef;
   import Box2D.Dynamics.Joints.b2RevoluteJoint;
   import Box2D.Dynamics.Joints.b2WeldJoint;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2DebugDraw;
   import Box2D.Dynamics.b2World;
   import Gun.Firearm;
   import com.anegmetex.Soundmanager.sounds;
   import com.bit101.components.HUISlider;
   import com.colour.bitmaps.HueBar;
   import com.colour.bitmaps.LightnessBar;
   import com.colour.bitmaps.SaturationBar;
   import com.colour.bitmaps.Spectrum;
   import com.colour.controls.ColourPicker;
   import com.colour.controls.ColourPickerEvent;
   import com.colour.controls.Handle;
   import com.dashrava.utils.DurationTimer;
   import com.hybrid.ui.ToolTip;
   import com.yahoo.astra.fl.controls.AutoComplete;
   import com.yahoo.astra.fl.controls.Tree;
   import com.yahoo.astra.fl.controls.treeClasses.LeafNode;
   import com.yahoo.astra.fl.controls.treeClasses.TNode;
   import com.yahoo.astra.fl.controls.treeClasses.TreeCellRenderer;
   import com.yahoo.astra.fl.controls.treeClasses.TreeDataProvider;
   import com.yahoo.astra.fl.events.DropdownEvent;
   import environment.*;
   import fl.data.DataProvider;
   import fl.events.ListEvent;
   import flash.desktop.Clipboard;
   import flash.desktop.ClipboardFormats;
   import flash.desktop.NativeApplication;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.GradientType;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.Screen;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.display.StageDisplayState;
   import flash.display.StageQuality;
   import flash.display.StageScaleMode;
   import flash.events.ContextMenuEvent;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filesystem.File;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.BlurFilter;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.SharedObject;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.Capabilities;
   import flash.system.System;
   import flash.text.Font;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.Keyboard;
   import flash.utils.ByteArray;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import powers.*;
   import shiny.*;
   import triggers.*;
   
   [SWF(width="1066", height="600", backgroundColor="#000000", frameRate="60")]
   public class Main extends MovieClip
   {
      
      public static var instance:Main;
      
      public var preloader:MovieClip;
      
      private var trigger:TriggerSystem;
      
      public var cam:Sprite;
      
      public var m_sprite:Sprite;
      
      public var mouseCatcher:Sprite;
      
      public var backgroundSprite:Sprite;
      
      public var itemSprite:Sprite;
      
      public var foregroundSprite:Sprite;
      
      public var toolSprite:Sprite;
      
      private var m_AABB:b2AABB;
      
      private var m_boundaryListener:CustomBoundaryListener;
      
      public var m_contactListener:CustomContactListener;
      
      public var dbgDraw:b2DebugDraw;
      
      private var fps:FPScounter;
      
      public var dollNumber:int = 0;
      
      private var segment:b2Segment;
      
      private var cutStart:b2Vec2;
      
      private var cutEnd:b2Vec2;
      
      private var cutDelta:Number = 0;
      
      private var linkStart:b2Vec2;
      
      private var linkEnd:b2Vec2;
      
      private var linkDelta:Number = 0;
      
      private var joints:Sprite;
      
      public var debugBM:Bitmap;
      
      public var bloodBMD:BitmapData;
      
      public var bloodBMD2:BitmapData;
      
      public var particlesBMD:BitmapData;
      
      public var particlesBM:Bitmap;
      
      private var keyhelp:MovieClip;
      
      public var bgBM:Bitmap;
      
      public var detailBody:b2Body;
      
      private var detailCounter:int;
      
      public var jointBody:b2Body;
      
      private var jointBody2:b2Body;
      
      private var rotateBody:b2Body;
      
      private var jointPos:b2Vec2;
      
      private var zoomPos:b2Vec2;
      
      public var spawnPos:b2Vec2;
      
      private var shiftPressed:Boolean = false;
      
      public var pauseMoving:Boolean = false;
      
      public var pauseMovingBodies:Array;
      
      public var forceFlip:Boolean = false;
      
      public var flipped:Boolean;
      
      public var spawnFlipped:Boolean;
      
      public var itemTriggered:Boolean;
      
      public var stabPressBandaid:Boolean = false;
      
      public var combo4:Array;
      
      public var comboProgress4:int = 0;
      
      public var combo2:Array;
      
      public var comboProgress2:int = 0;
      
      public var comboRequisite:Boolean = false;
      
      public var comboRequisite2:Boolean = false;
      
      public var previewEffectBody:b2Body;
      
      private var previewEffect:ParticleEffect;
      
      private var previewEffectType:String = "";
      
      private var previewEffectShape:String = "";
      
      private var previewEffectNode:Object;
      
      public var datanag:Boolean = true;
      
      private var mappingObject:String;
      
      private var scalingPos:b2Vec2;
      
      private var selectingPos:b2Vec2;
      
      internal var glowColour:* = 4493522;
      
      internal var selectColour:* = 4493522;
      
      internal var linkColour:* = 4695116;
      
      internal var ignoreColour:* = 11484485;
      
      internal var selectColourFilter:ColorMatrixFilter;
      
      internal var selectGlowFilter:GlowFilter;
      
      internal var selectShadowFilter:DropShadowFilter;
      
      internal var highlightGlowFilter:GlowFilter;
      
      private var cutArray:Array;
      
      public var brittleArray:Array;
      
      public var jointArray:Array;
      
      public var selectedBodies:Vector.<b2Body>;
      
      public var selectedSelection:Vector.<b2Body>;
      
      public var deletedBodies:Vector.<b2Body>;
      
      public var previousBody:b2Body;
      
      public var favourites:Array;
      
      public var customNames:Array;
      
      public var customItems:Array;
      
      public var localNames:Array;
      
      public var localItems:Array;
      
      public var currentSave:String = "";
      
      public var loadedLevel:String = "";
      
      public var loadedCustomItem:String;
      
      public var qSaveArray:Array;
      
      public var qSaveTimeArray:Array;
      
      public var favouriteSaves:Array;
      
      public var favouriteSaveNames:Array;
      
      public var favouriteSaveReset:int = -1;
      
      private var AutoSaveTimer:DurationTimer;
      
      private var customRenaming:String;
      
      public var m_mouseJoint:b2MouseJoint;
      
      public var mouseXWorld:Number;
      
      public var mouseYWorld:Number;
      
      public var effecting:Boolean = false;
      
      public var mainmenu:MovieClip;
      
      public var scrollhint:MovieClip;
      
      public var scrollhintV:MovieClip;
      
      public var firearmArray:Vector.<Firearm>;
      
      public var cameraPan:b2Vec2;
      
      private var cameraVel:b2Vec2;
      
      private var spectrum:Spectrum;
      
      private var colourPicker:ColourPicker;
      
      private var colourPickerField:TextField;
      
      private var cursorSpectrum:Sprite;
      
      private var skinModifying:String;
      
      public var skinOriginal:String;
      
      public var panLeft:Boolean = false;
      
      public var panRight:Boolean = false;
      
      public var panUp:Boolean = false;
      
      public var panDown:Boolean = false;
      
      private var panMouseLeft:Boolean = false;
      
      private var panMouseRight:Boolean = false;
      
      private var panMouseUp:Boolean = false;
      
      private var panMouseDown:Boolean = false;
      
      private var prevMouse:b2Vec2;
      
      private var mouseVel:b2Vec2;
      
      private var mouseVels:Vector.<b2Vec2>;
      
      private var mouseVelAverage:b2Vec2;
      
      private var draggingFirearm:Boolean;
      
      private var draggingAiming:Boolean;
      
      private var canThrowPower:Boolean;
      
      private var mouseleft:Boolean = false;
      
      private var mousepancounter:int = 10;
      
      private var jointsCleared:Boolean = false;
      
      public var colouring:String;
      
      private var rotatePositions:Vector.<b2Vec2>;
      
      private var rotateAngles:Vector.<Number>;
      
      public var sharingItem:Boolean = false;
      
      private var dulin:String;
      
      public var customPos:b2Vec2;
      
      public var customName:String;
      
      public var backBodies:Array;
      
      private var detailLine:Sprite;
      
      public var contract:Contract;
      
      private var contractArea:Boolean = false;
      
      private var contractTarget:Boolean = false;
      
      private var contractSplashShown:Boolean = false;
      
      public var PowerAutoUpdate:int = 2;
      
      private var powerMovePos:b2Vec2;
      
      private var powerMove:String;
      
      public var acData:Array;
      
      private var acUnique:Array;
      
      private var acTags:Array;
      
      private var movingCamera:Boolean = false;
      
      private var zoomingCamera:Boolean = false;
      
      private var dragCamCurrent:Point;
      
      private var dragCamMoved:Point;
      
      private var dragCamOrig:Point;
      
      private var dragBGOrig:Point;
      
      private var customItemOverridePositionBandaid:Boolean = false;
      
      public var customItemLoadedBandaid:Boolean = false;
      
      private var pauseReleasedBandaid:Boolean = false;
      
      private var cameraKeySpammedBandaid:int = 0;
      
      private var detailSubmenu:String = "main";
      
      private var quickCreatingCustomItem:int = 0;
      
      private var selectDoubleclick:int = 0;
      
      internal var hoveredJoint:int = -1;
      
      internal var hoveredJointBody:int = -1;
      
      internal var detailSkinBase:Array;
      
      internal var camCullDistance:b2Vec2;
      
      internal var spawnMenuSize:Number = 224;
      
      internal var previousWindow:Rectangle;
      
      internal var wasfrozen:Number = -1;
      
      internal var gamefrozen:Array;
      
      public function Main()
      {
         var ctx:ContextMenu;
         var dashrava:ContextMenuItem = null;
         var sfd:ContextMenuItem = null;
         var sfb:ContextMenuItem = null;
         var stw:ContextMenuItem = null;
         var screenBounds:Rectangle = null;
         var itemTree:Tree = null;
         var foundNode:TNode = null;
         var nodeIndex:int = 0;
         this.m_sprite = new Sprite();
         this.mouseCatcher = new Sprite();
         this.backgroundSprite = new Sprite();
         this.itemSprite = new Sprite();
         this.foregroundSprite = new Sprite();
         this.toolSprite = new Sprite();
         this.fps = new FPScounter(25,25,16777215);
         this.segment = new b2Segment();
         this.cutStart = new b2Vec2();
         this.cutEnd = new b2Vec2();
         this.linkStart = new b2Vec2();
         this.linkEnd = new b2Vec2();
         this.joints = new Sprite();
         this.bgBM = new Bitmap();
         this.pauseMovingBodies = [];
         this.combo4 = [66,85,70,70,68,79,76,76,66,85,70,70,68,79,76,76,66,85,70,70,68,79,76,76,66,85,70,70,68,79,76,76];
         this.combo2 = [66,85,70,70,68,79,76,76];
         this.previewEffectNode = {};
         this.selectColourFilter = new ColorMatrixFilter([1,0,0,0,30,0,1,0,0,30,0,0,1,0,30,0,0,0,1,0]);
         this.selectGlowFilter = new GlowFilter(15658734,1,4,4,3,BitmapFilterQuality.LOW,false);
         this.selectShadowFilter = new DropShadowFilter(2,90,1118481,0.5);
         this.highlightGlowFilter = new GlowFilter(4493522,1,4,4,4,BitmapFilterQuality.LOW,false);
         this.cutArray = [];
         this.brittleArray = [];
         this.jointArray = [];
         this.selectedBodies = new Vector.<b2Body>();
         this.selectedSelection = new Vector.<b2Body>();
         this.deletedBodies = new Vector.<b2Body>();
         this.favourites = [];
         this.customNames = [];
         this.customItems = [];
         this.localNames = [];
         this.localItems = [];
         this.qSaveArray = [];
         this.qSaveTimeArray = [];
         this.favouriteSaves = [];
         this.favouriteSaveNames = [];
         this.firearmArray = new Vector.<Firearm>();
         this.cameraPan = new b2Vec2();
         this.cameraVel = new b2Vec2();
         this.cursorSpectrum = new Sprite();
         this.prevMouse = new b2Vec2();
         this.mouseVel = new b2Vec2();
         this.mouseVels = new Vector.<b2Vec2>();
         this.mouseVelAverage = new b2Vec2();
         this.rotatePositions = new Vector.<b2Vec2>();
         this.rotateAngles = new Vector.<Number>();
         this.backBodies = [];
         this.dragCamCurrent = new Point();
         this.dragCamMoved = new Point();
         this.dragCamOrig = new Point();
         this.dragBGOrig = new Point();
         this.camCullDistance = new b2Vec2();
         this.gamefrozen = [60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60];
         super();
         Tweak.download = true;
         ctx = new ContextMenu();
         ctx.builtInItems.forwardAndBack = false;
         ctx.builtInItems.loop = false;
         ctx.builtInItems.rewind = false;
         ctx.builtInItems.print = false;
         ctx.builtInItems.save = false;
         dashrava = new ContextMenuItem("rava.games");
         dashrava.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,Links.Dashrava);
         sfd = new ContextMenuItem("Discord",true);
         sfd.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,Links.Discord);
         sfb = new ContextMenuItem("Facebook",true);
         sfb.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,Links.Facebook);
         stw = new ContextMenuItem("Twitter");
         stw.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,Links.Twitter);
         ctx.customItems.push(dashrava,sfd,sfb,stw);
         contextMenu = ctx;
         stage.scaleMode = StageScaleMode.NO_SCALE;
         GameState.steamworks = new SteamWorks();
         Font.registerFont(yanone);
         instance = this;
         GameState.width = stage.stageWidth;
         GameState.height = stage.stageHeight;
         GameState.menuHandler = new MenuHandler();
         if(Tweak.download)
         {
            if(Capabilities.playerType.toLowerCase().indexOf("desktop") != -1)
            {
               screenBounds = Screen.mainScreen.bounds;
               stage.nativeWindow.x = (screenBounds.width - stage.nativeWindow.width) * 0.5;
               stage.nativeWindow.y = (screenBounds.height - stage.nativeWindow.height) * 0.5;
            }
         }
         this.mainmenu = new mainmenumc();
         this.scrollhint = new scrollhintmc();
         this.scrollhintV = new scrollhintVmc();
         R.initSprites();
         Physics.scale = Vars.physScale;
         this.m_AABB = new b2AABB();
         this.m_AABB.lowerBound.Set(-1000,-1000);
         this.m_AABB.upperBound.Set(1000,1000);
         Physics.world = new b2World(this.m_AABB,new b2Vec2(0,0),true);
         this.m_contactListener = new CustomContactListener();
         Physics.contactFilter = new CustomContactFilter();
         this.m_boundaryListener = new CustomBoundaryListener();
         Physics.world.SetContactListener(this.m_contactListener);
         Physics.world.SetContactFilter(Physics.contactFilter);
         Physics.world.SetBoundaryListener(this.m_boundaryListener);
         GameState.particles = new PS();
         GameState.particles.init();
         GameState.objects = new Obj();
         GameState.ui = new UI();
         O.initItems();
         Keymap.init();
         this.trigger = new TriggerSystem();
         GameState.hullHandler = new ConvexHull();
         Tool.init();
         sounds.init(GameState.width,GameState.height);
         GameState.environment = new Lab();
         Vars.gravity = GameState.environment.gravity;
         Vars.wind = GameState.environment.wind;
         Vars.temperature = GameState.environment.temperature;
         GameState.environmenting = false;
         this.initConsole();
         try
         {
            IO.lab = new MaDLab();
            IO.lab.addEventListener(LabEvent.ON_LOAD_COMPLETE,this.lab_EventHandler);
            Settings.backupLocalItems();
            this.loadFavourites();
            this.loadPowers();
            this.loadCustomItems();
            this.loadLocalItems();
            GameState.steamworks.loadLocalWorkshop();
         }
         catch(errObject:Error)
         {
            GameState.ui.console.showConsole();
            GameState.ui.console.setConsoleText("CONTENT FILES FAILED TO LOAD. Please submit your .sol files in Bug Reports (see FAQ for help.)");
            return;
         }
         try
         {
            this.loadWorldSettings();
         }
         catch(e:Error)
         {
            GameState.ui.console.setConsoleText("SETTINGS FILE FAILED TO LOAD. Please submit your settings.sol files in Bug Reports (see FAQ for help.)");
            GameState.ui.console.showConsole();
            return;
         }
         try
         {
            GameState.ui.init();
            this.BuildInterface();
            this.buildTreeMenus();
            GameState.menuHandler.setScale(Tweak.UIScale);
            this.loadMenus();
            this.updateKeys();
            Settings.loadMapping();
            this.loadSettings();
            this.loadLocalSaves();
            this.initLibraryItems();
         }
         catch(errObject:Error)
         {
            GameState.ui.errorPopup(errObject,"MENU INIT FAILED. Please submit your .sol files (see FAQ) in Bug Reports.");
            GameState.ui.console.showConsole();
            return;
         }
         GameState.environmenting = false;
         if(World.toggleSmoothBlood == 1)
         {
            this.updateBlood();
         }
         GameState.cutter = new Cutter();
         stage.addEventListener(Event.ENTER_FRAME,this.update);
         if(!Tweak.download)
         {
            try
            {
               Kongregate.initAPI();
            }
            catch(errObject:Error)
            {
               GameState.ui.errorPopup(errObject,"API LOAD");
               return;
            }
         }
         try
         {
            if(GameState.environment)
            {
               GameState.environment.setupWalls();
            }
            if(!this.favourites || this.favourites.length == 0)
            {
               this.resetFavs();
            }
            GameState.ui.updateFavs();
            this.addUserListeners();
            stage.addChild(this.mainmenu);
            stage.addChild(this.scrollhint);
            stage.addChild(this.scrollhintV);
            this.scrollhint.visible = false;
            this.scrollhintV.visible = false;
            this.mainmenu.visible = false;
            this.m_sprite.visible = false;
            if(this.mainmenu.getChildByName("btn_play"))
            {
               new BigJuicyMenuButton(MovieClip(this.mainmenu.getChildByName("btn_play")),this.playButton);
            }
            if(this.mainmenu.getChildByName("btn_halloween"))
            {
               new BigJuicyMenuButton(MovieClip(this.mainmenu.getChildByName("btn_halloween")),this.startPumpkinMoon);
            }
            if(this.mainmenu.getChildByName("btn_winter"))
            {
               new BigJuicyMenuButton(MovieClip(this.mainmenu.getChildByName("btn_winter")),this.startWinterHitList);
            }
            if(this.mainmenu.getChildByName("btn_tutorial"))
            {
               new BigJuicyMenuButton(MovieClip(this.mainmenu.getChildByName("btn_tutorial")),this.playTutorial);
            }
            if(this.mainmenu.getChildByName("btn_kong"))
            {
               new BigJuicyMenuButton(MovieClip(this.mainmenu.getChildByName("btn_kong")),Links.Kong);
            }
            if(this.mainmenu.getChildByName("btn_steam"))
            {
               new BigJuicyMenuButton(MovieClip(this.mainmenu.getChildByName("btn_steam")),Links.Steam);
            }
            if(this.mainmenu.getChildByName("btn_steamStore"))
            {
               new BigJuicyMenuButton(MovieClip(this.mainmenu.getChildByName("btn_steamStore")),Links.SteamStore);
            }
            if(this.mainmenu.getChildByName("btn_faq"))
            {
               new BigJuicyMenuButton(MovieClip(this.mainmenu.getChildByName("btn_faq")),Links.FAQ);
            }
            if(this.mainmenu.getChildByName("btn_patch"))
            {
               new BigJuicyMenuButton(MovieClip(this.mainmenu.getChildByName("btn_patch")),Links.Patch2);
            }
            if(this.mainmenu.getChildByName("btn_kart"))
            {
               new BigJuicyMenuButton(MovieClip(this.mainmenu.getChildByName("btn_kart")),Links.Kart);
            }
            if(this.mainmenu.getChildByName("btn_itch"))
            {
               new BigJuicyMenuButton(MovieClip(this.mainmenu.getChildByName("btn_itch")),Links.Itch);
            }
            if(this.mainmenu.getChildByName("btn_madlab"))
            {
               new BigJuicyMenuButton(MovieClip(this.mainmenu.getChildByName("btn_madlab")),Links.MaDLab);
            }
            if(this.mainmenu.getChildByName("btn_gameplays"))
            {
               new BigJuicyMenuButton(MovieClip(this.mainmenu.getChildByName("btn_gameplays")),Links.Gameplays);
            }
            if(this.mainmenu.getChildByName("btn_facebook"))
            {
               new BigJuicyMenuButton(MovieClip(this.mainmenu.getChildByName("btn_facebook")),Links.Facebook);
            }
            if(this.mainmenu.getChildByName("btn_twitter"))
            {
               new BigJuicyMenuButton(MovieClip(this.mainmenu.getChildByName("btn_twitter")),Links.Twitter);
            }
            if(this.mainmenu.getChildByName("btn_discord"))
            {
               new BigJuicyMenuButton(MovieClip(this.mainmenu.getChildByName("btn_discord")),Links.Discord);
            }
            if(this.mainmenu.getChildByName("btn_discord2"))
            {
               new BigJuicyMenuButton(MovieClip(this.mainmenu.getChildByName("btn_discord2")),Links.Discord);
            }
            if(this.mainmenu.getChildByName("btn_contentfest"))
            {
               new BigJuicyMenuButton(MovieClip(this.mainmenu.getChildByName("btn_contentfest")),Links.Discord);
            }
            if(this.mainmenu.getChildByName("btn_silvergames"))
            {
               new BigJuicyMenuButton(MovieClip(this.mainmenu.getChildByName("btn_silvergames")),Links.Silvergames);
            }
            if(this.mainmenu.getChildByName("itemshowcase"))
            {
               new BigJuicyMenuButton(MovieClip(this.mainmenu.getChildByName("itemshowcase")),this.InspirationItem);
            }
            if(this.mainmenu.getChildByName("btn_rava"))
            {
               new BigJuicyMenuButton(MovieClip(this.mainmenu.getChildByName("btn_rava")),Links.Dashrava);
            }
            if(this.mainmenu.getChildByName("splashtext"))
            {
               TextField(this.mainmenu.getChildByName("splashtext")).mouseEnabled = false;
            }
            itemTree = GameState.ui.menuLibrary.getTree("buttons");
            foundNode = itemTree.findNode("label","Ragdoll");
            nodeIndex = itemTree.showNode(foundNode);
            if(nodeIndex != -1)
            {
               itemTree.selectedIndex = nodeIndex;
               itemTree.scrollToSelected();
               GameState.ui.selectItem(itemTree.selectedItem);
            }
            this.prevMouse.x = mouseX;
            this.prevMouse.x = mouseY;
         }
         catch(errObject:Error)
         {
            GameState.ui.errorPopup(errObject,"LOADING");
            return;
         }
         addChild(getChildByName("preloader"));
      }
      
      private function ParseItemsXML() : *
      {
         var _loc3_:Item = null;
         var _loc1_:Vector.<Item> = O.items;
         var _loc2_:Array = [];
         for each(_loc3_ in _loc1_)
         {
            _loc2_.push(JSON.stringify(_loc3_,this.ParseItemsReplacer));
         }
      }
      
      private function ParseItemsReplacer(param1:*, param2:*) : *
      {
         if(param2 is Boolean && !param2)
         {
            return undefined;
         }
         if(param2 == "false")
         {
            return undefined;
         }
         if(param2 == null)
         {
            return undefined;
         }
         if(param2 == "null")
         {
            return undefined;
         }
         if(param1 == "width")
         {
            return undefined;
         }
         if(param1 == "height")
         {
            return undefined;
         }
         return param2;
      }
      
      private function paste(param1:Event) : void
      {
         var _loc2_:String = Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT) as String;
         IO.loadWorld(_loc2_,false,true);
         if(Tool.isSelect)
         {
            Tool.reset();
         }
      }
      
      private function screenie() : Bitmap
      {
         var _loc1_:BitmapData = new BitmapData(GameState.width,GameState.height,false,0);
         _loc1_.draw(stage);
         return new Bitmap(_loc1_);
      }
      
      private function saveContent() : void
      {
         if(this.currentSave == "")
         {
            IO.saveWorld();
         }
         Kongregate.savingContent = true;
         this.toggleScreenShotMode();
      }
      
      private function onSavedItem(param1:Object) : *
      {
         GameState.ui.menuPrompt.unlock();
         GameState.ui.menuPrompt.getField("info").type = TextFieldType.DYNAMIC;
         GameState.ui.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_done);
         GameState.ui.menuPrompt.visible = true;
         GameState.ui.menuPrompt.moveToTop();
         GameState.ui.menuPrompt.center();
         GameState.ui.menuPrompt.lock();
         if(param1.success)
         {
            GameState.ui.menuPrompt.title = "Content Saved";
            GameState.ui.menuPrompt.getField("info").text = "Item saved successfully!\n\nHere is the link for sharing:\n\n" + param1.permalink;
            Kongregate.alreadyShared = true;
         }
         else
         {
            GameState.ui.menuPrompt.title = "Content Not Saved";
            GameState.ui.menuPrompt.getField("info").text = "Item was not saved successfully!\n\nTry re-sharing!";
         }
      }
      
      private function onSavedContent(param1:Object) : *
      {
         this.toggleScreenShotMode();
         GameState.ui.menuPrompt.unlock();
         GameState.ui.menuPrompt.getField("info").type = TextFieldType.DYNAMIC;
         GameState.ui.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_done);
         GameState.ui.menuPrompt.visible = true;
         GameState.ui.menuPrompt.moveToTop();
         GameState.ui.menuPrompt.center();
         GameState.ui.menuPrompt.lock();
         if(param1.success)
         {
            GameState.ui.menuPrompt.title = "Content Saved";
            GameState.ui.menuPrompt.getField("info").text = "Content saved successfully!\n\nHere is the link for sharing:\n\n" + param1.permalink;
            Kongregate.alreadyShared = true;
         }
         else
         {
            GameState.ui.menuPrompt.title = "Content Not Saved";
            GameState.ui.menuPrompt.getField("info").text = "Content was not saved successfully!\n\nTry saving it again and re-sharing!";
         }
      }
      
      private function addUserListeners() : void
      {
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.checkKeys);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.keyUps);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.mouse_up);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouse_moved);
         stage.addEventListener(MouseEvent.MOUSE_DOWN,this.mouse_pressed);
         if(World.rightClick == 1 && GameState.isRightClickCapable)
         {
            stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,this.mouse_rightdown);
            stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP,this.mouse_rightup);
            stage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN,this.mouse_middledown);
            stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP,this.mouse_middleup);
         }
         if(Tweak.download)
         {
            stage.addEventListener(Event.RESIZE,this.stage_resize);
         }
         stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.mouse_wheel);
         stage.addEventListener(Event.MOUSE_LEAVE,this.mouse_leave);
      }
      
      private function mouse_rightdown(param1:MouseEvent) : void
      {
         var _loc2_:b2Body = null;
         var _loc3_:userData = null;
         var _loc4_:b2Body = null;
         var _loc5_:b2Vec2 = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         if(GameState.spawning)
         {
            this.finishSpawningItem(GameState.objects.spawnSprite.name == "customSprite");
            return;
         }
         if(Tool.isCamera)
         {
            this.movingCamera = false;
            this.zoomingCamera = true;
         }
         if(Tool.isLaunch)
         {
            _loc2_ = this.selectedBodies[0];
            _loc3_ = userData(_loc2_.GetUserData());
            _loc4_ = GameState.objects.veryDelayedSpawnObject(_loc3_.name,_loc2_.GetPosition().x * Physics.scale,_loc2_.GetPosition().y * Physics.scale,_loc2_.GetAngle() * Vars.toDegrees,_loc3_.flipped,true,_loc3_.skin);
            userData(_loc4_.GetUserData()).ignored.push(_loc2_);
            _loc4_.WakeUp();
            _loc5_ = new b2Vec2((-this.scalingPos.x + this.mouseXWorld) * 10,(-this.scalingPos.y + this.mouseYWorld) * 10);
            _loc4_.SetLinearVelocity(_loc5_);
            return;
         }
         GameState.rightDown = true;
         if(Tool.isCamera || Tool.isLaunch)
         {
            return;
         }
         if(GameState.environment is PumpkinDefence)
         {
            return;
         }
         if(!GameState.mouseDown)
         {
            if(GameState.paused)
            {
               _loc6_ = Keymap.nameToCode("RightClickPause");
            }
            else
            {
               _loc6_ = Keymap.nameToCode("RightClick");
            }
            _loc7_ = Tool.current;
            this.checkKeys(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,_loc6_));
            this.mouse_pressed(new MouseEvent(MouseEvent.MOUSE_DOWN));
         }
      }
      
      private function mouse_rightup(param1:MouseEvent) : void
      {
         var _loc2_:b2Body = null;
         if(GameState.spawning)
         {
            return;
         }
         if(Tool.isLaunch)
         {
            return;
         }
         GameState.rightDown = false;
         if(this.pauseMoving)
         {
            if(GameState.stamping && this.pauseMovingBodies.length > 0)
            {
               _loc2_ = this.pauseMovingBodies[0][0];
               this.stampItem(_loc2_);
            }
            return;
         }
         if(Tool.isCamera)
         {
            this.SnapCam();
            this.zoomingCamera = false;
            return;
         }
         if(this.itemTriggered)
         {
            this.itemTriggered = false;
            if(this.m_mouseJoint)
            {
               userData(this.m_mouseJoint.GetBody2().GetUserData()).triggered = false;
            }
         }
         if(!this.m_mouseJoint)
         {
            this.mouse_up(new MouseEvent(MouseEvent.MOUSE_UP));
         }
         Tool.reset();
         GameState.ui.updateControls();
      }
      
      private function mouse_middledown(param1:MouseEvent) : void
      {
         if(Tool.isCamera)
         {
            this.movingCamera = false;
            this.zoomingCamera = false;
            this.CameraHome();
            return;
         }
         var _loc2_:String = Tool.current;
         this.checkKeys(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,Keymap.nameToCode("MiddleClick")));
         var _loc3_:MouseEvent = new MouseEvent(MouseEvent.MOUSE_DOWN,param1.bubbles,param1.cancelable,param1.localX,param1.localY,param1.relatedObject,param1.ctrlKey);
         this.mouse_pressed(_loc3_);
      }
      
      private function mouse_middleup(param1:MouseEvent) : void
      {
         GameState.rightDown = false;
         this.itemTriggered = false;
         if(!this.m_mouseJoint)
         {
            this.mouse_up(new MouseEvent(MouseEvent.MOUSE_UP));
         }
         Tool.reset();
         GameState.ui.updateControls();
      }
      
      private function stage_resize(param1:Event) : void
      {
      }
      
      private function BuildInterface(param1:Boolean = false) : void
      {
         var itemholder:Sprite;
         var rebuild:Boolean = param1;
         if(rebuild)
         {
            while(numChildren > 0)
            {
               removeChildAt(0);
            }
         }
         this.cam = new Sprite();
         this.cam.name = "cam";
         this.cam.mouseEnabled = false;
         GraphicUtils.cam = this.cam;
         if(Boolean(GameState.environment) && Boolean(GameState.environment.public::background))
         {
            this.bgBM = new Bitmap(new BitmapData(GameState.width,GameState.height,false,0));
            this.bgBM.bitmapData = GameState.environment.public::background;
            this.bgBM.cacheAsBitmap = true;
         }
         else
         {
            this.bgBM = new Bitmap(new BitmapData(GameState.width,GameState.height,false,0));
            this.bgBM.cacheAsBitmap = true;
         }
         addChild(this.bgBM);
         this.m_sprite.name = "canvas";
         this.m_sprite.mouseEnabled = false;
         this.m_sprite.mouseChildren = false;
         this.cam.addChild(this.m_sprite);
         this.backgroundSprite = new Sprite();
         this.backgroundSprite.name = "itemsBG";
         this.itemSprite = new Sprite();
         this.itemSprite.name = "items";
         this.foregroundSprite = new Sprite();
         this.foregroundSprite.name = "itemsFG";
         itemholder = new Sprite();
         itemholder.addChild(this.backgroundSprite);
         itemholder.addChild(this.itemSprite);
         itemholder.addChild(this.foregroundSprite);
         itemholder.name = "itemholder";
         this.m_sprite.addChild(itemholder);
         this.toolSprite = new Sprite();
         this.toolSprite.name = "selectSprite";
         this.m_sprite.addChild(this.toolSprite);
         this.cam.addChild(this.joints);
         this.joints.mouseEnabled = false;
         this.bloodBMD = new BitmapData(GameState.width,GameState.height,true,0);
         this.particlesBMD = new BitmapData(GameState.width,GameState.height,true,0);
         this.particlesBM = new Bitmap(this.particlesBMD);
         this.keyhelp = new dynamichelp();
         addChild(this.keyhelp);
         this.keyhelp.visible = false;
         this.keyhelp.mouseEnabled = false;
         this.keyhelp.mouseChildren = false;
         try
         {
            addChild(this.cam);
            addChild(TimeLord.pauseGrid);
            addChild(GameState.ui.menuEffects);
            addChild(this.particlesBM);
            addChild(GameState.ui.menuMain);
            addChild(GameState.ui.menuControls);
            addChild(GameState.ui.menuSettings);
            addChild(GameState.ui.menuWorld);
            addChild(GameState.ui.menuObject);
            addChild(GameState.ui.menuKeymap);
            addChild(GameState.ui.menuKeyConfig);
            addChild(GameState.ui.menuPrompt);
            addChild(GameState.ui.menuSave);
            addChild(GameState.ui.menuSpawn);
            addChild(GameState.ui.menuLibrary);
            addChild(GameState.ui.menuFavourite);
            addChild(GameState.ui.menuTools);
            addChild(GameState.ui.menuColour);
            addChild(GameState.ui.menuDetails);
            addChild(GameState.ui.menuChallenge);
            addChild(GameState.ui.console);
            this.CameraHome();
            GameState.ui.resetDocks();
            GameState.ui.menuDetails.center();
            GameState.ui.menuDetails.visible = false;
            GameState.ui.menuDetails.allowInputDrag = false;
            GameState.ui.menuDetails.addEventListener(WindowEvent.ON_CLOSE,this.windowClosed);
            GameState.ui.menuTools.addEventListener(WindowEvent.ON_CLOSE,this.windowClosed);
            GameState.ui.menuControls.collapseInsteadOfMinimising = true;
            this.fps.x = GameState.width - this.fps.width - 18;
            this.fps.y = 0;
            this.fps.visible = false;
            GameState.ui.menuSettings.addEventListener(WindowEvent.ON_CLOSE,this.windowClosed);
            GameState.ui.menuSettings.addEventListener(WindowEvent.ON_OPEN,this.windowOpened);
            GameState.ui.menuWorld.addEventListener(WindowEvent.ON_CLOSE,this.windowClosed);
            GameState.ui.menuWorld.addEventListener(WindowEvent.ON_OPEN,this.windowOpened);
            GameState.ui.menuObject.addEventListener(WindowEvent.ON_CLOSE,this.windowClosed);
            GameState.ui.menuObject.addEventListener(WindowEvent.ON_OPEN,this.windowOpened);
            GameState.ui.menuLibrary.addEventListener(WindowEvent.ON_CLOSE,this.windowClosed);
            GameState.ui.menuLibrary.addEventListener(WindowEvent.ON_OPEN,this.windowOpened);
            this.keyhelp.x = 300;
            this.keyhelp.y = 25;
         }
         catch(errObject:Error)
         {
            GameState.ui.errorPopup(errObject,"MENU LOADING");
            return;
         }
         addChild(this.fps);
         stage.focus = null;
         TimeLord.pause();
         TimeLord.unpause();
      }
      
      private function mapSelectedKey(param1:MouseEvent) : void
      {
         var _loc2_:Tree = GameState.ui.menuKeyConfig.getTree("keymap");
         var _loc3_:ListEvent = new ListEvent(ListEvent.ITEM_DOUBLE_CLICK,false,false,-1,-1,_loc2_.selectedIndex,_loc2_.selectedItem);
         this.changeMapping(_loc3_);
      }
      
      private function buildTreeMenus() : void
      {
         var treeKeymap:Tree;
         var keyField:TextField;
         var keyformat:TextFormat;
         var treeField:TextField;
         var infoformat:TextFormat;
         var promptField:TextField;
         var promptFormat:TextFormat;
         var treePrompt:Tree;
         var saveTree:Tree;
         var esiz:Number;
         var treeItems:Tree;
         var treeFavs:Tree;
         var cpfformat:TextFormat;
         var treeColour:Tree;
         var format:TextFormat = null;
         var actf:TextFormat = null;
         var acLib:AutoComplete = null;
         var treeKeymapButtons:Tree = GameState.ui.menuKeymap.addTree("buttons",R.xml_keymapButtons,0,0,24);
         treeKeymapButtons.selectable = false;
         treeKeymapButtons.addEventListener(ListEvent.ITEM_CLICK,this.keymapping);
         treeKeymapButtons.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,this.changeMapping);
         treeKeymap = GameState.ui.menuKeyConfig.addTree("keymap",R.xml_keymap,200,0,24);
         treeKeymap.selectable = true;
         treeKeymap.addEventListener(ListEvent.ITEM_CLICK,this.keymapping);
         treeKeymap.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,this.changeMapping);
         keyField = GameState.ui.menuKeyConfig.addField("Mapped","",null,24);
         keyformat = new TextFormat(Tweak.FONT,16,0);
         keyformat.align = TextFormatAlign.CENTER;
         keyformat.bold = true;
         keyField.defaultTextFormat = keyformat;
         keyField.embedFonts = true;
         keyField.setTextFormat(keyformat);
         keyField.background = true;
         keyField.backgroundColor = GameState.ui.menuKeyConfig.FIELDBACKGROUNDCOLOUR;
         keyField.selectable = false;
         treeField = GameState.ui.menuKeyConfig.addField("info","Click to browse.\nDouble click\nto keymap.",null,56);
         treeField.border = false;
         infoformat = new TextFormat(Tweak.FONT,12,0);
         infoformat.align = TextFormatAlign.CENTER;
         treeField.setTextFormat(infoformat);
         treeField.embedFonts = true;
         treeField.defaultTextFormat = infoformat;
         treeField.selectable = false;
         keyField.addEventListener(MouseEvent.CLICK,this.mapSelectedKey);
         treeField.addEventListener(MouseEvent.CLICK,this.mapSelectedKey);
         GameState.ui.menuKeyConfig.ignoreDrag("Mapped");
         GameState.ui.menuKeyConfig.ignoreDrag("info");
         if(Tweak.download)
         {
            GameState.ui.menuMain.addTree("buttons",R.xml_mainDownload);
         }
         else
         {
            GameState.ui.menuMain.addTree("buttons",R.xml_main);
         }
         GameState.ui.menuMain.getTree("buttons").addEventListener(ListEvent.ITEM_CLICK,this.mainTreeClick);
         GameState.ui.menuMain.getTree("buttons").selectable = false;
         GameState.ui.showEnvironments(null);
         GameState.ui.showEnvironmentInfo();
         this.updateToggles();
         GameState.ui.menuSettings.alpha = 0;
         GameState.ui.menuSettings.forceClosed();
         GameState.ui.menuPrompt.movePosition(12);
         promptField = GameState.ui.menuPrompt.addField("info","",null,200);
         promptFormat = new TextFormat(Tweak.FONT,14);
         promptFormat.align = TextFormatAlign.CENTER;
         promptField.defaultTextFormat = promptFormat;
         promptField.setTextFormat(promptFormat);
         promptField.embedFonts = true;
         promptField.border = false;
         treePrompt = GameState.ui.menuPrompt.addTree("buttons",R.xml_prompt);
         treePrompt.selectable = false;
         treePrompt.addEventListener(ListEvent.ITEM_CLICK,this.treeClick);
         treePrompt.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,this.treeClick);
         saveTree = GameState.ui.menuSave.addTree("buttons",R.xml_empty,32,0,32);
         saveTree.addEventListener(ListEvent.ITEM_CLICK,this.handleSaveTree);
         saveTree.selectable = false;
         this.AutoSaveTimer = new DurationTimer(1000);
         this.AutoSaveTimer.addEventListener(TimerEvent.TIMER,this.AutoSave);
         GameState.ui.menuSpawn.ignoreDrag("autoComplete");
         GameState.ui.menuSpawn.ignoreDrag("gfx");
         GameState.ui.menuSpawn.ignoreDrag("itemprev");
         GameState.ui.menuSpawn.ignoreDrag("itemnext");
         GameState.ui.menuSpawn.ignoreDrag("itemHolder");
         GameState.ui.menuSpawn.ignoreDrag("browsebuttons");
         GameState.ui.menuSpawn.ignoreDrag("flipicon");
         GameState.ui.menuSpawn.ignoreDrag("labicon");
         GameState.ui.menuSpawn.ignoreDrag("favicon");
         GameState.ui.menuSpawn.ignoreDrag("randomicon");
         GameState.ui.menuSpawn.ignoreDrag("favtf");
         GameState.ui.menuSpawn.ignoreDrag("infoicon");
         GameState.ui.menuSpawn.ignoreDrag("customicon");
         GameState.ui.menuSpawn.ignoreDrag("dollicon");
         GameState.ui.menuSpawn.ignoreDrag("gunicon");
         GameState.ui.menuSpawn.ignoreDrag("settingicon");
         GameState.ui.menuSpawn.ignoreDrag("propertyicon");
         GameState.ui.menuSpawn.ignoreDrag("skinicon");
         GameState.ui.menuSpawn.ignoreDrag("searchicon");
         GameState.ui.menuSpawn.ignoreDrag("armouricon");
         GameState.ui.menuSpawn.addEventListener(WindowEvent.ON_CLOSE,this.windowClosed);
         GameState.ui.menuSpawn.addEventListener(WindowEvent.ON_OPEN,this.windowOpened);
         GameState.ui.menuSpawn.addEventListener(WindowEvent.ON_MAXIMISE,this.windowMaximised);
         GameState.ui.menuSpawn.addEventListener(WindowEvent.ON_RESIZE,this.windowResized);
         GameState.ui.menuSpawn.addEventListener(WindowEvent.STOP_RESIZE,this.windowStopResize);
         this.contract = new Contract();
         this.m_sprite.addChild(this.contract);
         this.contract.mouseEnabled = false;
         this.contract.addEventListener("RIP",this.contractFailed);
         this.contract.addEventListener("DED",this.contractStep);
         this.contract.addEventListener("COMPLETE",this.contractComplete);
         GameState.ui.menuChallenge.ignoreDrag("holder");
         GameState.ui.menuChallenge.x = GameState.ui.menuMain.x;
         GameState.ui.menuChallenge.y = GameState.ui.menuMain.y;
         GameState.ui.menuChallenge.addEventListener(WindowEvent.ON_CLOSE,this.windowClosed);
         GameState.ui.menuChallenge.addOther(this.contract.itemholder);
         GameState.ui.menuChallenge.movePosition(-200);
         esiz = GameState.ui.menuChallenge.actualWidth - Window.BUFFER * 4;
         GameState.ui.menuChallenge.dulin = new Rectangle(Window.BUFFER * 2,22,esiz,esiz);
         GameState.ui.menuChallenge.movePosition(esiz + Window.BUFFER * 2);
         this.contract.itemholder.addEventListener(MouseEvent.MOUSE_DOWN,this.contractSpawn);
         this.updateChallengeMenu("init");
         GameState.ui.menuEffects.addEventListener(WindowEvent.ON_CLOSE,this.windowClosed);
         GameState.ui.menuEffects.addEventListener(WindowEvent.ON_OPEN,this.windowOpened);
         format = new TextFormat(Tweak.FONT,16,GameState.ui.menuSpawn.FONTCOLOUR,true);
         format.align = TextFormatAlign.CENTER;
         actf = new TextFormat(Tweak.FONT,16,GameState.ui.menuSpawn.FONTCOLOUR,true);
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
         acLib.textField.backgroundColor = GameState.ui.menuLibrary.FIELDBACKGROUNDCOLOUR;
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
         acLib.width = GameState.ui.menuLibrary.actualWidth - Window.BUFFER * 4;
         acLib.height = 28;
         acLib.dropdown.rowHeight = 24;
         GameState.ui.menuSpawn.ignoreDrag("autoComplete");
         acLib.addEventListener(DropdownEvent.CLOSE,GameState.ui.autocompleter);
         GameState.ui.menuLibrary.addChild(acLib);
         treeItems = GameState.ui.menuLibrary.addTree("buttons",R.xml_objects,224,0,24);
         treeItems.addEventListener(ListEvent.ITEM_CLICK,this.handleTreeClick);
         treeItems.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,this.handleTreeDoubleClick);
         GameState.ui.menuLibrary.maximiseHeight = Window.BUFFER + 15 * 32;
         GameState.ui.menuLibrary.ignoreDrag("autoComplete");
         GameState.ui.menuSettings.maximiseHeight = 544;
         GameState.ui.menuSettings.redraw();
         treeFavs = GameState.ui.menuFavourite.addTree("buttons",R.xml_empty,288,0,24);
         treeFavs.selectable = false;
         treeFavs.addEventListener(ListEvent.ITEM_CLICK,this.handleTreeClick);
         GameState.ui.menuControls.addTree("buttons",R.xml_play).selectable = true;
         GameState.ui.menuControls.getTree("buttons").addEventListener(ListEvent.ITEM_CLICK,this.handleTreeClick);
         GameState.ui.menuControls.getTree("buttons").selectable = false;
         GameState.ui.updateControls();
         GameState.ui.menuTools.ignoreDrag("autoComplete");
         GameState.ui.menuTools.ignoreDrag("random");
         GameState.ui.menuTools.ignoreDrag("list");
         GameState.ui.menuTools.ignoreDrag("prev");
         GameState.ui.menuTools.ignoreDrag("next");
         this.spectrum = new Spectrum(0,0,156,156);
         this.spectrum.x = Window.BUFFER * 2;
         this.spectrum.y = 24;
         this.colourPicker = new ColourPicker(4160377,147,8,2,9,14,0);
         this.colourPicker.colour = 3355443;
         this.colourPicker.x = this.spectrum.x;
         this.colourPicker.y = this.spectrum.y + this.spectrum.height + Window.BUFFER * 2;
         GameState.ui.menuColour.ignoreDrag(getQualifiedClassName(new Handle()));
         GameState.ui.menuColour.ignoreDrag(getQualifiedClassName(new HueBar()));
         GameState.ui.menuColour.ignoreDrag(getQualifiedClassName(new SaturationBar()));
         GameState.ui.menuColour.ignoreDrag(getQualifiedClassName(new LightnessBar()));
         GameState.ui.menuColour.ignoreDrag(getQualifiedClassName(this.spectrum));
         GameState.ui.menuColour.ignoreDrag(getQualifiedClassName(this.colourPicker));
         GameState.ui.menuColour.addEventListener(WindowEvent.ON_CLOSE,this.windowClosed);
         cpfformat = new TextFormat("Verdana",16,0);
         cpfformat.align = TextFormatAlign.CENTER;
         cpfformat.bold = true;
         this.colourPickerField = new TextField();
         this.colourPickerField.name = "colour";
         this.colourPickerField.width = 156;
         this.colourPickerField.height = 24;
         this.colourPickerField.x = this.colourPicker.x;
         this.colourPickerField.y = this.colourPicker.y + this.colourPicker.height + Window.BUFFER * 2;
         this.colourPickerField.background = true;
         this.colourPickerField.setTextFormat(cpfformat);
         this.colourPickerField.defaultTextFormat = cpfformat;
         this.colourPickerField.type = TextFieldType.INPUT;
         this.colourPickerField.maxChars = 7;
         this.colourPickerField.text = "333333";
         this.cursorSpectrum.graphics.lineStyle(1,0);
         this.cursorSpectrum.graphics.drawCircle(0,0,2);
         this.cursorSpectrum.graphics.lineStyle(1,16777215);
         this.cursorSpectrum.graphics.drawCircle(0,0,3);
         GameState.ui.menuColour.addChild(this.spectrum);
         GameState.ui.menuColour.addChild(this.cursorSpectrum);
         GameState.ui.menuColour.addChild(this.colourPicker);
         GameState.ui.menuColour.addChild(this.colourPickerField);
         GameState.ui.menuColour.movePosition(Window.BUFFER * 4);
         treeColour = GameState.ui.menuColour.addTree("buttons",R.xml_skinning,48,0,24);
         treeColour.addEventListener(ListEvent.ITEM_CLICK,this.handleTreeClick);
         this.spectrum.addEventListener(MouseEvent.MOUSE_DOWN,this.startPicking);
         this.colourPicker.addEventListener(ColourPickerEvent.COLOUR_PICKER_EVENT,this.onColourPicker);
         GameState.ui.menuColour.getField("colour").addEventListener(Event.CHANGE,this.updateColourFromField);
         GameState.ui.menuSpawn.alpha = 0;
         GameState.ui.menuSave.alpha = 0;
         GameState.ui.menuKeymap.alpha = 0;
         GameState.ui.menuKeyConfig.alpha = 0;
         GameState.ui.menuObject.alpha = 0;
         GameState.ui.menuSettings.alpha = 0;
         GameState.ui.menuLibrary.alpha = 0;
         GameState.ui.menuMain.alpha = 0;
         GameState.ui.menuControls.alpha = 0;
         GameState.ui.menuTools.alpha = 0;
         GameState.ui.menuWorld.alpha = 0;
         GameState.ui.menuColour.alpha = 0;
         GameState.ui.menuFavourite.alpha = 0;
         GameState.ui.menuEffects.alpha = 0;
         GameState.ui.menuChallenge.alpha = 0;
         GameState.ui.menuSpawn.close();
         GameState.ui.menuSave.close();
         GameState.ui.menuKeymap.close();
         GameState.ui.menuKeyConfig.close();
         GameState.ui.menuObject.close();
         GameState.ui.menuSettings.close();
         GameState.ui.menuLibrary.unmaximise();
         GameState.ui.menuLibrary.forceClosed();
         GameState.ui.menuWorld.close();
         GameState.ui.menuColour.close();
         GameState.ui.menuTools.close();
         GameState.ui.menuEffects.close();
         GameState.ui.menuChallenge.close();
         GameState.ui.menuFavourite.close();
         GameState.ui.menuPrompt.visible = false;
         GameState.ui.menuMain.collapseInsteadOfMinimising = true;
         GameState.ui.menuTools.collapseInsteadOfMinimising = true;
         GameState.ui.menuMain.collapse();
         GameState.ui.menuControls.collapse();
         stage.focus = null;
      }
      
      private function initAutoCompleteItems() : void
      {
         var _loc5_:* = undefined;
         var _loc7_:XMLList = null;
         var _loc8_:XML = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:int = 0;
         var _loc12_:Object = null;
         this.acData = [];
         this.acUnique = [];
         this.acTags = [];
         var _loc1_:XMLList = R.xml_objects.node.node;
         var _loc2_:XMLList = R.xml_objects.node.node.node;
         var _loc3_:int = 0;
         while(_loc3_ < 2)
         {
            if(_loc3_ == 0)
            {
               _loc7_ = _loc1_;
            }
            else
            {
               _loc7_ = _loc2_;
            }
            for each(_loc8_ in _loc7_)
            {
               if(String(_loc8_.@func) == "")
               {
                  if(String(_loc8_.@object) != "")
                  {
                     _loc9_ = _loc8_.@label;
                     _loc10_ = _loc8_.@tag;
                     if(_loc10_ == "")
                     {
                        _loc10_ = "item";
                     }
                     _loc10_ += "," + _loc8_.parent().@label;
                     if(_loc3_ == 1)
                     {
                        _loc10_ += "," + _loc8_.parent().parent().@label;
                     }
                     if(_loc8_.@lab == "true")
                     {
                        _loc10_ += ",madlab";
                        if(_loc8_.@object.length() > 0)
                        {
                           if(O.getItem(_loc8_.@object) == null)
                           {
                              _loc11_ = 0;
                              while(_loc11_ < 20)
                              {
                                 _loc11_++;
                              }
                           }
                           else if(O.getItem(_loc8_.@object).creator)
                           {
                              _loc10_ += "," + O.getItem(_loc8_.@object).creator;
                           }
                        }
                     }
                     if(_loc8_.@links == "true")
                     {
                        _loc10_ += ",links";
                     }
                     if(this.acUnique.indexOf(_loc9_) == -1)
                     {
                        this.acUnique.push(_loc9_);
                        this.acTags.push(_loc10_);
                     }
                  }
               }
            }
            _loc3_++;
         }
         var _loc4_:Array = [];
         _loc5_ = 0;
         while(_loc5_ != this.acUnique.length)
         {
            _loc12_ = {};
            _loc12_.label = this.acUnique[_loc5_];
            _loc12_.tag = this.acTags[_loc5_];
            _loc4_.push(_loc12_);
            _loc5_++;
         }
         _loc4_.sortOn("label",Array.CASEINSENSITIVE);
         _loc5_ = 0;
         while(_loc5_ != this.acUnique.length)
         {
            this.acUnique[_loc5_] = _loc4_[_loc5_].label;
            this.acTags[_loc5_] = _loc4_[_loc5_].tag;
            _loc5_++;
         }
         var _loc6_:int = 0;
         while(_loc6_ < this.acUnique.length)
         {
            this.acData.push({
               "label":this.acUnique[_loc6_],
               "tag":this.acTags[_loc6_]
            });
            _loc6_++;
         }
         GameState.objects.libraryItems = this.acUnique;
         AutoComplete(GameState.ui.menuSpawn.getGadget("autoComplete")).dataProvider = new DataProvider(this.acData);
         AutoComplete(GameState.ui.menuLibrary.getGadget("autoComplete")).dataProvider = new DataProvider(this.acData);
      }
      
      private function contractFailed(param1:Event) : void
      {
         this.contract.enabled = false;
         this.showContractFail();
      }
      
      private function contractComplete(param1:Event) : void
      {
         this.contract.enabled = false;
         if(this.contract.previewing)
         {
            this.updateChallengeMenu("previewComplete");
            this.contractSplashShown = true;
            IO.loadWorld();
            this.contractSplashShown = false;
            this.contract.previewing = false;
            GameState.ui.menuMain.open();
         }
         else
         {
            this.showContractSuccess();
         }
      }
      
      private function contractStep(param1:Event) : void
      {
      }
      
      public function updateChallengeMenu(param1:String = "none") : void
      {
         var _loc5_:String = null;
         var _loc6_:Tree = null;
         var _loc2_:XML = <node label="Root Node"></node>;
         var _loc3_:Number = 24 * 4;
         var _loc4_:String = "";
         if(GameState.ui.menuChallenge.getField("Secret"))
         {
            GameState.ui.menuChallenge.removeAllFields();
            GameState.ui.menuChallenge.movePosition(-24);
         }
         if(param1 == "none" || param1 == "init")
         {
            _loc2_.appendChild(<node label="Add Items" func="contractitems" center="true" tooltip="Drag items from the Spawn Menu to this menu to add them as available items in the Contract.&#10;&#10;&#10;&#10;"/>);
            _loc2_.appendChild(<node label="Add Target" func="targets" center="true" tooltip="Choose target(s) for this Contract, as well as their fate.&#10;&#10;"/>);
            _loc2_.appendChild(<node label="Add Area" func="areas" center="true" tooltip="Add a new area.&#10;Tools will only work inside allowed areas inside Contracts.&#10;&#10;"/>);
            if(this.contract.areaCount > 0)
            {
               _loc3_ += 24;
               _loc2_.appendChild(<node label="Remove Area" func="removeArea" center="true" tooltip="Click on any area to remove it.&#10;"/>);
            }
            if(this.contract.targetCount > 0)
            {
               _loc3_ += 24;
               _loc2_.appendChild(<node label="Remove Target" func="removeTarget" center="true" tooltip="Click on any target to remove it.&#10;"/>);
            }
            _loc2_.appendChild(<node label="Contract" func="contract" center="true"/>);
         }
         else if(param1 == "area")
         {
            _loc3_ += 24 * 4;
            _loc2_.appendChild(<node label="Back" func="back"/>);
            _loc2_.appendChild(<node label="Allow Spawn" func="allowSpawn" toggleValue="0"/>);
            _loc2_.appendChild(<node label="Allow Drag" func="allowDrag" toggleValue="0"/>);
            _loc2_.appendChild(<node label="Allow Trigger" func="allowTrigger" toggleValue="0"/>);
            _loc2_.appendChild(<node label="Allow Cut" func="allowCut" toggleValue="0"/>);
            _loc2_.appendChild(<node label="Allow Delete" func="allowDelete" toggleValue="0"/>);
            _loc2_.appendChild(<node label="Allow Powers" func="allowPower" toggleValue="0"/>);
            _loc4_ = "Tick the allowed tools, then click+drag on the stage to draw the Area.\n\n";
         }
         else if(param1 == "target")
         {
            _loc3_ += 24 * 5;
            _loc2_.appendChild(<node label="Back" func="back"/>);
            _loc2_.appendChild(<node label="Mutilate" contract="mutilate" tooltip="Success: Target is killed or cut to pieces.&#10;&#10;"/>);
            _loc2_.appendChild(<node label="Incapacitate" contract="incapacitate" tooltip="Success: Target reaches 50% health without getting cut to pieces. Requires alive item.&#10;&#10;&#10;&#10;"/>);
            _loc2_.appendChild(<node label="Heal" contract="heal" tooltip="Success: Target reaches full health. Requires an alive damaged item.&#10;&#10;&#10;"/>);
            _loc2_.appendChild(<node label="Burn" contract="burn" tooltip="Success: Target is set on fire.&#10;&#10;"/>);
            _loc2_.appendChild(<node label="Trigger" contract="trigger" tooltip="Success: Target is triggered for a short time. Doesn't work with temporary trigger items such as guns.&#10;&#10;&#10;&#10;"/>);
            _loc2_.appendChild(<node label="Relocate" contract="relocate" tooltip="Success: Target reaches selected Area.&#10;&#10;"/>);
            _loc2_.appendChild(<node label="Protect" contract="protect" tooltip="Failure: Target is killed or cut to pieces. Additional target is required to make the Contract winnable.&#10;&#10;&#10;&#10;"/>);
            _loc4_ = "First choose target type (hover for details), then click on any spawned item to mark it as the target.\n\n\n";
         }
         else if(param1 == "contract")
         {
            _loc3_ += 24 * 2;
            _loc5_ = "Area Preview";
            if(this.contract.enabled)
            {
               _loc5_ = "Stop Area Preview";
            }
            _loc2_.appendChild(<node label="Back" func="back" center="true"/>);
            _loc2_.appendChild(<node label={_loc5_} func="preview" center="true" tooltip="Toggle area previewing. Tool limitations are only enabled when enabled. Spawned items will be restored in the menu once disabled.&#10;&#10;&#10;&#10;&#10;"/>);
            if(this.contract.areaCount > 0 || this.contract.targetCount > 0 || this.contract.itemCount > 0)
            {
               _loc2_.appendChild(<node label="Share Contract" func="complete" center="true" tooltip="To share the Contract with others, you must first complete it to ensure it can be completed.&#10;&#10;&#10;&#10;"/>);
            }
            _loc2_.appendChild(<node label="" func="spacer"/>);
            _loc2_.appendChild(<node label="Reset" func="reset" background="#CC6666" center="true" tooltip="Reset all items, targets, and areas.&#10;"/>);
         }
         else if(param1 == "load")
         {
            if(this.contract.creator == "Guest" || this.contract.creator == Kongregate.playerName)
            {
               _loc3_ += 24;
               _loc2_.appendChild(<node label="Share Contract" func="complete" center="true" tooltip="Share the contract.&#10;&#10;"/>);
               _loc2_.appendChild(<node label="Edit Contract" func="backToEdit" center="true"/>);
            }
            _loc2_.appendChild(<node label="Restart Contract" func="restart" center="true" tooltip="Restart the contract from scratch.&#10;&#10;"/>);
            _loc2_.appendChild(<node label="End Contract" func="end" center="true" tooltip="End the Contract and return to the sandbox. The suits will be disappointed in you, but there will be no repercussions.&#10;&#10;&#10;&#10;&#10;"/>);
            this.showContractSplash();
            GameState.ui.menuSave.close();
         }
         else if(param1 == "previewing")
         {
            _loc4_ = "Please make sure the contract is completable before sharing.\n\n\n\n";
            _loc2_.appendChild(<node label="Back" func="back" center="true"/>);
            _loc2_.appendChild(<node label="Share Contract" func="finallyShare" center="true"/>);
            _loc3_ += 24;
         }
         else if(param1 == "items")
         {
            _loc3_ -= 24 * 3;
            if(!GameState.ui.menuSpawn.visible)
            {
               GameState.ui.menuSpawn.toggle();
            }
            if(!GameState.ui.menuSpawn.undocked)
            {
               GameState.ui.menuSpawn.x = GameState.ui.menuChallenge.x + GameState.ui.menuChallenge.actualWidth + 4;
               GameState.ui.menuSpawn.y = GameState.ui.menuChallenge.y;
            }
            _loc2_.appendChild(<node label="Done" func="additemsback" center="true"/>);
            GameState.ui.showTooltip(GameState.ui.menuSpawn,"Drag items from the Spawn Menu into the Contract Menu to add them to the Contract.\nDrag them from the Contract Menu to the stage to remove them.\n",0,10000,408);
         }
         if(param1 == "init")
         {
            _loc6_ = GameState.ui.menuChallenge.addTree("buttons",_loc2_,_loc3_,0,24);
            _loc6_.addEventListener(ListEvent.ITEM_CLICK,this.challengeTreeClick);
            _loc6_.selectable = false;
         }
         else
         {
            GameState.ui.menuChallenge.getTree("buttons").dataProvider = new TreeDataProvider(_loc2_);
            GameState.ui.menuChallenge.maximiseHeight = 222 + _loc3_;
            GameState.ui.menuChallenge.maximise();
         }
         if(_loc4_ != "")
         {
            GameState.ui.genericToolTip = GameState.ui.showTooltip(GameState.ui.menuChallenge,_loc4_,0,5000,GameState.ui.menuChallenge.actualWidth);
         }
         else if(GameState.ui.genericToolTip)
         {
            GameState.ui.genericToolTip.hide();
         }
      }
      
      private function showContractSplash() : void
      {
         var previewer:Sprite;
         var hoho:Sprite;
         var numc:int;
         var i:int;
         var ss:Bitmap;
         var papp:MovieClip;
         var nickn:String;
         var folder:MovieClip = null;
         var stamp1:MovieClip = null;
         var stamp2:MovieClip = null;
         var addy:Sprite = null;
         if(this.contractSplashShown)
         {
            return;
         }
         this.contractSplashShown = true;
         GameState.ui.menuLibrary.alpha = 1;
         this.toggleAllMenus();
         if(GameState.ui.menuPrompt.visible)
         {
            GameState.ui.menuPrompt.alpha = 0;
         }
         previewer = new Sprite();
         hoho = Sprite(GameState.ui.menuChallenge.getChildByName("holder"));
         numc = hoho.numChildren;
         i = 0;
         while(i < numc)
         {
            addy = previewer.addChild(hoho.getChildAt(0)) as Sprite;
            addy.x = 100 + i * 100;
            addy.y = 100;
            addy.scaleX = 1;
            addy.scaleY = 1;
            i++;
         }
         stage.addChild(previewer);
         folder = new contractFolder();
         folder.x = 400;
         folder.y = 300;
         this.update(null);
         ss = this.screenie();
         stage.removeChild(previewer);
         this.contract.updateItems();
         GameState.ui.menuPrompt.unlock();
         GameState.ui.menuPrompt.close();
         this.toggleAllMenus();
         GameState.ui.menuPrompt.unlock();
         GameState.ui.menuPrompt.close();
         ss.scaleX = 0.5;
         ss.scaleY = 0.5;
         ss.x = -200;
         ss.y = -100;
         papp = MovieClip(folder.getChildByName("paper"));
         papp.addChild(ss);
         stamp1 = papp.getChildByName("acceptStamp") as MovieClip;
         stamp2 = papp.getChildByName("refuseStamp") as MovieClip;
         stamp1.useHandCursor = true;
         stamp2.useHandCursor = true;
         stamp1.alpha = 0.1;
         stamp2.alpha = 0.1;
         nickn = "! REDACTED !";
         if(Kongregate.playerName != "Guest")
         {
            nickn = Kongregate.playerName;
         }
         TextField(papp.getChildByName("nick")).text = nickn;
         TextField(papp.getChildByName("goal")).text = this.contract.title;
         stamp1.addEventListener(MouseEvent.MOUSE_OVER,function():*
         {
            stamp1.alpha = 1;
         });
         stamp1.addEventListener(MouseEvent.MOUSE_OUT,function():*
         {
            stamp1.alpha = 0.1;
         });
         stamp2.addEventListener(MouseEvent.MOUSE_OVER,function():*
         {
            stamp2.alpha = 1;
         });
         stamp2.addEventListener(MouseEvent.MOUSE_OUT,function():*
         {
            stamp2.alpha = 0.1;
         });
         stamp1.addEventListener(MouseEvent.CLICK,function():*
         {
            contract.enabled = true;
            stage.removeChild(folder);
            GameState.ui.closeAllMenus();
         });
         stamp2.addEventListener(MouseEvent.CLICK,function():*
         {
            contract.enabled = false;
            stage.removeChild(folder);
            reset();
         });
         stage.addChild(folder);
      }
      
      private function showContractFail() : void
      {
         this.showContractSuccess(true);
      }
      
      private function showContractSuccess(param1:Boolean = false) : void
      {
         var papp:MovieClip;
         var nickn:String;
         var folder:MovieClip = null;
         var stamp1:MovieClip = null;
         var stamp2:MovieClip = null;
         var stamp3:MovieClip = null;
         var fail:Boolean = param1;
         if(fail)
         {
            folder = new contractFail();
         }
         else
         {
            folder = new contractSuccess();
         }
         folder.x = 400;
         folder.y = 300;
         papp = MovieClip(folder.getChildByName("paper"));
         nickn = "! REDACTED !";
         if(Kongregate.playerName != "Guest")
         {
            nickn = Kongregate.playerName;
         }
         TextField(papp.getChildByName("nick")).text = nickn;
         stamp1 = papp.getChildByName("restartStamp") as MovieClip;
         stamp2 = papp.getChildByName("browseStamp") as MovieClip;
         stamp3 = papp.getChildByName("refuseStamp") as MovieClip;
         stamp1.useHandCursor = true;
         stamp2.useHandCursor = true;
         stamp3.useHandCursor = true;
         stamp1.alpha = 0.1;
         stamp2.alpha = 0.1;
         stamp3.alpha = 0.1;
         stamp1.addEventListener(MouseEvent.MOUSE_OVER,function():*
         {
            stamp1.alpha = 1;
         });
         stamp1.addEventListener(MouseEvent.MOUSE_OUT,function():*
         {
            stamp1.alpha = 0.1;
         });
         stamp2.addEventListener(MouseEvent.MOUSE_OVER,function():*
         {
            stamp2.alpha = 1;
         });
         stamp2.addEventListener(MouseEvent.MOUSE_OUT,function():*
         {
            stamp2.alpha = 0.1;
         });
         stamp3.addEventListener(MouseEvent.MOUSE_OVER,function():*
         {
            stamp3.alpha = 1;
         });
         stamp3.addEventListener(MouseEvent.MOUSE_OUT,function():*
         {
            stamp3.alpha = 0.1;
         });
         stamp1.addEventListener(MouseEvent.CLICK,function():*
         {
            stage.removeChild(folder);
            IO.loadWorld();
         });
         stamp2.addEventListener(MouseEvent.CLICK,function():*
         {
            stage.removeChild(folder);
            Kongregate.viewContent("Contract");
         });
         stamp3.addEventListener(MouseEvent.CLICK,function():*
         {
            stage.removeChild(folder);
            contract.enabled = true;
            reset();
         });
         stage.addChild(folder);
      }
      
      private function selectEffectType(param1:Object) : void
      {
         if(!param1.label)
         {
            return;
         }
         this.previewEffectNode = param1;
         var _loc2_:Array = [PFXNone,PFXAngular,PFXCenter,PFXCenterEmit,PFXCircle,PFXCircleCycling,PFXCirclePingPong,PFXCirclePulse,PFXCircleRandom,PFXConnected,PFXCorners,PFXCross,PFXFirearm,PFXFourSides,PFXGlow,PFXHorizontal,PFXHorizontalPingPong,PFXInside,PFXInwards,PFXJoint,PFXJointAnchor,PFXOutline,PFXOutwards,PFXRadius,PFXSpiral,PFXVertical,PFXVerticalPingPong,PFXVoid,PFXZap,PFXPoint,PFXOverwrite,PFXScan,PFXSnake,PFXVoidInwards,PFXSpiralWave,PFXFirefly,PFXCollision,PFXCollisionExplosion,PFXWound];
         var _loc3_:Array = ["None","Angular","Center","CenterEmit","Circle","CircleCycling","CirclePingPong","CirclePulse","CircleRandom","Connected","Corners","Cross","Firearm","FourSides","Glow","Horizontal","HorizontalPingPong","Inside","Inwards","Joint","JointAnchor","Outline","Outwards","Radius","Spiral","Vertical","VerticalPingPong","Void","Zap","Point","Overwrite","Scan","Snake","VoidInwards","SpiralWave","Fly","Collision","CollisionExplosion","Wound"];
         var _loc4_:int = _loc3_.indexOf(param1.behaviour);
         var _loc5_:b2Vec2 = this.previewEffectBody.GetPosition().Copy();
         var _loc6_:Class = _loc2_[_loc4_] as Class;
         var _loc7_:Vector.<String> = this.previewEffect.particles;
         var _loc8_:Vector.<Number> = this.previewEffect.ratios;
         var _loc9_:ParticleEffect = this.previewEffect;
         this.previewEffect = new _loc6_(this.previewEffectBody);
         this.previewEffect.particles = _loc7_;
         this.previewEffect.ratios = _loc8_;
         this.previewEffect.effectIcon = param1.ico;
         this.previewEffect.elementIcon = _loc9_.elementIcon;
         if(GameState.ui.menuEffects.getSlider("% Radius"))
         {
            this.previewEffect.size = Number(GameState.ui.menuEffects.getValue("% Radius")) * 0.01;
         }
         if(GameState.ui.menuEffects.getSlider("% Speed"))
         {
            this.previewEffect.speed = Number(GameState.ui.menuEffects.getValue("% Speed")) * 0.01;
         }
         if(GameState.ui.menuEffects.getSlider("% Amount"))
         {
            this.previewEffect.amount = Number(GameState.ui.menuEffects.getValue("% Amount")) * 0.01;
         }
         this.previewEffect.noRadius = false;
         this.previewEffect.noAmount = false;
         this.previewEffect.noSpeed = false;
         if(param1.hideRadius)
         {
            this.previewEffect.noRadius = true;
            this.previewEffect.size = 1;
         }
         if(param1.hideAmount)
         {
            this.previewEffect.noAmount = true;
            this.previewEffect.amount = 1;
         }
         if(param1.hideSpeed)
         {
            this.previewEffect.noSpeed = true;
            this.previewEffect.speed = 1;
         }
         if(param1.hideRadius)
         {
            this.previewEffect.noScale = true;
         }
         this.previewEffect.effectLabel = param1.label;
         this.previewEffect.elementLabel = _loc9_.elementLabel;
         this.updateEffectsMenu();
      }
      
      private function selectEffect(param1:Object) : void
      {
         var _loc2_:Vector.<String> = new Vector.<String>();
         _loc2_.push(param1.element);
         this.previewEffect.particles = _loc2_;
         this.previewEffect.elementIcon = param1.ico;
         this.previewEffect.elementLabel = param1.label;
         this.updateEffectsMenu();
      }
      
      private function updateEffectsMenu() : void
      {
         var _loc6_:HUISlider = null;
         var _loc7_:HUISlider = null;
         var _loc8_:HUISlider = null;
         var _loc9_:XML = null;
         GameState.ui.menuEffects.removeAllChildren();
         if(!this.previewEffect.noRadius)
         {
            _loc6_ = GameState.ui.menuEffects.addSlider("% Radius",this.previewEffect.size * 100,10,300);
            _loc6_.addEventListener(Event.CHANGE,this.effectRadiusChanged);
         }
         if(!this.previewEffect.noSpeed)
         {
            _loc7_ = GameState.ui.menuEffects.addSlider("% Speed",this.previewEffect.speed * 100,10,300);
            _loc7_.addEventListener(Event.CHANGE,this.effectSpeedChanged);
         }
         if(!this.previewEffect.noAmount)
         {
            _loc8_ = GameState.ui.menuEffects.addSlider("% Amount",this.previewEffect.amount * 100,1,100);
            _loc8_.addEventListener(Event.CHANGE,this.effectAmountChanged);
         }
         var _loc1_:XML = <node label="Root Node"></node>;
         var _loc2_:XML = <node func="toggleparticles" tooltip="Particle"/>;
         var _loc3_:XML = <node func="toggleeffects" tooltip="Behaviour"/>;
         _loc2_.@ico = this.previewEffect.elementIcon;
         _loc3_.@ico = this.previewEffect.effectIcon;
         _loc3_.@label = this.previewEffect.effectLabel;
         _loc2_.@label = this.previewEffect.elementLabel;
         var _loc4_:Number = 48;
         if(!this.previewEffect.noScale)
         {
            _loc9_ = <node label="Scale to item" func="scale" toggleValue={this.previewEffect.applyScale ? "1" : "0"} tooltip="Scales the effect radius to the item dimensions.&#10;"/>;
            _loc1_.appendChild(_loc9_);
            _loc4_ += 24;
         }
         _loc1_.appendChild(_loc2_);
         _loc1_.appendChild(_loc3_);
         if(this.previewEffect.body == null)
         {
            if(this.previewEffect.applyOffset)
            {
               _loc4_ += 24;
               _loc1_.appendChild(<node label="Reattach" func="reattachfx" center="true"/>);
            }
            _loc4_ += 24;
            _loc1_.appendChild(<node label="Done" func="donefx" center="true"/>);
         }
         else if(this.previewEffect.effectLabel == "None")
         {
            _loc1_.appendChild(<node label="Remove Effect" func="removefx" center="true"/>);
            _loc4_ += 24;
         }
         else if(this.previewEffect.effectLabel != "Choose Effect" && this.previewEffect.effectLabel != "Choose Particle")
         {
            if(this.previewEffect.applyOffset)
            {
               _loc4_ += 24;
               _loc1_.appendChild(<node label="Attach" func="attachfx" tooltip="Choose a position for the effect. Click on an item to attach the effect.&#10;&#10;" center="true"/>);
            }
            _loc4_ += 24;
            _loc1_.appendChild(<node label="Attach to Center" func="centerfx" tooltip="Attach the effect to the center of the item.&#10;" center="true"/>);
         }
         var _loc5_:Tree = GameState.ui.menuEffects.addTree("buttons",_loc1_,_loc4_,0,24);
         _loc5_.addEventListener(ListEvent.ITEM_CLICK,this.effectTreeClick);
         _loc5_.selectable = false;
      }
      
      private function onColourPicker(param1:ColourPickerEvent) : *
      {
         var _loc2_:uint = uint(4278190080 + param1.target.colour);
         var _loc3_:String = _loc2_.toString(16).substr(2).toUpperCase();
         this.cursorSpectrum.visible = false;
         GameState.ui.menuColour.setValue("colour",_loc3_);
         this.updateColour(_loc3_,true,false);
         if(this.colouring == "skin")
         {
            this.updateSkin();
         }
         if(this.colouring == "skindetail")
         {
            this.updateSkin();
         }
         if(this.colouring == "walls")
         {
            GameState.ui.updateEnvironmentInfo();
         }
         if(this.colouring == "background")
         {
            GameState.ui.updateEnvironmentInfo();
         }
         if(this.colouring == "blood")
         {
            this.updateBlood();
         }
         if(this.colouring == "joint")
         {
            GameState.ui.updateJointProperties(Tool.currentJoint);
         }
      }
      
      private function updateColourAlpha(param1:Event) : void
      {
      }
      
      public function BeginColouring(param1:String, param2:String) : *
      {
         this.colouring = param1;
         this.skinOriginal = param2;
         this.updateColour(this.skinOriginal,true,true,false);
         if(!GameState.ui.menuColour.visible)
         {
            GameState.ui.menuColour.open();
            GameState.ui.menuColour.x = GameState.ui.menuWorld.x - GameState.ui.menuColour.actualWidth - Window.BUFFER * 2;
            GameState.ui.menuColour.y = GameState.ui.menuWorld.y;
         }
      }
      
      private function updateColourFromField(param1:Event) : void
      {
         param1.target.text = param1.target.text.replace("#","");
         if(param1.target.text.length == 6)
         {
            this.updateColour(param1.target.text);
            this.cursorSpectrum.visible = false;
            if(this.colouring == "skin")
            {
               this.updateSkin();
            }
            if(this.colouring == "skindetail")
            {
               this.updateSkin();
            }
            if(this.colouring == "walls")
            {
               GameState.ui.updateEnvironmentInfo();
            }
            if(this.colouring == "background")
            {
               GameState.ui.updateEnvironmentInfo();
            }
            if(this.colouring == "blood")
            {
               this.updateBlood();
            }
            if(this.colouring == "joint")
            {
               GameState.ui.updateJointProperties(Tool.currentJoint);
            }
         }
      }
      
      public function RandomiseSpawnSkin(param1:Number = -1) : *
      {
         var _loc4_:* = undefined;
         GameState.objects.spawnSkin = new Vector.<Array>();
         var _loc2_:Array = O.getItem(GameState.objects.spawnName).colours;
         var _loc3_:Array = [];
         if(param1 != -1)
         {
            param1 = TradingCardUI.seededrandom(param1);
         }
         for each(_loc4_ in _loc2_)
         {
            if(_loc4_ is ShapeUserData)
            {
               _loc4_ = ShapeUserData(_loc4_).name;
            }
            this.colouring = "skin";
            if(param1 == -1)
            {
               this.skinModifying = uint(Math.random() * 16777215).toString(16);
            }
            else
            {
               this.skinModifying = uint(param1 * 16777215).toString(16);
            }
            this.skinOriginal = _loc4_.toUpperCase();
            if(_loc3_.indexOf(this.skinOriginal) == -1)
            {
               if(param1 != -1)
               {
                  param1 = TradingCardUI.seededrandom(param1);
               }
               _loc3_.push(this.skinOriginal);
               this.updateColour(this.skinModifying,true,true,false);
               this.updateSkin();
            }
         }
         this.updateSpawnPic();
         if(this.detailBody)
         {
            userData(this.detailBody.GetUserData()).skin = GameState.objects.spawnSkin.slice();
            BoxUtils.ReplaceGraphic(userData(this.detailBody.GetUserData()),O.getItem(userData(this.detailBody.GetUserData()).name).updateGraphic(null));
         }
      }
      
      public function updateColour(param1:String, param2:Boolean = true, param3:Boolean = true, param4:Boolean = true) : *
      {
         var _loc7_:* = undefined;
         var _loc8_:int = 0;
         var _loc9_:b2Body = null;
         var _loc5_:uint = uint("0x" + param1);
         var _loc6_:TextField = GameState.ui.menuColour.getField("colour") as TextField;
         _loc6_.background = true;
         _loc6_.backgroundColor = _loc5_;
         if(GraphicUtils.hexBrightness(_loc5_) < 18000)
         {
            this.colourPickerField.textColor = 16448250;
            _loc6_.textColor = 16448250;
         }
         else
         {
            this.colourPickerField.textColor = 1118481;
            _loc6_.textColor = 1118481;
         }
         if(param3)
         {
            this.colourPicker.setColour(_loc5_);
         }
         if(param2)
         {
            this.colourPickerField.text = param1;
            this.colourPickerField.backgroundColor = _loc5_;
            _loc6_.text = this.colourPickerField.text;
         }
         if(!this.colouring)
         {
            return;
         }
         if(this.colouring == "skin")
         {
            _loc7_ = true;
            _loc8_ = 0;
            while(_loc8_ < GameState.objects.spawnSkin.length)
            {
               if(GameState.objects.spawnSkin[_loc8_][0] == this.skinOriginal)
               {
                  _loc7_ = false;
                  break;
               }
               _loc8_++;
            }
            if(_loc7_)
            {
               GameState.objects.spawnSkin.push([this.skinOriginal,param1]);
            }
            else
            {
               GameState.objects.spawnSkin.splice(_loc8_,1);
               GameState.objects.spawnSkin.push([this.skinOriginal,param1]);
            }
            if(param4)
            {
               this.updateSpawnPic();
            }
         }
         else if(this.colouring == "skindetail")
         {
            _loc7_ = true;
            _loc8_ = 0;
            while(_loc8_ < GameState.objects.spawnSkin.length)
            {
               if(GameState.objects.spawnSkin[_loc8_][1] == this.skinOriginal)
               {
                  _loc7_ = false;
                  break;
               }
               _loc8_++;
            }
            if(!_loc7_)
            {
               GameState.objects.spawnSkin.splice(_loc8_,1);
               GameState.objects.spawnSkin.push([this.skinOriginal,param1]);
            }
            if(param4)
            {
               this.updateSpawnPic();
            }
         }
         else if(this.colouring == "background")
         {
            GameState.environment.backgroundColour = _loc5_;
         }
         else if(this.colouring == "walls")
         {
            GameState.environment.wallColour = _loc5_;
         }
         else if(this.colouring == "blood")
         {
            if(this.detailBody)
            {
               userData(this.detailBody.GetUserData()).bloodColour = _loc5_;
               for each(_loc9_ in this.selectedBodies)
               {
                  userData(_loc9_.GetUserData()).bloodColour = _loc5_;
               }
            }
            else
            {
               Tweak.bloodColour = _loc5_;
            }
         }
         else if(this.colouring == "joint")
         {
            Tweak.jointColour = _loc5_;
         }
      }
      
      private function startPicking(param1:MouseEvent) : *
      {
         this.showColour(true,false);
         this.cursorSpectrum.visible = true;
         stage.addEventListener(MouseEvent.MOUSE_UP,this.stopPicking);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseColour);
      }
      
      private function stopPicking(param1:MouseEvent) : void
      {
         this.showColour();
         if(this.colouring == "skin")
         {
            this.updateSkin();
         }
         if(this.colouring == "blood")
         {
            this.updateSkin();
         }
         if(this.colouring == "skindetail")
         {
            this.updateSkin();
         }
         if(this.colouring == "walls")
         {
            GameState.ui.updateEnvironmentInfo();
         }
         if(this.colouring == "background")
         {
            GameState.ui.updateEnvironmentInfo();
         }
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.stopPicking);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseColour);
      }
      
      private function mouseColour(param1:MouseEvent) : void
      {
         this.showColour(true,false);
      }
      
      private function showColour(param1:Boolean = true, param2:Boolean = true) : void
      {
         this.cursorSpectrum.x = GeneralUtils.clamp(mouseX - GameState.ui.menuColour.x,this.spectrum.x,this.spectrum.width + this.spectrum.x - 1);
         this.cursorSpectrum.y = GeneralUtils.clamp(mouseY - GameState.ui.menuColour.y,this.spectrum.y,this.spectrum.height + this.spectrum.y - 1);
         var _loc3_:uint = this.spectrum.bmd.getPixel32(this.cursorSpectrum.x - this.spectrum.x,this.cursorSpectrum.y - this.spectrum.y);
         var _loc4_:String = _loc3_.toString(16).substr(2).toUpperCase();
         this.updateColour(_loc4_,param1,param2);
      }
      
      private function windowResized(param1:WindowEvent) : void
      {
         var _loc2_:String = param1.name;
         if(_loc2_ == "Spawn")
         {
            GameState.ui.initSpawnMenu(GameState.ui.menuSpawn.height,true);
         }
      }
      
      private function windowStopResize(param1:WindowEvent) : void
      {
         var _loc2_:String = param1.name;
         if(_loc2_ == "Spawn")
         {
            GameState.ui.initSpawnMenu(GameState.ui.menuSpawn.height - 56);
         }
      }
      
      private function windowMaximised(param1:WindowEvent) : void
      {
         var _loc2_:String = param1.name;
         if(_loc2_ == "Spawn")
         {
            this.updateSpawnPic();
         }
      }
      
      private function windowOpened(param1:WindowEvent) : void
      {
         if(GameState.tutorialActive)
         {
            return;
         }
         var _loc2_:String = param1.name;
         if(_loc2_ == "Spawn")
         {
            if(!GameState.quickspawning)
            {
               GameState.ui.initSpawnMenu(this.spawnMenuSize);
            }
            if(!GameState.ui.menuLibrary.undocked && !GameState.ui.menuSpawn.undocked)
            {
               if(GameState.ui.menuObject.visible && !GameState.ui.menuObject.undocked)
               {
                  GameState.ui.menuLibrary.x = GameState.ui.menuObject.x + GameState.ui.menuObject.actualWidth + 4;
                  GameState.ui.menuLibrary.y = GameState.ui.menuObject.y;
               }
               else
               {
                  GameState.ui.menuLibrary.x = GameState.ui.menuSpawn.x + GameState.ui.menuSpawn.actualWidth + 4;
                  GameState.ui.menuLibrary.y = GameState.ui.menuSpawn.y;
               }
            }
            AutoComplete(GameState.ui.menuSpawn.getChildByName("autoComplete")).keysEnabled = true;
         }
         else if(_loc2_ == "Library")
         {
            if(GameState.ui.menuSpawn.visible)
            {
               GameState.ui.menuLibrary.x = GameState.ui.menuSpawn.x + GameState.ui.menuSpawn.actualWidth + 4;
               GameState.ui.menuLibrary.y = GameState.ui.menuSpawn.y;
            }
            else if(GameState.ui.menuObject.visible && !GameState.ui.menuObject.undocked)
            {
               GameState.ui.menuLibrary.x = GameState.ui.menuObject.x + GameState.ui.menuObject.actualWidth + 4;
               GameState.ui.menuLibrary.y = GameState.ui.menuObject.y;
            }
            else
            {
               GameState.ui.menuLibrary.x = GameState.ui.menuMain.x + GameState.ui.menuMain.actualWidth + 4;
               GameState.ui.menuLibrary.y = GameState.ui.menuMain.y;
            }
         }
         else if(_loc2_ == "Effects")
         {
            userData(this.previewEffectBody.GetUserData()).graphic.alpha = 1;
         }
         else if(_loc2_ == "Properties")
         {
            if(!GameState.ui.menuLibrary.undocked && !GameState.ui.menuSpawn.undocked && !GameState.ui.menuObject.undocked)
            {
               if(GameState.ui.menuObject.title != "Detail Settings" && GameState.ui.menuObject.title != "Detail Properties" && GameState.ui.menuObject.title != "Bullet Properties" && GameState.ui.menuObject.title != "Gun Settings")
               {
                  GameState.ui.menuLibrary.x = GameState.ui.menuObject.x + GameState.ui.menuObject.actualWidth + 4;
                  GameState.ui.menuLibrary.y = GameState.ui.menuObject.y;
               }
            }
         }
         else if(_loc2_ == "Environment" && !GameState.ui.menuWorld.undocked)
         {
            if(GameState.ui.menuSettings.visible && !GameState.ui.menuSettings.undocked)
            {
               GameState.ui.menuWorld.x = GameState.ui.menuSettings.x - GameState.ui.menuSettings.actualWidth - Window.BUFFER * 2 - GameState.ui.menuWorld.actualWidth + GameState.ui.menuSettings.actualWidth;
               GameState.ui.menuWorld.y = GameState.ui.menuSettings.y;
            }
            else
            {
               GameState.ui.menuWorld.x = GameState.ui.menuControls.x - GameState.ui.menuControls.actualWidth - Window.BUFFER * 2 - GameState.ui.menuWorld.actualWidth + GameState.ui.menuControls.actualWidth - 1;
               GameState.ui.menuWorld.y = GameState.ui.menuControls.y;
            }
         }
         else if(_loc2_ == "Settings" && !GameState.ui.menuSettings.undocked)
         {
            if(GameState.ui.menuWorld.visible && !GameState.ui.menuWorld.undocked)
            {
               GameState.ui.menuSettings.x = GameState.ui.menuWorld.x - GameState.ui.menuWorld.actualWidth - Window.BUFFER * 2 - GameState.ui.menuSettings.actualWidth + GameState.ui.menuWorld.actualWidth;
               GameState.ui.menuSettings.y = GameState.ui.menuWorld.y;
            }
            else
            {
               GameState.ui.menuSettings.x = GameState.ui.menuControls.x - GameState.ui.menuControls.actualWidth - Window.BUFFER * 2 - GameState.ui.menuSettings.actualWidth + GameState.ui.menuControls.actualWidth - 1;
               GameState.ui.menuSettings.y = GameState.ui.menuControls.y;
            }
         }
      }
      
      private function windowClosed(param1:WindowEvent) : void
      {
         if(GameState.tutorialActive)
         {
            return;
         }
         var _loc2_:String = param1.name;
         if(_loc2_ == "Properties")
         {
            if(GameState.ui.menuColour.visible)
            {
               GameState.ui.menuColour.close();
               if(this.colouring == "skin")
               {
                  this.colouring = null;
               }
               if(this.colouring == "skindetail")
               {
                  this.colouring = null;
               }
            }
            if(GameState.objects.prevName)
            {
               GameState.ui.selectItemByName(GameState.objects.prevName);
               GameState.objects.spawnSkin = GameState.objects.prevSkin;
               this.updateSpawnPic();
               GameState.objects.prevName = null;
            }
            if(GameState.ui.menuObject.title != "Bullet Properties" && GameState.ui.menuObject.title != "Gun Settings")
            {
               if(!GameState.ui.menuLibrary.undocked && !GameState.ui.menuSpawn.undocked)
               {
                  GameState.ui.menuLibrary.x = GameState.ui.menuSpawn.x + GameState.ui.menuSpawn.actualWidth + 4;
                  GameState.ui.menuLibrary.y = GameState.ui.menuSpawn.y;
               }
            }
         }
         else if(_loc2_ == "Details")
         {
            this.detailBody = null;
            GameState.skinning = false;
            if(GameState.stamping)
            {
               GameState.stamping = false;
               this.detailSubmenu = "main";
               this.outlineSelected();
            }
            if(GameState.ui.menuObject.title == "Detail Skin")
            {
               GameState.ui.menuObject.close();
            }
            if(GameState.ui.menuObject.title == "Detail Gun")
            {
               GameState.ui.menuObject.close();
            }
            if(GameState.ui.menuObject.title == "Bullet Properties")
            {
               GameState.ui.menuObject.close();
            }
         }
         else if(_loc2_ == "Contract")
         {
            if(this.contract.enabled)
            {
               this.reset();
            }
         }
         else if(_loc2_ == "Effects")
         {
            if(GameState.ui.menuObject.visible && (GameState.ui.menuObject.title == "Behaviours" || GameState.ui.menuObject.title == "Particles"))
            {
               GameState.ui.menuObject.close();
            }
         }
         else if(_loc2_ == "Spawn")
         {
            if(GameState.ui.menuSpawn.title == "VIEW CARD")
            {
               GameState.ui.DisableTradingCardStyle();
            }
            GameState.quickspawning = false;
            if(GameState.ui.menuObject.visible && !GameState.ui.menuObject.undocked)
            {
               if(GameState.ui.menuObject.title.indexOf("Detail") == -1)
               {
                  GameState.ui.menuObject.close();
               }
            }
            if(!GameState.ui.menuLibrary.undocked && !GameState.ui.menuSpawn.undocked)
            {
               GameState.ui.menuLibrary.x = GameState.ui.menuMain.x + GameState.ui.menuMain.actualWidth + 4;
               GameState.ui.menuLibrary.y = GameState.ui.menuMain.y;
            }
            AutoComplete(GameState.ui.menuSpawn.getChildByName("autoComplete")).keysEnabled = false;
         }
         else if(_loc2_ == "Colour" && this.colouring == "blood")
         {
            this.updateSkin();
         }
         else if(_loc2_ == "Environment" && !GameState.ui.menuWorld.undocked)
         {
            if(GameState.ui.menuSettings.visible && !GameState.ui.menuSettings.undocked)
            {
               GameState.ui.menuSettings.x = GameState.ui.menuControls.x - GameState.ui.menuControls.actualWidth - Window.BUFFER * 2 - GameState.ui.menuSettings.actualWidth + GameState.ui.menuControls.actualWidth - 1;
               GameState.ui.menuSettings.y = GameState.ui.menuControls.y;
            }
         }
         else if(_loc2_ == "Settings" && !GameState.ui.menuSettings.undocked)
         {
            if(GameState.ui.menuWorld.visible && !GameState.ui.menuWorld.undocked)
            {
               GameState.ui.menuWorld.x = GameState.ui.menuControls.x - GameState.ui.menuControls.actualWidth - Window.BUFFER * 2 - GameState.ui.menuWorld.actualWidth + GameState.ui.menuControls.actualWidth - 1;
               GameState.ui.menuWorld.y = GameState.ui.menuControls.y;
            }
            GameState.ui.remSettingListeners();
         }
         else if(_loc2_ == "Powers" || _loc2_ == "Tools")
         {
            if(Powers.settingsNeedSaving)
            {
               Settings.saveSettings();
               Powers.settingsNeedSaving = false;
            }
         }
      }
      
      public function changeEnvironment(param1:String, param2:Object = null) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:Vector.<b2Body> = null;
         var _loc6_:b2Body = null;
         this.gamefrozen = [60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60];
         GameState.environmenting = true;
         this.clear();
         var _loc3_:Vector.<b2Body> = GameState.environment.public::wallBodies;
         for each(_loc4_ in _loc3_)
         {
            Body.Destroy(_loc4_,"environment change",true);
         }
         _loc5_ = GameState.environment.defaultBodies;
         for each(_loc6_ in _loc5_)
         {
            Body.Destroy(_loc6_,"environment change",true);
         }
         if(param1 == "lab")
         {
            GameState.environment = new Lab();
            Shadows.shadowStrength = 0.2;
         }
         else if(param1 == "MainMenu")
         {
            GameState.environment = new MainMenu();
            Shadows.shadowStrength = 0.2;
         }
         else if(param1 == "biglab")
         {
            GameState.environment = new Big_Lab();
            Shadows.shadowStrength = 0.2;
         }
         else if(param1 == "talllab")
         {
            GameState.environment = new Tall_Lab();
            Shadows.shadowStrength = 0.2;
         }
         else if(param1 == "megalab")
         {
            GameState.environment = new Mega_Lab();
            Shadows.shadowStrength = 0.2;
         }
         else if(param1 == "gigalab")
         {
            GameState.environment = new Giga_Lab();
            Shadows.shadowStrength = 0.2;
         }
         else if(param1 == "ultralab")
         {
            GameState.environment = new Max_Lab();
            Shadows.shadowStrength = 0.2;
         }
         else if(param1 == "desert")
         {
            GameState.environment = new Sand();
            Shadows.shadowStrength = 0.02;
         }
         else if(param1 == "moon")
         {
            GameState.environment = new Moon();
            Shadows.shadowStrength = 0.2;
         }
         else if(param1 == "forest")
         {
            GameState.environment = new Forest();
            Shadows.shadowStrength = 0.04;
         }
         else if(param1 == "ice")
         {
            GameState.environment = new Ice();
            Shadows.shadowStrength = 0.02;
         }
         else if(param1 == "icehole")
         {
            GameState.environment = new IceHole();
            Shadows.shadowStrength = 0.1;
         }
         else if(param1 == "openworld")
         {
            GameState.environment = new OpenWorld();
            Shadows.shadowStrength = 0.1;
            GameState.ui.menuWorld.close();
            GameState.ui.menuSpawn.close();
            GameState.ui.menuSettings.close();
         }
         else if(param1 == "pumpkindefence")
         {
            GameState.environment = new PumpkinDefence();
            Shadows.shadowStrength = 0.1;
            GameState.ui.menuWorld.close();
            GameState.ui.menuSpawn.close();
            GameState.ui.menuSettings.close();
         }
         else if(param1 == "pumpkinoffence")
         {
            GameState.environment = new PumpkinOffence();
            Shadows.shadowStrength = 0.1;
            GameState.ui.menuWorld.close();
            GameState.ui.menuSpawn.close();
            GameState.ui.menuSettings.close();
         }
         else if(param1 == "pumpkinmoon")
         {
            GameState.environment = new PumpkinMoon();
            Shadows.shadowStrength = 0.1;
            GameState.ui.menuWorld.close();
            GameState.ui.menuSpawn.close();
            GameState.ui.menuSettings.close();
         }
         else if(param1 == "winterhitlist")
         {
            GameState.environment = new WinterHitList();
            Shadows.shadowStrength = 0.1;
            GameState.ui.menuWorld.close();
            GameState.ui.menuSpawn.close();
            GameState.ui.menuSettings.close();
         }
         else
         {
            if(param1 == "crash")
            {
               Tool.setTool("crash");
               return;
            }
            if(param1 == "citynight")
            {
               GameState.environment = new CityNight();
               Shadows.shadowStrength = 0.2;
            }
            else if(param1 == "city")
            {
               GameState.environment = new City();
               Shadows.shadowStrength = 0.1;
            }
            else if(param1 == "slope")
            {
               GameState.environment = new Slope();
               Shadows.shadowStrength = 0.1;
            }
            else if(param1 == "snow")
            {
               GameState.environment = new Snow();
               Shadows.shadowStrength = 0.02;
            }
            else if(param1 == "island")
            {
               GameState.environment = new Island();
            }
            else if(param1 == "snowpiles")
            {
               GameState.environment = new SnowPiles();
               Shadows.shadowStrength = 0.02;
            }
            else if(param1 == "sky")
            {
               GameState.environment = new Sky();
               Shadows.shadowStrength = 0.02;
            }
            else if(param1 == "jungle")
            {
               GameState.environment = new Jungle();
               Shadows.shadowStrength = 0.02;
            }
            else if(param1 == "cave")
            {
               GameState.environment = new Cave();
               Shadows.shadowStrength = 0.02;
            }
            else if(param1 == "poison")
            {
               GameState.environment = new Poison();
               Shadows.shadowStrength = 0.02;
            }
            else if(param1 == "fire")
            {
               GameState.environment = new Fire();
               Shadows.shadowStrength = 0.1;
            }
            else if(param1 == "blood")
            {
               GameState.environment = new Blood();
               Shadows.shadowStrength = 0.1;
            }
            else if(param1 == "tinyplanet")
            {
               GameState.environment = new TinyPlanet();
               Shadows.shadowStrength = 0.1;
            }
            else if(param1 == "custom")
            {
               GameState.environment = new Custom();
               Shadows.shadowStrength = 0.1;
            }
         }
         if(Boolean(param2) && Boolean(param2.content))
         {
            GameState.environment.loadContent = param2.content;
         }
         var _loc7_:String = GameState.environment.loadContent;
         if(!IO.incrementalLoading)
         {
            if(_loc7_)
            {
               IO.loadWorld(GameState.environment.loadContent,false,true);
               GameState.environment.loadContent = _loc7_;
            }
         }
         if(Boolean(param2) && Boolean(param2.content))
         {
            GameState.environment.loadContent = param2.content;
            GameState.environment.contentName = param2.label;
         }
         GameState.ui.menuWorld.setValue("Gravity",GameState.environment.gravity);
         GameState.ui.menuWorld.setValue("Wind",GameState.environment.wind);
         var _loc8_:Number = GameState.environment.temperature;
         if(World.toggleFahrenheit == 1)
         {
            _loc8_ = 9 / 5 * _loc8_ + 32 >> 0;
         }
         GameState.ui.menuWorld.setValue("Temperature",_loc8_);
         Vars.gravity = GameState.environment.gravity;
         Vars.wind = GameState.environment.wind;
         Vars.temperature = GameState.environment.temperature;
         if(!_loc7_)
         {
            this.m_sprite.x = 0;
            this.m_sprite.y = 0;
            this.cam.scaleX = 1;
            this.cam.scaleY = 1;
            this.cam.x = 0;
            this.cam.y = 0;
            this.bgBM.x = 0;
            this.bgBM.y = 0;
            this.CameraHome();
         }
         GameState.environment.setupWalls();
         var _loc9_:Number = GameState.environment.borderLeft;
         var _loc10_:Number = GameState.environment.borderRight;
         var _loc11_:Number = GameState.environment.borderTop;
         if(World.toggleBackground == 1 && Boolean(GameState.environment.public::background))
         {
            this.bgBM.bitmapData = GameState.environment.public::background;
         }
         else if(this.bgBM.bitmapData)
         {
            this.bgBM.bitmapData.fillRect(this.bgBM.bitmapData.rect,GameState.environment.backgroundColour);
         }
         GameState.environmenting = false;
         GameState.ui.updateEnvironmentInfo();
         TimeLord.toggle();
         System.pauseForGCIfCollectionImminent(0.25);
      }
      
      public function changeEnvironmentOnMenu(param1:ListEvent) : void
      {
         var _loc2_:String = null;
         if(param1.item is LeafNode)
         {
            _loc2_ = param1.item.func;
            if(_loc2_)
            {
               this.changeEnvironment(_loc2_,param1.item);
               GameState.ui.showEnvironmentInfo();
               GameState.ui.menuWorld.forceMaximised();
            }
         }
      }
      
      private function CopyCustomItem() : void
      {
         GeneralUtils.copyToClipboard(GameState.objects.spawnCustomContent);
         GameState.ui.showTooltip(GameState.ui.menuDetails,"Item copied to clipboard.",0,1000,GameState.ui.menuDetails.actualWidth);
      }
      
      private function ShareCustomItem(param1:ListEvent) : void
      {
         var _loc2_:int = 0;
         this.reset(false,true);
         GameState.spawningCustom = true;
         this.sharingItem = true;
         this.customPos = new b2Vec2(400,300);
         IO.loadWorld(GameState.objects.spawnCustomContent,!GameState.paused,true);
         GameState.spawningCustom = false;
      }
      
      private function createCustomItem() : void
      {
         this.quickCreatingCustomItem = 1;
         Tool.detail();
         this.updateTools();
         GameState.ui.showTooltip(GameState.ui.menuLibrary,"Click+Drag to select all items you want to include in the Custom Item.\n\n\n",0,9000,GameState.ui.menuLibrary.actualWidth);
      }
      
      private function sortCustomItems() : void
      {
         if(GameState.CustomSort == "Newest")
         {
            GameState.CustomSort = "Alphabetical";
         }
         else
         {
            GameState.CustomSort = "Newest";
         }
         this.updateLibrary();
         var _loc1_:Tree = GameState.ui.menuLibrary.getTree("buttons");
         var _loc2_:TNode = _loc1_.findNode("label","[" + GameState.CustomSort + "]");
         var _loc3_:int = _loc1_.showNode(_loc2_);
         if(_loc3_ != -1)
         {
            _loc1_.scrollToSelected();
         }
      }
      
      public function forceUpdateLibrary() : void
      {
         var _loc1_:String = null;
         for each(_loc1_ in this.localNames)
         {
            O.delItem(_loc1_);
         }
         this.localItems = [];
         this.localNames = [];
         R.library_objects = null;
         R.library_names = null;
         this.loadLocalItems(true);
         IO.LoadExternalModels();
         this.initLibraryItems();
         this.updateLibrary();
      }
      
      public function updateLibrary() : void
      {
         var somethingFavourited:Boolean;
         var i:int = 0;
         var sortmode:String = null;
         var sortAlphabetical:Boolean = false;
         var sortOrder:Array = null;
         var item:XML = null;
         var ind:int = 0;
         var cName:String = null;
         var splittu:Array = null;
         var itemsadded:Boolean = false;
         var leveladded:Boolean = false;
         var content:Object = null;
         var node:XML = null;
         var title:String = null;
         var tt:String = null;
         var j:int = 0;
         var temp:Object = null;
         var funcxml:XML = null;
         var category:String = null;
         var favit:Item = null;
         var libxml:XML = R.xml_objects;
         var favLabel:String = "Favourite Items";
         var cusLabel:String = "Custom Items";
         var locLabel:String = "Item Models";
         var workLabel:String = "Workshop";
         var workItemLabel:String = "Workshop Items";
         var workLevelLabel:String = "Workshop Levels";
         var savedLevelLabel:String = "Saved Levels";
         delete global[libxml.node.(@label == favLabel).setChildren(new XMLList())];
         delete global[libxml.node.(@label == cusLabel).setChildren(new XMLList())];
         delete global[libxml.node.(@label == locLabel).setChildren(new XMLList())];
         delete global[libxml.node.(@label == savedLevelLabel).setChildren(new XMLList())];
         if(true == false || true == false)
         {
            delete libxml.node.(@label == workLabel)[0];
            workLabel = null;
         }
         else
         {
            delete global[libxml.node.(@label == workLabel).setChildren(new XMLList())];
         }
         somethingFavourited = false;
         i = 0;
         while(i < this.favourites.length)
         {
            if(this.favourites[i] != "")
            {
               somethingFavourited = true;
            }
            i++;
         }
         if(!somethingFavourited)
         {
            libxml.node.(@label == favLabel).appendChild(<node label="Empty" tooltip="Favourite via Spawn Menu to add things here.&#10;&#10;"></node>);
         }
         if(this.customItems.length == 0)
         {
            libxml.node.(@label == cusLabel).appendChild(<node label="Empty" tooltip="Create custom items by selecting them and using Detail Tool. See Tutorial > Custom Items.&#10;&#10;&#10;&#10;"></node>);
         }
         else
         {
            sortmode = "[" + GameState.CustomSort + "]";
            libxml.node.(@label == cusLabel).appendChild(<node label="Create" center="true" func="custom_create" tooltip="Create a new Custom Item.&#10;&#10;"/>);
            libxml.node.(@label == cusLabel).appendChild(<node label="Manage" center="true" func="custom_manage" tooltip="Share, remove, or rename your Custom Items.&#10;&#10;"/>);
            libxml.node.(@label == cusLabel).appendChild(<node label={sortmode} center="true" func="custom_sort" tooltip="Toggles list sort by most recently saved or alphabetical.&#10;&#10;"/>);
            libxml.node.(@label == cusLabel).appendChild(<node label="" func="spacer"/>);
            sortAlphabetical = false;
            if(GameState.CustomSort == "Alphabetical")
            {
               sortAlphabetical = true;
            }
            sortOrder = this.customNames.sort(8);
            i = 0;
            while(i < this.customItems.length)
            {
               item = <node/>;
               ind = i;
               if(sortAlphabetical)
               {
                  ind = int(sortOrder[i]);
               }
               else
               {
                  ind = this.customItems.length - 1 - i;
               }
               cName = String(this.customNames[ind]);
               item.@label = cName;
               item.@object = cName;
               item.@custom = this.customItems[ind];
               splittu = cName.split(" by ");
               if(splittu.length == 2 && String(splittu[1]).length > 10)
               {
                  item.@tooltip = "by " + splittu[1] + "\n\n";
               }
               libxml.node.(@label == cusLabel).appendChild(item);
               i++;
            }
         }
         if(Boolean(workLabel))
         {
            if(Boolean(GameState.steamworks) && Boolean(GameState.steamworks.API) && Boolean(GameState.steamworks.API.isReady))
            {
               libxml.node.(@label == workLabel).appendChild(<node label="Browse Workshop" func="openWorkshop" tooltip="Open Steam Workshop.&#10;Requires steam:// protocol.&#10;"/>);
               libxml.node.(@label == workLabel).appendChild(<node label="Share Custom Item" func="custom_share" tooltip="Share your custom items on the Workshop.&#10;&#10;"></node>);
               libxml.node.(@label == workLabel).appendChild(<node label="Download Subscribed" func="workshopSubscribed" tooltip="Redownload all your subscribed content from the Steam Workshop.&#10;&#10;"></node>);
               if(GameState.steamworks.workshopContentDownloadFinished)
               {
                  libxml.node.(@label == workLabel).appendChild(<node label="Save Locally" func="workshopSave" tooltip="Save downloaded content locally so it doesn't need to be downloaded on every launch.&#10;&#10;"></node>);
               }
            }
            else
            {
               libxml.node.(@label == workLabel).appendChild(<node label="Not connected." tooltip="Steamworks API returned it's not connected. Proceed to panic.&#10;&#10;&#10;&#10;"></node>);
            }
            itemsadded = false;
            leveladded = false;
            i = 0;
            while(i < GameState.steamworks.workshopContent.length)
            {
               content = GameState.steamworks.workshopContent[i];
               if(String(content.title).indexOf("[Item]") != -1)
               {
                  if(!itemsadded)
                  {
                     libxml.node.(@label == workLabel).appendChild(<node label={workItemLabel} tooltip="Workshop Items.&#10;Spawn by dragging or via Spawn Menu.&#10;"></node>);
                     itemsadded = true;
                  }
                  title = content.title.replace("[Item] ","");
                  title = title.replace("[Item]","");
                  node = <node label={title}/>;
                  node.@object = title;
                  if(content.description)
                  {
                     tt = content.description;
                     j = 0;
                     while(j < int(tt.length / 24) + 1)
                     {
                        tt += "\n";
                        j++;
                     }
                     node.@tooltip = tt;
                  }
                  node.@custom = "MAD" + content.content;
                  libxml.node.node.(@label == workItemLabel).appendChild(node);
               }
               else
               {
                  if(!leveladded)
                  {
                     libxml.node.(@label == workLabel).appendChild(<node label={workLevelLabel} tooltip="Workshop Levels.&#10;Click to load.&#10;"></node>);
                     leveladded = true;
                  }
                  title = content.title.replace("[Level] ","");
                  title = title.replace("[Level]","");
                  node = <node label={title} func="workshopLoad" tooltip="Click to load." content={content.content}/>;
                  libxml.node.node.(@label == workLevelLabel).appendChild(node);
               }
               i++;
            }
         }
         if(this.favouriteSaveNames.length > 0)
         {
            libxml.node.(@label == savedLevelLabel).appendChild(<node label="Manage" func="removefavs" center="true" tooltip="Opens a list for removing saved levels.&#10;&#10;"/>);
            libxml.node.(@label == savedLevelLabel).appendChild(<node label="" func="spacer"/>);
            if(Main.instance.favouriteSaveNames.length > 0)
            {
               i = 0;
               while(i < this.favouriteSaveNames.length)
               {
                  item = <node/>;
                  item.@label = Main.instance.favouriteSaveNames[i];
                  item.@func = "favload";
                  item.@center = "true";
                  item.@id = i;
                  libxml.node.(@label == savedLevelLabel).appendChild(item);
                  i++;
               }
            }
         }
         libxml.node.(@label == locLabel).appendChild(<node label="Refresh" func="models_refresh" center="true" tooltip="Refresh to update the Library after making changes to the models folder.&#10;&#10;&#10;"/>);
         libxml.node.(@label == locLabel).appendChild(<node label="Open Folder" func="models_folder" center="true" tooltip="Open the models folder.&#10;&#10;"/>);
         libxml.node.(@label == locLabel).appendChild(<node label="MaD Lab" func="madlab" center="true" tooltip="MaD Lab is the item editor for MaD2. Click to open its site for more information.&#10;&#10;&#10;"/>);
         if(this.localItems.length > 0)
         {
            libxml.node.(@label == locLabel).appendChild(<node label="" func="spacer"/>);
         }
         else
         {
            libxml.node.(@label == locLabel).appendChild(<node label="" func="spacer"/>);
            libxml.node.(@label == locLabel).appendChild(<node label="Empty." func="spacer" tooltip="No item models imported. Create one in MaD Lab, or find models made by others on MaD2 Discord.&#10;&#10;"/>);
         }
         i = 0;
         for(; i < this.localItems.length; i++)
         {
            temp = JSON.parse(this.localItems[i]);
            cName = temp.ItemName;
            if(!cName)
            {
               cName = temp.Title;
            }
            if(Boolean(temp.Functionality) && String(temp.Functionality).substr(0,5) == "<node")
            {
               try
               {
                  funcxml = new XML(temp.Functionality);
                  funcxml.@label = cName;
                  funcxml.@object = cName.toLowerCase().replace(/\s/g,"");
                  category = locLabel;
                  if(funcxml.hasOwnProperty("@category"))
                  {
                     category = funcxml.@category;
                  }
                  if(libxml.node.(@label == category).length() > 0)
                  {
                     if(libxml.node.(@label == category).node.(@label == funcxml.@label))
                     {
                        delete libxml.node.(@label == category).node.(@label == funcxml.@label)[0];
                     }
                     libxml.node.(@label == category).appendChild(funcxml);
                  }
                  else
                  {
                     libxml.node.(@label == locLabel).appendChild(funcxml);
                  }
                  continue;
               }
               catch(e:*)
               {
                  GameState.ui.showTooltip(GameState.ui.menuMain,"Model XML functionality error:\n" + cName + "\nFix or remove the XML using MaD Lab.\n",100,5000,300);
               }
            }
            item = <node/>;
            item.@label = String(cName);
            item.@object = String(cName).toLowerCase().replace(/\s/g,"");
            item.@local = this.localItems[i];
            libxml.node.(@label == locLabel).appendChild(item);
         }
         i = 0;
         while(i < this.favourites.length)
         {
            if(this.favourites[i] != "")
            {
               item = <node/>;
               item.@label = GeneralUtils.objectToName(this.favourites[i]);
               item.@object = this.favourites[i];
               item.@favourite = "true";
               favit = O.getItem(this.favourites[i]);
               if(Boolean(favit) && Boolean(favit.creator))
               {
                  item.@lab = "true";
                  item.@creator = favit.creator;
                  item.@tooltip = GeneralUtils.objectToTooltip(this.favourites[i]);
               }
               libxml.node.(@label == favLabel).appendChild(item);
            }
            i++;
         }
         GameState.ui.menuLibrary.getTree("buttons").dataProvider = new TreeDataProvider(libxml);
         this.initAutoCompleteItems();
      }
      
      public function flip() : void
      {
         this.spawnFlipped = !this.spawnFlipped;
         this.flipped = !this.flipped;
         this.updateSpawnPic();
         this.updateFlipIcon();
      }
      
      private function initConsole() : void
      {
         var _loc1_:Console = new Console(GameState.width,24);
         GameState.ui.console = _loc1_;
         _loc1_.name = "console";
         _loc1_.x = 0;
         _loc1_.y = GameState.height - _loc1_.height;
         addChild(_loc1_);
         _loc1_.addCommand("menualpha",this.SetMenuAlpha);
         _loc1_.addCommand("tooSpooky",this.ToggleFools);
         _loc1_.addCommand("notSpookyEnough",this.ToggleFoolsOn);
         _loc1_.addCommand("decodestring",this.decode);
         _loc1_.addCommand("encodestring",this.encode);
         _loc1_.addCommand("prioritizeselect",this.prioritizeSelect);
         _loc1_.addCommand("simpleignores",this.simpleIgnores);
         _loc1_.addCommand("ps",this.prioritizeSelect);
         _loc1_.addCommand("stampquality",this.stampQuality);
         _loc1_.addCommand("detaillocked",this.detailLocked);
         _loc1_.addCommand("modelimport",this.modelImport);
         _loc1_.addCommand("modelmanage",this.modelManage);
         _loc1_.addCommand("whatdoesthisdo",this.debugInfo);
         _loc1_.addCommand("debuginfo",this.debugInfo);
         _loc1_.addCommand("debug",this.debugInfo);
         _loc1_.addCommand("selectcolour",this.changeSelectColour);
         _loc1_.addCommand("selectcolor",this.changeSelectColour);
         _loc1_.addCommand("compress",this.compress);
         _loc1_.addCommand("playertype",this.playertype);
         _loc1_.addCommand("howmanyitems",this.howmanyitems);
         _loc1_.addCommand("bmd",this.createbmd);
         _loc1_.addCommand("environment",this.changeEnvironment);
         _loc1_.addCommand("yarr",this.spawnPirate);
         _loc1_.addCommand("library",this.forceUpdateLibrary);
         _loc1_.addCommand("close",this.toggleConsole);
         _loc1_.addCommand("pause",TimeLord.pause);
         _loc1_.addCommand("unpause",TimeLord.unpause);
         _loc1_.addCommand("spawn",GameState.objects.spawnConsoleObject);
         _loc1_.addCommand("reset",this.reset);
         _loc1_.addCommand("clear",this.clear);
         _loc1_.addCommand("fullscreen",this.ConsoleFullscreen);
         _loc1_.addCommand("toggleMenus",this.toggleAllMenus);
         _loc1_.addCommand("togglemenus",this.toggleAllMenus);
         _loc1_.addCommand("credits",GameState.ui.openCredits);
         _loc1_.addCommand("parsexml",this.ParseItemsXML);
         if(true == false)
         {
            _loc1_.addCommand("debug_api",this.viewAPI);
            _loc1_.addCommand("debug_capability",this.viewCapability);
            _loc1_.addCommand("username",Kongregate.username);
            _loc1_.addCommand("userid",Kongregate.userid);
            _loc1_.addCommand("getsave",Kongregate.getSave);
         }
         _loc1_.addCommand("workshoplogs",GameState.steamworks.ShowWorkShopLogs);
         _loc1_.addCommand("workshoptest",GameState.steamworks.Test);
         _loc1_.addCommand("resetmenus",GameState.ui.resetDocks);
         _loc1_.addCommand("resetfavs",this.resetFavs);
         _loc1_.addCommand("resetsettings",this.resetSettings);
         _loc1_.addCommand("resetcustoms",this.resetCustoms);
         _loc1_.addCommand("resetpowers",this.resetPowersList);
         _loc1_.addCommand("localItem",this.localItem);
         _loc1_.addCommand("localSave",this.localSave);
         _loc1_.addCommand("localLoad",this.localLoad);
         _loc1_.addCommand("updateLibrary",this.updateLibrary);
         _loc1_.addCommand("whatis",GameState.ui.itemtoname);
         _loc1_.addCommand("id",GameState.ui.itemtoname);
         _loc1_.addCommand("xml",GameState.ui.itemtoxml);
         _loc1_.addCommand("customs",this.dild);
         _loc1_.addCommand("spawnCustom",this.spawnCustomObject);
         _loc1_.addCommand("spawnBatch",this.spawnBatch);
         _loc1_.addCommand("contracts",this.ToggleContracts);
         _loc1_.addCommand("itemsbackup",this.loadCustomItemsBackup);
         _loc1_.addCommand("fps",this.togglefps);
         _loc1_.addCommand("integerScaling",this.ConsoleIntegerScaling);
         _loc1_.addCommand("integerscaling",this.ConsoleIntegerScaling);
         _loc1_.addCommand("intscale",this.ConsoleIntegerScaling);
         _loc1_.addCommand("intsnap",this.ConsoleIntegerScaling);
         _loc1_.addCommand("snap",this.ConsoleIntegerScaling);
         _loc1_.addCommand("disablepause",this.DisablePausing);
         _loc1_.addCommand("PleaseStopMeFromPressingAllTheseButtonsThankYou",this.DisablePausing);
      }
      
      public function ReInitLibraryItems() : void
      {
         R.library_objects = null;
         R.library_names = null;
         this.initLibraryItems();
      }
      
      private function initLibraryItems() : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:XMLList = null;
         var _loc6_:int = 0;
         var _loc7_:XML = null;
         var _loc8_:Object = null;
         if(R.library_objects)
         {
            return;
         }
         var _loc1_:Array = [];
         var _loc2_:Array = [];
         var _loc5_:int = 0;
         while(_loc5_ < 2)
         {
            if(_loc5_ == 0)
            {
               _loc3_ = XMLList(R.xml_objects.node.node);
               _loc4_ = XMLList(R.xml_objects.node.node.@object);
            }
            else
            {
               _loc3_ = XMLList(R.xml_objects.node.node.node);
               _loc4_ = XMLList(R.xml_objects.node.node.node.@object);
            }
            _loc6_ = 0;
            for each(_loc7_ in _loc3_)
            {
               if(_loc7_.@object != null && _loc7_.@object != undefined && _loc7_.@object != "" && _loc7_.@object != "undefined")
               {
                  _loc8_ = new Object();
                  if(_loc7_.@label)
                  {
                     _loc8_.label = _loc7_.@label;
                  }
                  if(_loc7_.@object)
                  {
                     _loc8_.object = _loc7_.@object;
                  }
                  if(_loc7_.@lab)
                  {
                     _loc8_.lab = _loc7_.@lab;
                  }
                  if(_loc7_.@tooltip)
                  {
                     _loc8_.tooltip = _loc7_.@tooltip;
                  }
                  _loc2_.push(String(_loc4_[_loc6_]));
                  _loc1_.push(_loc8_);
                  _loc6_++;
               }
            }
            _loc5_++;
         }
         R.library_objects = _loc1_;
         R.library_names = _loc2_;
      }
      
      public function selectRandomItem() : void
      {
         var _loc1_:Array = GameState.objects.libraryItems;
         var _loc2_:String = _loc1_[int(Math.random() * _loc1_.length)];
         this.librarySelect(_loc2_,true);
      }
      
      public function selectPrevItem(param1:Event = null) : void
      {
         if(GameState.ui.menuSpawn.title != "Spawn")
         {
            return;
         }
         this.librarySelect(R.library_objects[this.getPrevItem()].label,true);
      }
      
      public function getPrevItem(param1:int = 0) : int
      {
         if(!GameState.objects.spawnName)
         {
            return -1;
         }
         var _loc2_:int = R.library_names.indexOf(GameState.objects.spawnName) + 1 + param1;
         if(_loc2_ >= R.library_names.length)
         {
            _loc2_ = 0;
         }
         return _loc2_;
      }
      
      public function getNextItem(param1:int = 0) : int
      {
         if(!GameState.objects.spawnName)
         {
            return -1;
         }
         var _loc2_:int = R.library_names.indexOf(GameState.objects.spawnName) - 1 - param1;
         if(_loc2_ < 0)
         {
            _loc2_ = R.library_names.length - 1;
         }
         return _loc2_;
      }
      
      public function selectNextItem(param1:Event = null) : void
      {
         if(GameState.ui.menuSpawn.title != "Spawn")
         {
            return;
         }
         this.librarySelect(R.library_objects[this.getNextItem()].label,true);
      }
      
      public function librarySelect(param1:String, param2:Boolean = false) : *
      {
         var _loc3_:Tree = GameState.ui.menuLibrary.getTree("buttons");
         _loc3_.closeAllNodes();
         var _loc4_:TNode = _loc3_.findNode("label",param1);
         var _loc5_:int = _loc3_.showNode(_loc4_);
         if(_loc5_ != -1)
         {
            _loc3_.selectedIndex = _loc5_;
            _loc3_.scrollToSelected();
            if(param2)
            {
               GameState.ui.selectItem(_loc3_.selectedItem);
            }
         }
         if(GameState.ui.menuObject.visible && GameState.ui.menuObject.title == "Detail Skin")
         {
            this.itemSkin();
            GameState.ui.dockItemMenu();
         }
         if(GameState.ui.menuObject.visible && GameState.ui.menuObject.title == "Skin")
         {
            this.updateSkin();
            GameState.ui.menuObject.maximiseHeight = 392 + 36;
            GameState.ui.menuObject.maximise();
         }
      }
      
      public function jointTreeClick(param1:ListEvent) : void
      {
         var _loc3_:XML = null;
         var _loc4_:XML = null;
         var _loc5_:int = 0;
         if(!param1)
         {
            return;
         }
         if(param1.item is LeafNode)
         {
            if(param1.item.toggleValue)
            {
               if(param1.item.toggleValue == "0")
               {
                  param1.item.toggleValue = "1";
               }
               else
               {
                  param1.item.toggleValue = "0";
               }
               param1.item.forceDrawNode();
               if(param1.item.func)
               {
                  if(param1.item.func == "collide")
                  {
                     Tweak.jointCollide = param1.item.toggleValue == "1";
                  }
                  else if(param1.item.func == "visible")
                  {
                     Tweak.jointVisible = param1.item.toggleValue == "1";
                     GameState.ui.updateJointProperties(Tool.currentJoint);
                  }
                  else if(param1.item.func == "center")
                  {
                     Tweak.jointCenter = param1.item.toggleValue == "1";
                     GameState.ui.updateJointProperties(Tool.currentJoint);
                  }
                  else if(param1.item.func == "motor")
                  {
                     Tweak.jointMotor = param1.item.toggleValue == "1";
                     if(!Tweak.jointMotor)
                     {
                        Tweak.jointMotorSpeed = 0;
                        Tweak.jointMotorForce = 0;
                     }
                     GameState.ui.updateJointProperties(Tool.currentJoint);
                  }
                  else if(param1.item.func == "limited")
                  {
                     Tweak.jointLimited = param1.item.toggleValue == "1";
                     if(!Tweak.jointLimited)
                     {
                        Tweak.jointLower = -9000;
                        Tweak.jointUpper = 9000;
                     }
                     GameState.ui.updateJointProperties(Tool.currentJoint);
                  }
                  else if(param1.item.func == "limitedLower")
                  {
                     Tweak.jointLimitedLower = param1.item.toggleValue == "1";
                     if(!Tweak.jointLimitedLower)
                     {
                        Tweak.jointLower = -9000;
                     }
                     GameState.ui.updateJointProperties(Tool.currentJoint);
                  }
                  else if(param1.item.func == "limitedUpper")
                  {
                     Tweak.jointLimitedUpper = param1.item.toggleValue == "1";
                     if(!Tweak.jointLimitedUpper)
                     {
                        Tweak.jointUpper = 9000;
                     }
                     GameState.ui.updateJointProperties(Tool.currentJoint);
                  }
                  return;
               }
            }
         }
         if(!param1.item.func)
         {
            return;
         }
         if(param1.item.func == "togglejoints")
         {
            GameState.ui.menuTools.removeAllChildren();
            _loc3_ = R.xml_joints.copy();
            for each(_loc4_ in _loc3_.node)
            {
               _loc5_ = Keymap.nameToCode(_loc4_.@key);
               if(_loc5_ != 0)
               {
                  _loc4_.@label = _loc4_.@label + " [" + Keymap.codeToKeyname(_loc5_) + "]";
               }
            }
            GameState.ui.menuTools.addTree("buttons",_loc3_).selectable = false;
            GameState.ui.menuTools.getTree("buttons").addEventListener(ListEvent.ITEM_CLICK,this.jointTreeClick);
            GameState.ui.menuTools.getTree("buttons").height = 32;
            GameState.ui.menuTools.title = "Joints";
            GameState.ui.menuTools.maximiseHeight = 28 + 8 * 32;
            GameState.ui.menuTools.minWidth = 42;
            GameState.ui.menuTools.maximise();
            return;
         }
         var _loc2_:String = param1.item.joint;
         if(_loc2_ == "revolute")
         {
            this.skinOriginal = "CCFFFF";
         }
         else if(_loc2_ == "bgjoint")
         {
            this.skinOriginal = "FFFFFF";
         }
         else if(_loc2_ == "ropejoint")
         {
            this.skinOriginal = "663300";
         }
         else if(_loc2_ == "objjoint")
         {
            this.skinOriginal = "FFFFCC";
         }
         else if(_loc2_ == "weldjoint")
         {
            this.skinOriginal = "808080";
         }
         else if(_loc2_ == "revolute")
         {
            this.skinOriginal = "CCFFFF";
         }
         else if(_loc2_ == "pistonjoint")
         {
            this.skinOriginal = "333338";
         }
         if(param1.item.func == "colour")
         {
            this.colouring = "joint";
            this.updateColour(this.skinOriginal,true,true,false);
            if(!GameState.ui.menuColour.visible)
            {
               GameState.ui.menuColour.open();
               GameState.ui.menuColour.x = GameState.ui.menuTools.x - GameState.ui.menuColour.actualWidth - Window.BUFFER * 2;
               GameState.ui.menuColour.y = GameState.ui.menuTools.y;
            }
            return;
         }
         if(!param1.item.toggleValue)
         {
            Tool.setTool(param1.item.func);
            this.toolSprite.graphics.clear();
            GameState.ui.updateControls();
         }
         if(param1.item.joint)
         {
            GameState.ui.updateJointProperties(param1.item.joint);
         }
      }
      
      private function challengeTreeClick(param1:ListEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         if(param1.item.toggleValue)
         {
            if(param1.item.toggleValue == "0")
            {
               param1.item.toggleValue = "1";
            }
            else
            {
               param1.item.toggleValue = "0";
            }
            param1.item.forceDrawNode();
            _loc2_ = param1.item.func;
            _loc3_ = param1.item.toggleValue == "1";
            if(_loc2_)
            {
               if(_loc2_ == "allowSpawn")
               {
                  this.contract.areaSpawn = _loc3_;
               }
               else if(_loc2_ == "allowDrag")
               {
                  this.contract.areaDrag = _loc3_;
               }
               else if(_loc2_ == "allowTrigger")
               {
                  this.contract.areaTrigger = _loc3_;
               }
               else if(_loc2_ == "allowCut")
               {
                  this.contract.areaCut = _loc3_;
               }
               else if(_loc2_ == "allowDelete")
               {
                  this.contract.areaDestroy = _loc3_;
               }
               else if(_loc2_ == "allowOther")
               {
                  this.contract.areaOther = _loc3_;
               }
               else if(_loc2_ == "allowPower")
               {
                  this.contract.areaPower = _loc3_;
               }
            }
         }
         else if(param1.item.func)
         {
            _loc2_ = param1.item.func;
            if(_loc2_ == "back")
            {
               this.updateChallengeMenu();
               this.contractArea = false;
               Tool.reset();
               GameState.ui.updateControls();
            }
            if(_loc2_ == "additemsback")
            {
               this.updateChallengeMenu();
               if(GameState.ui.menuSpawn.visible)
               {
                  GameState.ui.menuSpawn.toggle();
                  if(!GameState.ui.menuChallenge.undocked)
                  {
                     GameState.ui.menuChallenge.x = GameState.ui.menuMain.x + GameState.ui.menuMain.actualWidth + 4;
                  }
               }
            }
            else if(_loc2_ == "areas")
            {
               this.updateChallengeMenu("area");
               Tool.select();
               GameState.ui.updateControls();
               this.contractArea = true;
            }
            else if(_loc2_ == "removeArea")
            {
               Tool.destroy();
               GameState.ui.updateControls();
               this.contractArea = true;
            }
            else if(_loc2_ == "removeTarget")
            {
               Tool.destroy();
               GameState.ui.updateControls();
               this.contractTarget = true;
            }
            else if(_loc2_ == "contractitems")
            {
               this.updateChallengeMenu("items");
            }
            else if(_loc2_ == "targets")
            {
               this.updateChallengeMenu("target");
            }
            else if(_loc2_ == "contract")
            {
               this.updateChallengeMenu("contract");
            }
            else if(_loc2_ == "preview")
            {
               this.contract.enabled = !this.contract.enabled;
               this.updateChallengeMenu("contract");
            }
            else if(_loc2_ == "complete")
            {
               this.contract.previewing = true;
               this.contract.enabled = true;
               GameState.ui.closeAllMenus();
               IO.saveWorld();
               this.updateChallengeMenu("previewing");
            }
            else if(_loc2_ == "backToEdit")
            {
               GameState.ui.menuMain.open();
               this.contract.enabled = false;
               this.contract.previewing = false;
               this.updateChallengeMenu();
            }
            else if(_loc2_ == "finallyShare")
            {
               Kongregate.shareContentType = "Contract";
               GameState.ui.genericToolTip.alpha = 0;
               this.saveContent();
               this.updateChallengeMenu();
            }
            else if(_loc2_ == "restart")
            {
               IO.loadWorld();
            }
            else if(_loc2_ == "end")
            {
               if(this.contract.enabled)
               {
                  this.reset();
               }
               else
               {
                  this.contract.Reset();
               }
            }
            else if(_loc2_ == "reset")
            {
               this.contract.Reset();
               this.updateChallengeMenu();
            }
         }
         else if(param1.item.contract)
         {
            _loc4_ = param1.item.contract;
            if(_loc4_ == "mutilate")
            {
               this.contract.target = 1;
            }
            else if(_loc4_ == "incapacitate")
            {
               this.contract.target = 2;
            }
            else if(_loc4_ == "protect")
            {
               this.contract.target = 3;
            }
            else if(_loc4_ == "relocate")
            {
               this.contract.target = 4;
            }
            else if(_loc4_ == "trigger")
            {
               this.contract.target = 5;
            }
            else if(_loc4_ == "heal")
            {
               this.contract.target = 6;
            }
            else if(_loc4_ == "burn")
            {
               this.contract.target = 7;
            }
            Tool.aim();
            GameState.ui.updateControls();
         }
      }
      
      public function effectTreeClick(param1:ListEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TNode = null;
         var _loc7_:TNode = null;
         if(param1.item is LeafNode)
         {
            if(param1.item.toggleValue)
            {
               if(param1.item.toggleValue == "0")
               {
                  param1.item.toggleValue = "1";
               }
               else
               {
                  param1.item.toggleValue = "0";
               }
               param1.item.forceDrawNode();
               if(Boolean(param1.item.func) && param1.item.func == "center")
               {
                  this.previewEffect.applyOffset = param1.item.toggleValue == "0";
               }
               if(Boolean(param1.item.func) && param1.item.func == "scale")
               {
                  this.previewEffect.applyScale = param1.item.toggleValue == "1";
               }
            }
            else if(param1.item.func)
            {
               if(param1.item.func == "randomfx")
               {
                  _loc2_ = int(GameState.ui.menuEffects.getTree("behaviours").length);
                  _loc3_ = int(GameState.ui.menuEffects.getTree("elements").length);
                  _loc4_ = Math.random() * _loc2_ >> 0;
                  _loc5_ = Math.random() * _loc3_ >> 0;
                  _loc6_ = GameState.ui.menuEffects.getTree("behaviours").getNode(_loc4_);
                  _loc7_ = GameState.ui.menuEffects.getTree("elements").getNode(_loc5_);
                  GameState.ui.menuEffects.getTree("behaviours").selectedIndex = _loc4_;
                  GameState.ui.menuEffects.getTree("behaviours").scrollToSelected();
                  GameState.ui.menuEffects.getTree("elements").selectedIndex = _loc5_;
                  GameState.ui.menuEffects.getTree("elements").scrollToSelected();
                  this.selectEffect(_loc7_);
                  this.selectEffectType(_loc6_);
               }
               else if(param1.item.func == "attachfx")
               {
                  this.dragEffect();
               }
               else if(param1.item.func == "donefx")
               {
                  GameState.ui.menuEffects.close();
               }
               else if(param1.item.func == "reattachfx")
               {
                  this.previewEffectBody = this.detailBody;
                  this.previewEffect.body = this.detailBody;
                  this.dragEffect();
               }
               else if(param1.item.func == "centerfx")
               {
                  this.previewEffect.applyOffset = false;
                  this.AttachEffect(this.previewEffectBody,this.previewEffectBody.GetWorldCenter());
               }
               else if(param1.item.func == "removefx")
               {
                  this.previewEffect.applyOffset = false;
                  this.AttachEffect(this.previewEffectBody,this.previewEffectBody.GetWorldCenter());
                  GameState.ui.menuEffects.close();
               }
               else if(param1.item.func == "toggleparticles")
               {
                  GameState.ui.effectParticlesList();
               }
               else if(param1.item.func == "toggleeffects")
               {
                  GameState.ui.effectEffectsList();
               }
            }
            if(param1.item.element)
            {
               this.selectEffect(param1.item);
            }
            else if(param1.item.behaviour)
            {
               this.selectEffectType(param1.item);
            }
         }
      }
      
      public function toolTreeDoubleClick(param1:ListEvent) : void
      {
         this.toolTreeClick(param1,true);
      }
      
      public function toolTreeClick(param1:ListEvent, param2:Boolean = false) : void
      {
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         if(param1.item is LeafNode)
         {
            if(param1.item.toggleValue)
            {
               if(param1.item.toggleValue == "0")
               {
                  param1.item.toggleValue = "1";
               }
               else
               {
                  param1.item.toggleValue = "0";
               }
               param1.item.forceDrawNode();
               _loc3_ = param1.item.power;
               _loc4_ = param1.item.toggleValue == "1";
               if(_loc4_)
               {
                  Powers.favPowers.push(_loc3_);
               }
               else
               {
                  Powers.favPowers.splice(Powers.favPowers.indexOf(_loc3_),1);
               }
            }
            else if(param1.item.func)
            {
               if(param1.item.func == "resetpowers")
               {
                  Tweak.toolRadius = 40;
                  Tweak.toolSpeed = 4;
                  Tweak.toolSpread = 10;
                  Tweak.toolProjectiles = 4;
                  Tweak.toolEffectForce = 50;
                  GameState.ui.menuTools.setValue("Press Radius",Tweak.toolRadius);
                  GameState.ui.menuTools.setValue("Throw Radius",Tweak.toolThrowRadius);
                  GameState.ui.menuTools.setValue("Throw Speed",Tweak.toolSpeed);
                  GameState.ui.menuTools.setValue("Throw Spread",Tweak.toolSpread);
                  GameState.ui.menuTools.setValue("Throw Projectiles",Tweak.toolProjectiles);
                  GameState.ui.menuTools.setValue("Effect Duration",Tweak.toolDuration);
                  GameState.ui.menuTools.setValue("Effect Force",Tweak.toolEffectForce);
                  Powers.settingsNeedSaving = true;
               }
               else if(param1.item.func == "modpowers")
               {
                  Powers.updatePowers();
                  GameState.ui.showTooltip(GameState.ui.menuTools,"Click to toggle visibility. Click+Drag to reorder the list.\n\n",100,5000,GameState.ui.menuTools.actualWidth);
                  Powers.settingsNeedSaving = true;
               }
               else if(param1.item.func == "powback")
               {
                  Powers.updatePowersList();
                  Settings.savePowers();
               }
               else if(param1.item.func == "rp")
               {
                  GameState.roleplaying = true;
                  Tool.drag();
                  GameState.ui.updateControls();
                  this.toolSprite.graphics.clear();
                  GameState.ui.menuTools.close();
               }
               else
               {
                  GameState.roleplaying = false;
                  Powers.scrollPos = GameState.ui.menuTools.getTree("buttons").verticalScrollPosition;
                  Tool.setTool(param1.item.func);
                  if(Tool.isPower && !param2)
                  {
                     Powers.updatePowerProperties();
                  }
                  else
                  {
                     GameState.ui.menuTools.close();
                  }
                  this.toolSprite.graphics.clear();
                  GameState.ui.updateControls();
               }
            }
         }
      }
      
      private function massSave() : *
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:Tree = null;
         var _loc5_:TNode = null;
         var _loc6_:int = 0;
         this.dulin = null;
         GameState.spawningCustom = true;
         var _loc1_:String = this.currentSave;
         this.customPos = this.detailBody.GetPosition();
         if(IO.saveWorld())
         {
            this.dulin = this.currentSave;
         }
         GameState.spawningCustom = false;
         if(_loc1_ != "")
         {
            this.currentSave = _loc1_;
         }
         if(this.dulin)
         {
            _loc2_ = this.customNames.indexOf(this.customName);
            if(_loc2_ == -1)
            {
               _loc3_ = Base64.compress(this.dulin);
               this.customNames.push(this.customName);
               this.customItems.push(_loc3_);
            }
            else
            {
               _loc3_ = Base64.compress(this.dulin);
               this.customNames[_loc2_] = this.customName;
               this.customItems[_loc2_] = _loc3_;
            }
            Settings.backupCustomItem(_loc3_,this.customName);
            Settings.saveCustomItems();
            GameState.ui.menuDetails.close();
            this.updateLibrary();
            _loc4_ = GameState.ui.menuLibrary.getTree("buttons");
            _loc5_ = _loc4_.findNode("label",this.customName);
            _loc6_ = _loc4_.showNode(_loc5_);
            if(_loc6_ != -1)
            {
               _loc4_.selectedIndex = _loc6_;
               _loc4_.scrollToSelected();
               GameState.ui.selectItem(_loc4_.selectedItem);
            }
            if(!GameState.ui.menuLibrary.visible)
            {
               GameState.ui.menuLibrary.open();
            }
            GameState.ui.showTooltip(GameState.ui.menuLibrary,"Custom item saved!\n\nRemember to make backups! See FAQ.\n",0,2000,GameState.ui.menuLibrary.actualWidth);
            Settings.backupCustomItemJSON(_loc3_,this.customName);
         }
      }
      
      private function showDetails(param1:b2Body, param2:* = "main") : *
      {
         var bl:Number;
         var br:Number;
         var bt:Number;
         var ud:userData = null;
         var iname:String = null;
         var xml_actions:XML = null;
         var menuheight:* = undefined;
         var dtree:Tree = null;
         var bpx:Number = NaN;
         var alive:Boolean = false;
         var sbody:b2Body = null;
         var gun:Boolean = false;
         var joints:Boolean = false;
         var tkey:String = null;
         var hkey:String = null;
         var vol:Number = NaN;
         var slid:HUISlider = null;
         var i:int = 0;
         var sbod:b2Body = null;
         var sbud:userData = null;
         var sname:String = null;
         var totalJoints:* = undefined;
         var s:int = 0;
         var n:int = 0;
         var numJoints:int = 0;
         var jl:b2JointEdge = null;
         var jud:jointUserData = null;
         var jointproperties:String = null;
         var body1:String = null;
         var body2:String = null;
         var otherbody:String = null;
         var colour:String = null;
         var jointbodies:String = null;
         var jointName:String = null;
         var limited:Boolean = false;
         var jointParent:* = undefined;
         var jointParentName:String = null;
         var jointIcon:String = null;
         var group:int = 0;
         var body:b2Body = param1;
         var submenu:* = param2;
         if(this.contract.enabled)
         {
            return;
         }
         if(this.selectedBodies.length == 0)
         {
            this.selectedBodies = new Vector.<b2Body>();
            this.selectedBodies.push(body);
         }
         else if(!body)
         {
            body = this.selectedBodies[0];
         }
         ud = userData(body.GetUserData());
         if(ud.hidden)
         {
            return;
         }
         if(ud.hasBeenCut)
         {
            return;
         }
         if(ud.dead)
         {
            return;
         }
         this.detailBody = body;
         this.previousBody = body;
         this.previewEffectBody = body;
         if(this.selectedBodies.length < 2)
         {
            this.selectedBodies = new Vector.<b2Body>();
            this.selectedBodies.push(body);
         }
         if(!GameState.ui.menuDetails.undocked)
         {
            bpx = GraphicUtils.camX(body.GetPosition().x * Physics.scale);
            if(bpx < GameState.width * 0.5)
            {
               GameState.ui.menuDetails.x = bpx + 50;
            }
            else
            {
               GameState.ui.menuDetails.x = bpx - 50 - GameState.ui.menuDetails.actualWidth;
            }
            GameState.ui.menuDetails.y = GraphicUtils.camY(body.GetPosition().y * Physics.scale);
            if(GameState.ui.menuDetails.x > 600)
            {
               GameState.ui.menuDetails.x = 600;
            }
            if(GameState.ui.menuDetails.x < 50)
            {
               GameState.ui.menuDetails.x = 50;
            }
            if(GameState.ui.menuDetails.y > 300)
            {
               GameState.ui.menuDetails.y = 300;
            }
         }
         if(GameState.ui.menuObject.visible && GameState.ui.menuObject.title == "Detail Skin")
         {
            this.ModifyDetailSkin();
            GameState.ui.dockItemMenuDetail();
         }
         this.detailSubmenu = submenu;
         if(!GameState.ui.menuDetails.visible)
         {
            GameState.ui.menuDetails.open();
         }
         GameState.ui.menuDetails.removeAllChildren();
         iname = "Item";
         if(this.selectedBodies.length > 1)
         {
            iname = this.selectedBodies.length.toString() + " Items";
         }
         else
         {
            iname = GeneralUtils.objectToName(ud.name);
         }
         if(!iname || iname == "")
         {
            iname = ud.name;
            if(!O.getItem(iname))
            {
               if(ud.projectile)
               {
                  iname = "Temp Bullet";
               }
               else if(ud.hasBeenCut || ud.dead)
               {
                  iname = "Trash";
               }
               else
               {
                  iname = "Temp Item";
               }
            }
            if(!ud.saveable || ud.projectile)
            {
               iname += " !save";
            }
         }
         GameState.ui.menuDetails.title = iname;
         GameState.ui.menuDetails.allowInputDrag = false;
         xml_actions = <node label="Root Node"></node>;
         bl = GameState.environment.borderLeft;
         br = GameState.environment.borderRight;
         bt = GameState.environment.borderTop;
         menuheight = 240;
         if(submenu == "selection")
         {
            menuheight = Math.min(240,(3 + this.selectedBodies.length) * 24);
         }
         else if(submenu == "collision")
         {
            menuheight = 168;
         }
         if(submenu == "main")
         {
            xml_actions.appendChild(<node label="Functionality" func="functionality" ico="iconiteminfomed" tooltip="Additional functionality.&#10;&#10;"/>);
            xml_actions.appendChild(<node label="Properties" func="properties" ico="iconproperties" tooltip="Toggle properties.&#10;&#10;"/>);
            xml_actions.appendChild(<node label="Settings" func="settings" ico="iconsettingsmed" tooltip="Modify run-time settings.&#10;Spawn settings can only be modified before spawning.&#10;&#10;"/>);
            xml_actions.appendChild(<node label="Graphics" func="detailgraphics" ico="icongraphicsmed" tooltip="Modify the item's graphics.&#10;&#10;"/>);
            xml_actions.appendChild(<node label="Physics" func="detailcollision" ico="iconclone" tooltip="Modify the item's physics and collisions.&#10;&#10;"/>);
            alive = false;
            for each(sbody in this.selectedBodies)
            {
               if(userData(sbody.GetUserData()).alive)
               {
                  alive = true;
                  break;
               }
            }
            if(alive)
            {
               xml_actions.appendChild(<node label="Fleshcraft" func="alivesettings" ico="icondollsmall" tooltip="Modify alive settings.&#10;"/>);
               menuheight += 26;
            }
            gun = false;
            for each(sbody in this.selectedBodies)
            {
               if(Boolean(userData(sbody.GetUserData()).trigger) && userData(sbody.GetUserData()).trigger is Gun)
               {
                  gun = true;
                  break;
               }
            }
            if(gun)
            {
               xml_actions.appendChild(<node label="Gunsmith" func="gunsettings" ico="icongunsmith" tooltip="Modify gun settings.&#10;"/>);
               xml_actions.appendChild(<node label="Bullet Jacket" func="bulletsettings" ico="iconbullet" tooltip="Properties applied to physics bullets (Requires a bullet with a collider.)&#10;&#10;"/>);
               xml_actions.appendChild(<node label="Muzzle Sound" func="detailsound" ico="iconmuzzle" tooltip="Modify shooting sound and volume.&#10;&#10;"/>);
            }
            joints = false;
            for each(sbody in this.selectedBodies)
            {
               if(Joints.NumJoints(sbody) > 0)
               {
                  joints = true;
                  break;
               }
            }
            if(joints)
            {
               xml_actions.appendChild(<node label="Joints" func="joints" ico="iconjointmed" tooltip="List joints.&#10;&#10;"/>);
            }
            if(this.selectedBodies.length < 2)
            {
               if(this.selectedSelection.length > 0)
               {
                  xml_actions.appendChild(<node label="Back to Selection" func="selectionback" ico="tool_select" tooltip="List selected items.&#10;&#10;"/>);
               }
               if(Boolean(ud.trigger) && !gun)
               {
                  xml_actions.appendChild(<node label="Sound" func="detailsound" ico="iconvolume" tooltip="Replace any sound the item directly generates.&#10;&#10;"/>);
               }
            }
            else
            {
               xml_actions.appendChild(<node label="Selection" func="selection" ico="tool_select" tooltip="List selected items.&#10;&#10;"/>);
            }
         }
         if(submenu == "graphics")
         {
            xml_actions.appendChild(<node label="Back" func="functionalityBack"/>);
            if(ud.layer == 2)
            {
               xml_actions.appendChild(<node label="Layer: Front" func="changeLayer" ico="iconlayertop" tooltip="Item is currently on the foreground layer, in front of all items on Normal and Back layers. Items within layers are displayed in order of spawning.&#10;&#10;&#10;&#10;&#10;"/>);
            }
            else if(ud.layer == 0)
            {
               xml_actions.appendChild(<node label="Layer: Back" func="changeLayer" ico="iconlayerbtm" tooltip="Item is currently on the background layer, behind all items on Normal and Foreground layers. Items within layers are displayed in order of spawning.&#10;&#10;&#10;&#10;&#10;"/>);
            }
            else
            {
               xml_actions.appendChild(<node label="Layer: Normal" func="changeLayer" ico="iconlayermid" tooltip="Item is currently on the default layer. Items within layers are displayed in order of spawning.&#10;&#10;&#10;&#10;&#10;"/>);
            }
            xml_actions.appendChild(<node label="Skin" func="detailskin" ico="iconskin" tooltip="Modify colours of the item.&#10;&#10;"/>);
            if(!ud.stainless)
            {
               xml_actions.appendChild(<node label="Stamp" func="detailstamp" ico="icongraphicsmed" tooltip="Stamp other item graphics onto the visual effects layer of this item.&#10;&#10;"/>);
            }
            xml_actions.appendChild(<node label="Effects" func="effects" ico="iconstar" tooltip="Add a particle effect to the item.&#10;&#10;"/>);
         }
         if(submenu == "func")
         {
            xml_actions.appendChild(<node label="Back" func="functionalityBack"/>);
            xml_actions.appendChild(<node label="Custom Item" func="beginmasssave" ico="iconmadlabmed" tooltip="Creates a custom item from the selection. Includes joints, settings, properties, and everything else that is saveable normally.&#10;&#10;&#10;&#10;"/>);
            if(Boolean(ud.trigger) && !ud.triggerLock)
            {
               if(ud.triggered)
               {
                  xml_actions.appendChild(<node label="Untrigger" func="untrigger" ico="iconuntrigger" tooltip="Untrigger the item, deactivating its functionality.&#10;&#10;"/>);
               }
               else
               {
                  xml_actions.appendChild(<node label="Trigger" func="trigger" ico="icontrigger" tooltip="Trigger the item, activating its functionality.&#10;&#10;"/>);
               }
            }
            if(!ud.hasBeenCut)
            {
               xml_actions.appendChild(<node label="Flip" func="flip" ico={ud.flipped ? "iconflipleft" : "iconflipright"} tooltip="Respawns the item flipped. Spawn settings will reapply.&#10;&#10;"/>);
            }
            if(this.selectedBodies.length > 1)
            {
               xml_actions.appendChild(<node label="Align X" func="alignx" ico="iconalignx" tooltip="Aligns item centers with the X position of the selected item.&#10;&#10;"/>);
               xml_actions.appendChild(<node label="Align Y" func="aligny" ico="iconaligny" tooltip="Aligns item centers with the Y position of the selected item.&#10;&#10;"/>);
            }
            if(this.selectedBodies.length > 1)
            {
               if(this.loadedLevel == "")
               {
                  xml_actions.appendChild(<node label="Clone" func="massclone" ico="iconclone" tooltip="Clones the selected items with settings, properties, and joints. Spawn settings will reset.&#10;&#10;"/>);
               }
            }
            else
            {
               xml_actions.appendChild(<node label="Clone" func="massclone" ico="iconclone" tooltip="Clones the object with all properties. Spawn settings will reset.&#10;&#10;"/>);
               if(this.detailBody == GameState.followBody)
               {
                  xml_actions.appendChild(<node label="Stop Following" func="cameraunfollow" ico="iconfollow" tooltip="Stop following with camera.&#10;"/>);
               }
               else
               {
                  xml_actions.appendChild(<node label="Camera Follow" func="camerafollow" ico="iconfollow" tooltip="Follow with camera.&#10;"/>);
               }
            }
            if(ud.connected.length > 0)
            {
               xml_actions.appendChild(<node label="Remove Links" func="removelinks" ico="iconlinkmed" tooltip="Remove all links."/>);
            }
            tkey = "None";
            hkey = "None";
            if(ud.triggerKey != -1)
            {
               tkey = Keymap.codeToKeyname(ud.triggerKey);
               menuheight += 26;
            }
            if(ud.triggerKeyHold != -1)
            {
               hkey = Keymap.codeToKeyname(ud.triggerKeyHold);
               menuheight += 26;
            }
            xml_actions.appendChild(<node label={"Key Toggle: " + tkey} func="triggerkey" ico="iconkeytap" tooltip="Set a key that toggles the item's trigger.&#10;Overrides all other functionality of that key while the item exists.&#10;&#10;"/>);
            xml_actions.appendChild(<node label={"Key Press: " + hkey} func="triggerkeyhold" ico="iconkeyhold" tooltip="Set a key that triggers the item while pressed.&#10;Overrides all other functionality of that key while the item exists.&#10;&#10;"/>);
         }
         if(submenu == "collision")
         {
            xml_actions.prependChild(<node label="Back" center="true" func="functionalityBack"/>);
            if(!ud.hasBeenCut)
            {
               xml_actions.appendChild(<node label={body.IsDynamic() ? "Freeze" : "Thaw"} ico="iconfreeze" func="freezethaw" tooltip={body.IsDynamic() ? "Respawns and freezes the item, disabling physics.\n" : "Respawns and unfreezes the item, enabling physics again.\n"}/>);
            }
            if(this.selectedBodies.length < 2)
            {
               menuheight += 26;
               menuheight += 26;
               xml_actions.appendChild(<node label="Move to Top" func="movefront" ico="iconup" tooltip="Respawns the item, moving it to the front. Spawn settings will reapply.&#10;&#10;&#10;&#10;"/>);
               xml_actions.appendChild(<node label="Move to Bottom" func="movebottom" ico="icondown" tooltip="Moves the item to the bottom of the current layer.&#10;&#10;&#10;&#10;"/>);
            }
            if(Boolean(this.jointBody) && Tool.isIgnore)
            {
               xml_actions.appendChild(<node label="Cancel Ignore" func="ignoreTool" ico="iconignoremed" tooltip="Cancel item ignore.&#10;"/>);
            }
            else
            {
               xml_actions.appendChild(<node label="Ignore Another" func="ignoreTool" ico="iconignoremed" tooltip="Ignore another item to make the two items not collide.&#10;"/>);
            }
            if(ud.ignored.length > 0)
            {
               xml_actions.appendChild(<node label="Remove Ignores" func="removeignores" ico="p_error" tooltip="Remove all ignores."/>);
               menuheight += 26;
            }
            xml_actions.appendChild(<node label="Collide:" func="spacer"/>);
            xml_actions.appendChild(<node label="Walls" func="collideWalls" toggleValue={ud.wallGhost ? "0" : "1"} ico="iconwall" tooltip="Collide with walls?&#10;"/>);
            xml_actions.appendChild(<node label="Items" func="collideItems" toggleValue={ud.ghost ? "0" : "1"} ico="iconclone" tooltip="Collide with other items?&#10;"/>);
            if(!ud.ghost)
            {
               xml_actions.appendChild(<node label="Projectiles" func="collideProjectiles" toggleValue={ud.projectileGhost ? "0" : "1"} ico="iconprojectile" tooltip="Collide with bullets and other weapon projectiles?&#10;&#10;"/>);
               xml_actions.appendChild(<node label="" func="spacer"/>);
            }
            if(GameState.ui.menuObject.visible && GameState.ui.menuObject.title == "Detail Alive")
            {
               GameState.ui.addStabSettings(true);
            }
         }
         if(submenu == "stamp")
         {
            if(!GameState.stamping)
            {
               this.showDetails(body,"graphics");
               return;
            }
            xml_actions.appendChild(<node label="Done" func="stopstamp" tooltip="Stop stamping and allow spawning items normally again.&#10;&#10;"/>);
            xml_actions.appendChild(<node label="Help" tooltip="Drag an item from the Spawn menu on top of any of the selected items to stamp them with the item's graphic. The stamp can be rotated and scaled with arrow keys while dragging it out of the menu.&#10;&#10;&#10;&#10;&#10;&#10;"/>);
            xml_actions.appendChild(<node label="Clean" func="clean" ico="p_bubble" tooltip="Clean the effects layer.&#10;"/>);
         }
         if(submenu == "sound")
         {
            vol = 50;
            if(ud.overrideVolume)
            {
               vol = ud.overrideVolume * 100;
            }
            slid = GameState.ui.menuDetails.addSlider("Volume %",vol,0,200,150);
            slid.addEventListener(Event.CHANGE,this.detailVolumeChanged);
            slid.addEventListener("finished",this.detailVolumePlay);
            xml_actions = R.xml_sfx.copy();
            xml_actions.prependChild(<node label="Default" center="true" sound="default"/>);
            xml_actions.prependChild(<node label="Back" center="true" func="functionalityBack"/>);
         }
         if(submenu == "selection")
         {
            xml_actions.appendChild(<node label="Back" func="functionalityBack"/>);
            if(GameState.focused)
            {
               xml_actions.appendChild(<node label="Unfocus" func="selectionUnFocus" ico="iconsearch" tooltip="Unfocus selected items, showing and unlocking the rest.&#10;&#10;"/>);
            }
            else
            {
               xml_actions.appendChild(<node label="Focus" func="selectionFocus" ico="iconsearch" tooltip="Focus selected items, hiding and locking the rest.&#10;&#10;"/>);
            }
            xml_actions.appendChild(<node label="Selection"/>);
            i = 0;
            while(i < this.selectedBodies.length)
            {
               sbod = this.selectedBodies[i];
               sbud = userData(sbod.GetUserData());
               sname = GeneralUtils.objectToName(sbud.name);
               xml_actions.node.(@label == "Selection").appendChild(<node label={sname} func="selectitem" id={i} center="true" tooltip="Select item.&#10;"/>);
               i++;
            }
         }
         if(submenu == "joints")
         {
            joints = false;
            for each(sbody in this.selectedBodies)
            {
               if(Joints.NumJoints(sbody) > 0)
               {
                  joints = true;
                  break;
               }
            }
            if(!joints)
            {
               this.showDetails(this.detailBody);
               return;
            }
            xml_actions.appendChild(<node label="Back" nodeid="9000" func="functionalityBack"/>);
            xml_actions.appendChild(<node label="Remove All" func="removejoints" nodeid="9000" tooltip="Remove all joints.&#10;"/>);
            xml_actions.appendChild(<node label="Hide All" func="hidejoints" nodeid="9000" tooltip="Turn all joints invisible.&#10;"/>);
            xml_actions.appendChild(<node label="" nodeid="9000" func="spacer"/>);
            totalJoints = 0;
            for each(sbody in this.selectedBodies)
            {
               totalJoints += Joints.NumJoints(sbody);
            }
            GameState.ui.menuDetails.title = totalJoints + " Joints";
            s = 0;
            i = 0;
            n = 0;
            for each(sbody in this.selectedBodies)
            {
               numJoints = Joints.NumJoints(sbody);
               jl = sbody.GetJointList();
               while(jl)
               {
                  jud = jointUserData(jl.joint.GetUserData());
                  if(!jud.dead)
                  {
                     jointproperties = "";
                     body1 = GeneralUtils.objectToName(jl.joint.GetBody1().GetUserData().name);
                     body2 = GeneralUtils.objectToName(jl.joint.GetBody2().GetUserData().name);
                     if(!body1)
                     {
                        body1 = "Background";
                     }
                     if(!body2)
                     {
                        body2 = "Background";
                     }
                     otherbody = body1;
                     if(jl.joint.GetBody1() == sbody)
                     {
                        otherbody = body2;
                     }
                     colour = "#" + GraphicUtils.hexToString(jud.lineColour);
                     if(colour == "#000000")
                     {
                        colour = "Default";
                     }
                     jointbodies = "> " + otherbody;
                     jointName = Joints.Name(jud.name);
                     jointproperties += "Type: " + jointName;
                     if(jud.lineVisible && jud.name != "rag")
                     {
                        jointproperties += "\nColour: " + colour;
                        jointproperties += "\nWidth: " + jud.lineWidth.toString();
                     }
                     if(jud.name != "ropejoint" && jud.name != "pistonjoint")
                     {
                        jointproperties += "\nBreak: " + jud.forceLimit.toString();
                     }
                     limited = false;
                     if(jl.joint is b2RevoluteJoint)
                     {
                        limited = b2RevoluteJoint(jl.joint).IsLimitEnabled();
                     }
                     if(jud.name == "ropejoint")
                     {
                        jointproperties += "\nDamping: " + int(b2DistanceJoint(jl.joint).m_dampingRatio * 100).toString();
                        jointproperties += "\nFrequency: " + int(b2DistanceJoint(jl.joint).m_frequencyHz * 100).toString();
                     }
                     if(limited)
                     {
                        jointproperties += "\nUpper Limit: " + jud.defaultLA.toString() + "°";
                        jointproperties += "\nLower Limit: " + jud.defaultUA.toString() + "°";
                     }
                     jointParent = xml_actions.node.(@label == jointName);
                     jointParentName = GeneralUtils.objectToName(sbody.GetUserData().name) + " (" + numJoints + ")";
                     if(xml_actions.node.(@nodeid == s)[0] == undefined)
                     {
                        n++;
                        xml_actions.appendChild(<node label={jointParentName} nodeid={s} ico="tinysquare" tooltip="Hover to view joint info.&#10;Click to remove joint."/>);
                     }
                     jointIcon = Joints.Icon(jointName);
                     xml_actions.node.(@nodeid == s).appendChild(<node label={jointbodies} func="removejoint" sid={s} id={i} ico={jointIcon} tooltip={jointproperties}/>);
                     i++;
                  }
                  jl = jl.next;
               }
               i = 0;
               s++;
            }
         }
         dtree = GameState.ui.menuDetails.addTree("buttons",xml_actions,menuheight,0,24);
         dtree.addEventListener(ListEvent.ITEM_CLICK,this.detailTreeClick);
         dtree.selectable = false;
         dtree.addEventListener(ListEvent.ITEM_ROLL_OVER,this.detailTreeHover);
         dtree.addEventListener(ListEvent.ITEM_ROLL_OUT,this.detailTreeExit);
         if(submenu != "sound")
         {
            dtree.openAllNodes();
         }
         if(submenu == "collision" && !ud.ghost)
         {
            group = ud.group;
            if(group >= 1000)
            {
               group -= 1000;
            }
            if(group <= -1000)
            {
               group += 1000;
            }
            GameState.ui.menuDetails.addInput("Item Group",group,null,null,"0-9\\-",3).addEventListener(Event.CHANGE,this.detailMenuUpdate);
            GameState.ui.menuDetails.addTooltip("Item Group","Items only collide with the same group\'s items. Negative groups collide with everything except their positive counterpart.\n\n\n\n\n");
         }
         if(!ud.saveable || ud.projectile)
         {
            GameState.ui.showTooltip(GameState.ui.menuDetails,"This item isn\'t saveable.\nModifying it is useless.\n",0,2000,250);
         }
         GameState.ui.menuDetails.maximiseHeight = GameState.ui.menuDetails.fieldPosition + Window.BUFFER;
         GameState.ui.menuDetails.maximise();
         GameState.ui.menuDetails.redraw();
         this.detailCounter = 0;
         if(GameState.ui.menuObject.title == "Detail Settings" && GameState.ui.menuObject.visible)
         {
            GameState.ui.detailSettings(false);
            GameState.ui.dockItemMenuDetail();
         }
         if(GameState.ui.menuObject.title == "Detail Properties" && GameState.ui.menuObject.visible)
         {
            Properties.itemProperties(true,false);
            GameState.ui.dockItemMenuDetail();
         }
      }
      
      public function detailMenuUpdate(param1:Event) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:TextField = null;
         var _loc4_:Number = NaN;
         var _loc5_:Vector.<b2Body> = null;
         var _loc6_:b2Body = null;
         var _loc7_:userData = null;
         _loc2_ = param1.currentTarget.name;
         _loc3_ = GameState.ui.menuDetails.getField(_loc2_);
         _loc4_ = 0;
         if(_loc3_.text == "-" || _loc3_.text == "")
         {
            return;
         }
         _loc4_ = Number(_loc3_.text);
         if(isNaN(_loc4_))
         {
            _loc3_.text = "0";
            return;
         }
         _loc5_ = this.selectedBodies.slice();
         for each(_loc6_ in _loc5_)
         {
            _loc7_ = userData(_loc6_.GetUserData());
            if(_loc2_ == "Group" || _loc2_ == "Item Group")
            {
               _loc7_.group = _loc4_;
            }
         }
      }
      
      public function detailUpdate(param1:Event) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:TextField = null;
         var _loc4_:Number = NaN;
         var _loc5_:Vector.<b2Body> = null;
         var _loc6_:b2Body = null;
         var _loc7_:userData = null;
         var _loc8_:Number = NaN;
         _loc2_ = param1.currentTarget.name;
         _loc3_ = GameState.ui.menuObject.getField(_loc2_);
         _loc4_ = 0;
         if(_loc3_.text == "-" || _loc3_.text == "")
         {
            return;
         }
         _loc4_ = Number(_loc3_.text);
         if(isNaN(_loc4_))
         {
            _loc3_.text = "0";
            return;
         }
         _loc5_ = this.selectedBodies.slice();
         for each(_loc6_ in _loc5_)
         {
            _loc7_ = userData(_loc6_.GetUserData());
            if(_loc2_ == "Scale")
            {
               Body.Scale(_loc6_,_loc4_ * 0.01,false);
            }
            else if(_loc2_ == "X Position")
            {
               _loc6_.SetXForm(new b2Vec2(_loc4_ / Physics.scale,_loc6_.GetPosition().y),_loc6_.GetAngle());
            }
            else if(_loc2_ == "Y Position")
            {
               _loc6_.SetXForm(new b2Vec2(_loc6_.GetPosition().x,_loc4_ / Physics.scale),_loc6_.GetAngle());
            }
            else if(_loc2_ == "Angle")
            {
               if(_loc4_ > 360)
               {
                  _loc4_ = 360;
                  _loc3_.text = _loc4_.toString();
               }
               _loc6_.SetXForm(_loc6_.GetPosition(),_loc4_ * Vars.toRadians);
            }
            else if(_loc2_ == "Temperature")
            {
               _loc8_ = _loc4_;
               if(_loc8_ > 200)
               {
                  _loc8_ = 200;
               }
               if(_loc8_ < -200)
               {
                  _loc8_ = -200;
               }
               if(World.toggleFahrenheit == 1)
               {
                  _loc8_ = (-32 + _loc8_) * (5 / 9) >> 0;
               }
               _loc7_.temperature = _loc8_;
            }
            else if(_loc2_ == "Health")
            {
               _loc7_.health = _loc4_;
               if(_loc7_.health > _loc7_.maxhealth)
               {
                  _loc7_.maxhealth = _loc7_.health;
               }
            }
            else if(_loc2_ == "Max Health")
            {
               _loc7_.maxhealth = _loc4_;
            }
            else if(_loc2_ == "Range")
            {
               if(_loc4_ < 1)
               {
                  _loc4_ = 1;
               }
               _loc7_.triggerRadius = _loc4_;
            }
            else if(_loc2_ == "Force")
            {
               _loc7_.triggerForce = _loc4_;
            }
            else if(_loc2_ == "Contact")
            {
               _loc7_.triggerContact = _loc4_;
            }
            else if(_loc2_ == "Duration")
            {
               _loc7_.triggerDuration = _loc4_;
               _loc7_.originalTriggerDuration = _loc4_;
            }
            else if(_loc2_ == "X Velocity")
            {
               _loc6_.GetLinearVelocity().x = _loc4_ / Physics.scale;
            }
            else if(_loc2_ == "Y Velocity")
            {
               _loc6_.GetLinearVelocity().y = _loc4_ / Physics.scale;
            }
            else if(_loc2_ == "A Velocity")
            {
               _loc6_.SetAngularVelocity(_loc4_ * Vars.toRadians);
            }
            else if(_loc2_ == "Layer")
            {
               _loc7_.layer = _loc4_;
               if(_loc4_ > 2)
               {
                  _loc4_ = 2;
               }
               if(_loc4_ == 0)
               {
                  this.backgroundSprite.addChild(_loc7_.graphic);
               }
               else if(_loc4_ == 1)
               {
                  this.itemSprite.addChild(_loc7_.graphic);
               }
               else if(_loc4_ == 2)
               {
                  this.foregroundSprite.addChild(_loc7_.graphic);
               }
            }
         }
         if(GameState.ui.menuEffects.visible)
         {
            this.OpenEffects(this.detailBody);
         }
      }
      
      private function dragEffect() : void
      {
         this.effecting = true;
      }
      
      private function contractSpawn(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         _loc2_ = GameState.ui.menuChallenge.globalToLocal(new Point(mouseX,mouseY));
         GameState.objects.spawnName = this.contract.selectItem(new b2Vec2(_loc2_.x,_loc2_.y));
         if(GameState.objects.spawnName)
         {
            GameState.spawning = true;
            GameState.objects.spawnScale = 1;
            GameState.objects.spawnAngle = Vars.objAngle;
            GameState.objects.spawnSprite = O.getItem(GameState.objects.spawnName).updateGraphic(null);
            GameState.objects.spawnSprite.mouseEnabled = false;
            GameState.objects.spawnSprite.mouseChildren = false;
            GameState.objects.spawnSprite.scaleX = Vars.objSize * (this.flipped ? -1 : 1);
            GameState.objects.spawnSprite.scaleY = Vars.objSize;
            GameState.objects.spawnSprite.rotation = Vars.objAngle;
            stage.addChild(GameState.objects.spawnSprite);
            GameState.objects.spawnSprite.x = mouseX;
            GameState.objects.spawnSprite.y = mouseY;
            stage.setChildIndex(GameState.objects.spawnSprite,stage.numChildren - 1);
         }
      }
      
      public function dragSpawn(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = null;
         if(Boolean(GameState.objects.spawnName) && Boolean(GameState.objects.spawnSprite))
         {
            GameState.spawning = true;
            GameState.objects.spawnScale = 1;
            GameState.objects.spawnAngle = Vars.objAngle;
            GameState.objects.spawnSprite.scaleX = Vars.objSize * this.cam.scaleX;
            GameState.objects.spawnSprite.scaleY = Vars.objSize * this.cam.scaleY;
            GameState.objects.spawnSprite.rotation = Vars.objAngle;
            stage.addChild(GameState.objects.spawnSprite);
            GameState.objects.spawnSprite.x = mouseX;
            GameState.objects.spawnSprite.y = mouseY;
            if(GameState.objects.spawnSprite.name == "customSprite")
            {
               GameState.objects.spawnSprite.scaleX = GameState.objects.spawnSprite.scaleY = 1 / this.m_sprite.scaleX;
            }
            stage.setChildIndex(GameState.objects.spawnSprite,stage.numChildren - 1);
            _loc2_ = GameState.ui.menuSpawn.getChildByName("itemHolder") as Sprite;
            _loc2_.visible = false;
         }
      }
      
      private function toggleTree(param1:ListEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:File = null;
         var _loc6_:String = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if(param1.item is LeafNode)
         {
            if(param1.item.func)
            {
               if(param1.item.label == "")
               {
                  return;
               }
               if(param1.item.func == "mappingEdit")
               {
                  GameState.ui.menuKeyConfig.toggle();
               }
               else if(param1.item.func == "settingsSubmenu")
               {
                  this.updateToggles(param1.item.submenu);
               }
               else if(param1.item.func == "exitgame")
               {
                  NativeApplication.nativeApplication.exit(0);
               }
               else if(param1.item.func == "mainmenu")
               {
                  this.reset(false,true);
                  this.mainmenu.visible = true;
                  this.mainmenu.mouseEnabled = true;
                  this.mainmenu.mouseChildren = true;
                  GameState.menuHandler.closeAll();
                  this.ShowMainMenu();
               }
               else if(param1.item.func == "tutorial")
               {
                  GameState.ui.menuPrompt.unlock();
                  GameState.ui.menuPrompt.visible = false;
                  this.mainmenu.visible = false;
                  GameState.ui.menuSettings.close();
                  this.goToTutorial();
                  GameState.ui.menuControls.alpha = 1;
               }
               else if(param1.item.func == "resetCustoms")
               {
                  this.resetCustoms();
               }
               else if(param1.item.func == "resetPowersList")
               {
                  this.resetPowersList();
               }
               else if(param1.item.func == "resetFavs")
               {
                  this.resetFavs();
               }
               else if(param1.item.func == "resetSettings")
               {
                  this.resetSettings();
               }
               else if(param1.item.func == "loadMenus")
               {
                  this.loadMenus();
               }
               else if(param1.item.func == "saveMenus")
               {
                  Settings.saveMenus();
               }
               else if(param1.item.func == "resetMenus")
               {
                  GameState.ui.resetDocks(true);
               }
               else if(param1.item.func == "toggleConsole")
               {
                  GameState.ui.console.toggleConsole();
               }
               else if(param1.item.func == "toggleCredits")
               {
                  GameState.ui.openCredits();
               }
               else if(param1.item.func == "settingsFolder")
               {
                  _loc5_ = File.applicationStorageDirectory.resolvePath("#SharedObjects/#orava/mutilate");
                  if(!_loc5_.exists)
                  {
                     _loc5_.createDirectory();
                  }
                  _loc5_.openWithDefaultApplication();
               }
               else if(param1.item.func == "credits")
               {
                  GameState.ui.openCredits();
               }
               else if(param1.item.func == "changeImpactQuality")
               {
                  ++GameState.ImpactQuality;
                  if(GameState.ImpactQuality > 2)
                  {
                     GameState.ImpactQuality = 0;
                  }
                  this.updateToggles(param1.item.submenu);
               }
               else if(param1.item.func == "changeQuality")
               {
                  _loc6_ = stage.quality.toLowerCase();
                  if(_loc6_ == StageQuality.LOW)
                  {
                     stage.quality = StageQuality.MEDIUM;
                  }
                  else if(_loc6_ == StageQuality.MEDIUM)
                  {
                     stage.quality = StageQuality.HIGH;
                  }
                  else if(_loc6_ == StageQuality.HIGH)
                  {
                     stage.quality = StageQuality.LOW;
                  }
                  this.updateToggles(param1.item.submenu);
               }
               else if(param1.item.func == "windowedMode")
               {
                  World.toggleFullscreen = 0;
                  this.SetFullscreen(World.toggleFullscreen);
                  this.updateToggles("graphics");
               }
               else if(param1.item.func == "fullscreenModeQuality")
               {
                  World.toggleFullscreen = 1;
                  this.SetFullscreen(World.toggleFullscreen);
                  this.updateToggles("graphics");
               }
               else if(param1.item.func == "fullscreenModePerformance")
               {
                  World.toggleFullscreen = 2;
                  this.SetFullscreen(World.toggleFullscreen);
                  this.updateToggles("graphics");
               }
            }
            if(!param1.item.toggleValue)
            {
               return;
            }
            if(param1.item.toggleValue == "0")
            {
               param1.item.toggleValue = "1";
            }
            else
            {
               param1.item.toggleValue = "0";
            }
            param1.item.forceDrawNode();
            _loc2_ = param1.item.label;
            _loc3_ = param1.item.func;
            _loc4_ = int(param1.item.toggleValue);
            if(_loc3_ == "slomo")
            {
               World.toggleSlomo = _loc4_;
            }
            else if(_loc3_ == "dollstand")
            {
               World.toggleStabi = _loc4_;
            }
            else if(_loc3_ == "dollbreak")
            {
               World.toggleRagdollBreak = _loc4_;
               this.updateToggles(param1.item.submenu);
            }
            else if(_loc3_ == "dollgib")
            {
               World.toggleBodypartGibs = _loc4_;
            }
            else if(_loc3_ == "gibgib")
            {
               World.toggleGibsGib = _loc4_;
            }
            else if(_loc3_ == "jointbreak")
            {
               World.toggleJointBreak = _loc4_;
            }
            else if(_loc3_ == "sounds")
            {
               World.toggleSounds = _loc4_;
               sounds.enabled = World.toggleSounds == 1;
            }
            else if(_loc3_ == "effects")
            {
               World.toggleEffects = _loc4_;
            }
            else if(_loc3_ == "contacts")
            {
               World.toggleContact = _loc4_;
               GameState.contact = World.toggleContact == 1;
            }
            else if(_loc3_ == "bloodgore")
            {
               World.toggleGore = _loc4_;
            }
            else if(_loc3_ == "healthbars")
            {
               World.toggleHealthbars = _loc4_;
            }
            else if(_loc3_ == "dollbars")
            {
               World.toggleDollbars = _loc4_;
            }
            else if(_loc3_ == "armourbars")
            {
               World.toggleArmourbars = _loc4_;
            }
            else if(_loc3_ == "dollicons")
            {
               World.toggleDollicons = _loc4_;
            }
            else if(_loc3_ == "showjoints")
            {
               World.toggleJoints = _loc4_;
            }
            else if(_loc3_ == "pausejoints")
            {
               World.toggleJointsPause = _loc4_;
            }
            else if(_loc3_ == "pauselinks")
            {
               World.toggleLinkPause = _loc4_;
            }
            else if(_loc3_ == "selectedlinks")
            {
               World.toggleLinkSelected = _loc4_;
            }
            else if(_loc3_ == "selectedjoints")
            {
               World.toggleJointSelected = _loc4_;
            }
            else if(_loc3_ == "alivejoints")
            {
               World.toggleJointsAlive = _loc4_;
            }
            else if(_loc3_ == "temperature")
            {
               World.toggleTemperature = _loc4_;
            }
            else if(_loc3_ == "autorespawn")
            {
               World.toggleAutorespawn = _loc4_;
            }
            else if(_loc3_ == "physicsblood")
            {
               World.togglePhysicsBlood = _loc4_;
            }
            else if(_loc3_ == "strongdolls")
            {
               World.toggleStrongDolls = 1;
            }
            else if(_loc3_ == "backgrounds")
            {
               World.toggleBackground = _loc4_;
            }
            else if(_loc3_ == "edgepan")
            {
               World.toggleEdgePan = _loc4_;
            }
            else if(_loc3_ == "culling")
            {
               World.toggleCulling = _loc4_;
            }
            else if(_loc3_ == "floorpan")
            {
               World.toggleFloorPan = _loc4_;
            }
            else if(_loc3_ == "edgestick")
            {
               World.toggleEdgeStick = _loc4_;
            }
            else if(_loc3_ == "showvelo")
            {
               World.toggleVelocity = _loc4_;
            }
            else if(_loc3_ == "showradius")
            {
               World.toggleRadius = _loc4_;
            }
            else if(_loc3_ == "layerback")
            {
               this.backgroundSprite.visible = !this.backgroundSprite.visible;
            }
            else if(_loc3_ == "layerdefault")
            {
               this.itemSprite.visible = !this.itemSprite.visible;
            }
            else if(_loc3_ == "layerfront")
            {
               this.foregroundSprite.visible = !this.foregroundSprite.visible;
            }
            else if(_loc3_ == "precisefx")
            {
               World.togglePreciseEffects = _loc4_;
            }
            else if(_loc3_ == "selectionglow")
            {
               World.toggleSelectionGlow = _loc4_;
            }
            else if(_loc3_ == "destroysmall")
            {
               World.toggleShrapnel = _loc4_;
            }
            else if(_loc3_ == "resetConfirm")
            {
               World.toggleResetConfirm = _loc4_;
            }
            else if(_loc3_ == "scaleMode")
            {
               World.toggleScaleMode = _loc4_;
               this.SetStageScaleMode(_loc4_ == 1);
            }
            else if(_loc3_ == "darkMode")
            {
               World.toggleDarkMode = _loc4_;
               GameState.ui.UpdateMenuStyle();
               GameState.ui.menuStylePopup();
            }
            else if(_loc3_ == "hoverSound")
            {
               sounds.UISound = _loc4_ == 1;
            }
            else if(_loc3_ == "toolbox")
            {
               World.toggleToolbox = _loc4_;
               GameState.ui.menuControls.visible = World.toggleToolbox == 1;
            }
            else if(_loc3_ == "spawnbg")
            {
               World.toggleSpawnBG = _loc4_;
               if(_loc4_ == 0)
               {
                  GameState.ui.menuSpawn.dulin = null;
               }
               else
               {
                  _loc7_ = GameState.ui.menuSpawn.actualWidth - Window.BUFFER * 4;
                  GameState.ui.menuSpawn.dulin = new Rectangle(Window.BUFFER * 2,22,_loc7_,_loc7_);
               }
            }
            else if(_loc3_ == "doubleclick")
            {
               World.doubleClickSelect = _loc4_;
            }
            else if(_loc3_ == "scrollwheel")
            {
               World.scrollWheel = _loc4_;
            }
            else if(_loc3_ == "rightclick")
            {
               World.rightClick = _loc4_;
               if(_loc4_ == 1)
               {
                  if(!stage.hasEventListener(MouseEvent.RIGHT_MOUSE_DOWN))
                  {
                     stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,this.mouse_rightdown);
                     stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP,this.mouse_rightup);
                  }
               }
               else
               {
                  if(stage.hasEventListener(MouseEvent.RIGHT_MOUSE_DOWN))
                  {
                     stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN,this.mouse_rightdown);
                     stage.removeEventListener(MouseEvent.RIGHT_MOUSE_UP,this.mouse_rightup);
                  }
                  GameState.rightDown = false;
               }
            }
            else if(_loc3_ == "smoothblood")
            {
               World.toggleSmoothBlood = _loc4_;
               this.bloodBMD.fillRect(this.bloodBMD.rect,0);
               this.updateBlood();
               this.updateToggles(param1.item.submenu);
            }
            else if(_loc3_ == "showblueprint" || _loc3_ == "showgrid")
            {
               this.m_sprite.getChildByName("itemholder").filters = [];
               if(_loc3_ == "showblueprint")
               {
                  World.toggleBlueprint = _loc4_;
               }
               else
               {
                  World.toggleGrid = _loc4_;
                  if(GameState.ui.menuTools.visible)
                  {
                     GameState.ui.menuTools.title = "";
                     this.TogglePauseSettingsMenu();
                  }
               }
               TimeLord.pauseGrid.Redraw();
               TimeLord.UpdateBlueprint();
            }
            else if(_loc3_ == "fahrenheit")
            {
               World.toggleFahrenheit = _loc4_;
               _loc8_ = Vars.temperature;
               if(World.toggleFahrenheit == 1)
               {
                  _loc8_ = 9 / 5 * _loc8_ + 32 >> 0;
               }
               GameState.ui.menuWorld.setValue("Temperature",_loc8_);
            }
            else if(_loc3_ == "concuss")
            {
               World.toggleDollSleep = _loc4_;
            }
            else if(_loc3_ == "extragore")
            {
               World.toggleExtraGore = _loc4_;
            }
            else if(_loc3_ == "shrapnels")
            {
               World.toggleCutFilter = _loc4_;
               Physics.contactFilter.shrapnel = _loc4_ == 0;
            }
            if(param1.item.submenu)
            {
               this.updateToggles(param1.item.submenu);
            }
         }
         Settings.saveSettings();
      }
      
      public function handleSaveTree(param1:ListEvent) : *
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:SharedObject = null;
         var _loc6_:String = null;
         var _loc7_:Boolean = false;
         if(param1.item is LeafNode)
         {
            if(param1.item.toggleValue)
            {
               if(param1.item.toggleValue == "0")
               {
                  param1.item.toggleValue = "1";
                  param1.item.forceDrawNode();
               }
               else if(param1.item.toggleValue == "1")
               {
                  param1.item.toggleValue = "0";
                  param1.item.forceDrawNode();
               }
               _loc2_ = param1.item.label;
               _loc3_ = int(param1.item.toggleValue);
               if(param1.item.func == "allowedit")
               {
                  Kongregate.shareAsUnlocked = _loc3_;
                  if(this.currentSave != "")
                  {
                     GameState.ui.showTooltip(GameState.ui.menuSave,"Please re-save the level before sharing to apply the setting.\n\n",0,2000,GameState.ui.menuSave.actualWidth);
                  }
               }
               else if(param1.item.func == "WorkshopApplyTag")
               {
                  GameState.steamworks.SetTag(param1.item.label,_loc3_);
                  GameState.steamworks.ParseTags();
               }
            }
            if(param1.item.func)
            {
               if(param1.item.func == "save")
               {
                  IO.saveWorld();
                  this.updateSaveMenu("localContent");
                  GameState.ui.showTooltip(GameState.ui.menuSave,"Saved!",0,1000,GameState.ui.menuSave.actualWidth);
               }
               else if(param1.item.func == "back")
               {
                  this.updateSaveMenu();
                  if(GameState.ui.menuDetails.title == "Favourite Save")
                  {
                     GameState.ui.menuDetails.close();
                  }
               }
               else if(param1.item.func == "localContent")
               {
                  this.updateSaveMenu("localContent");
               }
               else if(param1.item.func == "favBack")
               {
                  GameState.ui.menuDetails.close();
               }
               else if(param1.item.func == "favourite")
               {
                  GameState.ui.menuDetails.open();
                  GameState.ui.menuDetails.x = GameState.ui.menuSave.x + GameState.ui.menuSave.actualWidth + 4;
                  GameState.ui.menuDetails.y = GameState.ui.menuSave.y;
                  this.updateFavSave();
               }
               else if(param1.item.func == "favSave")
               {
                  GameState.ui.menuDetails.close();
                  _loc4_ = this.favouriteSaveNames.indexOf(this.customName);
                  if(_loc4_ == -1)
                  {
                     this.favouriteSaveNames.push(this.customName);
                     this.favouriteSaves.push(this.currentSave);
                  }
                  else
                  {
                     this.favouriteSaveNames[_loc4_] = this.customName;
                     this.favouriteSaves[_loc4_] = this.currentSave;
                  }
                  _loc5_ = SharedObject.getLocal("orava/mutilate/savesBackup","/");
                  if(!_loc5_.data.names)
                  {
                     _loc5_.data.names = this.customName;
                  }
                  else
                  {
                     _loc5_.data.names = _loc5_.data.names + "|" + this.customName;
                  }
                  if(!_loc5_.data.saves)
                  {
                     _loc5_.data.saves = Base64.compress(this.currentSave);
                  }
                  else
                  {
                     _loc5_.data.saves = _loc5_.data.saves + "|" + Base64.compress(this.currentSave);
                  }
                  Settings.saveFavouriteSaves();
                  this.updateSaveMenu("localContent");
               }
               else if(param1.item.func == "sort")
               {
                  this.updateSaveMenu("sort");
               }
               else if(param1.item.func == "autosave")
               {
                  this.updateSaveMenu("autosave");
               }
               else if(param1.item.func == "createContentWorkshop")
               {
                  this.updateSaveMenu("createContentWorkshop");
               }
               else if(param1.item.func == "createContent")
               {
                  this.updateSaveMenu("createContent");
               }
               else if(param1.item.func == "viewContent")
               {
                  this.updateSaveMenu("viewContent");
               }
               else if(param1.item.func == "unloadLevel")
               {
                  this.reset();
                  this.updateSaveMenu();
               }
               else if(param1.item.func == "restartLevel")
               {
                  IO.loadWorld(this.loadedLevel);
               }
               else if(param1.item.func != "defaultLevel")
               {
                  if(param1.item.func == "copy")
                  {
                     _loc6_ = Base64.compress(this.currentSave);
                     _loc6_ = "MAD" + _loc6_.replace(/\//g,"-");
                     if(_loc6_ != "")
                     {
                        GeneralUtils.copyToClipboard(_loc6_);
                        GameState.ui.showTooltip(GameState.ui.menuSave,"Save copied to clipboard.",0,1000,GameState.ui.menuSave.actualWidth);
                     }
                     else
                     {
                        GameState.ui.showTooltip(GameState.ui.menuSave,"Nothing to copy. Save first.",0,1000,GameState.ui.menuSave.actualWidth);
                     }
                  }
                  else if(param1.item.func == "workshopBack")
                  {
                     GameState.ui.menuDetails.close();
                  }
                  else if(param1.item.func == "copyItem")
                  {
                     this.CopyCustomItem();
                  }
                  else if(param1.item.func == "shareItemWorkshop")
                  {
                     GameState.ui.menuDetails.unlock();
                     GameState.ui.menuDetails.close();
                     this.ShareCustomItem(param1);
                  }
                  else if(param1.item.func == "shareLevelWorkshop")
                  {
                     GameState.ui.OpenWorkshopShareDialogue(null,Kongregate.shareContentType);
                  }
                  else if(param1.item.func == "shareLevel" || param1.item.func == "shareRoleplay" || param1.item.func == "shareLevelLocked" || param1.item.func == "shareRoleplayLocked" || param1.item.func == "workshopShareLevel")
                  {
                     if(param1.item.func == "workshopShareLevel")
                     {
                        GameState.steamworks.filenam = GameState.ui.menuDetails.getValue("Name");
                        GameState.steamworks.filedes = GameState.ui.menuDetails.getValue("Description");
                        GameState.ui.menuDetails.unlock();
                        GameState.ui.menuDetails.close();
                     }
                     if(param1.item.func == "shareLevelLocked" || param1.item.func == "shareRoleplayLocked")
                     {
                        Kongregate.shareAsUnlocked = 0;
                     }
                     else
                     {
                        Kongregate.shareAsUnlocked = 1;
                     }
                     if(param1.item.func == "shareRoleplay" || param1.item.func == "shareRoleplayLocked")
                     {
                        Kongregate.shareContentType = "Roleplay";
                     }
                     else
                     {
                        Kongregate.shareContentType = "Level";
                     }
                     _loc7_ = true;
                     if(this.currentSave == "")
                     {
                        _loc7_ = IO.saveWorld();
                     }
                     if(_loc7_)
                     {
                        GameState.ui.menuPrompt.unlock();
                        GameState.ui.menuPrompt.getField("info").type = TextFieldType.DYNAMIC;
                        GameState.ui.menuPrompt.visible = true;
                        GameState.ui.menuPrompt.moveToTop();
                        GameState.ui.menuPrompt.center();
                        GameState.ui.menuPrompt.lock();
                        if(Boolean(Kongregate.API) || true)
                        {
                           GameState.ui.menuPrompt.title = "Saving Level";
                           GameState.ui.menuPrompt.getField("info").text = "Please note that there are certain restrictions when saving, so you need to preview the level if you wish to share it.\n\n- Broken or cut items are not saved.\n\n- Visual effects are only saved for stamped items.\n(Blood, item effects, etc.)\n\n-Temporary projectiles are not saved.\n(Bullets, water, thrown powers, etc.)";
                           GameState.ui.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_promptShare);
                        }
                        else
                        {
                           GameState.ui.menuPrompt.title = "Sharing Error";
                           GameState.ui.menuPrompt.getField("info").text = "No Kongregate API detected!\nLevel sharing is not available.\n\nPlay MaD2 on Kongregate to share levels:\nhttp://www.kongregate.com/games/0rava/mutilate-a-doll-2";
                           GameState.ui.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_promptKongShare);
                        }
                     }
                  }
                  else if(param1.item.func == "shareItem")
                  {
                     Kongregate.shareCustomItems();
                  }
                  else if(param1.item.func == "shareContract")
                  {
                     if(!GameState.ui.menuChallenge.visible)
                     {
                        GameState.ui.menuChallenge.toggle();
                        if(!GameState.ui.menuMain.undocked)
                        {
                           GameState.ui.menuChallenge.x = GameState.ui.menuMain.x + GameState.ui.menuMain.actualWidth + 4;
                        }
                        GameState.ui.showTooltip(GameState.ui.menuChallenge,"Create a Contract and share it via the Contract Menu.\n",0,2000,GameState.ui.menuChallenge.actualWidth);
                     }
                  }
                  else if(param1.item.func == "reset")
                  {
                     this.PlayerReset();
                  }
                  else if(param1.item.func == "load")
                  {
                     IO.loadWorld();
                  }
                  else if(param1.item.func == "unshare")
                  {
                     this.updateSaveMenu();
                  }
                  else if(param1.item.func == "unbrowse")
                  {
                     this.updateSaveMenu();
                  }
                  else if(param1.item.func == "unhistory")
                  {
                     this.updateSaveMenu("viewContent");
                  }
                  else if(param1.item.func == "removefavs")
                  {
                     GameState.ui.openFavouriteSaves();
                  }
                  else if(param1.item.func == "defaultfavs")
                  {
                     GameState.ui.openResetSaves();
                  }
                  else if(param1.item.func == "browseItems")
                  {
                     this.updateSaveMenu("viewItems");
                  }
                  else if(param1.item.func == "shareItem")
                  {
                     Kongregate.shareCustomItems();
                  }
                  else if(param1.item.func == "sharing")
                  {
                     if(Tweak.download)
                     {
                        GameState.ui.kongPopup();
                     }
                     else if(this.loadedLevel == "")
                     {
                        GameState.ui.menuSave.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_share);
                     }
                  }
                  else if(param1.item.func == "favourites")
                  {
                     this.updateSaveMenu("favourites");
                  }
                  else if(param1.item.func == "savehistory")
                  {
                     this.updateSaveMenu("history");
                  }
                  else if(param1.item.func == "openWorkshop")
                  {
                     Links.Workshop(param1);
                  }
                  else if(param1.item.func == "browseLevel")
                  {
                     Kongregate.viewContent("Level");
                  }
                  else if(param1.item.func == "browseRoleplay")
                  {
                     Kongregate.viewContent("Roleplay");
                  }
                  else if(param1.item.func == "browseContract")
                  {
                     Kongregate.viewContent("Contract");
                  }
                  else if(param1.item.func == "browseItemDoll")
                  {
                     Kongregate.viewContent("Custom Item","doll");
                  }
                  else if(param1.item.func == "browseItemApparel")
                  {
                     Kongregate.viewContent("Custom Item","apparel");
                  }
                  else if(param1.item.func == "browseItemMelee")
                  {
                     Kongregate.viewContent("Custom Item","melee");
                  }
                  else if(param1.item.func == "browseItemGuns")
                  {
                     Kongregate.viewContent("Custom Item","gun");
                  }
                  else if(param1.item.func == "browseItemEnviron")
                  {
                     Kongregate.viewContent("Custom Item","environment");
                  }
                  else if(param1.item.func == "browseItemMisc")
                  {
                     Kongregate.viewContent("Custom Item","misc");
                  }
                  else if(param1.item.func == "qload")
                  {
                     IO.loadWorld(this.qSaveArray[int(param1.item.id)]);
                  }
                  else if(param1.item.func == "favload")
                  {
                     IO.loadWorld(this.favouriteSaves[int(param1.item.id)]);
                  }
               }
            }
         }
      }
      
      private function handleTreeDoubleClick(param1:ListEvent) : void
      {
         if(param1.item.object)
         {
            GameState.objects.spawnObject(param1.item.object,Math.random() * (GameState.width - 100) + 50,Math.random() * (GameState.height - 100) + 50,0,this.shiftPressed,true);
            GameState.spawning = false;
         }
      }
      
      public function bulletPropertyClick(param1:ListEvent) : void
      {
         var _loc2_:b2Body = null;
         var _loc3_:userData = null;
         var _loc4_:Firearm = null;
         var _loc6_:Boolean = false;
         _loc2_ = this.detailBody;
         if(!_loc2_)
         {
            return;
         }
         _loc3_ = userData(_loc2_.GetUserData());
         if(!_loc3_)
         {
            return;
         }
         if(_loc3_.dead)
         {
            return;
         }
         if(!_loc3_.trigger || !(_loc3_.trigger is Gun))
         {
            return;
         }
         _loc4_ = Gun(_loc3_.trigger).firearm;
         var _loc5_:Vector.<b2Body> = this.selectedBodies.slice();
         if(param1.item.toggleValue)
         {
            if(param1.item.toggleValue == "0")
            {
               param1.item.toggleValue = "1";
            }
            else if(param1.item.toggleValue == "1")
            {
               param1.item.toggleValue = "0";
            }
            param1.item.forceDrawNode();
            _loc6_ = param1.item.toggleValue == "1";
            _loc4_.SetBulletProperty(String(param1.item.property),_loc6_);
         }
      }
      
      public function detailTreeHover(param1:ListEvent) : void
      {
         if(Boolean(param1.item.sid) && Boolean(param1.item.id))
         {
            this.hoveredJoint = int(param1.item.id);
            this.hoveredJointBody = int(param1.item.sid);
         }
         else
         {
            this.hoveredJoint = -1;
            this.hoveredJointBody = -1;
         }
      }
      
      public function detailTreeExit(param1:ListEvent) : void
      {
         this.hoveredJoint = -1;
         this.hoveredJointBody = -1;
      }
      
      public function detailTreeClick(param1:ListEvent) : void
      {
         var _loc2_:b2Body = null;
         var _loc3_:userData = null;
         var _loc4_:Vector.<b2Body> = null;
         var _loc5_:Boolean = false;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         var _loc9_:userData = null;
         var _loc10_:String = null;
         var _loc11_:b2Body = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:b2JointEdge = null;
         var _loc15_:b2Body = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:b2Vec2 = null;
         var _loc19_:b2Body = null;
         var _loc20_:BitmapData = null;
         var _loc21_:Boolean = false;
         _loc2_ = this.detailBody;
         if(!_loc2_)
         {
            return;
         }
         _loc3_ = userData(_loc2_.GetUserData());
         if(!_loc3_)
         {
            return;
         }
         if(_loc3_.dead)
         {
            return;
         }
         _loc4_ = this.selectedBodies.slice();
         if(param1.item.toggleValue)
         {
            if(param1.item.toggleValue == "0")
            {
               param1.item.toggleValue = "1";
               param1.item.forceDrawNode();
            }
            else if(param1.item.toggleValue == "1")
            {
               param1.item.toggleValue = "0";
               param1.item.forceDrawNode();
            }
            _loc5_ = param1.item.toggleValue == "1";
            _loc6_ = param1.item.label;
            _loc7_ = 0;
            while(_loc7_ < _loc4_.length)
            {
               _loc9_ = userData(_loc4_[_loc7_].GetUserData());
               if(_loc6_ == "Debug ")
               {
                  if(!_loc5_)
                  {
                     if(_loc9_.graphic.getChildByName("debug_pos"))
                     {
                        _loc9_.graphic.removeChild(_loc9_.graphic.getChildByName("debug_pos"));
                     }
                     if(_loc9_.graphic.getChildByName("debug_scalerot"))
                     {
                        _loc9_.graphic.removeChild(_loc9_.graphic.getChildByName("debug_scalerot"));
                     }
                  }
               }
               if(_loc6_ == "Sticky")
               {
                  _loc9_.sticky = _loc5_;
               }
               else if(_loc6_ == "Debug ")
               {
                  _loc9_.debug = _loc5_;
               }
               else if(_loc6_ == "Locked ")
               {
                  _loc9_.locked = _loc5_;
               }
               else if(_loc6_ == "Wall Ignore ")
               {
                  _loc9_.locked = _loc5_;
               }
               else if(_loc6_ == "Snap to Grid ")
               {
                  _loc9_.gridSnap = _loc5_;
               }
               else if(_loc6_ == "Alive ")
               {
                  _loc9_.alive = _loc5_;
               }
               else if(_loc6_ == "Sharp ")
               {
                  _loc9_.sharp = _loc5_;
               }
               else if(_loc6_ == "Dull ")
               {
                  _loc9_.blunt = _loc5_;
               }
               else if(_loc6_ == "Muted ")
               {
                  _loc9_.mute = _loc5_;
               }
               else if(_loc6_ == "Sticky ")
               {
                  _loc9_.sticky = _loc5_;
               }
               else if(_loc6_ == "Breakable ")
               {
                  _loc9_.breakable = _loc5_;
               }
               else if(_loc6_ == "Brittle ")
               {
                  _loc9_.brittle = _loc5_;
               }
               else if(_loc6_ == "Explosive ")
               {
                  _loc9_.explosive = _loc5_;
               }
               else if(_loc6_ == "Implosive ")
               {
                  _loc9_.implosive = _loc5_;
               }
               else if(_loc6_ == "Ghost ")
               {
                  _loc9_.ghost = _loc5_;
               }
               else if(_loc6_ == "Stainless ")
               {
                  _loc9_.stainless = _loc5_;
               }
               else if(_loc6_ == "Invisible ")
               {
                  _loc9_.invisible = _loc5_;
               }
               else if(_loc6_ == "Dispel")
               {
                  _loc9_.dispelling = _loc5_;
               }
               else if(_loc6_ == "Drain")
               {
                  _loc9_.draining = _loc5_;
               }
               else if(_loc6_ == "Burn")
               {
                  _loc9_.flaming = _loc5_;
               }
               else if(_loc6_ == "Freeze")
               {
                  _loc9_.freezing = _loc5_;
               }
               else if(_loc6_ == "Repel")
               {
                  _loc9_.gusting = _loc5_;
               }
               else if(_loc6_ == "Heal")
               {
                  _loc9_.healing = _loc5_;
               }
               else if(_loc6_ == "Deadly")
               {
                  _loc9_.killing = _loc5_;
               }
               else if(_loc6_ == "Poison")
               {
                  _loc9_.poisoning = _loc5_;
               }
               else if(_loc6_ == "Shock")
               {
                  _loc9_.shocking = _loc5_;
               }
               else if(_loc6_ == "Anti-Gravity")
               {
                  _loc9_.antigrav = _loc5_;
               }
               else if(_loc6_ == "Zero-Gravity")
               {
                  _loc9_.zerograv = _loc5_;
               }
               else if(_loc6_ == "Unbreakable ")
               {
                  _loc9_.unbreakable = _loc5_;
               }
               else if(_loc6_ == "Flammable ")
               {
                  _loc9_.flammable = _loc5_;
               }
               else if(_loc6_ == "Fixed Rotation ")
               {
                  _loc9_.fixedrotation = _loc5_;
               }
               else if(_loc6_ == "Sleep ")
               {
                  _loc9_.sleepOnSpawn = _loc5_;
               }
               else if(_loc6_ == "Vanilla ")
               {
                  _loc9_.vanilla = _loc5_;
               }
               else if(_loc6_ == "Resist Dispel")
               {
                  _loc9_.resistDispel = _loc5_;
               }
               else if(_loc6_ == "Resist Drain")
               {
                  _loc9_.resistDrain = _loc5_;
               }
               else if(_loc6_ == "Resist Burning")
               {
                  _loc9_.resistFlame = _loc5_;
               }
               else if(_loc6_ == "Resist Freezing")
               {
                  _loc9_.resistFreeze = _loc5_;
               }
               else if(_loc6_ == "Resist Repel")
               {
                  _loc9_.resistGust = _loc5_;
               }
               else if(_loc6_ == "Resist Healing")
               {
                  _loc9_.resistHeal = _loc5_;
               }
               else if(_loc6_ == "Resist Deadly")
               {
                  _loc9_.resistKill = _loc5_;
               }
               else if(_loc6_ == "Resist Poison")
               {
                  _loc9_.resistPoison = _loc5_;
               }
               else if(_loc6_ == "Resist Shocking")
               {
                  _loc9_.resistShock = _loc5_;
               }
               else if(_loc6_ == "Resist Concuss")
               {
                  _loc9_.resistConcuss = _loc5_;
               }
               else if(_loc6_ == "Resist Wounds")
               {
                  _loc9_.resistBleed = _loc5_;
               }
               else if(_loc6_ == "Resist Armour")
               {
                  _loc9_.resistArmour = _loc5_;
               }
               else if(_loc6_ == "Resist Joints")
               {
                  _loc9_.resistJoints = _loc5_;
               }
               else if(_loc6_ == "Rend")
               {
                  _loc9_.rending = _loc5_;
               }
               else if(_loc6_ == "Transferring")
               {
                  _loc9_.alchemying = _loc5_;
               }
               else if(_loc6_ == "Transmute")
               {
                  _loc9_.transmuting = _loc5_;
               }
               else if(_loc6_ == "Critical Hit!")
               {
                  _loc9_.critting = _loc5_;
               }
               else if(_loc6_ == "Deleting")
               {
                  _loc9_.deleting = _loc5_;
               }
               else if(_loc6_ == "Triggering")
               {
                  _loc9_.triggering = _loc5_;
               }
               else if(_loc6_ == "Relaying")
               {
                  _loc9_.relaying = _loc5_;
               }
               else if(_loc6_ == "Cleaning")
               {
                  _loc9_.cleaning = _loc5_;
               }
               else if(_loc6_ == "Janitor")
               {
                  _loc9_.janitoring = _loc5_;
               }
               else if(_loc6_ == "Hype")
               {
                  _loc9_.hyping = _loc5_;
               }
               else if(_loc6_ == "Stasis")
               {
                  _loc9_.suspending = _loc5_;
               }
               else if(_loc6_ == "Banish")
               {
                  _loc9_.banning = _loc5_;
               }
               else if(_loc6_ == "Blight")
               {
                  _loc9_.blighting = _loc5_;
               }
               else if(_loc6_ == "Resist Bullets")
               {
                  _loc9_.bulletproof = _loc5_;
               }
               else if(_loc6_ == "Cauterize")
               {
                  _loc9_.cauterizing = _loc5_;
               }
               else if(_loc6_ == "Regeneration")
               {
                  _loc9_.regenerating = _loc5_;
               }
               else if(_loc6_ == "Powder")
               {
                  _loc9_.disintegrator = _loc5_;
               }
               else if(_loc6_ == "Disintegrating")
               {
                  _loc9_.disintegrating = _loc5_;
               }
               else if(_loc6_ == "Sandstone")
               {
                  _loc9_.drying = _loc5_;
               }
               else if(_loc6_ == "Frostfire")
               {
                  _loc9_.frostfiring = _loc5_;
               }
               else if(_loc6_ == "Deepfry")
               {
                  _loc9_.frying = _loc5_;
               }
               else if(_loc6_ == "Wet")
               {
                  _loc9_.wetting = _loc5_;
               }
               else if(_loc6_ == "Glass")
               {
                  _loc9_.glassing = _loc5_;
               }
               else if(_loc6_ == "Glitch")
               {
                  _loc9_.glitching = _loc5_;
               }
               else if(_loc6_ == "Magnetic")
               {
                  _loc9_.magnetic = _loc5_;
               }
               else if(_loc6_ == "Oily")
               {
                  _loc9_.oily = _loc5_;
               }
               else if(_loc6_ == "Petrify")
               {
                  _loc9_.petrifying = _loc5_;
               }
               else if(_loc6_ == "Radioactive")
               {
                  _loc9_.radioactive = _loc5_;
               }
               else if(_loc6_ == "Lacerate")
               {
                  _loc9_.sanguine = _loc5_;
               }
               else if(_loc6_ == "Scorch")
               {
                  _loc9_.scorching = _loc5_;
               }
               else if(_loc6_ == "Ultrasharp")
               {
                  _loc9_.ultrasharp = _loc5_;
               }
               else if(_loc6_ == "Trigger On Cut")
               {
                  _loc9_.triggerOnCut = _loc5_;
               }
               else if(_loc6_ == "Linked Only")
               {
                  _loc9_.triggerLinkedInstead = _loc5_;
               }
               else if(_loc6_ == "Linked Also")
               {
                  _loc9_.triggerLinkedAsWell = _loc5_;
               }
               else if(_loc6_ == "Warming")
               {
                  _loc9_.warming = _loc5_;
               }
               else if(_loc6_ == "Webbing")
               {
                  _loc9_.webbing = _loc5_;
               }
               else if(_loc6_ == "Spreading")
               {
                  _loc9_.spreading = _loc5_;
               }
               else if(_loc6_ == "Resist Banning")
               {
                  _loc9_.resistBanning = _loc5_;
               }
               else if(_loc6_ == "Resist Blight")
               {
                  _loc9_.resistBlighting = _loc5_;
               }
               else if(_loc6_ == "Resist Stasis")
               {
                  _loc9_.resistStasis = _loc5_;
               }
               else if(_loc6_ == "Resist Transmute")
               {
                  _loc9_.resistTransmuting = _loc5_;
               }
               else if(_loc6_ == "Resist Cutting")
               {
                  _loc9_.resistCutting = _loc5_;
               }
               else if(_loc6_ == "Resist Breaking")
               {
                  _loc9_.resistAliveBreak = _loc5_;
               }
               else if(_loc6_ == "Resist Disintegrating")
               {
                  _loc9_.resistDisintegrating = _loc5_;
               }
               else if(_loc6_ == "Resist Sandstone")
               {
                  _loc9_.resistDrying = _loc5_;
               }
               else if(_loc6_ == "Resist Frostfire")
               {
                  _loc9_.resistFrostfiring = _loc5_;
               }
               else if(_loc6_ == "Resist Fry")
               {
                  _loc9_.resistFrying = _loc5_;
               }
               else if(_loc6_ == "Resist Gassy")
               {
                  _loc9_.resistGassy = _loc5_;
               }
               else if(_loc6_ == "Resist Glass")
               {
                  _loc9_.resistGlassing = _loc5_;
               }
               else if(_loc6_ == "Resist Glitch")
               {
                  _loc9_.resistGlitching = _loc5_;
               }
               else if(_loc6_ == "Resist Magnetic")
               {
                  _loc9_.resistMagnetic = _loc5_;
               }
               else if(_loc6_ == "Resist Oily")
               {
                  _loc9_.resistOily = _loc5_;
               }
               else if(_loc6_ == "Resist Petrify")
               {
                  _loc9_.resistPetrifying = _loc5_;
               }
               else if(_loc6_ == "Resist Radiation")
               {
                  _loc9_.resistRadioactive = _loc5_;
               }
               else if(_loc6_ == "Resist Scorch")
               {
                  _loc9_.resistScorching = _loc5_;
               }
               else if(_loc6_ == "Resist Ultrasharp")
               {
                  _loc9_.resistUltrasharp = _loc5_;
               }
               else if(_loc6_ == "Resist Chilling")
               {
                  _loc9_.resistChilling = _loc5_;
               }
               else if(_loc6_ == "Resist Warming")
               {
                  _loc9_.resistWarming = _loc5_;
               }
               else if(_loc6_ == "Resist Webbing")
               {
                  _loc9_.resistWebbing = _loc5_;
               }
               else if(_loc6_ == "Resist Ghosting")
               {
                  _loc9_.resistGhosting = _loc5_;
               }
               else if(_loc6_ == "Resist Protect")
               {
                  _loc9_.resistProtect = _loc5_;
               }
               else if(_loc6_ == "Resist Adrenaline")
               {
                  _loc9_.resistAdrenaline = _loc5_;
               }
               else if(_loc6_ == "Resist Arc")
               {
                  _loc9_.resistArc = _loc5_;
               }
               else if(_loc6_ == "Resist Gravity")
               {
                  _loc9_.resistGravity = _loc5_;
               }
               else if(_loc6_ == "Resist Droning")
               {
                  _loc9_.resistDroning = _loc5_;
               }
               else if(_loc6_ == "Resist Snare")
               {
                  _loc9_.resistSnare = _loc5_;
               }
               else if(_loc6_ == "Concuss")
               {
                  _loc9_.concussing = _loc5_;
               }
               else if(_loc6_ == "Wall Ghost")
               {
                  _loc9_.wallGhost = _loc5_;
               }
               else if(_loc6_ == "Bullet Ghost")
               {
                  _loc9_.projectileGhost = _loc5_;
               }
               else if(_loc6_ == "Unequip Death")
               {
                  _loc9_.unequipDead = _loc5_;
               }
               else if(_loc6_ == "Unequip Concuss")
               {
                  _loc9_.unequipConcuss = _loc5_;
               }
               if(_loc9_.sleepOnSpawn)
               {
                  _loc4_[_loc7_].PutToSleep();
               }
               if(_loc9_.invisible)
               {
                  _loc9_.graphic.alpha = 0;
               }
               if(param1.item.label == "Stainless ")
               {
                  Body.Scale(_loc4_[_loc7_],_loc9_.size,false);
               }
               Properties.forceObjVanilla = _loc3_.vanilla ? 1 : 0;
               if(param1.item.label == "Vanilla ")
               {
                  Body.Respawn(_loc4_[_loc7_]);
               }
               if(param1.item.label == "Static ")
               {
                  Body.ToggleStatic(_loc4_[_loc7_],_loc5_);
               }
               if(param1.item.label == "Fixed Rotation ")
               {
                  _loc4_[_loc7_].SetAngularVelocity(0);
                  _loc4_[_loc7_].SetFixedRotation(_loc5_);
               }
               _loc7_++;
            }
            Properties.forceObjVanilla = 0;
            _loc8_ = param1.item.toggleValue == "0" ? false : true;
            if(param1.item.label == "Roof")
            {
               GameState.environment.roof = _loc8_;
            }
            if(param1.item.label == "Sides")
            {
               GameState.environment.walls = _loc8_;
            }
            if(param1.item.label == "Left")
            {
               GameState.environment.wallL = _loc8_;
            }
            if(param1.item.label == "Right")
            {
               GameState.environment.wallR = _loc8_;
            }
            if(param1.item.label == "Floor")
            {
               GameState.environment.floor = _loc8_;
            }
            if(param1.item.label == "Particles")
            {
               GameState.environment.particles = _loc8_;
            }
            if(param1.item.label == "Loop")
            {
               GameState.environment.loop = _loc8_;
            }
            if(param1.item.label == "Filler")
            {
               GameState.environment.filler = _loc8_;
            }
            if(param1.item.label == "Auto Wind")
            {
               GameState.environment.autoWind = _loc8_;
               Vars.wind = Number(GameState.ui.menuWorld.getValue("Wind")) >> 0;
            }
         }
         if(param1.item.sound)
         {
            _loc3_.mute = false;
            if(param1.item.sound == "default")
            {
               _loc3_.overrideSound = null;
               _loc3_.overrideVolume = null;
            }
            else
            {
               _loc3_.overrideSound = param1.item.sound;
               sounds.play(param1.item.sound,this.detailBody);
            }
         }
         if(param1.item.func)
         {
            _loc10_ = param1.item.func;
            if(_loc10_ == "resetproperties")
            {
               Properties.resetProperties();
               Properties.itemProperties(true,false);
            }
            else if(_loc10_ == "toggleDetails")
            {
               if(GameState.ui.menuDetails.maximiseHeight != 320)
               {
                  GameState.ui.menuDetails.maximiseHeight == 320;
               }
               GameState.ui.menuDetails.maximise();
            }
            else if(_loc10_ == "flip")
            {
               for each(_loc11_ in _loc4_)
               {
                  this.selectedBodies.push(Body.Flip(_loc11_));
               }
               this.showDetails(this.detailBody,this.detailSubmenu);
            }
            else if(_loc10_ == "camerafollow")
            {
               GameState.followBody = _loc2_;
               this.showDetails(this.detailBody,this.detailSubmenu);
            }
            else if(_loc10_ == "cameraunfollow")
            {
               GameState.followBody = null;
               this.showDetails(this.detailBody,this.detailSubmenu);
            }
            else if(_loc10_ == "clone")
            {
               GameState.cloning = true;
            }
            else if(_loc10_ == "properties")
            {
               Properties.itemProperties(true);
            }
            else if(_loc10_ == "settings")
            {
               GameState.ui.detailSettings();
            }
            else if(_loc10_ == "alivesettings")
            {
               GameState.ui.stabSettings(true);
            }
            else if(_loc10_ == "gunsettings")
            {
               GameState.ui.gunSettings(true);
            }
            else if(_loc10_ == "bulletsettings")
            {
               Properties.bulletProperties();
            }
            else if(_loc10_ == "functionality")
            {
               this.showDetails(this.detailBody,"func");
            }
            else if(_loc10_ == "functionalityBack")
            {
               this.showDetails(this.detailBody,"main");
            }
            else if(_loc10_ == "selection")
            {
               this.showDetails(this.detailBody,"selection");
            }
            else if(_loc10_ == "joints")
            {
               this.showDetails(this.detailBody,"joints");
            }
            else if(_loc10_ == "selectionback")
            {
               this.selectedBodies = new Vector.<b2Body>();
               _loc12_ = 0;
               while(_loc12_ < this.selectedSelection.length)
               {
                  if(Boolean(this.selectedSelection[_loc12_]) && !userData(this.selectedSelection[_loc12_].GetUserData()).dead)
                  {
                     this.selectedBodies.push(this.selectedSelection[_loc12_]);
                  }
                  _loc12_++;
               }
               if(this.selectedBodies.length > 0)
               {
                  this.showDetails(this.selectedBodies[0],"selection");
               }
               this.selectedSelection = new Vector.<b2Body>();
            }
            else if(_loc10_ == "selectitem")
            {
               if(this.shiftPressed)
               {
                  this.selectedBodies.splice(int(param1.item.id),1);
                  this.showDetails(this.detailBody,"selection");
                  return;
               }
               this.selectedSelection = this.selectedBodies.slice();
               _loc11_ = this.selectedBodies[int(param1.item.id)];
               this.selectedBodies = new Vector.<b2Body>();
               this.selectedBodies.push(_loc11_);
               this.detailBody = _loc11_;
               this.showDetails(this.detailBody,"main");
            }
            else if(_loc10_ == "removejoint")
            {
               _loc11_ = this.detailBody;
               if(Boolean(param1.item.sid) && Boolean(this.selectedBodies[param1.item.sid]))
               {
                  _loc11_ = this.selectedBodies[param1.item.sid];
               }
               _loc13_ = 0;
               _loc14_ = _loc11_.GetJointList();
               while(_loc14_)
               {
                  if(_loc13_ == param1.item.id)
                  {
                     Joints.DestroyJoint(_loc14_.joint);
                     break;
                  }
                  _loc13_++;
                  _loc14_ = _loc14_.next;
               }
               this.showDetails(this.detailBody,"joints");
            }
            else if(_loc10_ == "selectionFocus")
            {
               GameState.focused = true;
               _loc15_ = Physics.world.GetBodyList();
               while(_loc15_)
               {
                  if(this.selectedBodies.indexOf(_loc15_) == -1)
                  {
                     userData(_loc15_.GetUserData()).hidden = true;
                     userData(_loc15_.GetUserData()).locked = true;
                     if(userData(_loc15_.GetUserData()).graphic)
                     {
                        userData(_loc15_.GetUserData()).graphic.visible = false;
                     }
                  }
                  _loc15_ = _loc15_.GetNext();
               }
               this.showDetails(this.detailBody,"selection");
            }
            else if(_loc10_ == "selectionUnFocus")
            {
               GameState.focused = false;
               _loc15_ = Physics.world.GetBodyList();
               while(_loc15_)
               {
                  if(userData(_loc15_.GetUserData()).hidden)
                  {
                     userData(_loc15_.GetUserData()).hidden = false;
                     userData(_loc15_.GetUserData()).locked = false;
                     if(userData(_loc15_.GetUserData()).graphic)
                     {
                        userData(_loc15_.GetUserData()).graphic.visible = true;
                     }
                  }
                  _loc15_ = _loc15_.GetNext();
               }
               this.showDetails(this.detailBody,"selection");
            }
            else if(_loc10_ == "movebottom")
            {
               _loc16_ = this.backBodies.indexOf(this.detailBody);
               if(_loc16_ == -1)
               {
                  this.backBodies.push(this.detailBody);
               }
               else
               {
                  this.backBodies.slice(_loc16_,1);
                  this.backBodies.push(this.detailBody);
               }
               userData(this.detailBody.GetUserData()).getParent().setChildIndex(userData(this.detailBody.GetUserData()).graphic,0);
               GameState.ui.menuDetails.close();
            }
            else if(_loc10_ == "unmovebottom")
            {
               _loc17_ = this.backBodies.indexOf(this.detailBody);
               if(_loc17_ != -1)
               {
                  this.backBodies.splice(_loc17_,1);
               }
            }
            else if(param1.item.func == "effects")
            {
               this.OpenEffects(this.detailBody);
            }
            else if(_loc10_ == "detailsound")
            {
               this.showDetails(this.detailBody,"sound");
            }
            else if(_loc10_ == "detailcollision")
            {
               this.showDetails(this.detailBody,"collision");
            }
            else if(_loc10_ == "detailgraphics")
            {
               this.showDetails(this.detailBody,"graphics");
            }
            else if(_loc10_ == "detailstamp")
            {
               GameState.stamping = true;
               Tool.drag();
               this.showDetails(this.detailBody,"stamp");
               if(!GameState.ui.menuSpawn.visible)
               {
                  param1 = new ListEvent("fake",false,false,-1,-1,-1,{"func":"spawn"});
                  this.mainTreeClick(param1);
               }
               TimeLord.DisableBlueprint();
               this.outlineSelected();
               _loc18_ = new b2Vec2();
               _loc18_.x = Math.round(this.detailBody.GetPosition().x * Physics.scale) / Physics.scale;
               _loc18_.y = Math.round(this.detailBody.GetPosition().y * Physics.scale) / Physics.scale;
            }
            else if(_loc10_ == "stopstamp")
            {
               GameState.stamping = false;
               this.showDetails(this.detailBody,"graphics");
            }
            else if(_loc10_ == "detailskin")
            {
               GameState.ui.menuObject.toggle();
               if(!GameState.ui.menuObject.visible)
               {
                  return;
               }
               GameState.objects.prevName = GameState.objects.spawnName;
               GameState.objects.prevSkin = GameState.objects.spawnSkin.slice();
               GameState.objects.spawnSkin = userData(this.detailBody.GetUserData()).skin.slice();
               GameState.ui.menuObject.title = "Detail Skin";
               this.itemSkin();
               this.ModifyDetailSkin();
               GameState.ui.menuObject.title = "Detail Skin";
               this.outlineSelected(false);
               GameState.ui.dockItemMenuDetail();
            }
            else if(_loc10_ == "movefront")
            {
               _loc17_ = this.backBodies.indexOf(this.detailBody);
               if(_loc17_ != -1)
               {
                  this.backBodies.splice(_loc17_,1);
               }
               Body.Scale(this.detailBody,userData(this.detailBody.GetUserData()).size,false);
               GameState.ui.menuDetails.close();
            }
            else if(_loc10_ == "stamp")
            {
               GameState.stamping = true;
            }
            else if(_loc10_ == "clean")
            {
               for each(_loc19_ in _loc4_)
               {
                  _loc20_ = BoxUtils.getEffectBMD(_loc19_);
                  if(_loc20_)
                  {
                     _loc20_.fillRect(_loc20_.rect,0);
                  }
               }
            }
            else if(_loc10_ == "beginmasssave")
            {
               this.updateMassSave();
            }
            else if(_loc10_ == "massBack")
            {
               this.showDetails(this.detailBody);
            }
            else if(_loc10_ == "massSave")
            {
               this.massSave();
            }
            else if(_loc10_ == "trigger")
            {
               userData(this.detailBody.GetUserData()).triggered = true;
               for each(_loc11_ in _loc4_)
               {
                  userData(_loc11_.GetUserData()).triggered = true;
               }
               this.showDetails(this.detailBody,this.detailSubmenu);
            }
            else if(_loc10_ == "untrigger")
            {
               userData(this.detailBody.GetUserData()).triggered = false;
               for each(_loc11_ in _loc4_)
               {
                  userData(_loc11_.GetUserData()).triggered = false;
               }
               this.showDetails(this.detailBody,this.detailSubmenu);
            }
            else if(_loc10_ == "alignx")
            {
               BoxUtils.AlignSelectedBodies(this.detailBody,this.selectedBodies,"X");
            }
            else if(_loc10_ == "aligny")
            {
               BoxUtils.AlignSelectedBodies(this.detailBody,this.selectedBodies,"Y");
            }
            else if(_loc10_ == "freezethaw")
            {
               _loc21_ = this.detailBody.GetMass() != 0;
               for each(_loc11_ in _loc4_)
               {
                  Body.ToggleStatic(_loc11_,_loc21_);
               }
               this.showDetails(this.detailBody,this.detailSubmenu);
            }
            else if(_loc10_ == "changeLayer")
            {
               ++userData(this.detailBody.GetUserData()).layer;
               if(userData(this.detailBody.GetUserData()).layer > 2)
               {
                  userData(this.detailBody.GetUserData()).layer = 0;
               }
               for each(_loc11_ in _loc4_)
               {
                  userData(_loc11_.GetUserData()).layer = userData(this.detailBody.GetUserData()).layer;
                  GraphicUtils.addGraphicToLayer(userData(_loc11_.GetUserData()));
               }
               this.showDetails(this.detailBody,this.detailSubmenu);
            }
            else if(_loc10_ == "massclone")
            {
               this.MassClone();
            }
            else if(_loc10_ == "removejoints")
            {
               for each(_loc11_ in this.selectedBodies)
               {
                  BoxUtils.RemoveJoints(_loc11_);
               }
               this.showDetails(this.detailBody);
            }
            else if(_loc10_ == "hidejoints")
            {
               for each(_loc11_ in this.selectedBodies)
               {
                  BoxUtils.InvisibleJoints(_loc11_);
               }
               this.showDetails(this.detailBody);
            }
            else if(_loc10_ == "triggerkey")
            {
               GameState.mappingItem = 1;
               GameState.ui.showTooltip(GameState.ui.menuMain,"Press any key to trigger the item when pressed.\nEsc to cancel.\n",0,2000,200);
            }
            else if(_loc10_ == "triggerkeyhold")
            {
               GameState.mappingItem = 2;
               GameState.ui.showTooltip(GameState.ui.menuMain,"Press any key to trigger the item when held.\nEsc to cancel.\n",0,2000,200);
            }
            else if(_loc10_ == "removelinks")
            {
               for each(_loc11_ in this.selectedBodies)
               {
                  BoxUtils.RemoveLinks(_loc11_);
               }
               this.showDetails(this.detailBody,this.detailSubmenu);
            }
            else if(_loc10_ == "removeignores")
            {
               for each(_loc11_ in this.selectedBodies)
               {
                  BoxUtils.RemoveIgnores(_loc11_);
               }
               this.showDetails(this.detailBody,this.detailSubmenu);
            }
            else if(_loc10_ == "collideItems")
            {
               for each(_loc11_ in this.selectedBodies)
               {
                  userData(_loc11_.GetUserData()).ghost = !userData(_loc11_.GetUserData()).ghost;
               }
            }
            else if(_loc10_ == "collideWalls")
            {
               for each(_loc11_ in this.selectedBodies)
               {
                  userData(_loc11_.GetUserData()).wallGhost = !userData(_loc11_.GetUserData()).wallGhost;
               }
            }
            else if(_loc10_ == "collideProjectiles")
            {
               for each(_loc11_ in this.selectedBodies)
               {
                  userData(_loc11_.GetUserData()).projectileGhost = !userData(_loc11_.GetUserData()).projectileGhost;
               }
            }
            else if(_loc10_ == "ignoreTool")
            {
               if(Tool.isIgnore)
               {
                  this.jointBody = null;
                  this.jointPos = null;
                  Tool.setTool(Tool.DETAIL);
               }
               else
               {
                  Tool.setTool(Tool.IGNORE);
                  GameState.ui.showTooltip(GameState.ui.menuMain,"Click on an item to ignore.",0,2000,200);
                  if(this.detailBody)
                  {
                     this.jointPos = new b2Vec2(0,0);
                     this.jointBody = this.detailBody;
                  }
               }
            }
            else if(_loc10_ == "repair")
            {
               GameState.objects.spawnObject(_loc3_.name,_loc2_.GetPosition().x * Physics.scale,_loc2_.GetPosition().y * Physics.scale,_loc2_.GetAngle(),_loc3_.flipped,true,_loc3_.skin);
               Body.Destroy(_loc2_,"repair");
            }
         }
      }
      
      private function MassClone() : void
      {
         var _loc1_:String = null;
         var _loc2_:b2Vec2 = null;
         GameState.spawningCustom = true;
         GameState.cloning = true;
         _loc1_ = this.currentSave;
         _loc2_ = new b2Vec2();
         if(this.detailBody)
         {
            _loc2_ = this.detailBody.GetPosition().Copy();
         }
         else if(this.selectedBodies.length > 0)
         {
            _loc2_ = this.selectedBodies[0].GetPosition().Copy();
         }
         this.customPos = _loc2_;
         if(IO.saveWorld())
         {
            this.dulin = Base64.compress(this.currentSave);
         }
         if(_loc1_ != "")
         {
            this.currentSave = _loc1_;
         }
      }
      
      private function resetPowersList() : void
      {
         Powers.favPowers = Tool.elementals.slice();
         Settings.savePowers();
         Powers.updatePowersList();
      }
      
      private function updateMassSave() : void
      {
         var _loc1_:Tree = null;
         GameState.ui.menuDetails.title = "Saving Custom Item";
         GameState.ui.menuDetails.removeAllChildren();
         GameState.ui.menuDetails.addInput("Name","Item Name",GameState.ui.menuDetails.actualWidth - Window.BUFFER * 6,null,"a-zA-Z0-9 -",24,false).addEventListener(Event.CHANGE,this.updateCustomName);
         _loc1_ = GameState.ui.menuDetails.addTree("buttons",R.xml_massSave);
         _loc1_.addEventListener(ListEvent.ITEM_CLICK,this.detailTreeClick);
         _loc1_.selectable = false;
         if(this.quickCreatingCustomItem == 3)
         {
            GameState.ui.showTooltip(GameState.ui.menuDetails,"Name the item and save it to add it to your Library.\n\n",0,10000,GameState.ui.menuDetails.actualWidth);
            this.quickCreatingCustomItem = 0;
         }
         else
         {
            GameState.ui.showTooltip(GameState.ui.menuDetails,"Please back up your custom items file if you use this feature a lot! See FAQ for instructions.\n\n\n\n",0,5000,GameState.ui.menuDetails.actualWidth);
         }
      }
      
      private function updateFavSave() : void
      {
         var _loc1_:Tree = null;
         GameState.ui.menuDetails.title = "Favourite Save";
         GameState.ui.menuDetails.removeAllChildren();
         GameState.ui.menuDetails.addInput("Name","Save Name",GameState.ui.menuDetails.actualWidth - Window.BUFFER * 6,null,"a-zA-Z0-9 -",24,false).addEventListener(Event.CHANGE,this.updateFavouriteSave);
         _loc1_ = GameState.ui.menuDetails.addTree("buttons",R.xml_favSave);
         _loc1_.addEventListener(ListEvent.ITEM_CLICK,this.handleSaveTree);
         _loc1_.selectable = false;
         GameState.ui.showTooltip(GameState.ui.menuDetails,"Please back up your favourite saves file if you use this feature a lot! See FAQ for instructions.\n\n\n\n",0,5000,GameState.ui.menuDetails.actualWidth);
      }
      
      private function updateCustomRename(param1:Event) : void
      {
         this.customName = GameState.ui.menuFavourite.getValue("Name");
         if(this.customNames.indexOf(this.customName) != -1)
         {
            GameState.ui.genericToolTip = GameState.ui.showTooltip(GameState.ui.menuFavourite,"\"" + this.customName + "\" custom item already exists.\n\n",0,-1,GameState.ui.menuFavourite.actualWidth);
         }
         else if(O.names.indexOf(this.customName.toLowerCase()) != -1 || GeneralUtils.objectToName(this.customName.toLowerCase()) != "")
         {
            GameState.ui.genericToolTip = GameState.ui.showTooltip(GameState.ui.menuDetails,"\"" + GeneralUtils.objectToName(this.customName.toLowerCase()) + "\" already exists as an item.\nSaving a Custom Item with this name will override the item in loaded saves.\n\n\n\n",0,-1,GameState.ui.menuFavourite.actualWidth);
         }
         else if(this.customName.indexOf(" by ") != -1)
         {
            GameState.ui.genericToolTip = GameState.ui.showTooltip(GameState.ui.menuFavourite,"Custom items are automatically credited, please don\'t include \"by\".\n\n",0,-1,GameState.ui.menuFavourite.actualWidth);
         }
         else if(GameState.ui.genericToolTip)
         {
            GameState.ui.genericToolTip.hide();
         }
      }
      
      private function updateCustomName(param1:Event) : void
      {
         this.customName = GameState.ui.menuDetails.getValue("Name");
         if(this.customNames.indexOf(this.customName) != -1)
         {
            GameState.ui.genericToolTip = GameState.ui.showTooltip(GameState.ui.menuDetails,"\"" + this.customName + "\" custom item already exists.\nSaving will overwrite it!\n\n",0,-1,GameState.ui.menuDetails.actualWidth);
         }
         else if(O.names.indexOf(this.customName.toLowerCase()) != -1 || GeneralUtils.objectToName(this.customName.toLowerCase()) != "")
         {
            GameState.ui.genericToolTip = GameState.ui.showTooltip(GameState.ui.menuDetails,"\"" + GeneralUtils.objectToName(this.customName.toLowerCase()) + "\" already exists as an item.\nSaving a Custom Item with this name will override the item in loaded saves.\n\n\n\n",0,-1,GameState.ui.menuFavourite.actualWidth);
         }
         else if(this.customName.indexOf(" by ") != -1)
         {
            GameState.ui.genericToolTip = GameState.ui.showTooltip(GameState.ui.menuDetails,"Custom items are automatically credited, please don\'t include \"by\".\n\n",0,-1,GameState.ui.menuDetails.actualWidth);
         }
         else if(GameState.ui.genericToolTip)
         {
            GameState.ui.genericToolTip.hide();
         }
      }
      
      private function updateFavouriteSave(param1:Event) : void
      {
         this.customName = GameState.ui.menuDetails.getValue("Name");
         if(this.favouriteSaveNames.indexOf(this.customName) != -1)
         {
            GameState.ui.genericToolTip = GameState.ui.showTooltip(GameState.ui.menuDetails,"\"" + this.customName + "\" favourite save already exists.\nSaving will overwrite it!\n\n",0,-1,GameState.ui.menuDetails.actualWidth);
         }
         else if(GameState.ui.genericToolTip)
         {
            GameState.ui.genericToolTip.hide();
         }
      }
      
      private function treeClick(param1:ListEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:int = 0;
         if(param1.item is LeafNode)
         {
            if(param1.item.toggleValue)
            {
               if(param1.item.toggleValue == "0")
               {
                  param1.item.toggleValue = "1";
                  param1.item.forceDrawNode();
               }
               else if(param1.item.toggleValue == "1")
               {
                  param1.item.toggleValue = "0";
                  param1.item.forceDrawNode();
               }
            }
            else if(!param1.item.object)
            {
               if(param1.item.func)
               {
                  _loc2_ = param1.item.func;
                  if(_loc2_ == "promptYes")
                  {
                     if(GameState.ui.menuPrompt.title == "Import Keymap")
                     {
                        if(Keymap.setKeymap(GameState.ui.menuPrompt.getValue("info")))
                        {
                           Settings.saveMapping();
                           GameState.ui.menuPrompt.setValue("info","Imported keymap loaded.");
                           GameState.ui.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_done);
                        }
                        else
                        {
                           GameState.ui.menuPrompt.setValue("info","That doesn\'t seem to be a valid keymap.\n\nIt should look something like:\n" + Keymap.getDefault().substr(1,32) + "...");
                        }
                     }
                  }
                  else if(_loc2_ == "resetKeymap")
                  {
                     if(GameState.ui.menuPrompt.title == "Reset Keymap")
                     {
                        Keymap.setKeymap("default");
                        Settings.saveMapping();
                        GameState.ui.menuPrompt.setValue("info","Default keymap loaded.");
                        GameState.ui.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_done);
                     }
                  }
                  else if(_loc2_ == "promptLocal")
                  {
                     GameState.ui.menuMain.alpha = 1;
                     GameState.ui.menuControls.alpha = 1;
                     GameState.ui.menuTools.close();
                     GameState.ui.menuPrompt.unlock();
                     GameState.ui.menuPrompt.visible = false;
                     this.closeMainMenu();
                  }
                  else if(_loc2_ == "promptReset")
                  {
                     this.reset();
                     GameState.ui.menuPrompt.unlock();
                     GameState.ui.menuPrompt.visible = false;
                  }
                  else if(_loc2_ == "promptNag")
                  {
                     this.datanag = false;
                     GameState.ui.menuPrompt.unlock();
                     GameState.ui.menuPrompt.visible = false;
                  }
                  else if(_loc2_ == "promptNo")
                  {
                     _loc3_ = GameState.ui.menuPrompt.getChildByName("temp");
                     if(_loc3_)
                     {
                        GameState.ui.menuPrompt.removeChild(_loc3_);
                     }
                     GameState.ui.menuPrompt.unlock();
                     GameState.ui.menuPrompt.visible = false;
                     GameState.ui.menuMain.alpha = 1;
                     GameState.ui.menuControls.alpha = 1;
                     if(this.mainmenu.visible)
                     {
                        this.mainmenu.visible = false;
                     }
                     if(GameState.previewing)
                     {
                        Kongregate.alreadyShared = false;
                        GameState.previewing = false;
                     }
                  }
                  else if(param1.item.func == "mappingComplete")
                  {
                     this.mapKey(param1.item.key);
                     GameState.ui.menuPrompt.unlock();
                     GameState.ui.menuPrompt.visible = false;
                  }
                  else if(_loc2_ == "crashPower")
                  {
                     PowerCrash(Tool.power).Crash();
                  }
                  else if(_loc2_ == "crashPowerYes")
                  {
                     PowerCrash(Tool.power).Yes();
                  }
                  else if(_loc2_ == "crashPowerNo")
                  {
                     PowerCrash(Tool.power).No();
                  }
                  else if(_loc2_ == "promptReset")
                  {
                     this.reset();
                     if(GameState.ui.menuSave.visible)
                     {
                        this.updateSaveMenu();
                     }
                  }
                  else if(_loc2_ == "promptKong")
                  {
                     navigateToURL(new URLRequest("http://www.kongregate.com/games/0rava/mutilate-a-doll-2"),"_blank");
                  }
                  else if(_loc2_ == "promptRava")
                  {
                     navigateToURL(new URLRequest("https://www.rava.games"),"_blank");
                  }
                  else if(_loc2_ == "promptDownload")
                  {
                     navigateToURL(new URLRequest("https://www.rava.games/mutilate"),"_blank");
                  }
                  else if(_loc2_ == "promptFAQ")
                  {
                     navigateToURL(new URLRequest("https://www.kongregate.com/forums/9794/topics/513429#posts-13230330"),"_blank");
                  }
                  else if(_loc2_ == "promptLab")
                  {
                     navigateToURL(new URLRequest("https://rava.games/madlab"),"_blank");
                  }
                  else if(_loc2_ == "promptShare")
                  {
                     this.saveContent();
                     GameState.ui.menuPrompt.unlock();
                     GameState.ui.menuPrompt.visible = false;
                  }
                  else if(_loc2_ == "promptView")
                  {
                     GameState.previewing = true;
                     IO.loadWorld();
                     if(Kongregate.alreadyShared)
                     {
                        GameState.ui.menuPrompt.title = "Preview Error";
                        GameState.ui.menuPrompt.getField("info").text = "This content can\'t be shared.\n\n1) It either doesn\'t contain enough items\nor \n2) It was already shared during this session.\n\nPlease back up the save string and try again after reseting.";
                        GameState.ui.menuPrompt.unlock();
                        GameState.ui.menuPrompt.getField("info").type = TextFieldType.DYNAMIC;
                        GameState.ui.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_done);
                        GameState.ui.menuPrompt.visible = true;
                        GameState.ui.menuPrompt.unlock();
                        GameState.ui.menuPrompt.moveToTop();
                        GameState.ui.menuPrompt.center();
                        GameState.ui.menuPrompt.lock();
                        GameState.ui.menuSave.close();
                        return;
                     }
                     GameState.ui.menuSave.visible = false;
                     GameState.ui.menuMain.visible = false;
                     GameState.ui.menuPrompt.unlock();
                     GameState.ui.menuPrompt.getField("info").type = TextFieldType.DYNAMIC;
                     GameState.ui.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_promptConfirm);
                     GameState.ui.menuPrompt.visible = true;
                     GameState.ui.menuPrompt.title = "Level Preview";
                     GameState.ui.menuPrompt.moveToTop();
                     GameState.ui.menuPrompt.center();
                     GameState.ui.menuPrompt.getField("info").text = "You\'re now previewing the level, unpause the game to see how it plays out.\n\n(This menu has also been unlocked so you can move it around.)\n\nIf the level works as intended when played, press the button below to share it!\n\nPlease do not save broken levels to reduce the clutter!";
                  }
                  else if(_loc2_ == "shareConfirm")
                  {
                     GameState.previewing = false;
                     GameState.ui.menuSave.visible = true;
                     GameState.ui.menuMain.visible = true;
                     GameState.ui.menuPrompt.unlock();
                     GameState.ui.menuPrompt.visible = false;
                     this.saveContent();
                  }
                  else if(_loc2_ == "promptBackToTheDrawingBoard")
                  {
                     GameState.ui.menuSave.visible = true;
                     GameState.ui.menuMain.visible = true;
                     GameState.ui.menuPrompt.unlock();
                     GameState.ui.menuPrompt.visible = false;
                  }
                  else if(_loc2_ == "copyKeymap")
                  {
                     GeneralUtils.copyToClipboard(GameState.ui.menuPrompt.getValue("info"));
                     GameState.ui.menuPrompt.setValue("info","Keymap successfully copied to clipboard.");
                     GameState.ui.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_done);
                  }
                  else if(_loc2_ == "copySave")
                  {
                     GeneralUtils.copyToClipboard(GameState.ui.menuPrompt.getValue("info"));
                     GameState.ui.menuPrompt.setValue("info","Save successfully copied to clipboard.");
                     GameState.ui.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_done);
                  }
                  else if(_loc2_ == "play")
                  {
                     this.beginPlay();
                  }
                  else if(_loc2_ == "tutorial")
                  {
                     this.beginTutorial();
                  }
                  else if(_loc2_ == "customRename")
                  {
                     _loc5_ = _loc4_ = GameState.ui.menuFavourite.getValue("Name");
                     _loc6_ = 2;
                     while(this.customNames.indexOf(_loc5_) != -1)
                     {
                        _loc5_ = _loc4_ + " " + _loc6_;
                        _loc6_++;
                     }
                     this.customNames[this.customNames.indexOf(this.customRenaming)] = _loc5_;
                     GameState.ui.openCustomItems("rename");
                  }
                  else if(_loc2_ == "customRenameBack")
                  {
                     GameState.ui.openCustomItems("rename");
                  }
               }
            }
         }
      }
      
      private function playButton(param1:Event) : void
      {
         this.beginPlay();
      }
      
      private function playTutorial(param1:Event) : void
      {
         this.beginTutorial();
      }
      
      private function beginTutorial() : void
      {
         this.closeMainMenu();
         this.goToTutorial();
         GameState.ui.menuControls.open();
      }
      
      private function ShowMainMenu() : void
      {
         this.changeEnvironment("MainMenu");
         sounds.vol = 0;
         this.mainmenu.visible = true;
         this.InspirationItem(null,false,O.names[int(O.names.length * Math.random())]);
         this.loadWorldSettings();
      }
      
      private function loadWorldSettings() : void
      {
         var _loc1_:Array = null;
         _loc1_ = Settings.loadWorldSettings();
         if(_loc1_[0])
         {
            World.toggleSlomo = parseInt(_loc1_[0],10);
         }
         if(_loc1_[1])
         {
            World.toggleRagdollBreak = parseInt(_loc1_[1],10);
         }
         if(_loc1_[2])
         {
            World.toggleJointBreak = parseInt(_loc1_[2],10);
         }
         if(_loc1_[3])
         {
            World.toggleObjectBreak = parseInt(_loc1_[3],10);
         }
         if(_loc1_[4])
         {
            World.toggleContact = 1;
         }
         if(_loc1_[5])
         {
            World.toggleSounds = 1;
         }
         if(_loc1_[7])
         {
            World.toggleStabi = parseInt(_loc1_[7],10);
         }
         if(_loc1_[8])
         {
            World.toggleGore = parseInt(_loc1_[8],10);
         }
         if(_loc1_[9])
         {
            World.toggleHealthbars = parseInt(_loc1_[9],10);
         }
         if(_loc1_[10])
         {
            World.toggleJoints = parseInt(_loc1_[10],10);
         }
         if(_loc1_[11])
         {
            World.toggleBlueprint = parseInt(_loc1_[11],10);
         }
         if(_loc1_[12])
         {
            World.toggleTemperature = parseInt(_loc1_[12],10);
         }
         if(_loc1_[13])
         {
            World.toggleFahrenheit = parseInt(_loc1_[13],10);
         }
         if(_loc1_[14])
         {
            World.toggleAutorespawn = parseInt(_loc1_[14],10);
         }
         if(_loc1_[15])
         {
            World.toggleGrid = parseInt(_loc1_[15],10);
         }
         if(_loc1_[16])
         {
            World.toggleSmoothBlood = parseInt(_loc1_[16],10);
         }
         if(_loc1_[17])
         {
            World.togglePhysicsBlood = parseInt(_loc1_[17],10);
         }
         if(_loc1_[18])
         {
            World.toggleStrongDolls = 1;
         }
         if(_loc1_[19])
         {
            World.toggleBodypartGibs = parseInt(_loc1_[19],10);
         }
         if(_loc1_[20])
         {
            World.toggleBackground = 1;
         }
         if(_loc1_[21])
         {
            World.toggleEdgePan = parseInt(_loc1_[21],10);
         }
         if(_loc1_[22])
         {
            Tweak.toolRadius = parseInt(_loc1_[22],10);
         }
         if(_loc1_[23])
         {
            Tweak.toolSpeed = parseInt(_loc1_[23],10);
         }
         if(_loc1_[24])
         {
            Tweak.toolSpread = parseInt(_loc1_[24],10);
         }
         if(_loc1_[25])
         {
            Tweak.toolProjectiles = parseInt(_loc1_[25],10);
         }
         if(_loc1_[26])
         {
            World.toggleDollSleep = parseInt(_loc1_[26],10);
         }
         if(_loc1_[27])
         {
            World.toggleCutFilter = parseInt(_loc1_[27],10);
         }
         if(_loc1_[28])
         {
            World.toggleVelocity = parseInt(_loc1_[28],10);
         }
         if(_loc1_[29])
         {
            World.toggleRadius = parseInt(_loc1_[29],10);
         }
         if(_loc1_[30])
         {
            World.toggleToolbox = parseInt(_loc1_[30],10);
         }
         if(_loc1_[31])
         {
            World.rightClick = parseInt(_loc1_[31],10);
         }
         if(_loc1_[32])
         {
            World.toggleExtraGore = parseInt(_loc1_[32],10);
         }
         if(_loc1_[33])
         {
            World.toggleDollbars = parseInt(_loc1_[33],10);
         }
         if(_loc1_[34])
         {
            World.toggleDollicons = parseInt(_loc1_[34],10);
         }
         if(_loc1_[35])
         {
            World.toggleSpawnBG = parseInt(_loc1_[35],10);
         }
         if(_loc1_[36])
         {
            World.firstRunGeneric = parseInt(_loc1_[36],10);
         }
         if(_loc1_[37])
         {
            World.toggleShrapnel = parseInt(_loc1_[37],10);
         }
         if(_loc1_[38])
         {
            World.toggleJointsPause = parseInt(_loc1_[38],10);
         }
         if(_loc1_[39])
         {
            Tweak.toolThrowRadius = parseInt(_loc1_[39],10);
         }
         if(_loc1_[40])
         {
            Tweak.toolDuration = parseInt(_loc1_[40],10);
         }
         if(_loc1_[41])
         {
            Tweak.toolEffectRadius = parseInt(_loc1_[41],10);
         }
         if(_loc1_[42])
         {
            sounds.UISound = parseInt(_loc1_[42],10) == 1;
         }
         if(_loc1_[43])
         {
            World.toggleResetConfirm = parseInt(_loc1_[43],10);
         }
         if(_loc1_[44])
         {
            World.toggleLinkPause = parseInt(_loc1_[44],10);
         }
         if(_loc1_[45])
         {
            World.toggleLinkSelected = parseInt(_loc1_[45],10);
         }
         if(_loc1_[46])
         {
            World.toggleGibsGib = parseInt(_loc1_[46],10);
         }
         if(_loc1_[47])
         {
            World.toggleEdgeStick = parseInt(_loc1_[47],10);
         }
         if(_loc1_[48])
         {
            World.togglePreciseEffects = parseInt(_loc1_[48],10);
         }
         if(_loc1_[49])
         {
            World.toggleSelectionGlow = parseInt(_loc1_[49],10);
         }
         if(_loc1_[50])
         {
            World.toggleJointSelected = parseInt(_loc1_[50],10);
         }
         if(_loc1_[51])
         {
            World.toggleDarkMode = parseInt(_loc1_[51],10);
         }
         if(_loc1_[52])
         {
            World.scrollWheel = parseInt(_loc1_[52],10);
         }
         if(_loc1_[53])
         {
            World.toggleFloorPan = parseInt(_loc1_[53],10);
         }
         if(_loc1_[54])
         {
            World.toggleFullscreen = parseInt(_loc1_[54],10);
         }
         this.SetFullscreen(World.toggleFullscreen);
         if(_loc1_[55])
         {
            World.toggleScaleMode = parseInt(_loc1_[55],10);
         }
         this.SetStageScaleMode(World.toggleScaleMode == 1);
         if(_loc1_[56])
         {
            World.toggleJointsAlive = parseInt(_loc1_[56],10);
         }
         if(_loc1_[57])
         {
            World.toggleArmourbars = parseInt(_loc1_[57],10);
         }
         if(_loc1_[58])
         {
            Tweak.GridSize = parseInt(_loc1_[58],10);
         }
         if(_loc1_[59])
         {
            Tweak.AntiFreezeFPS = parseInt(_loc1_[59],10);
         }
         if(_loc1_[60])
         {
            Tweak.UIScale = parseFloat(_loc1_[60]) * 0.01;
         }
         if(_loc1_[61])
         {
            World.toggleCulling = parseInt(_loc1_[61],10);
         }
         if(_loc1_[62])
         {
            World.doubleClickSelect = parseInt(_loc1_[62],10);
         }
         GameState.contact = World.toggleContact == 1;
         sounds.enabled = World.toggleSounds == 1;
         if(World.toggleSpawnBG == 0)
         {
            if(GameState.ui.menuSpawn)
            {
               GameState.ui.menuSpawn.dulin = null;
            }
         }
         Physics.contactFilter.shrapnel = World.toggleCutFilter == 0;
      }
      
      private function loadSettings() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Number = NaN;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Rectangle = null;
         var _loc7_:Array = null;
         _loc1_ = Settings.loadSettings();
         if(_loc1_[0])
         {
            _loc2_ = Number(_loc1_[0]);
            _loc3_ = TimeLord.speed == 0;
            Vars.speed = _loc2_ * 0.01;
            TimeLord.speed = _loc2_ * 0.01;
            if(_loc3_)
            {
               TimeLord.pause();
            }
         }
         if(_loc1_[1])
         {
            _loc2_ = Number(_loc1_[1]);
            Vars.particles = _loc2_ * 0.01;
         }
         if(_loc1_[2])
         {
            _loc2_ = Number(_loc1_[2]);
            if(isNaN(_loc2_))
            {
               _loc2_ = 20;
            }
            sounds.vol = _loc2_ * 0.01;
         }
         if(_loc1_[3])
         {
            stage.quality = _loc1_[3];
         }
         if(_loc1_[4])
         {
            _loc2_ = Number(_loc1_[4]);
            Vars.slowspeed = _loc2_ * 0.01;
         }
         if(_loc1_[5])
         {
            _loc2_ = Number(_loc1_[5]);
            Vars.barscale = _loc2_ * 0.01;
         }
         if(_loc1_[6])
         {
            _loc2_ = Number(_loc1_[6]);
            Vars.dragEditor = _loc2_ * 0.01;
         }
         if(_loc1_[7])
         {
            _loc2_ = Number(_loc1_[7]);
            Vars.dragDoll = _loc2_ * 0.01;
         }
         if(_loc1_[8])
         {
            _loc2_ = Number(_loc1_[8]);
            Vars.cameraAcceleration = _loc2_ * 0.01;
         }
         if(_loc1_[9])
         {
            _loc2_ = Number(_loc1_[9]);
            Vars.particlesMax = _loc2_;
         }
         if(_loc1_[10])
         {
            _loc2_ = int(_loc1_[10]);
            Tweak.m_iterations = _loc2_;
         }
         if(_loc1_[11])
         {
            _loc2_ = int(_loc1_[11]);
            Tweak.MinShrapnelSize = _loc2_ * 0.01;
         }
         if(_loc1_[12])
         {
            _loc2_ = int(_loc1_[12]);
            Vars.cutlimit = _loc2_;
         }
         if(_loc1_[13])
         {
            _loc2_ = int(_loc1_[13]);
            Vars.edgePanDelay = _loc2_;
         }
         if(_loc1_[14])
         {
            _loc2_ = int(_loc1_[14]);
            Tweak.smoothBloodSize = _loc2_;
         }
         if(_loc1_[15])
         {
            _loc2_ = _loc1_[15] * 0.01;
            Tweak.bloodSmoothing = _loc2_;
         }
         if(Capabilities.playerType.toLowerCase().indexOf("desktop") != -1)
         {
            if(stage.nativeWindow)
            {
               _loc4_ = int(_loc1_[16]);
               _loc5_ = int(_loc1_[17]);
               _loc6_ = Screen.mainScreen.bounds;
               if(!_loc4_)
               {
                  _loc4_ = (_loc6_.width - stage.nativeWindow.width) * 0.5;
               }
               if(!_loc5_)
               {
                  _loc5_ = (_loc6_.height - stage.nativeWindow.height) * 0.5;
               }
               stage.nativeWindow.x = _loc4_;
               stage.nativeWindow.y = _loc5_;
               _loc7_ = Screen.getScreensForRectangle(stage.nativeWindow.bounds);
               if(_loc7_.length == 0)
               {
                  stage.nativeWindow.x = (_loc6_.width - stage.nativeWindow.width) * 0.5;
                  stage.nativeWindow.y = (_loc6_.height - stage.nativeWindow.height) * 0.5;
               }
            }
         }
         if(_loc1_[18])
         {
            _loc2_ = Number(_loc1_[18]);
            Vars.collisionsMax = _loc2_;
         }
         if(_loc1_[19])
         {
            _loc2_ = Number(_loc1_[19]);
            Vars.loadSpeed = _loc2_;
         }
         if(_loc1_[20])
         {
            _loc2_ = Number(_loc1_[20]);
            Vars.wheelSpeed = _loc2_ * 0.01;
         }
         this.updateToggles();
         this.resetSpawnSettings();
      }
      
      private function loadPowers() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:String = null;
         _loc1_ = Settings.loadPowers();
         if(_loc1_.length == 0)
         {
            _loc1_ = Tool.elementals.slice();
         }
         Powers.favPowers = _loc1_;
         if(Powers.favPowers != Tool.elementals)
         {
            if(!_loc1_.ForcePowerAutoUpdate || String(_loc1_.ForcePowerAutoUpdate) != String(this.PowerAutoUpdate))
            {
               _loc2_ = [];
               for each(_loc3_ in _loc2_)
               {
                  if(Powers.favPowers.indexOf(_loc3_) == -1)
                  {
                     Powers.favPowers.unshift(_loc3_);
                  }
               }
            }
         }
      }
      
      private function loadCustomItems(param1:Boolean = false) : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         _loc2_ = Settings.loadCustomItems(param1);
         if(Boolean(_loc2_.items) && Boolean(_loc2_.names))
         {
            this.customItems = [];
            _loc3_ = _loc2_.names;
            _loc4_ = _loc2_.items;
            _loc5_ = _loc4_.split("|");
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               this.customItems.push(_loc5_[_loc6_]);
               _loc6_++;
            }
            this.customNames = _loc3_.split("|");
         }
      }
      
      private function loadCustomItemsBackup() : void
      {
         this.loadCustomItems(true);
         this.updateLibrary();
      }
      
      private function loadLocalSaves() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         _loc1_ = Settings.loadLocalSaves();
         _loc2_ = [];
         _loc3_ = [];
         _loc4_ = [];
         if(_loc1_.reset)
         {
            this.favouriteSaveReset = int(_loc1_.reset);
         }
         if(_loc1_.recovery)
         {
            _loc2_ = String(_loc1_.recovery).split("|");
         }
         if(_loc1_.saves)
         {
            _loc3_ = String(_loc1_.saves).split("|");
         }
         if(_loc1_.names)
         {
            _loc4_ = String(_loc1_.names).split("|");
         }
         this.qSaveArray = [];
         this.qSaveTimeArray = [];
         this.favouriteSaves = [];
         this.favouriteSaveNames = [];
         for each(_loc5_ in _loc2_)
         {
            this.qSaveArray.push(Base64.uncompress(_loc5_));
            this.qSaveTimeArray.push(0);
         }
         if(this.qSaveArray.length > 0)
         {
            this.currentSave = this.qSaveArray[0];
         }
         _loc6_ = 0;
         while(_loc6_ < _loc3_.length)
         {
            this.favouriteSaves.push(Base64.uncompress(_loc3_[_loc6_]));
            this.favouriteSaveNames.push(_loc4_[_loc6_]);
            _loc6_++;
         }
         if(!O.needsUpdating)
         {
            GameState.ui.showTooltip(GameState.ui.menuFavourite,"Loaded from file.\n",0,1000,GameState.ui.menuFavourite.actualWidth);
         }
      }
      
      private function loadMenus() : void
      {
         var _loc1_:Object = null;
         _loc1_ = Settings.loadMenus();
         if(_loc1_.menuMainX)
         {
            GameState.ui.menuMain.undocked = true;
            GameState.ui.menuMain.x = _loc1_.menuMainX;
            GameState.ui.menuMain.y = _loc1_.menuMainY;
         }
         if(_loc1_.menuControlsX)
         {
            GameState.ui.menuControls.undocked = true;
            GameState.ui.menuControls.x = _loc1_.menuControlsX;
            GameState.ui.menuControls.y = _loc1_.menuControlsY;
         }
         if(_loc1_.menuSettingsX)
         {
            GameState.ui.menuSettings.undocked = true;
            GameState.ui.menuSettings.x = _loc1_.menuSettingsX;
            GameState.ui.menuSettings.y = _loc1_.menuSettingsY;
         }
         if(_loc1_.menuObjectX)
         {
            GameState.ui.menuObject.undocked = true;
            GameState.ui.menuObject.x = _loc1_.menuObjectX;
            GameState.ui.menuObject.y = _loc1_.menuObjectY;
         }
         if(_loc1_.menuSaveX)
         {
            GameState.ui.menuSave.undocked = true;
            GameState.ui.menuSave.x = _loc1_.menuSaveX;
            GameState.ui.menuSave.y = _loc1_.menuSaveY;
         }
         if(_loc1_.menuSpawnX)
         {
            GameState.ui.menuSpawn.undocked = true;
            GameState.ui.menuSpawn.x = _loc1_.menuSpawnX;
            GameState.ui.menuSpawn.y = _loc1_.menuSpawnY;
         }
         if(_loc1_.menuLibraryX)
         {
            GameState.ui.menuLibrary.undocked = true;
            GameState.ui.menuLibrary.x = _loc1_.menuLibraryX;
            GameState.ui.menuLibrary.y = _loc1_.menuLibraryY;
         }
         if(_loc1_.menuEffectsX)
         {
            GameState.ui.menuEffects.undocked = true;
            GameState.ui.menuEffects.x = _loc1_.menuEffectsX;
            GameState.ui.menuEffects.y = _loc1_.menuEffectsY;
         }
         if(_loc1_.menuToolsX)
         {
            GameState.ui.menuTools.undocked = true;
            GameState.ui.menuTools.x = _loc1_.menuToolsX;
            GameState.ui.menuTools.y = _loc1_.menuToolsY;
         }
         if(_loc1_.menuWorldX)
         {
            GameState.ui.menuWorld.undocked = true;
            GameState.ui.menuWorld.x = _loc1_.menuWorldX;
            GameState.ui.menuWorld.y = _loc1_.menuWorldY;
         }
         if(_loc1_.menuColourX)
         {
            GameState.ui.menuColour.undocked = true;
            GameState.ui.menuColour.x = _loc1_.menuColourX;
            GameState.ui.menuColour.y = _loc1_.menuColourY;
         }
         if(_loc1_.spawnSize)
         {
            this.spawnMenuSize = int(_loc1_.spawnSize);
            GameState.ui.initSpawnMenu(this.spawnMenuSize);
         }
         if(Boolean(_loc1_.menuControlsX) && GameState.ui.menuControls.x > 400)
         {
            GameState.ui.menuControls.x -= 94;
         }
         if(Boolean(_loc1_.menuMainX) && GameState.ui.menuMain.x > 400)
         {
            GameState.ui.menuMain.x -= 124;
         }
      }
      
      public function loadLocalItems(param1:Boolean = true) : void
      {
         var item:String = null;
         var titem:Object = null;
         var iname:String = null;
         var exists:Boolean = false;
         var vers:Array = null;
         var cols:Array = null;
         var props:Array = null;
         var alps:Array = null;
         var i:int = 0;
         var shapes:Array = null;
         var centre:Array = null;
         var centroid:b2Vec2 = null;
         var layer:Object = null;
         var l:int = 0;
         var v:int = 0;
         var currentProps:Array = null;
         var propo:ShapeUserData = null;
         var funcxml:XML = null;
         var vertices:Array = null;
         var verticesCount:int = 0;
         var j:int = 0;
         var coords:Array = null;
         var newitem:Item = null;
         var loadFromFile:Boolean = param1;
         if(loadFromFile)
         {
            this.localItems = Settings.loadLocalItems();
            if(Capabilities.playerType == "Desktop")
            {
               IO.LoadExternalModels();
            }
         }
         for each(item in this.localItems)
         {
            titem = JSON.parse(item);
            iname = titem.ItemName;
            if(!iname)
            {
               iname = titem.Title;
            }
            if(!iname)
            {
               iname = "Local Model " + this.localNames.length;
            }
            exists = O.getItem(iname) != null;
            if(exists)
            {
               if(this.localNames.indexOf(iname) == -1)
               {
                  this.localNames.push(iname);
               }
            }
            else
            {
               if(titem.Layers)
               {
                  titem.Vertices = "";
                  titem.Colours = "";
                  titem.ShapeProperties = "";
                  titem.Alphas = "";
                  l = int(titem.Layers.length);
                  i = 0;
                  while(i < l)
                  {
                     layer = titem.Layers[i];
                     v = 0;
                     while(v < layer.Vertices.length)
                     {
                        titem.Vertices += layer.Vertices[v].x + "," + layer.Vertices[v].y;
                        if(v < layer.Vertices.length - 1)
                        {
                           titem.Vertices += ";";
                        }
                        v++;
                     }
                     titem.Colours += layer.Fill;
                     titem.ShapeProperties += layer.Properties.join(",");
                     titem.Alphas += layer.Alpha;
                     if(i < l - 1)
                     {
                        titem.Vertices += "|";
                        titem.Colours += ",";
                        titem.ShapeProperties += ";";
                        titem.Alphas += ",";
                     }
                     i++;
                  }
               }
               vers = [];
               cols = titem.Colours.split(",");
               props = titem.ShapeProperties.split(";");
               alps = [1];
               if(titem.Alphas)
               {
                  alps = titem.Alphas.split(",");
               }
               i = 0;
               while(i < cols.length)
               {
                  currentProps = props[i].split(",");
                  propo = Properties.shapeProperties(cols[i]);
                  if(currentProps.indexOf("Sharp") != -1)
                  {
                     propo.sharp = true;
                  }
                  if(currentProps.indexOf("Sticky") != -1)
                  {
                     propo.sticky = true;
                  }
                  if(currentProps.indexOf("Decorative") != -1)
                  {
                     propo.decorative = true;
                  }
                  if(currentProps.indexOf("Invisible") != -1)
                  {
                     propo.invisible = true;
                  }
                  if(currentProps.indexOf("Drag") != -1)
                  {
                     propo.sensor = true;
                  }
                  cols[i] = propo;
                  i++;
               }
               shapes = titem.Vertices.split("|");
               centre = [0,0];
               if(titem.PhysicsCentre)
               {
                  centre = titem.PhysicsCentre.split(",");
               }
               try
               {
                  if(Boolean(titem.Functionality) && String(titem.Functionality).substr(0,5) == "<node")
                  {
                     funcxml = new XML(titem.Functionality);
                     if(funcxml.hasOwnProperty("@useGraphicsCentre") && funcxml.@useGraphicsCentre == "true")
                     {
                        if(titem.Centre)
                        {
                           centre = titem.Centre.split(",");
                        }
                     }
                  }
               }
               catch(e:*)
               {
               }
               centroid = new b2Vec2(centre[0],centre[1]);
               i = 0;
               while(i < cols.length)
               {
                  vertices = shapes[i].split(";");
                  verticesCount = int(vertices.length);
                  vers[i] = [];
                  j = 0;
                  while(j < verticesCount)
                  {
                     coords = vertices[j].split(",");
                     vers[i].push(new b2Vec2(coords[0],coords[1]));
                     j++;
                  }
                  if(!(cols[i] is ShapeUserData && ShapeUserData(cols[i]).decorative))
                  {
                     vers[i] = BoxUtils.arrangeClockwise(vers[i]);
                  }
                  j = 0;
                  while(j < verticesCount)
                  {
                     vers[i][j] = [vers[i][j].x - centroid.x,vers[i][j].y - centroid.y];
                     j++;
                  }
                  i++;
               }
               if(titem.Flip == "true")
               {
                  vers = GeneralUtils.flipArray(vers);
               }
               if(iname)
               {
                  newitem = O.addItem(iname,titem.Scale,cols,vers,alps);
                  if(newitem)
                  {
                     if(this.localNames.indexOf(iname) == -1)
                     {
                        this.localNames.push(iname);
                     }
                     if(titem.Creator != "rava")
                     {
                        newitem.creator = titem.Creator;
                     }
                  }
               }
            }
         }
      }
      
      private function loadFavourites() : void
      {
         this.favourites = Settings.loadFavourites();
      }
      
      private function startPumpkinDefence(param1:Event) : void
      {
         this.beginPlay();
         this.changeEnvironment("pumpkindefence");
      }
      
      private function startPumpkinOffence(param1:Event) : void
      {
         this.beginPlay();
         this.changeEnvironment("pumpkinoffence");
      }
      
      private function startPumpkinMoon(param1:Event) : void
      {
         this.beginPlay();
         this.changeEnvironment("pumpkinmoon");
      }
      
      private function startWinterHitList(param1:Event) : void
      {
         this.beginPlay();
         this.changeEnvironment("winterhitlist");
      }
      
      private function InspirationItem(param1:Event, param2:* = true, param3:String = "") : void
      {
         var _loc4_:Item = null;
         var _loc5_:* = undefined;
         var _loc6_:Sprite = null;
         var _loc7_:MovieClip = null;
         if(!this.mainmenu.getChildByName("itemshowcase"))
         {
            return;
         }
         _loc4_ = O.items[int(O.items.length * Math.random())];
         if(param3 != "")
         {
            _loc4_ = O.getItem(param3);
         }
         _loc5_ = GeneralUtils.objectToName(_loc4_.name);
         _loc6_ = _loc4_.updateGraphic();
         while(!_loc5_ || _loc5_ == "" || _loc6_.width > 200)
         {
            _loc4_ = O.items[int(O.items.length * Math.random())];
            _loc5_ = GeneralUtils.objectToName(_loc4_.name);
            _loc6_ = _loc4_.updateGraphic();
         }
         _loc6_.x -= _loc6_.width * 0.5;
         _loc6_.y -= _loc6_.height * 0.5;
         _loc7_ = MovieClip(this.mainmenu.getChildByName("itemshowcase"));
         if(_loc7_.getChildByName("inspiration"))
         {
            _loc7_.removeChild(_loc7_.getChildByName("inspiration"));
         }
         _loc7_.addChildAt(_loc6_,0).name = "inspiration";
         TextField(this.mainmenu.getChildByName("itemname")).text = _loc5_;
         if(Boolean(param2) && GameState.environment is MainMenu)
         {
            MainMenu(GameState.environment).SetItem(_loc4_.name);
         }
      }
      
      private function beginPlay() : void
      {
         var itemTree:Tree = null;
         var foundNode:TNode = null;
         var nodeIndex:int = 0;
         this.mainmenu.mouseEnabled = false;
         this.mainmenu.mouseChildren = false;
         this.mainmenu.visible = false;
         GameState.ui.menuMain.alpha = 1;
         GameState.ui.menuControls.alpha = 1;
         GameState.ui.menuTools.close();
         GameState.ui.menuMain.open();
         GameState.ui.menuControls.open();
         if(GameState.environment is MainMenu)
         {
            this.reset();
            this.changeEnvironment("lab");
            GameState.ui.updateVolume(null);
            GameState.environmenting = false;
         }
         GameState.ui.menuLibrary.visible = false;
         if(this.loadedLevel == "")
         {
            this.reset();
         }
         if(!GameState.isCapable)
         {
            GameState.ui.capabilityPopup();
         }
         GameState.ui.menuSettings.forceClosed();
         stage.focus = stage;
         try
         {
            GameState.steamworks.init(stage);
         }
         catch(e:Error)
         {
            GameState.ui.menuPrompt.title = "Steamworks Error";
            GameState.ui.menuPrompt.getField("info").text = "Steamworks init failed.\n" + e.errorID + " " + e.name + " " + e.message + " " + e.getStackTrace();
            GameState.ui.menuPrompt.unlock();
            GameState.ui.menuPrompt.getField("info").type = TextFieldType.DYNAMIC;
            GameState.ui.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_done);
            GameState.ui.menuPrompt.visible = true;
            GameState.ui.menuPrompt.unlock();
            GameState.ui.menuPrompt.moveToTop();
            GameState.ui.menuPrompt.center();
            GameState.ui.menuPrompt.lock();
         }
         if(Capabilities.playerType == "Desktop")
         {
            IO.LoadExternalModels();
         }
         if(World.firstRunCurrent != GameState.version)
         {
            World.firstRunCurrent = GameState.version;
            Settings.saveSettings();
            GameState.ui.menuSpawn.open();
            GameState.ui.menuLibrary.open();
            itemTree = GameState.ui.menuLibrary.getTree("buttons");
            foundNode = itemTree.findNode("label","B-Beam Gun");
            nodeIndex = itemTree.showNode(foundNode);
            if(nodeIndex != -1)
            {
               itemTree.selectedIndex = nodeIndex;
               itemTree.scrollToSelected();
               GameState.ui.selectItem(itemTree.selectedItem);
            }
            GameState.ui.showTooltip(GameState.ui.menuLibrary,"Guns Guns Guns Update!\n\nEven more guns as well as\nGunsmithing in Detail tool.\n",1000,8000,GameState.ui.menuLibrary.actualWidth);
         }
      }
      
      public function closeMainMenu() : void
      {
         this.mainmenu.mouseEnabled = false;
         this.mainmenu.mouseChildren = false;
         this.mainmenu.visible = false;
         if(GameState.environment is MainMenu)
         {
            this.reset();
            this.changeEnvironment("lab");
            GameState.ui.updateVolume(null);
            GameState.environmenting = false;
         }
      }
      
      public function handleTreeClick(param1:ListEvent) : *
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:File = null;
         var _loc6_:Tree = null;
         var _loc7_:TNode = null;
         var _loc8_:int = 0;
         var _loc9_:Array = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:Array = null;
         var _loc13_:* = undefined;
         var _loc14_:b2Body = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:ToolTip = null;
         var _loc18_:Tree = null;
         var _loc19_:int = 0;
         if(param1.item is LeafNode)
         {
            if(param1.item.toggleValue)
            {
               if(param1.item.toggleValue == "0")
               {
                  param1.item.toggleValue = "1";
                  param1.item.forceDrawNode();
               }
               else if(param1.item.toggleValue == "1")
               {
                  param1.item.toggleValue = "0";
                  param1.item.forceDrawNode();
               }
               _loc2_ = param1.item.label;
               _loc3_ = int(param1.item.toggleValue);
               if(_loc2_.substr(0,4) == "Stic")
               {
                  Properties.forceObjStick = param1.item.toggleValue;
               }
               else if(_loc2_ == "Alive ")
               {
                  Properties.forceObjAlive = _loc3_;
               }
               else if(_loc2_ == "Sharp ")
               {
                  Properties.forceObjSharp = _loc3_;
               }
               else if(_loc2_ == "Dull ")
               {
                  Properties.forceObjBlunt = _loc3_;
               }
               else if(_loc2_ == "Sticky ")
               {
                  Properties.forceObjStick = _loc3_;
               }
               else if(_loc2_ == "Breakable ")
               {
                  Properties.forceObjCrumb = _loc3_;
               }
               else if(_loc2_ == "Brittle ")
               {
                  Properties.forceObjBritt = _loc3_;
               }
               else if(_loc2_ == "Explosive ")
               {
                  Properties.forceObjExplo = _loc3_;
               }
               else if(_loc2_ == "Implosive ")
               {
                  Properties.forceObjImplo = _loc3_;
               }
               else if(_loc2_ == "Ghost ")
               {
                  Properties.forceObjGhost = _loc3_;
               }
               else if(_loc2_ == "Stainless ")
               {
                  Properties.forceObjStain = _loc3_;
               }
               else if(_loc2_ == "Invisible ")
               {
                  Properties.forceObjInvis = _loc3_;
               }
               else if(_loc2_ == "Static ")
               {
                  Properties.forceObjStatic = _loc3_;
               }
               else if(_loc2_ == "Dispel")
               {
                  Properties.forceObjDispel = _loc3_;
               }
               else if(_loc2_ == "Drain")
               {
                  Properties.forceObjDrain = _loc3_;
               }
               else if(_loc2_ == "Burn")
               {
                  Properties.forceObjFlame = _loc3_;
               }
               else if(_loc2_ == "Freeze")
               {
                  Properties.forceObjFreeze = _loc3_;
               }
               else if(_loc2_ == "Repel")
               {
                  Properties.forceObjGust = _loc3_;
               }
               else if(_loc2_ == "Heal")
               {
                  Properties.forceObjHeal = _loc3_;
               }
               else if(_loc2_ == "Deadly")
               {
                  Properties.forceObjKill = _loc3_;
               }
               else if(_loc2_ == "Poison")
               {
                  Properties.forceObjPoison = _loc3_;
               }
               else if(_loc2_ == "Shock")
               {
                  Properties.forceObjShock = _loc3_;
               }
               else if(_loc2_ == "Anti-Gravity")
               {
                  Properties.forceObjAGrav = _loc3_;
               }
               else if(_loc2_ == "Zero-Gravity")
               {
                  Properties.forceObjZGrav = _loc3_;
               }
               else if(_loc2_ == "Sleep ")
               {
                  Properties.forceObjSleep = _loc3_;
               }
               else if(_loc2_ == "Unbreakable ")
               {
                  Properties.forceObjUnBreak = _loc3_;
               }
               else if(_loc2_ == "Vanilla ")
               {
                  Properties.forceObjVanilla = _loc3_;
               }
               else if(_loc2_ == "Flammable ")
               {
                  Properties.forceObjFlamm = _loc3_;
               }
               else if(_loc2_ == "Fixed Rotation ")
               {
                  Properties.forceObjFixed = _loc3_;
               }
               else if(_loc2_ == "Rend")
               {
                  Properties.forceObjRending = _loc3_;
               }
               else if(_loc2_ == "Transferring")
               {
                  Properties.forceObjAlchemying = _loc3_;
               }
               else if(_loc2_ == "Transmute")
               {
                  Properties.forceObjTransmuting = _loc3_;
               }
               else if(_loc2_ == "Critical Hit!")
               {
                  Properties.forceObjCritting = _loc3_;
               }
               else if(_loc2_ == "Deleting")
               {
                  Properties.forceObjDeleting = _loc3_;
               }
               else if(_loc2_ == "Triggering")
               {
                  Properties.forceObjTriggering = _loc3_;
               }
               else if(_loc2_ == "Relaying")
               {
                  Properties.forceObjRelaying = _loc3_;
               }
               else if(_loc2_ == "Cleaning")
               {
                  Properties.forceObjCleaning = _loc3_;
               }
               else if(_loc2_ == "Janitor")
               {
                  Properties.forceObjJanitoring = _loc3_;
               }
               else if(_loc2_ == "Hype")
               {
                  Properties.forceObjHyping = _loc3_;
               }
               else if(_loc2_ == "Stasis")
               {
                  Properties.forceObjSuspending = _loc3_;
               }
               else if(_loc2_ == "Banish")
               {
                  Properties.forceObjBanning = _loc3_;
               }
               else if(_loc2_ == "Blight")
               {
                  Properties.forceObjBlighting = _loc3_;
               }
               else if(_loc2_ == "Resist Bullets")
               {
                  Properties.forceObjBulletproof = _loc3_;
               }
               else if(_loc2_ == "Resist Ghosting")
               {
                  Properties.forceResGhosting = _loc3_;
               }
               else if(_loc2_ == "Resist Protect")
               {
                  Properties.forceResProtect = _loc3_;
               }
               else if(_loc2_ == "Resist Adrenaline")
               {
                  Properties.forceResAdrenaline = _loc3_;
               }
               else if(_loc2_ == "Resist Arc")
               {
                  Properties.forceResArc = _loc3_;
               }
               else if(_loc2_ == "Resist Gravity")
               {
                  Properties.forceResGravity = _loc3_;
               }
               else if(_loc2_ == "Resist Droning")
               {
                  Properties.forceResDroning = _loc3_;
               }
               else if(_loc2_ == "Resist Snare")
               {
                  Properties.forceResSnare = _loc3_;
               }
               else if(_loc2_ == "Concuss")
               {
                  Properties.forceObjConcussing = _loc3_;
               }
               else if(_loc2_ == "Cauterize")
               {
                  Properties.forceObjCauterizing = _loc3_;
               }
               else if(_loc2_ == "Regeneration")
               {
                  Properties.forceObjRegeneration = _loc3_;
               }
               else if(_loc2_ == "Powder")
               {
                  Properties.forceObjDisintegrator = _loc3_;
               }
               else if(_loc2_ == "Disintegrating")
               {
                  Properties.forceObjDisintegrating = _loc3_;
               }
               else if(_loc2_ == "Sandstone")
               {
                  Properties.forceObjDrying = _loc3_;
               }
               else if(_loc2_ == "Frostfire")
               {
                  Properties.forceObjFrostfiring = _loc3_;
               }
               else if(_loc2_ == "Deepfry")
               {
                  Properties.forceObjFrying = _loc3_;
               }
               else if(_loc2_ == "Wet")
               {
                  Properties.forceObjWetting = _loc3_;
               }
               else if(_loc2_ == "Glass")
               {
                  Properties.forceObjGlassing = _loc3_;
               }
               else if(_loc2_ == "Glitch")
               {
                  Properties.forceObjGlitching = _loc3_;
               }
               else if(_loc2_ == "Magnetic")
               {
                  Properties.forceObjMagnetic = _loc3_;
               }
               else if(_loc2_ == "Oily")
               {
                  Properties.forceObjOily = _loc3_;
               }
               else if(_loc2_ == "Petrify")
               {
                  Properties.forceObjPetrifying = _loc3_;
               }
               else if(_loc2_ == "Radioactive")
               {
                  Properties.forceObjRadioactive = _loc3_;
               }
               else if(_loc2_ == "Lacerate")
               {
                  Properties.forceObjSanguine = _loc3_;
               }
               else if(_loc2_ == "Scorch")
               {
                  Properties.forceObjScorching = _loc3_;
               }
               else if(_loc2_ == "Ultrasharp")
               {
                  Properties.forceObjUltrasharp = _loc3_;
               }
               else if(_loc2_ == "Trigger On Cut")
               {
                  Properties.forceObjTriggerOnCut = _loc3_;
               }
               else if(_loc2_ == "Linked Only")
               {
                  Properties.forceObjLinkedOnly = _loc3_;
               }
               else if(_loc2_ == "Linked Also")
               {
                  Properties.forceObjLinkedAlso = _loc3_;
               }
               else if(_loc2_ == "Warming")
               {
                  Properties.forceObjWarming = _loc3_;
               }
               else if(_loc2_ == "Webbing")
               {
                  Properties.forceObjWebbing = _loc3_;
               }
               else if(_loc2_ == "Spreading")
               {
                  Properties.forceObjSpreading = _loc3_;
               }
               else if(_loc2_ == "Resist Banning")
               {
                  Properties.forceResBanning = _loc3_;
               }
               else if(_loc2_ == "Resist Blight")
               {
                  Properties.forceResBlighting = _loc3_;
               }
               else if(_loc2_ == "Resist Stasis")
               {
                  Properties.forceResStasis = _loc3_;
               }
               else if(_loc2_ == "Resist Transmute")
               {
                  Properties.forceResTransmuting = _loc3_;
               }
               else if(_loc2_ == "Resist Cutting")
               {
                  Properties.forceResCutting = _loc3_;
               }
               else if(_loc2_ == "Resist Breaking")
               {
                  Properties.forceResAliveBreak = _loc3_;
               }
               else if(_loc2_ == "Resist Disintegrating")
               {
                  Properties.forceResDisintegrating = _loc3_;
               }
               else if(_loc2_ == "Resist Sandstone")
               {
                  Properties.forceResDrying = _loc3_;
               }
               else if(_loc2_ == "Resist Frostfire")
               {
                  Properties.forceResFrostfiring = _loc3_;
               }
               else if(_loc2_ == "Resist Fry")
               {
                  Properties.forceResFrying = _loc3_;
               }
               else if(_loc2_ == "Resist Gassy")
               {
                  Properties.forceResGassy = _loc3_;
               }
               else if(_loc2_ == "Resist Glass")
               {
                  Properties.forceResGlassing = _loc3_;
               }
               else if(_loc2_ == "Resist Glitch")
               {
                  Properties.forceResGlitching = _loc3_;
               }
               else if(_loc2_ == "Resist Magnetic")
               {
                  Properties.forceResMagnetic = _loc3_;
               }
               else if(_loc2_ == "Resist Oily")
               {
                  Properties.forceResOily = _loc3_;
               }
               else if(_loc2_ == "Resist Petrify")
               {
                  Properties.forceResPetrifying = _loc3_;
               }
               else if(_loc2_ == "Resist Radiation")
               {
                  Properties.forceResRadioactive = _loc3_;
               }
               else if(_loc2_ == "Resist Scorch")
               {
                  Properties.forceResScorching = _loc3_;
               }
               else if(_loc2_ == "Resist Ultrasharp")
               {
                  Properties.forceResUltrasharp = _loc3_;
               }
               else if(_loc2_ == "Resist Chilling")
               {
                  Properties.forceResChilling = _loc3_;
               }
               else if(_loc2_ == "Resist Warming")
               {
                  Properties.forceResWarming = _loc3_;
               }
               else if(_loc2_ == "Resist Webbing")
               {
                  Properties.forceResWebbing = _loc3_;
               }
               else if(_loc2_ == "Resist Dispel")
               {
                  Properties.forceResDispel = _loc3_;
               }
               else if(_loc2_ == "Resist Drain")
               {
                  Properties.forceResDrain = _loc3_;
               }
               else if(_loc2_ == "Resist Burning")
               {
                  Properties.forceResFlame = _loc3_;
               }
               else if(_loc2_ == "Resist Freezing")
               {
                  Properties.forceResFreeze = _loc3_;
               }
               else if(_loc2_ == "Resist Repel")
               {
                  Properties.forceResGust = _loc3_;
               }
               else if(_loc2_ == "Resist Healing")
               {
                  Properties.forceResHeal = _loc3_;
               }
               else if(_loc2_ == "Resist Deadly")
               {
                  Properties.forceResKill = _loc3_;
               }
               else if(_loc2_ == "Resist Poison")
               {
                  Properties.forceResPoison = _loc3_;
               }
               else if(_loc2_ == "Resist Shocking")
               {
                  Properties.forceResShock = _loc3_;
               }
               else if(_loc2_ == "Resist Concuss")
               {
                  Properties.forceResConcuss = _loc3_;
               }
               else if(_loc2_ == "Resist Wounds")
               {
                  Properties.forceResBleed = _loc3_;
               }
               else if(_loc2_ == "Resist Armour")
               {
                  Properties.forceResArmour = _loc3_;
               }
               else if(_loc2_ == "Resist Joints")
               {
                  Properties.forceResJoints = _loc3_;
               }
               else if(_loc2_ == "Unequip Death")
               {
                  Properties.forceObjJointsDead = _loc3_;
               }
               else if(_loc2_ == "Unequip Concuss")
               {
                  Properties.forceObjJointsConc = _loc3_;
               }
               else if(_loc2_ == "Wall Ghost")
               {
                  Properties.forceObjWallGhost = _loc3_;
               }
               else if(_loc2_ == "Bullet Ghost")
               {
                  Properties.forceObjProjectileGhost = _loc3_;
               }
               _loc4_ = param1.item.toggleValue == "0" ? false : true;
               if(_loc2_ == "Roof")
               {
                  GameState.environment.roof = _loc4_;
               }
               if(_loc2_ == "Sides")
               {
                  GameState.environment.walls = _loc4_;
               }
               if(_loc2_ == "Left")
               {
                  GameState.environment.wallL = _loc4_;
               }
               if(_loc2_ == "Right")
               {
                  GameState.environment.wallR = _loc4_;
               }
               if(_loc2_ == "Floor")
               {
                  GameState.environment.floor = _loc4_;
               }
               if(_loc2_ == "Particles")
               {
                  GameState.environment.particles = _loc4_;
               }
               if(_loc2_ == "Loop")
               {
                  GameState.environment.loop = _loc4_;
               }
               if(_loc2_ == "Filler")
               {
                  GameState.environment.filler = _loc4_;
               }
               if(_loc2_ == "Auto Wind")
               {
                  GameState.environment.autoWind = _loc4_;
                  Vars.wind = Number(GameState.ui.menuWorld.getValue("Wind")) >> 0;
               }
            }
            else if(param1.item.func)
            {
               if(param1.item.func == "models_folder")
               {
                  _loc5_ = File.applicationStorageDirectory.resolvePath("models/");
                  if(!_loc5_.exists)
                  {
                     _loc5_.createDirectory();
                  }
                  _loc5_.openWithDefaultApplication();
               }
               else if(param1.item.func == "models_refresh")
               {
                  this.forceUpdateLibrary();
                  _loc6_ = GameState.ui.menuLibrary.getTree("buttons");
                  _loc7_ = _loc6_.findNode("func","models_refresh");
                  _loc8_ = _loc6_.showNode(_loc7_);
                  GameState.ui.showTooltip(GameState.ui.menuLibrary,"Refreshed item models.\n",0,1000,GameState.ui.menuLibrary.actualWidth);
               }
               else if(param1.item.func == "item_import")
               {
                  IO.lab.loadMultiple();
                  GameState.ui.menuLibrary.close();
               }
               else if(param1.item.func == "resetproperties")
               {
                  Properties.resetProperties();
                  Properties.itemProperties(false,false);
               }
               else if(param1.item.func == "workshopSubscribed")
               {
                  GameState.steamworks.updatingExistingFile = false;
                  GameState.steamworks.workshopContentDownloadFinished = false;
                  GameState.steamworks.workshopContent = [];
                  GameState.steamworks.enumerateSubscribedFiles(GameState.steamworks.onWorkshopContentLoaded);
               }
               else if(param1.item.func == "workshopSave")
               {
                  Settings.saveLocalWorkshop();
               }
               else if(param1.item.func == "openWorkshop")
               {
                  Links.Workshop(param1);
               }
               else if(param1.item.func == "workshopLoad")
               {
                  IO.loadWorld("MAD" + param1.item.content,false,true);
               }
               else if(param1.item.func == "favload")
               {
                  IO.loadWorld(this.favouriteSaves[int(param1.item.id)]);
               }
               else if(param1.item.func == "removefavs")
               {
                  GameState.ui.openFavouriteSaves();
               }
               else if(param1.item.func == "madlab")
               {
                  navigateToURL(new URLRequest("https://rava.games/madlab"),"_blank");
               }
               else if(param1.item.func == "item_list")
               {
                  GameState.ui.openLocalItems();
               }
               else if(param1.item.func == "custom_share")
               {
                  Kongregate.shareCustomItems();
               }
               else if(param1.item.func == "custom_remove")
               {
                  GameState.ui.openCustomItems("remove");
               }
               else if(param1.item.func == "custom_manage")
               {
                  GameState.ui.openCustomItems("manage");
               }
               else if(param1.item.func == "custom_rename")
               {
                  GameState.ui.openCustomItems("rename");
               }
               else if(param1.item.func == "custom_sort")
               {
                  this.sortCustomItems();
               }
               else if(param1.item.func == "custom_create")
               {
                  this.createCustomItem();
               }
               else if(param1.item.func == "reset")
               {
                  this.PlayerReset();
               }
               else if(param1.item.func == "kong")
               {
                  Links.Kong(null);
               }
               else if(param1.item.func == "discord")
               {
                  Links.Discord(null);
               }
               else if(param1.item.func == "twitter")
               {
                  Links.Twitter(null);
               }
               else if(param1.item.func == "steam")
               {
                  Links.Steam(null);
               }
               else if(param1.item.func == "settings")
               {
                  GameState.ui.itemSettings();
               }
               else if(param1.item.func == "defaultSettings")
               {
                  this.resetSpawnSettings();
               }
               else if(param1.item.func == "properties")
               {
                  Properties.itemProperties();
               }
               else if(param1.item.func == "skin")
               {
                  this.itemSkin();
               }
               else if(param1.item.func == "random")
               {
                  _loc9_ = GameState.objects.libraryItems;
                  _loc10_ = _loc9_[int(Math.random() * _loc9_.length)];
                  this.librarySelect(_loc10_,true);
               }
               else if(param1.item.func == "favourite")
               {
                  GameState.ui.menuFavourite.moveToTop();
                  GameState.ui.menuFavourite.center();
                  GameState.ui.menuFavourite.lock();
                  GameState.ui.menuFavourite.open();
                  GameState.ui.menuFavourite.getTree("buttons").openAllNodes();
                  if(GameState.objects.spawnName)
                  {
                     GameState.ui.menuFavourite.title = "Favourite " + GameState.objects.spawnName;
                  }
                  else
                  {
                     GameState.ui.menuFavourite.title = "Favourites";
                  }
               }
               else if(param1.item.func == "customLoad")
               {
                  this.loadCustomItems();
                  if(GameState.ui.menuFavourite.title == "Rename Custom Items")
                  {
                     GameState.ui.updateCustoms("rename");
                  }
                  else if(GameState.ui.menuFavourite.title == "Remove Custom Items")
                  {
                     GameState.ui.updateCustoms("remove");
                  }
               }
               else if(param1.item.func == "customSave")
               {
                  Settings.saveCustomItems();
                  GameState.ui.showTooltip(GameState.ui.menuFavourite,"Saved custom items.\n",0,1000,GameState.ui.menuFavourite.actualWidth);
               }
               else if(param1.item.func == "customBack")
               {
                  GameState.ui.menuFavourite.unlock();
                  GameState.ui.menuFavourite.close();
                  this.updateLibrary();
                  _loc6_ = GameState.ui.menuLibrary.getTree("buttons");
                  _loc7_ = _loc6_.findNode("label","[" + GameState.CustomSort + "]");
                  _loc8_ = _loc6_.showNode(_loc7_);
                  if(_loc8_ != -1)
                  {
                     _loc6_.scrollToSelected();
                  }
               }
               else if(param1.item.func == "localLoad")
               {
                  this.localNames = [];
                  this.loadLocalItems();
                  GameState.ui.updateLocals();
               }
               else if(param1.item.func == "localSave")
               {
                  Settings.saveLocalItems();
                  GameState.ui.showTooltip(GameState.ui.menuFavourite,"Saved local models.\n",0,1000,GameState.ui.menuFavourite.actualWidth);
                  Settings.backupLocalItems(false);
               }
               else if(param1.item.func == "favouriteSaveLoad")
               {
                  this.loadLocalSaves();
                  GameState.ui.updateFavouriteSaves();
               }
               else if(param1.item.func == "favouriteSaveSave")
               {
                  Settings.saveFavouriteSaves();
                  GameState.ui.showTooltip(GameState.ui.menuFavourite,"Saved favourite saves.\n",0,1000,GameState.ui.menuFavourite.actualWidth);
               }
               else if(param1.item.func == "favback")
               {
                  GameState.ui.menuFavourite.unlock();
                  GameState.ui.menuFavourite.close();
                  this.updateSpawnPic();
                  Settings.saveFavourites();
                  this.updateLibrary();
                  if(GameState.ui.menuFavourite.getField("Category"))
                  {
                     GameState.ui.menuFavourite.removeChild(GameState.ui.menuFavourite.getField("Category"));
                  }
               }
               else if(param1.item.func == "skinreset")
               {
                  this.updateColour(this.skinOriginal,true,true,false);
                  this.updateSkin();
               }
               else if(param1.item.func == "skinrandom")
               {
                  _loc11_ = uint(Math.random() * 16777215).toString(16);
                  while(_loc11_.length < 6)
                  {
                     _loc11_ = "0" + _loc11_;
                  }
                  this.skinModifying = _loc11_;
                  this.updateColour(this.skinModifying,true,true,false);
                  this.updateSkin();
               }
               else if(param1.item.func == "bgreset")
               {
                  this.updateColour(this.skinOriginal,true,true,false);
               }
               else if(param1.item.func == "bgrandom")
               {
                  _loc11_ = uint(Math.random() * 16777215).toString(16);
                  while(_loc11_.length < 6)
                  {
                     _loc11_ = "0" + _loc11_;
                  }
                  this.skinModifying = _loc11_;
                  this.updateColour(this.skinModifying,true,true,false);
               }
               else if(param1.item.func == "resetskin")
               {
                  GameState.objects.spawnSkin = new Vector.<Array>();
                  _loc12_ = O.getItem(GameState.objects.spawnName).colours;
                  for each(_loc13_ in _loc12_)
                  {
                     if(_loc13_ is ShapeUserData)
                     {
                        _loc13_ = ShapeUserData(_loc13_).name;
                     }
                     this.colouring = "skin";
                     this.skinOriginal = _loc13_.toUpperCase();
                     this.updateColour(this.skinOriginal,true,true,false);
                  }
                  Tweak.bloodColour = 10027008;
                  this.updateSkin();
               }
               else if(param1.item.func == "randomskin")
               {
                  this.RandomiseSpawnSkin();
               }
               else if(param1.item.func == "copyskin")
               {
                  GeneralUtils.copyToClipboard(String(param1.item.label).replace("#",""));
                  GameState.ui.showTooltip(GameState.ui.menuObject,"Skin colour copied.\n");
               }
               else if(param1.item.func == "applydetailskin")
               {
                  this.ApplyDetailSkin();
                  if(this.detailBody)
                  {
                     this.showDetails(this.detailBody,this.detailSubmenu);
                  }
                  else
                  {
                     this.updateSkin();
                  }
               }
               else if(param1.item.func == "copydetailskin")
               {
                  _loc14_ = Physics.world.GetBodyList();
                  while(_loc14_)
                  {
                     if(!(Boolean(this.detailBody) && userData(_loc14_.GetUserData()).name == userData(this.detailBody.GetUserData()).name))
                     {
                        if(userData(_loc14_.GetUserData()).name != GameState.objects.spawnName)
                        {
                           userData(_loc14_.GetUserData()).hidden = true;
                           if(userData(_loc14_.GetUserData()).graphic)
                           {
                              userData(_loc14_.GetUserData()).graphic.visible = false;
                              userData(_loc14_.GetUserData()).locked = true;
                           }
                        }
                     }
                     _loc14_ = _loc14_.GetNext();
                  }
                  GameState.skinning = true;
                  if(this.detailBody)
                  {
                     this.showDetails(this.detailBody,this.detailSubmenu);
                  }
                  else
                  {
                     this.updateSkin();
                  }
               }
               else if(param1.item.func == "copydetailskinfinish")
               {
                  GameState.skinning = false;
                  _loc14_ = Physics.world.GetBodyList();
                  while(_loc14_)
                  {
                     if(userData(_loc14_.GetUserData()).graphic)
                     {
                        userData(_loc14_.GetUserData()).graphic.visible = true;
                        userData(_loc14_.GetUserData()).locked = false;
                        userData(_loc14_.GetUserData()).hidden = false;
                     }
                     _loc14_ = _loc14_.GetNext();
                  }
                  if(this.detailBody)
                  {
                     this.showDetails(this.detailBody,this.detailSubmenu);
                  }
                  else
                  {
                     this.updateSkin();
                  }
               }
               else if(param1.item.func == "modifyskin" || param1.item.func == "modifydetailskin")
               {
                  if(param1.item.func == "modifydetailskin")
                  {
                     this.ModifyDetailSkin();
                  }
                  else
                  {
                     this.colouring = "skin";
                     this.skinModifying = String(param1.item.label).substr(1).toUpperCase();
                     this.skinOriginal = String(param1.item.colour).toUpperCase();
                     this.updateColour(this.skinModifying,true,true,false);
                     if(!GameState.ui.menuColour.visible)
                     {
                        GameState.ui.menuColour.open();
                        GameState.ui.menuColour.x = GameState.ui.menuObject.x + GameState.ui.menuObject.actualWidth + Window.BUFFER * 2;
                        GameState.ui.menuColour.y = GameState.ui.menuObject.y;
                     }
                  }
               }
               else if(param1.item.func == "modifycolour")
               {
                  this.BeginColouring(String(param1.item.label).toLowerCase(),String(param1.item.background).substr(1).toUpperCase());
               }
               else if(param1.item.func == "libfav")
               {
                  if(this.favourites.indexOf(GameState.objects.spawnName) == -1)
                  {
                     this.favourites.push(GameState.objects.spawnName);
                     Settings.saveFavourites();
                     GameState.ui.updateFavs();
                  }
               }
               else if(param1.item.func == "unfav")
               {
                  _loc15_ = this.favourites.indexOf(GameState.objects.spawnName);
                  if(_loc15_ != -1)
                  {
                     this.favourites[_loc15_] = "";
                  }
                  GameState.ui.updateFavs();
               }
               else if(param1.item.func == "shareCustomWorkshop")
               {
                  GameState.ui.menuFavourite.unlock();
                  GameState.ui.menuFavourite.close();
                  _loc16_ = this.customNames.indexOf(param1.item.label);
                  if(_loc16_ != -1)
                  {
                     GameState.objects.spawnCustomContent = this.customItems[_loc16_];
                  }
                  Kongregate.shareContentType = "Item";
                  GameState.ui.OpenWorkshopShareDialogue(param1.item.label,Kongregate.shareContentType);
               }
               else if(param1.item.func == "sharecustom")
               {
                  this.ShareCustomItem(param1);
               }
               else if(param1.item.func == "removecustom")
               {
                  _loc16_ = this.customNames.indexOf(param1.item.label);
                  if(_loc16_ != -1)
                  {
                     this.customNames.splice(_loc16_,1);
                     this.customItems.splice(_loc16_,1);
                     GameState.ui.updateCustoms();
                  }
                  _loc17_ = GameState.ui.showTooltip(GameState.ui.menuFavourite,"Removed " + param1.item.label + ". Save to confirm, or reload to undo.\n\n",0,4000,GameState.ui.menuFavourite.actualWidth);
               }
               else if(param1.item.func == "renamecustom")
               {
                  _loc16_ = this.customNames.indexOf(param1.item.label);
                  this.customRenaming = this.customNames[_loc16_];
                  GameState.ui.menuFavourite.title = "Renaming...";
                  GameState.ui.menuFavourite.removeAllChildren();
                  GameState.ui.menuFavourite.addInput("Name",this.customNames[_loc16_],GameState.ui.menuFavourite.actualWidth - Window.BUFFER * 6,null,"a-zA-Z0-9 -",24,false).addEventListener(Event.CHANGE,this.updateCustomRename);
                  _loc18_ = GameState.ui.menuFavourite.addTree("buttons",R.xml_renameCustom);
                  _loc18_.addEventListener(ListEvent.ITEM_CLICK,this.treeClick);
                  _loc18_.selectable = false;
               }
               else if(param1.item.func == "removelocal")
               {
                  _loc16_ = this.localNames.indexOf(param1.item.label);
                  if(_loc16_ != -1)
                  {
                     this.localNames.splice(_loc16_,1);
                     this.localItems.splice(_loc16_,1);
                     GameState.ui.updateLocals();
                  }
                  _loc17_ = GameState.ui.showTooltip(GameState.ui.menuFavourite,"Removed " + param1.item.label + ". Save to confirm, or reload to undo.\n\n",0,4000,GameState.ui.menuFavourite.actualWidth);
               }
               else if(param1.item.func == "selectresetsave")
               {
                  _loc16_ = this.favouriteSaveNames.indexOf(param1.item.label);
                  this.favouriteSaveReset = _loc16_;
                  GameState.ui.menuFavourite.close();
                  Settings.saveFavouriteSaves();
                  _loc17_ = GameState.ui.showTooltip(GameState.ui.menuSave,"Selected Reset save.\n",0,2000,GameState.ui.menuSave.actualWidth);
               }
               else if(param1.item.func == "removefavourite")
               {
                  _loc16_ = this.favouriteSaveNames.indexOf(param1.item.label);
                  if(_loc16_ != -1)
                  {
                     this.favouriteSaveNames.splice(_loc16_,1);
                     this.favouriteSaves.splice(_loc16_,1);
                     GameState.ui.updateFavouriteSaves();
                  }
                  _loc17_ = GameState.ui.showTooltip(GameState.ui.menuFavourite,"Removed " + param1.item.label + ". Save to confirm, or reload to undo.\n\n",0,4000,GameState.ui.menuFavourite.actualWidth);
               }
               else if(param1.item.func == "fav")
               {
                  if(GameState.objects.spawnName)
                  {
                     _loc19_ = int(param1.item.id);
                     _loc15_ = this.favourites.indexOf(GameState.objects.spawnName);
                     if(_loc15_ != -1)
                     {
                        this.favourites[_loc15_] = "";
                     }
                     this.favourites[_loc19_] = GameState.objects.spawnName;
                     GameState.ui.updateFavs();
                     GameState.ui.menuFavourite.getTree("buttons").openAllNodes();
                  }
               }
               else if(param1.item.func == "slomo")
               {
                  if(GameState.paused)
                  {
                     TimeLord.unpause();
                  }
                  TimeLord.speed = Vars.slowspeed;
                  GameState.slomo = true;
                  GameState.ui.updateControls();
               }
               else if(param1.item.func == "unslomo")
               {
                  if(!GameState.paused)
                  {
                     TimeLord.speed = Vars.speed;
                     GameState.slomo = false;
                     GameState.ui.updateControls();
                  }
               }
               else if(param1.item.func == "restartLevel")
               {
                  IO.loadWorld(this.loadedLevel);
               }
               else if(param1.item.func == "togglemode")
               {
                  if(World.togglePauseConfirm == 1)
                  {
                     return;
                  }
                  if(GameState.paused)
                  {
                     TimeLord.unpause();
                  }
                  else
                  {
                     TimeLord.pause();
                  }
                  GameState.ui.updateControls();
               }
               else if(param1.item.func == "toggletools")
               {
                  this.ToggleToolsMenu();
               }
               else if(param1.item.func == "togglejoints")
               {
                  this.ToggleJointsMenu(param1);
               }
               else if(param1.item.func == "pausesettings")
               {
                  this.TogglePauseSettingsMenu();
               }
               else if(param1.item.func == "togglepowers")
               {
                  this.TogglePowerMenu();
               }
               else if(param1.item.func == "environmentSeed")
               {
                  Vars.seed = Math.random() * 100000 >> 0;
                  GameState.environment.seed = Vars.seed;
                  GameState.ui.menuWorld.setValue("Seed",Vars.seed);
                  GameState.environment.setupBackground();
               }
               else if(param1.item.func == "environmentBack")
               {
                  GameState.ui.showEnvironments(null);
               }
            }
         }
      }
      
      private function ApplyDetailSkin() : void
      {
         var _loc1_:userData = null;
         var _loc2_:BitmapData = null;
         var _loc3_:Bitmap = null;
         var _loc4_:b2Body = null;
         var _loc5_:userData = null;
         if(this.colouring == "blood")
         {
            return;
         }
         _loc1_ = userData(this.detailBody.GetUserData());
         _loc1_.skin = GameState.objects.spawnSkin.slice();
         _loc2_ = BoxUtils.getEffectBMD(this.detailBody);
         BoxUtils.ReplaceGraphic(userData(this.detailBody.GetUserData()),O.getItem(userData(this.detailBody.GetUserData()).name).updateGraphic(null));
         _loc3_ = BoxUtils.getEffectBM(this.detailBody);
         if(_loc3_)
         {
            _loc3_.bitmapData = _loc2_.clone();
         }
         if(this.selectedBodies.length > 0)
         {
            for each(_loc4_ in this.selectedBodies)
            {
               _loc5_ = _loc4_.GetUserData() as userData;
               if(_loc1_.name == _loc5_.name)
               {
                  _loc5_.skin = _loc1_.skin.slice();
                  BoxUtils.ReplaceGraphic(_loc5_,O.getItem(_loc5_.name).updateGraphic(null));
               }
            }
         }
      }
      
      public function resetSpawnSettings() : void
      {
         Vars.objSize = 1;
         Vars.objAngle = 0;
         Vars.objDensity = 1;
         Vars.objFriction = 0.5;
         Vars.objRestitution = 0.2;
         Vars.objDampLinear = 0;
         Vars.objDampAngular = 0;
         Tweak.bloodColour = 10027008;
         Vars.stabSettings = {};
         Vars.gunSettings = {};
         GameState.ui.initStabSettings();
         GameState.ui.initGunSettings();
         if(GameState.ui.menuObject.title == "Settings")
         {
            GameState.ui.UpdateItemSettings();
         }
         if(!GameState.spawningCustom)
         {
            GameState.ui.menuObject.close();
            this.updateSpawnPic();
         }
      }
      
      private function pauseGridChanged(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         _loc2_ = HUISlider(param1.currentTarget).value;
         Tweak.GridSize = _loc2_;
         TimeLord.pauseGrid.Redraw();
      }
      
      private function effectRadiusChanged(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         _loc2_ = HUISlider(param1.currentTarget).value;
         this.previewEffect.size = _loc2_ * 0.01;
      }
      
      private function effectAmountChanged(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         _loc2_ = HUISlider(param1.currentTarget).value;
         this.previewEffect.amount = _loc2_ * 0.01;
      }
      
      private function effectSpeedChanged(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         _loc2_ = HUISlider(param1.currentTarget).value;
         this.previewEffect.speed = _loc2_ * 0.01;
      }
      
      private function detailVolumeChanged(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         if(!this.detailBody)
         {
            return;
         }
         _loc2_ = Number(GameState.ui.menuDetails.getValue("Volume %")) * 0.01;
         if(_loc2_ > 1.5)
         {
            _loc2_ = 1.5;
         }
         if(_loc2_ < 0.25)
         {
            _loc2_ = 0.25;
         }
         userData(this.detailBody.GetUserData()).overrideVolume = _loc2_;
      }
      
      private function detailVolumePlay(param1:Event) : void
      {
         if(userData(this.detailBody.GetUserData()).overrideSound)
         {
            sounds.play(userData(this.detailBody.GetUserData()).overrideSound,this.detailBody);
         }
      }
      
      public function jointUpperAngleChanged(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         _loc2_ = Number(GameState.ui.menuTools.getValue("+Angle"));
         Tweak.jointUpper = _loc2_;
      }
      
      public function jointLowerAngleChanged(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         _loc2_ = Number(GameState.ui.menuTools.getValue("-Angle"));
         Tweak.jointLower = _loc2_;
      }
      
      public function jointMotorSpeedChanged(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         _loc2_ = Number(GameState.ui.menuTools.getValue("Speed"));
         Tweak.jointMotorSpeed = _loc2_;
      }
      
      public function jointMotorForceChanged(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         _loc2_ = Number(GameState.ui.menuTools.getValue("Force"));
         Tweak.jointMotorForce = _loc2_ * 100;
      }
      
      public function jointDampingChanged(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         _loc2_ = Number(GameState.ui.menuTools.getValue("Damping"));
         Tweak.jointDamping = _loc2_ * 0.01;
      }
      
      public function jointFrequencyChanged(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         _loc2_ = Number(GameState.ui.menuTools.getValue("Frequency"));
         Tweak.jointFrequency = _loc2_ * 0.01;
      }
      
      public function jointBreakChanged(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         _loc2_ = Number(GameState.ui.menuTools.getValue("Break"));
         Tweak.jointForce = _loc2_ * 1000;
      }
      
      public function jointWidthChanged(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         _loc2_ = Number(GameState.ui.menuTools.getValue("Width"));
         Tweak.jointWidth = _loc2_;
      }
      
      public function itemSearch() : void
      {
         stage.focus = AutoComplete(GameState.ui.menuSpawn.getChildByName("autoComplete")).textField;
      }
      
      public function itemArmour() : void
      {
      }
      
      public function itemSkin() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:HUISlider = null;
         var _loc3_:Tree = null;
         if(GameState.ui.menuObject.visible && GameState.ui.menuObject.title == "Skin")
         {
            GameState.ui.menuObject.close();
            return;
         }
         GameState.ui.menuObject.title = "Skin";
         if(!GameState.ui.menuObject.visible)
         {
            GameState.ui.dockItemMenu();
            GameState.ui.menuObject.open();
         }
         if(GameState.ui.menuObject.title == "Settings")
         {
            GameState.ui.remSettingListeners();
         }
         GameState.ui.menuObject.removeAllChildren();
         _loc1_ = int(GameState.objects.spawnAlpha * 100);
         if(this.detailBody)
         {
            _loc1_ = int(userData(this.detailBody.GetUserData()).alpha * 100);
         }
         _loc2_ = GameState.ui.menuObject.addSlider("Opacity",_loc1_,0,400);
         _loc2_.addEventListener(Event.CHANGE,this.spawnAlphaChanged);
         _loc3_ = GameState.ui.menuObject.addTree("buttons",R.xml_empty,52 + 36,0,24);
         GameState.ui.menuObject.addTooltip("Opacity","Values &lt;100% = transparent\n100% = opaque\n&gt;100% = model\'s transparent layers become more opaque");
         this.updateSkin();
         GameState.ui.menuObject.title = "Skin";
         GameState.ui.menuObject.maximiseHeight = 592 + 36;
         GameState.ui.menuObject.maximise();
         _loc3_.selectable = false;
         _loc3_.addEventListener(ListEvent.ITEM_CLICK,this.handleTreeClick);
         _loc3_.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,this.handleTreeClick);
      }
      
      private function spawnAlphaChanged(param1:Event) : void
      {
         var _loc2_:String = null;
         var _loc3_:Number = NaN;
         var _loc4_:b2Body = null;
         _loc2_ = GameState.ui.menuObject.getValue("Opacity");
         if(!_loc2_ || _loc2_ == "-")
         {
            return;
         }
         _loc3_ = Number(_loc2_) * 0.01;
         if(this.detailBody)
         {
            userData(this.detailBody.GetUserData()).alpha = _loc3_;
            for each(_loc4_ in this.selectedBodies)
            {
               userData(_loc4_.GetUserData()).alpha = _loc3_;
            }
            return;
         }
         GameState.objects.spawnAlpha = _loc3_;
         this.updateSpawnPic();
      }
      
      private function updateFlipIcon() : void
      {
         var _loc1_:Sprite = null;
         _loc1_ = Sprite(GameState.ui.menuSpawn.getChildByName("flipicon"));
         Bitmap(_loc1_.getChildByName("icon")).bitmapData.copyPixels(R.getSprite(!this.flipped ? "iconflipleft" : "iconflipright"),new Rectangle(0,0,20,20),new Point(0,0));
      }
      
      public function updateSpawnPic() : void
      {
         var _loc1_:Item = null;
         var _loc2_:AutoComplete = null;
         var _loc3_:Sprite = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:int = 0;
         var _loc7_:MovieClip = null;
         var _loc8_:MovieClip = null;
         var _loc9_:MovieClip = null;
         var _loc10_:MovieClip = null;
         var _loc11_:MovieClip = null;
         var _loc12_:MovieClip = null;
         var _loc13_:MovieClip = null;
         var _loc14_:MovieClip = null;
         var _loc15_:MovieClip = null;
         var _loc16_:MovieClip = null;
         var _loc17_:MovieClip = null;
         var _loc18_:MovieClip = null;
         var _loc19_:MovieClip = null;
         var _loc20_:MovieClip = null;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Array = null;
         var _loc24_:Array = null;
         var _loc25_:MovieClip = null;
         var _loc26_:int = 0;
         var _loc27_:Array = null;
         var _loc28_:Number = NaN;
         var _loc29_:Array = null;
         var _loc30_:int = 0;
         var _loc31_:TextFormat = null;
         var _loc32_:TextField = null;
         var _loc33_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc35_:Number = NaN;
         var _loc36_:int = 0;
         var _loc37_:int = 0;
         var _loc38_:Item = null;
         var _loc39_:Sprite = null;
         var _loc40_:Number = NaN;
         var _loc41_:Item = null;
         var _loc42_:int = 0;
         _loc1_ = O.getItem(GameState.objects.spawnName);
         if(!_loc1_ && !GameState.objects.spawnCustom)
         {
            return;
         }
         _loc2_ = GameState.ui.menuSpawn.getChildByName("autoComplete") as AutoComplete;
         GameState.ui.menuSpawn.maximiseHeight = _loc2_.y + _loc2_.height + 4;
         GameState.ui.menuSpawn.forceChildrenVisible();
         if(GameState.objects.spawnCustom)
         {
            GameState.objects.spawnSprite = new Sprite();
            GameState.objects.spawnSprite.mouseEnabled = false;
            GameState.objects.spawnSprite.mouseChildren = false;
            GameState.objects.spawnSprite.name = "customSprite";
            GameState.objects.spawnSprite.graphics.beginFill(GameState.ui.menuSpawn.FIELDBACKGROUNDCOLOUR);
            GameState.objects.spawnSprite.graphics.drawRoundRect(-50,-50,100,100,8,8);
            _loc31_ = new TextFormat(Window.FONT,Window.FONTSIZE,GameState.ui.menuSpawn.FONTCOLOUR);
            _loc31_.align = TextFormatAlign.CENTER;
            _loc32_ = new TextField();
            _loc32_.defaultTextFormat = _loc31_;
            _loc32_.setTextFormat(_loc31_);
            _loc32_.text = GameState.objects.spawnName;
            _loc32_.width = 100;
            _loc32_.height = 100;
            _loc32_.x = -50;
            _loc32_.y = -45;
            _loc32_.wordWrap = true;
            _loc32_.selectable = false;
            _loc32_.mouseEnabled = false;
            GameState.objects.spawnSprite.addChild(_loc32_);
         }
         else if(!GameState.spawning)
         {
            GameState.objects.spawnSprite = _loc1_.updateGraphic(GameState.objects.spawnSkin,this.flipped);
            GameState.objects.spawnSprite.mouseEnabled = false;
            GameState.objects.spawnSprite.mouseChildren = false;
            GameState.objects.spawnSprite.name = "itemSprite";
            GameState.objects.spawnSprite.scaleX = Vars.objSize;
            GameState.objects.spawnSprite.scaleY = Vars.objSize;
         }
         _loc3_ = GameState.ui.menuSpawn.getChildByName("itemHolder") as Sprite;
         while(_loc3_.numChildren > 0)
         {
            _loc3_.removeChildAt(0);
         }
         if(true || Vars.objSize <= 1)
         {
            _loc33_ = GameState.objects.spawnSprite.width > GameState.objects.spawnSprite.height ? GameState.objects.spawnSprite.width : GameState.objects.spawnSprite.height;
            _loc34_ = GameState.ui.menuSpawn.actualWidth * 0.5;
            if(_loc33_ > _loc34_)
            {
               GameState.objects.spawnSprite.scaleX = GameState.objects.spawnSprite.scaleY = _loc34_ / _loc33_ * Vars.objSize;
            }
            _loc35_ = GameState.objects.spawnSprite.width > GameState.objects.spawnSprite.height ? GameState.objects.spawnSprite.width : GameState.objects.spawnSprite.height;
         }
         GameState.objects.spawnSprite.rotation = Vars.objAngle;
         GameState.objects.spawnSprite.x = _loc3_.width >> 1;
         GameState.objects.spawnSprite.y = _loc3_.height >> 1;
         _loc3_.addChild(GameState.objects.spawnSprite);
         _loc4_ = GameState.ui.menuSpawn.getChildByName("itemprev") as MovieClip;
         _loc5_ = GameState.ui.menuSpawn.getChildByName("itemnext") as MovieClip;
         while(_loc4_.numChildren > 0)
         {
            _loc4_.removeChildAt(0);
         }
         while(_loc5_.numChildren > 0)
         {
            _loc5_.removeChildAt(0);
         }
         _loc6_ = 0;
         while(_loc6_ < 1)
         {
            _loc36_ = this.getPrevItem(_loc6_);
            if(_loc36_ != -1)
            {
               _loc38_ = O.getItem(R.library_objects[_loc36_].object);
               if(_loc38_)
               {
                  _loc39_ = _loc38_.updateGraphic(GameState.objects.spawnSkin);
                  _loc4_.addChild(_loc39_);
                  _loc40_ = _loc34_ * 0.25;
                  _loc33_ = _loc39_.width > _loc39_.height ? _loc39_.width : _loc39_.height;
                  if(_loc33_ > _loc40_)
                  {
                     _loc39_.scaleX = _loc39_.scaleY = _loc40_ / _loc33_;
                     _loc39_.scaleX *= this.flipped ? -1 : 1;
                  }
                  _loc39_.x = 0;
                  _loc39_.y = 0;
                  _loc39_.name = "gfx";
               }
            }
            _loc37_ = this.getNextItem(_loc6_);
            if(_loc37_ != -1)
            {
               _loc41_ = O.getItem(R.library_objects[_loc37_].object);
               if(_loc41_)
               {
                  _loc39_ = _loc41_.updateGraphic(GameState.objects.spawnSkin);
                  _loc5_.addChild(_loc39_);
                  _loc40_ = _loc34_ * 0.25;
                  _loc33_ = _loc39_.width > _loc39_.height ? _loc39_.width : _loc39_.height;
                  if(_loc33_ > _loc40_)
                  {
                     _loc39_.scaleX = _loc39_.scaleY = _loc40_ / _loc33_;
                     _loc39_.scaleX *= this.flipped ? -1 : 1;
                  }
                  _loc39_.x = 0;
                  _loc39_.y = 0;
                  _loc39_.name = "gfx";
               }
            }
            _loc6_++;
         }
         if(GameState.ui.menuSpawn.isMinimised)
         {
            return;
         }
         _loc7_ = GameState.ui.menuSpawn.getChildByName("favicon") as MovieClip;
         _loc8_ = GameState.ui.menuSpawn.getChildByName("labicon") as MovieClip;
         _loc9_ = GameState.ui.menuSpawn.getChildByName("infoicon") as MovieClip;
         _loc10_ = GameState.ui.menuSpawn.getChildByName("linkicon") as MovieClip;
         _loc11_ = GameState.ui.menuSpawn.getChildByName("customicon") as MovieClip;
         _loc12_ = GameState.ui.menuSpawn.getChildByName("dollicon") as MovieClip;
         _loc13_ = GameState.ui.menuSpawn.getChildByName("gunicon") as MovieClip;
         _loc14_ = GameState.ui.menuSpawn.getChildByName("flipicon") as MovieClip;
         _loc15_ = GameState.ui.menuSpawn.getChildByName("settingicon") as MovieClip;
         _loc16_ = GameState.ui.menuSpawn.getChildByName("randomicon") as MovieClip;
         _loc17_ = GameState.ui.menuSpawn.getChildByName("propertyicon") as MovieClip;
         _loc18_ = GameState.ui.menuSpawn.getChildByName("skinicon") as MovieClip;
         _loc19_ = GameState.ui.menuSpawn.getChildByName("searchicon") as MovieClip;
         _loc20_ = GameState.ui.menuSpawn.getChildByName("armouricon") as MovieClip;
         _loc11_.x = _loc3_.x + (_loc3_.width >> 1) - 10;
         _loc12_.x = _loc3_.x + (_loc3_.width >> 1) - 10;
         _loc13_.x = _loc3_.x + (_loc3_.width >> 1) - 10;
         _loc7_.x = _loc3_.x + (_loc3_.width >> 1) - 10;
         _loc8_.x = _loc3_.x + (_loc3_.width >> 1) - 10;
         _loc9_.x = _loc3_.x + (_loc3_.width >> 1) - 10;
         _loc10_.x = _loc3_.x + (_loc3_.width >> 1) - 10;
         _loc21_ = _loc3_.y + 16;
         _loc22_ = _loc3_.y + _loc3_.height - _loc15_.height + 6;
         _loc23_ = [_loc10_,_loc9_,_loc8_,_loc11_,_loc7_];
         _loc24_ = [_loc15_,_loc17_,_loc18_,_loc14_];
         if(Boolean(GameState.objects.spawnNode) && Boolean(GameState.objects.spawnNode.armour))
         {
            _loc23_.push(_loc20_);
            _loc20_.visible = true;
         }
         else
         {
            _loc20_.visible = false;
         }
         if(Body.IsAlive(GameState.objects.spawnName))
         {
            _loc24_.unshift(_loc12_);
            _loc12_.visible = true;
         }
         else
         {
            _loc12_.visible = false;
         }
         if(Body.IsGun(GameState.objects.spawnName))
         {
            _loc24_.unshift(_loc13_);
            _loc13_.visible = true;
         }
         else
         {
            _loc13_.visible = false;
         }
         if(GameState.quickspawning)
         {
            _loc29_ = _loc23_.concat(_loc24_).concat([_loc19_,_loc16_,_loc4_,_loc5_]);
            _loc6_ = 0;
            while(_loc6_ < _loc29_.length)
            {
               MovieClip(_loc29_[_loc6_]).visible = false;
               _loc6_++;
            }
            return;
         }
         for each(_loc25_ in _loc23_)
         {
            _loc25_.y = _loc21_;
         }
         for each(_loc25_ in _loc24_)
         {
            _loc25_.y = _loc22_;
         }
         _loc10_.visible = GameState.objects.spawnLinks;
         _loc11_.visible = GameState.objects.spawnCustom;
         _loc14_.visible = !GameState.objects.spawnCustom;
         _loc15_.visible = !GameState.objects.spawnCustom;
         _loc17_.visible = !GameState.objects.spawnCustom;
         _loc18_.visible = !GameState.objects.spawnCustom;
         if(Boolean(GameState.objects.spawnCreator) && GameState.objects.spawnCreator != "")
         {
            _loc8_.visible = true;
         }
         else
         {
            _loc8_.visible = false;
         }
         if(Boolean(GameState.objects.spawnDetails) && GameState.objects.spawnDetails != "")
         {
            _loc9_.visible = true;
            if(_loc8_.visible)
            {
               _loc8_.x -= 1 + _loc8_.width >> 1;
               _loc9_.x += 1 + _loc8_.width >> 1;
            }
         }
         else
         {
            _loc9_.visible = false;
         }
         _loc26_ = this.favourites.indexOf(GameState.objects.spawnName);
         if(_loc26_ != -1)
         {
            _loc7_.visible = true;
            Bitmap(_loc7_.getChildByName("icon")).bitmapData.copyPixels(R.getSprite("iconfavmed"),new Rectangle(0,0,20,20),new Point(0,0));
            TextField(_loc7_.getChildByName("favtf")).text = Keymap.codeToKeyname(Keymap.nameToCode("Favourite" + String(_loc26_ + 1)));
            TextField(_loc7_.getChildByName("favtf")).visible = true;
            TextField(_loc7_.getChildByName("favtf")).textColor = 2236962;
            _loc7_.removeEventListener(MouseEvent.MOUSE_OVER,GameState.ui.notfaviconhovered);
            _loc7_.addEventListener(MouseEvent.MOUSE_OVER,GameState.ui.faviconhovered);
         }
         else
         {
            _loc7_.visible = true;
            _loc7_.removeEventListener(MouseEvent.MOUSE_OVER,GameState.ui.faviconhovered);
            _loc7_.addEventListener(MouseEvent.MOUSE_OVER,GameState.ui.notfaviconhovered);
            TextField(_loc7_.getChildByName("favtf")).visible = false;
            Bitmap(_loc7_.getChildByName("icon")).bitmapData.copyPixels(R.getSprite("iconnotfavmed"),new Rectangle(0,0,20,20),new Point(0,0));
         }
         _loc27_ = [_loc23_,_loc24_];
         _loc30_ = 0;
         while(_loc30_ < 2)
         {
            _loc28_ = _loc3_.x + (_loc3_.width >> 1) + 15;
            _loc29_ = _loc27_[_loc30_];
            for each(_loc25_ in _loc29_)
            {
               if(_loc25_.visible)
               {
                  _loc25_.x = _loc28_;
                  _loc28_ += 17;
                  _loc42_ = 0;
                  while(_loc42_ < _loc29_.length)
                  {
                     Sprite(_loc29_[_loc42_]).x = Sprite(_loc29_[_loc42_]).x - 17;
                     _loc42_++;
                  }
               }
            }
            _loc30_++;
         }
         GameState.objects.spawnSprite.alpha = GameState.objects.spawnAlpha;
         if(GameState.ui.menuSpawn.title == "VIEW CARD")
         {
            _loc7_.visible = false;
            _loc8_.visible = false;
            _loc9_.visible = false;
            _loc10_.visible = false;
            _loc11_.visible = false;
            _loc12_.visible = false;
            _loc13_.visible = false;
            _loc14_.visible = false;
            _loc15_.visible = false;
            _loc16_.visible = false;
            _loc17_.visible = false;
            _loc18_.visible = false;
            _loc19_.visible = false;
            _loc20_.visible = false;
            GameState.ui.menuSpawn.getChildByName("resize").visible = false;
            GameState.ui.menuSpawn.getChildByName("itemprev").visible = false;
            GameState.ui.menuSpawn.getChildByName("itemnext").visible = false;
         }
      }
      
      private function lab_EventHandler(param1:LabEvent) : *
      {
         var _loc2_:Object = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:int = 0;
         var _loc13_:String = null;
         var _loc14_:int = 0;
         var _loc15_:* = undefined;
         var _loc16_:Array = null;
         var _loc17_:String = null;
         var _loc18_:int = 0;
         var _loc20_:String = null;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:Array = null;
         var _loc24_:ShapeUserData = null;
         var _loc25_:int = 0;
         var _loc26_:Boolean = false;
         var _loc27_:Array = null;
         var _loc28_:ShapeUserData = null;
         var _loc29_:int = 0;
         _loc2_ = param1.customMessage;
         _loc3_ = [];
         _loc4_ = _loc2_.Vertices.split("|");
         if(_loc2_.Properties)
         {
            _loc5_ = _loc2_.Properties.split(",");
         }
         if(_loc2_.ShapeProperties)
         {
            _loc6_ = _loc2_.ShapeProperties.split(";");
         }
         _loc7_ = int(_loc4_.length);
         _loc10_ = _loc2_.Colours.split(",");
         _loc11_ = [];
         if(_loc2_.Alphas)
         {
            _loc11_ = _loc2_.Alphas.split(",");
         }
         if(_loc6_)
         {
            _loc22_ = 0;
            while(_loc22_ < _loc6_.length)
            {
               _loc23_ = _loc6_[_loc22_].split(",");
               _loc24_ = Properties.shapeProperties(_loc10_[_loc22_]);
               if(_loc23_.indexOf("Sharp") != -1)
               {
                  _loc24_.sharp = true;
               }
               if(_loc23_.indexOf("Sticky") != -1)
               {
                  _loc24_.sticky = true;
               }
               if(_loc23_.indexOf("Decorative") != -1)
               {
                  _loc24_.decorative = true;
               }
               if(_loc23_.indexOf("Invisible") != -1)
               {
                  _loc24_.invisible = true;
               }
               if(_loc23_.indexOf("Drag") != -1)
               {
                  _loc24_.sensor = true;
               }
               _loc10_[_loc22_] = _loc24_;
               _loc22_++;
            }
         }
         _loc12_ = 0;
         while(_loc12_ < _loc7_)
         {
            _loc8_ = _loc4_[_loc12_].split(";");
            _loc9_ = int(_loc8_.length);
            _loc3_[_loc12_] = [];
            _loc25_ = 0;
            while(_loc25_ < _loc9_)
            {
               _loc27_ = _loc8_[_loc25_].split(",");
               _loc3_[_loc12_].push(new b2Vec2(_loc27_[0],_loc27_[1]));
               _loc25_++;
            }
            _loc26_ = true;
            if(_loc10_[_loc12_] is ShapeUserData && ShapeUserData(_loc10_[_loc12_]).decorative)
            {
               _loc26_ = false;
            }
            if(_loc26_)
            {
               _loc3_[_loc12_] = BoxUtils.arrangeClockwise(_loc3_[_loc12_]);
            }
            _loc25_ = 0;
            while(_loc25_ < _loc9_)
            {
               _loc3_[_loc12_][_loc25_] = [_loc3_[_loc12_][_loc25_].x,_loc3_[_loc12_][_loc25_].y];
               _loc25_++;
            }
            _loc12_++;
         }
         _loc13_ = "[";
         _loc14_ = 0;
         for each(_loc15_ in _loc10_)
         {
            if(_loc15_ is ShapeUserData)
            {
               _loc28_ = ShapeUserData(_loc15_);
               if(_loc28_.invisible && _loc28_.sharp)
               {
                  _loc13_ += "Properties.shapeInvisSharp(";
               }
               else if(_loc28_.invisible && _loc28_.sticky)
               {
                  _loc13_ += "Properties.shapeInvisStick(";
               }
               else if(_loc28_.sensor && _loc28_.invisible)
               {
                  _loc13_ += "Properties.shapeInvisSensor(";
               }
               else if(_loc28_.invisible)
               {
                  _loc13_ += "Properties.shapeInvis(";
               }
               else if(_loc28_.decorative)
               {
                  _loc13_ += "Properties.shapeDecor(";
               }
               else if(_loc28_.sharp && _loc28_.sticky)
               {
                  _loc13_ += "Properties.shapeStickSharp(";
               }
               else if(_loc28_.sharp)
               {
                  _loc13_ += "Properties.shapeSharp(";
               }
               else if(_loc28_.sticky)
               {
                  _loc13_ += "Properties.shapeStick(";
               }
               else if(_loc28_.sensor)
               {
                  _loc13_ += "Properties.shapeSensor(";
               }
               _loc13_ += "\"" + _loc28_.name + "\"";
               if(_loc28_.sharp || _loc28_.sticky || _loc28_.decorative || _loc28_.invisible || _loc28_.invisible || _loc28_.sensor)
               {
                  _loc13_ += ")";
               }
            }
            else
            {
               _loc13_ += "\"" + _loc15_ + "\"";
            }
            if(_loc14_ != _loc10_.length - 1)
            {
               _loc13_ += ", ";
            }
            else
            {
               _loc13_ += "]";
            }
            _loc14_++;
         }
         _loc16_ = [0,0];
         if(_loc2_.PhysicsCentre)
         {
            _loc16_ = _loc2_.PhysicsCentre.split(",");
         }
         _loc17_ = "";
         _loc18_ = 0;
         while(_loc18_ < _loc3_.length)
         {
            _loc17_ += "[";
            _loc29_ = 0;
            while(_loc29_ < _loc3_[_loc18_].length)
            {
               _loc17_ += "[" + Math.round(_loc3_[_loc18_][_loc29_][0] - _loc16_[0]) + ", " + Math.round(_loc3_[_loc18_][_loc29_][1] - _loc16_[1]) + "]";
               if(_loc29_ != _loc3_[_loc18_].length - 1)
               {
                  _loc17_ += ", ";
               }
               _loc29_++;
            }
            _loc17_ += "]";
            if(_loc18_ != _loc3_.length - 1)
            {
               _loc17_ += ", ";
            }
            _loc18_++;
         }
         if(_loc11_.length > 0)
         {
            GameState.objects.spawnAlphas = _loc11_;
         }
         var _loc19_:String = "";
         if(_loc2_.Title)
         {
            _loc19_ = _loc2_.Title;
         }
         if(_loc2_.ItemName)
         {
            _loc19_ = _loc2_.ItemName;
         }
         _loc17_ = "[" + _loc17_ + "]";
         if(Boolean(_loc2_.Angle) && _loc2_.Angle != 0)
         {
            _loc17_ = "GeneralUtils.rotateArray(" + _loc17_ + ", " + String(_loc2_.Angle) + ")";
         }
         if(_loc2_.Flip == "true")
         {
            _loc17_ = "GeneralUtils.flipArray(" + _loc17_ + ")";
         }
         delete _loc2_.LayerNames;
         delete _loc2_.Shapes;
         delete _loc2_.Height;
         delete _loc2_.Width;
         delete _loc2_.Centre;
         _loc20_ = _loc2_.ItemName;
         if(!_loc20_)
         {
            _loc20_ = _loc2_.Title;
         }
         _loc21_ = this.localNames.indexOf(_loc20_);
         if(_loc21_ == -1)
         {
            this.localItems.push(JSON.stringify(_loc2_));
            this.localNames.push(_loc20_);
         }
         else
         {
            this.localItems[_loc21_] = JSON.stringify(_loc2_);
            this.localNames[_loc21_] = _loc20_;
         }
      }
      
      private function mainTreeClick(param1:ListEvent) : *
      {
         if(param1.item.func)
         {
            if(param1.item.func == "spawn")
            {
               if(GameState.ui.menuSpawn.visible && GameState.ui.menuObject.visible)
               {
                  GameState.ui.menuObject.close();
               }
               if(GameState.ui.menuSpawn.title == "Spawn")
               {
                  GameState.ui.menuSpawn.toggle();
               }
               if(GameState.ui.menuSpawn.x == 0 || GameState.ui.menuSpawn.title != "Spawn")
               {
                  GameState.ui.menuSpawn.x = GameState.ui.menuMain.x + GameState.ui.menuMain.actualWidth + 4;
                  GameState.ui.menuSpawn.y = GameState.ui.menuMain.y;
               }
               if(GameState.ui.menuSpawn.alpha < 1 && this.loadedLevel != "")
               {
                  GameState.ui.showTooltip(GameState.ui.menuSpawn,"The loaded level is locked.\nAny changes will not be saveable!\n",0,6000,GameState.ui.menuSpawn.actualWidth);
               }
               GameState.ui.DisableTradingCardStyle();
            }
            else if(param1.item.func == "world")
            {
               if(GameState.ui.menuWorld.x == 0)
               {
                  GameState.ui.menuWorld.x = GameState.ui.menuControls.x - GameState.ui.menuControls.actualWidth - Window.BUFFER * 2 - GameState.ui.menuWorld.actualWidth + GameState.ui.menuControls.actualWidth - 1;
                  GameState.ui.menuWorld.y = GameState.ui.menuControls.y;
               }
               GameState.ui.menuWorld.toggle();
            }
            else if(param1.item.func == "contracts")
            {
               this.ToggleContracts();
            }
            else if(param1.item.func == "library")
            {
               this.initLibraryItems();
               GameState.ui.menuLibrary.toggle();
               if(GameState.ui.menuLibrary.undocked)
               {
                  if(GameState.ui.menuSpawn.x == 0 || !GameState.ui.menuSpawn.visible || GameState.ui.menuSpawn.undocked)
                  {
                     GameState.ui.menuLibrary.x = GameState.ui.menuMain.x + GameState.ui.menuMain.actualWidth + 4;
                     GameState.ui.menuLibrary.y = GameState.ui.menuMain.y;
                  }
                  else if(GameState.ui.menuObject.visible && !GameState.ui.menuObject.undocked)
                  {
                     GameState.ui.menuLibrary.x = GameState.ui.menuObject.x + GameState.ui.menuObject.actualWidth + 4;
                     GameState.ui.menuLibrary.y = GameState.ui.menuObject.y;
                  }
                  else
                  {
                     GameState.ui.menuLibrary.x = GameState.ui.menuSpawn.x + GameState.ui.menuSpawn.actualWidth + 4;
                     GameState.ui.menuLibrary.y = GameState.ui.menuSpawn.y;
                  }
               }
               this.updateLibrary();
            }
            else if(param1.item.func == "itch")
            {
               navigateToURL(new URLRequest("http://dashrava.itch.io/mutilate"),"_blank");
            }
            else if(param1.item.func == "silvergames")
            {
               Links.Silvergames(null);
            }
            else if(param1.item.func == "gameplays")
            {
               Links.Gameplays(null);
            }
            else if(param1.item.func == "settings")
            {
               GameState.ui.menuSettings.toggle();
               if(GameState.ui.menuSettings.x == 0)
               {
                  GameState.ui.menuSettings.x = GameState.ui.menuControls.x - GameState.ui.menuControls.actualWidth - Window.BUFFER * 2 - GameState.ui.menuSettings.actualWidth + GameState.ui.menuControls.actualWidth - 1;
                  GameState.ui.menuSettings.y = GameState.ui.menuControls.y;
               }
            }
            else if(param1.item.func == "object")
            {
               GameState.ui.menuObject.toggle();
            }
            else if(param1.item.func == "save")
            {
               GameState.ui.menuSave.toggle();
               this.updateSaveMenu();
            }
            else if(param1.item.func == "keymap")
            {
               GameState.ui.menuKeymap.toggle();
            }
            else if(param1.item.func == "tools")
            {
               GameState.ui.menuTools.toggle();
            }
            else if(param1.item.func == "reset")
            {
               this.reset();
               if(GameState.ui.menuSave.visible)
               {
                  this.updateSaveMenu();
               }
            }
            else if(param1.item.func != "mapping")
            {
               if(param1.item.func == "tutorial")
               {
                  this.goToTutorial();
               }
            }
         }
      }
      
      private function ToggleContracts() : void
      {
         GameState.ui.menuChallenge.toggle();
         if(!GameState.ui.menuChallenge.undocked)
         {
            if(GameState.ui.menuSpawn.x == 0 || !GameState.ui.menuSpawn.visible || GameState.ui.menuSpawn.undocked)
            {
               GameState.ui.menuChallenge.x = GameState.ui.menuMain.x + GameState.ui.menuMain.actualWidth + 4;
               GameState.ui.menuChallenge.y = GameState.ui.menuMain.y;
            }
            else if(GameState.ui.menuObject.visible && !GameState.ui.menuObject.undocked)
            {
               GameState.ui.menuChallenge.x = GameState.ui.menuObject.x + GameState.ui.menuObject.actualWidth + 4;
               GameState.ui.menuChallenge.y = GameState.ui.menuObject.y;
            }
            else
            {
               GameState.ui.menuChallenge.x = GameState.ui.menuSpawn.x + GameState.ui.menuSpawn.actualWidth + 4;
               GameState.ui.menuChallenge.y = GameState.ui.menuSpawn.y;
            }
         }
      }
      
      public function updateSaveMenu(param1:String = "none") : void
      {
         var loadSpeed:String = null;
         var loadslider:DisplayObject = null;
         var savxml:XML = null;
         var items:int = 0;
         var delay:Number = NaN;
         var loadTooltip:String = null;
         var autosaveLabel:String = null;
         var sortLabel:String = null;
         var timeleft:Number = NaN;
         var timerString:String = null;
         var pasteStr:String = null;
         var saveField:TextField = null;
         var savetf:TextFormat = null;
         var submenu:String = param1;
         loadSpeed = "Loading Speed";
         loadslider = GameState.ui.menuSave.getGadget(loadSpeed);
         if(loadslider)
         {
            GameState.ui.menuSave.removeChild(loadslider);
         }
         savxml = <node label="Root Node">
			</node>;
         if(submenu == "sort")
         {
            if(GameState.ContentSort == "Newest")
            {
               GameState.ContentSort = "Top";
               if(Kongregate.API)
               {
                  GameState.ContentFilter = Kongregate.API.sharedContent.BY_RATING;
               }
            }
            else if(GameState.ContentSort == "Top")
            {
               GameState.ContentSort = "My Content";
               if(Kongregate.API)
               {
                  GameState.ContentFilter = Kongregate.API.sharedContent.BY_OWN;
               }
            }
            else if(GameState.ContentSort == "My Content")
            {
               GameState.ContentSort = "Friends";
               if(Kongregate.API)
               {
                  GameState.ContentFilter = Kongregate.API.sharedContent.BY_FRIENDS;
               }
            }
            else if(GameState.ContentSort == "Friends")
            {
               GameState.ContentSort = "Newest";
               if(Kongregate.API)
               {
                  GameState.ContentFilter = Kongregate.API.sharedContent.BY_NEWEST;
               }
            }
            submenu = "viewContent";
         }
         if(submenu == "autosave")
         {
            if(GameState.AutoSave == "1 min")
            {
               GameState.AutoSave = "5 min";
               delay = 300000;
            }
            else if(GameState.AutoSave == "5 min")
            {
               GameState.AutoSave = "10 min";
               delay = 600000;
            }
            else if(GameState.AutoSave == "10 min")
            {
               GameState.AutoSave = "Never";
            }
            else if(GameState.AutoSave == "Never")
            {
               GameState.AutoSave = "1 min";
               delay = 60000;
            }
            this.AutoSaveTimer.stop();
            if(GameState.AutoSave == "Never")
            {
               GameState.ui.showTooltip(GameState.ui.menuSave,"Autosaving disabled.",0,2000,GameState.ui.menuSave.actualWidth);
            }
            else
            {
               this.AutoSaveTimer.delay = delay;
               this.AutoSaveTimer.start();
               GameState.ui.showTooltip(GameState.ui.menuSave,"Next save in " + GameState.AutoSave + ".",0,2000,GameState.ui.menuSave.actualWidth);
            }
            submenu = "localContent";
         }
         items = 7;
         if(submenu != "none")
         {
            savxml.appendChild(<node label="Back" func="back" center="true" background="#444444"/>);
         }
         GameState.ui.menuSave.removeGadget("load");
         if(submenu == "none")
         {
            items = 2;
            if(this.currentSave)
            {
               savxml.appendChild(<node label="Current Save" func="localContent" center="true"/>);
            }
            else
            {
               savxml.appendChild(<node label="Save" func="save" center="true" tooltip="Saves the current state of the level.&#10;Note that cut or broken items, and projectiles are not saved.&#10;&#10;"/>);
            }
            if(!Tweak.download && this.loadedLevel == "")
            {
               savxml.appendChild(<node label="Share Content" func="createContent" center="true" tooltip="Share your content with others on Kongregate.&#10;"/>);
               items++;
            }
            loadTooltip = "Browse player-submitted content.\nWarning: May contain laggy or obscene designs.\nModeration is done by Kongregate\'s flagging system, NOT the developer.\n\n\n";
            if(Tweak.download)
            {
               loadTooltip = "Load your local saves.";
            }
            savxml.appendChild(<node label="Browse Content" func="viewContent" center="true" tooltip={loadTooltip}/>);
            if(!Tweak.download)
            {
               items++;
               savxml.appendChild(<node label="" func="spacer" center="true"/>);
            }
            GameState.ui.menuSave.title = "Content";
         }
         else if(submenu == "localContent")
         {
            items = 1;
            if(this.currentSave)
            {
               if(this.loadedLevel == "")
               {
                  savxml.appendChild(<node label="Overwrite Save" func="save" ico="iconsave" tooltip="Saves the current state of the level.&#10;Note that cut or broken items, and projectiles are not saved.&#10;&#10;"/>);
                  savxml.appendChild(<node label="Load" func="load" ico="iconreload" tooltip="Loads the current save.&#10;"/>);
                  savxml.appendChild(<node label="Share on Workshop" func="shareLevelWorkshop" tooltip="Share the level publicly on Steam Workshop.&#10;" ico="workshop"/>);
                  items++;
                  items += 2;
               }
               else
               {
                  savxml.appendChild(<node label="Unload" func="unloadLevel" ico="iconreset" tooltip="Reset and unload the loaded locked level.&#10;&#10;"/>);
                  savxml.appendChild(<node label="Restart" func="restartLevel" ico="icon_restart" tooltip="Restarts the loaded save.&#10;"/>);
                  items += 2;
               }
               savxml.appendChild(<node label="Add to Library" func="favourite" ico="iconeffects" tooltip="Adds the save in [Library > Saved Levels].&#10;&#10;"/>);
               savxml.appendChild(<node label="Copy to Clipboard" func="copy" ico="iconclipboard" tooltip="Copies the save string to your clipboard.&#10;&#10;"/>);
               items += 2;
            }
            if(this.loadedLevel == "")
            {
               autosaveLabel = "Autosave: " + GameState.AutoSave;
               savxml.appendChild(<node label={autosaveLabel} func="autosave" ico="mode_slomo" tooltip="When enabled, the game will automatically save periodically.&#10;Automatic saves can be found in Save History.&#10;&#10;"/>);
               items++;
            }
            GameState.ui.menuSave.title = "Current Save";
         }
         else if(submenu == "createContentWorkshop")
         {
            items = 7;
            savxml.appendChild(<node label="Custom Item" func="shareItem" tooltip="Custom items created by putting existing items together.&#10;"/>);
            GameState.ui.menuSave.title = "Share on Steam Workshop";
         }
         else if(submenu == "createContent")
         {
            items = 7;
            savxml.appendChild(<node label="Level" func="shareLevel" tooltip="For general mutilating content you want to share.&#10;"/>);
            savxml.appendChild(<node label="Roleplay" func="shareRoleplay" tooltip="For roleplaying content with player-run storylines.&#10;"/>);
            savxml.appendChild(<node label="Contract" func="shareContract" tooltip="Share a Contract, objective-based missions inside the sandbox.&#10;"/>);
            savxml.appendChild(<node label="Custom Item" func="shareItem" tooltip="Share your previously created Custom Items.&#10;"/>);
            GameState.ui.menuSave.title = "Share Content";
         }
         else if(submenu == "viewItems")
         {
            savxml = R.xml_browseItems;
            items = 7;
         }
         else if(submenu == "viewContent")
         {
            items = 4;
            sortLabel = GameState.ContentSort;
            if(this.favouriteSaves.length > 0)
            {
               savxml.appendChild(<node label="Favourites" func="favourites" ico="iconeffects" tooltip="Browse your precious most favourite saves.&#10;"/>);
            }
            else
            {
               savxml.appendChild(<node label="No Favourites" ico="iconeffects" tooltip="Use [Current Save -> Favourite] to save things here for quick access later.&#10;&#10;"/>);
            }
            if(this.qSaveArray.length > 0)
            {
               savxml.appendChild(<node label="Save History" func="savehistory" ico="iconhistory" tooltip="Browse a rolling list of most recent saves, and backup saves from previous session.&#10;&#10;"/>);
               items++;
            }
            savxml.appendChild(<node label="Steam Workshop" func="openWorkshop" ico="workshop" tooltip="Open Steam Workshop.&#10;Requires steam:// protocol.&#10;"/>);
            items++;
            if(!Tweak.download)
            {
               items += 4;
               savxml.appendChild(<node label={sortLabel} func="sort" ico="iconbrowse" tooltip="Select User Content sorting mode.&#10;"/>);
               savxml.appendChild(<node label="Levels" func="browseLevel" ico="iconbrowsee" tooltip="Miscellaneous levels.&#10;"/>);
               savxml.appendChild(<node label="Roleplays" func="browseRoleplay" ico="iconbrowsee" tooltip="Roleplaying content with player-run storylines.&#10;"/>);
               savxml.appendChild(<node label="Contracts" func="browseContract" ico="iconbrowsee" tooltip="Objective-based tiny missions.&#10;&#10;"/>);
               savxml.appendChild(<node label="Custom Items" func="browseItems" ico="iconbrowsee" tooltip="Various player-made items constructed of existing basic items.&#10;&#10;"/>);
            }
            else
            {
               items++;
               savxml.appendChild(<node label="" func="spacer" center="true"/>);
               savxml.appendChild(<node label="" func="spacer" center="true"/>);
            }
            GameState.ui.menuSave.title = "Browse Content";
         }
         else if(submenu == "history")
         {
            items = 2 + this.qSaveArray.length;
            savxml.appendChild(<node label="Back" func="unhistory" center="true" background="#444444"/>);
         }
         else if(submenu == "favourites")
         {
            items = 3 + this.favouriteSaves.length;
            if(items > 7)
            {
               items = 7;
            }
         }
         GameState.ui.menuSave.getTree("buttons").dataProvider = new TreeDataProvider(savxml);
         GameState.ui.menuSave.maximiseHeight = 28 + items * 32;
         GameState.ui.menuSave.fieldPosition = 0;
         GameState.ui.menuSave.movePosition(28 + items * 32);
         GameState.ui.menuSave.redraw();
         if(submenu == "history")
         {
            IO.updateSaveHistory();
         }
         else if(submenu == "favourites")
         {
            IO.updateSaveFavourites();
         }
         else if(submenu == "localContent")
         {
            if(this.AutoSaveTimer.running)
            {
               timeleft = this.AutoSaveTimer.TimeLeft();
               timerString = "";
               if(timeleft > 1)
               {
                  timerString = (timeleft >> 0) + "m ";
               }
               timerString = timerString + int((timeleft - (timeleft >> 0)) * 60).toString() + "s";
               GameState.ui.showTooltip(GameState.ui.menuSave,"Next save in " + timerString + ".",0,2000,GameState.ui.menuSave.actualWidth);
            }
         }
         else if(!Tweak.download && submenu == "none" || Tweak.download && submenu == "viewContent")
         {
            pasteStr = "Paste a save here to load it.";
            saveField = GameState.ui.menuSave.addField("load","",null,24);
            saveField.background = true;
            saveField.backgroundColor = GameState.ui.menuSave.FIELDBACKGROUNDCOLOUR;
            saveField.type = TextFieldType.INPUT;
            saveField.multiline = false;
            saveField.text = pasteStr;
            GameState.ui.menuSave.fieldPosition = 152;
            GameState.ui.menuSave.addSlider(loadSpeed,int(Vars.loadSpeed),1,100,100,16,0);
            GameState.ui.menuSave.addTooltip(loadSpeed,"How many items per frame the game attempts to load. Higher values are more likely to cause the game to freeze while the content loads.\n\n\n\n");
            GameState.ui.menuSave.getGadget(loadSpeed).addEventListener(Event.CHANGE,GameState.ui.updateLoadSpeed);
            GameState.ui.menuSave.getGadget(loadSpeed).addEventListener("finished",this.saveSliderFinished);
            savetf = new TextFormat();
            savetf.align = TextFormatAlign.CENTER;
            saveField.defaultTextFormat = savetf;
            saveField.setTextFormat(savetf);
            saveField.addEventListener(FocusEvent.FOCUS_IN,function(param1:FocusEvent):*
            {
               param1.currentTarget.text = "";
            });
            saveField.addEventListener(FocusEvent.FOCUS_OUT,function(param1:FocusEvent):*
            {
               if(param1.currentTarget.text == "")
               {
                  param1.currentTarget.text = pasteStr;
               }
            });
            saveField.addEventListener(Event.CHANGE,function(param1:Event):*
            {
               if(saveField.text.substr(0,3) != "MAD" && saveField.text.substr(0,2) != "eN")
               {
                  if(saveField.text.substr(0,4) != "http" && saveField.text.substr(0,3) != "www")
                  {
                     saveField.text = "Invalid save pasted.";
                     stage.focus = null;
                  }
                  else
                  {
                     IO.loadExternalModelFromUrl(saveField.text);
                     saveField.text = pasteStr;
                     stage.focus = null;
                     GameState.ui.menuSave.close();
                  }
               }
               else
               {
                  IO.loadWorld(saveField.text,false,true);
                  stage.focus = null;
                  saveField.text = pasteStr;
                  updateSaveMenu("localContent");
               }
            });
            saveField.y = 30 + (items - 1) * 32;
         }
      }
      
      public function stageUnfocus() : void
      {
         stage.focus = null;
      }
      
      public function stageFocus(param1:InteractiveObject) : void
      {
         stage.focus = param1;
      }
      
      private function goToTutorial() : void
      {
         if(!GameState.tutorial)
         {
            GameState.tutorial = new Tutorial();
            addChild(GameState.tutorial);
            GameState.ui.menuMain.visible = false;
         }
         else
         {
            GameState.ui.menuMain.visible = false;
            GameState.menuHandler.getMenu("Tutorials").open();
         }
      }
      
      private function keymapping(param1:ListEvent) : *
      {
         var _loc2_:* = undefined;
         if(param1.item is LeafNode)
         {
            if(param1.item.func)
            {
               if(param1.item.func == "mappingDefault")
               {
                  GameState.ui.menuPrompt.unlock();
                  GameState.ui.menuPrompt.getField("info").type = TextFieldType.DYNAMIC;
                  GameState.ui.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_resetKeymap);
                  GameState.ui.menuPrompt.visible = true;
                  GameState.ui.menuPrompt.title = "Reset Keymap";
                  GameState.ui.menuPrompt.moveToTop();
                  GameState.ui.menuPrompt.center();
                  GameState.ui.menuPrompt.lock();
                  GameState.ui.menuPrompt.getField("info").text = "Please confirm reseting keymap to the default settings.\n\nThis reset can not be reverted,\nback up your keymap first if you wish to keep it.";
               }
               else if(param1.item.func == "mappingList")
               {
                  this.updateKeys();
                  this.keyhelp.visible = !this.keyhelp.visible;
                  addChild(this.keyhelp);
               }
               else if(param1.item.func == "mappingExp")
               {
                  GameState.ui.menuPrompt.unlock();
                  GameState.ui.menuPrompt.getField("info").type = TextFieldType.DYNAMIC;
                  GameState.ui.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_promptCopyKeymap);
                  GameState.ui.menuPrompt.visible = true;
                  GameState.ui.menuPrompt.title = "Export Keymap";
                  GameState.ui.menuPrompt.moveToTop();
                  GameState.ui.menuPrompt.center();
                  GameState.ui.menuPrompt.lock();
                  GameState.ui.menuPrompt.getField("info").text = Keymap.getString();
               }
               else if(param1.item.func == "mappingImp")
               {
                  GameState.ui.menuPrompt.unlock();
                  GameState.ui.menuPrompt.getField("info").type = TextFieldType.INPUT;
                  GameState.ui.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_prompt);
                  GameState.ui.menuPrompt.title = "Import Keymap";
                  GameState.ui.menuPrompt.getField("info").text = "Remove this text and paste a valid keymap here to load.";
                  GameState.ui.menuPrompt.getField("info").textColor = GameState.ui.menuMain.FONTCOLOUR;
                  GameState.ui.menuPrompt.moveToTop();
                  GameState.ui.menuPrompt.center();
                  GameState.ui.menuPrompt.lock();
               }
            }
            if(param1.item.object)
            {
               _loc2_ = Keymap.nameToCode(param1.item.object);
               if(_loc2_ != 0)
               {
                  GameState.ui.menuKeyConfig.getField("Mapped").text = Keymap.codeToKeyname(_loc2_);
                  GameState.ui.menuKeyConfig.getField("info").text = "Double click the action on the list to modify.";
                  GameState.ui.menuKeyConfig.getField("Mapped").textColor = GameState.ui.menuMain.FONTCOLOUR;
                  GameState.ui.menuKeyConfig.getField("info").textColor = GameState.ui.menuMain.FONTCOLOUR;
               }
               else
               {
                  GameState.ui.menuKeyConfig.getField("Mapped").text = "Not Mapped";
                  GameState.ui.menuKeyConfig.getField("info").text = "Double click the action on the list to modify.";
                  GameState.ui.menuKeyConfig.getField("Mapped").textColor = GameState.ui.menuMain.FONTCOLOUR;
                  GameState.ui.menuKeyConfig.getField("info").textColor = GameState.ui.menuMain.FONTCOLOUR;
               }
            }
            else if(param1.item.toggleValue)
            {
               if(param1.item.toggleValue == "0")
               {
                  param1.item.toggleValue = "1";
                  param1.item.forceDrawNode();
               }
               else if(param1.item.toggleValue == "1")
               {
                  param1.item.toggleValue = "0";
                  param1.item.forceDrawNode();
               }
            }
         }
         else
         {
            GameState.ui.menuKeyConfig.getField("Mapped").text = "";
            GameState.ui.menuKeyConfig.getField("info").text = "Click to browse.\nDouble click\nto keymap.";
            GameState.ui.menuKeyConfig.getField("Mapped").textColor = GameState.ui.menuMain.FONTCOLOUR;
            GameState.ui.menuKeyConfig.getField("info").textColor = GameState.ui.menuMain.FONTCOLOUR;
         }
      }
      
      private function updateTools() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:b2Vec2 = null;
         var _loc7_:Number = NaN;
         var _loc8_:userData = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Boolean = false;
         var _loc12_:Boolean = false;
         var _loc13_:Boolean = false;
         var _loc14_:Boolean = false;
         var _loc15_:Boolean = false;
         var _loc16_:Boolean = false;
         var _loc17_:Boolean = false;
         var _loc18_:Boolean = false;
         var _loc19_:Boolean = false;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:userData = null;
         var _loc26_:Number = NaN;
         var _loc27_:Boolean = false;
         if(this.spawnPos)
         {
            if(BoxUtils.vectorDist(this.spawnPos,new b2Vec2(mouseX,mouseY)) > Tweak.toolDeadzone)
            {
               this.spawnPos = null;
               this.dragSpawn(null);
            }
         }
         if(Tool.isCamera)
         {
            if(GameState.mouseDown && GameState.rightDown)
            {
               this.zoom(1 / (1 - Tweak.ZoomStep));
            }
            else if(GameState.rightDown)
            {
               this.zoom(1 / (1 / (1 - Tweak.ZoomStep)));
            }
         }
         if(Tool.isTrigger && !this.itemTriggered)
         {
            this.toolSprite.graphics.clear();
            if(GameState.mouseDown && !GameState.spawning)
            {
               this.toolSprite.graphics.lineStyle(this.zoomLineStyle(),4097883);
               if(!this.triggerBodyAt(new b2Vec2(this.mouseXWorld,this.mouseYWorld)))
               {
                  this.toolSprite.graphics.drawCircle(this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale,5 / this.cam.scaleX);
               }
            }
         }
         if(Tool.isAim)
         {
            if(Boolean(this.selectedBodies) && this.selectedBodies.length > 0)
            {
               _loc1_ = BoxUtils.vectorDist(this.scalingPos,new b2Vec2(this.mouseXWorld,this.mouseYWorld)) <= Tweak.toolDeadzone / Physics.scale;
               if(!_loc1_ && GameState.mouseDown)
               {
                  userData(this.selectedBodies[0].GetUserData()).triggered = true;
               }
            }
            else
            {
               this.toolSprite.graphics.clear();
            }
         }
         if(this.detailBody)
         {
            _loc2_ = this.detailBody.GetPosition().x * Physics.scale;
            _loc3_ = this.detailBody.GetPosition().y * Physics.scale;
            _loc4_ = GameState.ui.menuDetails.x + 2;
            _loc5_ = GameState.ui.menuDetails.y + 11;
            _loc6_ = GeneralUtils.pointOnCircle(_loc2_,_loc3_,20,Math.atan2(_loc5_ - _loc3_,_loc4_ - _loc2_) * Vars.toDegrees);
            _loc2_ = _loc6_.x + this.m_sprite.x;
            _loc3_ = _loc6_.y + this.m_sprite.y;
            _loc2_ = GraphicUtils.camX(_loc2_);
            _loc3_ = GraphicUtils.camY(_loc3_);
            _loc7_ = 1;
            if(_loc2_ > _loc4_ + GameState.ui.menuDetails.actualWidth * 0.5)
            {
               _loc4_ += GameState.ui.menuDetails.actualWidth - 2;
               _loc7_ = -1;
            }
            if(!this.detailLine)
            {
               this.detailLine = new Sprite();
            }
            this.detailLine.graphics.clear();
            this.detailLine.graphics.lineStyle(2,GameState.ui.menuDetails.FONTCOLOUR);
            this.detailLine.graphics.moveTo(_loc2_ + _loc7_,_loc3_ + _loc7_);
            this.detailLine.graphics.lineTo(_loc4_ + _loc7_,_loc5_ + _loc7_);
            this.detailLine.graphics.lineStyle(1,GameState.ui.menuDetails.BORDERCOLOUR);
            this.detailLine.graphics.moveTo(_loc2_,_loc3_);
            this.detailLine.graphics.lineTo(_loc4_,_loc5_);
            this.particlesBMD.draw(this.detailLine);
            if(this.detailCounter > 0)
            {
               --this.detailCounter;
            }
            else if(GameState.ui.menuObject.visible && GameState.ui.menuObject.title == "Detail Settings")
            {
               this.detailCounter = 30;
               _loc8_ = userData(this.detailBody.GetUserData());
               _loc9_ = this.detailBody.GetAngle() * Vars.toDegrees % 360 >> 0;
               if(_loc9_ < 0)
               {
                  _loc9_ += 360;
               }
               _loc10_ = _loc8_.health >> 0;
               if(_loc10_ < 0)
               {
                  _loc10_ = 0;
               }
               _loc11_ = true;
               _loc12_ = true;
               _loc13_ = true;
               _loc14_ = true;
               _loc15_ = true;
               _loc16_ = true;
               _loc17_ = true;
               _loc18_ = true;
               _loc19_ = true;
               if(stage.focus)
               {
                  if(stage.focus.name == "X Position")
                  {
                     _loc18_ = false;
                  }
                  if(stage.focus.name == "Y Position")
                  {
                     _loc19_ = false;
                  }
                  if(stage.focus.name == "Angle")
                  {
                     _loc11_ = false;
                  }
                  if(stage.focus.name == "Temperature")
                  {
                     _loc12_ = false;
                  }
                  if(stage.focus.name == "Health")
                  {
                     _loc13_ = false;
                  }
                  if(stage.focus.name == "Scale")
                  {
                     _loc14_ = false;
                  }
                  if(stage.focus.name == "X Velocity")
                  {
                     _loc15_ = false;
                  }
                  if(stage.focus.name == "Y Velocity")
                  {
                     _loc16_ = false;
                  }
                  if(stage.focus.name == "A Velocity")
                  {
                     _loc17_ = false;
                  }
               }
               if(!_loc8_.alive && !_loc8_.armour)
               {
                  _loc13_ = false;
               }
               if(_loc11_)
               {
                  GameState.ui.menuObject.setValue("Angle",_loc9_ >> 0);
               }
               if(_loc12_)
               {
                  _loc20_ = _loc8_.temperature;
                  if(World.toggleFahrenheit == 1)
                  {
                     _loc20_ = 9 / 5 * _loc20_ + 32;
                  }
                  GameState.ui.menuObject.setValue("Temperature",_loc20_ >> 0);
               }
               if(_loc18_)
               {
                  GameState.ui.menuObject.setValue("X Position",this.detailBody.GetPosition().x * Physics.scale >> 0);
               }
               if(_loc19_)
               {
                  GameState.ui.menuObject.setValue("Y Position",this.detailBody.GetPosition().y * Physics.scale >> 0);
               }
               if(_loc13_)
               {
                  GameState.ui.menuObject.setValue("Health",_loc10_ >> 0);
               }
               if(_loc15_)
               {
                  GameState.ui.menuObject.setValue("X Velocity",this.detailBody.GetLinearVelocity().x * Physics.scale >> 0);
               }
               if(_loc16_)
               {
                  GameState.ui.menuObject.setValue("Y Velocity",this.detailBody.GetLinearVelocity().y * Physics.scale >> 0);
               }
               if(_loc17_)
               {
                  GameState.ui.menuObject.setValue("A Velocity",this.detailBody.GetAngularVelocity() * Vars.toDegrees >> 0);
               }
               if(_loc14_)
               {
                  GameState.ui.menuObject.setValue("Scale",_loc8_.size * 100 >> 0);
               }
            }
            else if(GameState.ui.menuObject.visible && GameState.ui.menuColour.visible && GameState.ui.menuObject.title == "Detail Skin")
            {
               this.detailCounter = 30;
               this.ApplyDetailSkin();
            }
         }
         if(Tool.isAim)
         {
            if(Boolean(this.scalingPos) && Boolean(this.selectedBodies) && this.selectedBodies.length > 0)
            {
               this.scalingPos = this.selectedBodies[0].GetPosition().Copy();
               this.toolSprite.graphics.clear();
               _loc1_ = BoxUtils.vectorDist(this.scalingPos,new b2Vec2(this.mouseXWorld,this.mouseYWorld)) <= Tweak.toolDeadzone / Physics.scale;
               _loc21_ = (-this.mouseYWorld + this.scalingPos.y) * Physics.scale;
               _loc22_ = (-this.mouseXWorld + this.scalingPos.x) * Physics.scale;
               _loc23_ = Math.atan2(_loc21_,_loc22_);
               if(!_loc1_)
               {
                  this.toolSprite.graphics.beginFill(16777215,0.2);
               }
               this.toolSprite.graphics.lineStyle(this.zoomLineStyle(),16777215);
               this.toolSprite.graphics.drawCircle(this.scalingPos.x * Physics.scale,this.scalingPos.y * Physics.scale,Tweak.toolDeadzone);
               if(!_loc1_ && this.selectedBodies.length > 0)
               {
                  _loc24_ = 0;
                  _loc25_ = userData(this.selectedBodies[0].GetUserData());
                  _loc26_ = Math.atan2(-this.mouseYWorld + this.selectedBodies[0].GetPosition().y,-this.mouseXWorld + this.selectedBodies[0].GetPosition().x);
                  _loc26_ = _loc26_ - (this.selectedBodies[0].GetAngle() % (Math.PI * 2) - (_loc25_.flipped ? Math.PI : 0));
                  if(_loc25_.name == "jointslinger")
                  {
                     _loc26_ += 180 * Vars.toRadians;
                  }
                  if(_loc26_ * Vars.toDegrees > 270)
                  {
                     _loc26_ -= Math.PI * 2;
                  }
                  if(_loc26_ * Vars.toDegrees < -270)
                  {
                     _loc26_ += Math.PI * 2;
                  }
                  _loc26_ *= 250;
                  if(GameState.slomo)
                  {
                     _loc26_ /= TimeLord.speed * 0.1;
                  }
                  this.selectedBodies[0].ApplyTorque(_loc26_ * this.selectedBodies[0].GetMass());
                  this.selectedBodies[0].WakeUp();
               }
               this.toolSprite.graphics.endFill();
            }
            else
            {
               _loc27_ = true;
               if(this.contract.target != -1)
               {
                  _loc27_ = false;
               }
               if(_loc27_)
               {
                  this.MouseDrag();
               }
            }
         }
      }
      
      private function ModifyDetailSkin() : *
      {
         var _loc1_:Vector.<Array> = null;
         GameState.ui.selectItemByName(userData(this.detailBody.GetUserData()).name);
         this.detailSkinBase = O.getItem(GameState.objects.spawnName).colours;
         this.colouring = "skindetail";
         _loc1_ = userData(this.detailBody.GetUserData()).skin;
         if(_loc1_.length > 0)
         {
            GameState.objects.spawnSkin = _loc1_;
            this.updateSpawnPic();
            this.updateSkin();
         }
      }
      
      public function updateSkin() : void
      {
         var spawnitem:Item = null;
         var item:Item = null;
         var skinxml:XML = null;
         var uniqArray:Array = null;
         var c:int = 0;
         var replace:String = null;
         var btn:XML = null;
         var i:int = 0;
         var alive:Boolean = false;
         var bc:uint = 0;
         var objTree:Tree = null;
         var col:* = undefined;
         var colString:String = null;
         var bloodstr:String = null;
         if(GameState.ui.menuObject.title != "Skin" && GameState.ui.menuObject.title != "Detail Skin")
         {
            return;
         }
         spawnitem = O.getItem(GameState.objects.spawnName);
         if(!spawnitem)
         {
            return;
         }
         item = spawnitem;
         skinxml = <node label="Root Node"></node>;
         uniqArray = [];
         c = 0;
         for(; c < item.colours.length; c++)
         {
            col = item.colours[c];
            if(col is userData)
            {
               col = userData(col).name;
            }
            if(col is ShapeUserData)
            {
               if(ShapeUserData(col).invisible)
               {
                  continue;
               }
               col = ShapeUserData(col).name;
            }
            col = BoxUtils.shapeNameToColour(col).toString(16);
            col = col.toUpperCase();
            if(uniqArray.indexOf(col) == -1)
            {
               uniqArray.push(col);
            }
         }
         if(GameState.skinning)
         {
            btn = <node/>;
            btn.@label = "Finished";
            btn.@func = "copydetailskinfinish";
            btn.@center = "true";
            btn.@tooltip = "Finish skinning items.\n";
            skinxml.appendChild(btn);
         }
         else
         {
            btn = <node/>;
            btn.@label = "Reset";
            btn.@func = "resetskin";
            btn.@center = "true";
            btn.@tooltip = "Resets skin colours to defaults.\n";
            skinxml.appendChild(btn);
            btn = <node/>;
            btn.@label = "Clone";
            btn.@func = "copydetailskin";
            btn.@center = "true";
            btn.@tooltip = "Focuses identical items, allowing clicking them to apply this skin.\n\n";
            skinxml.appendChild(btn);
            btn = <node/>;
            btn.@label = "Random";
            btn.@func = "randomskin";
            btn.@center = "true";
            btn.@tooltip = "Randomises all skin colours.\n";
            skinxml.appendChild(btn);
         }
         skinxml.appendChild(<node label="" func="spacer"/>);
         i = 0;
         while(i < uniqArray.length)
         {
            btn = <button/>;
            btn.@id = i;
            btn.@func = "modifyskin";
            colString = uniqArray[i];
            replace = BoxUtils.shapeNameToColour(colString,GameState.objects.spawnSkin).toString(16).toUpperCase();
            while(replace.length < 6)
            {
               replace = "0" + replace;
            }
            btn.@label = "#" + replace;
            btn.@background = "#" + replace;
            btn.@center = "true";
            btn.@colour = colString;
            skinxml.appendChild(btn);
            i++;
         }
         alive = Body.IsAlive(GameState.objects.spawnName);
         bc = Tweak.bloodColour;
         if(Boolean(this.detailBody) && Boolean(this.detailBody.GetUserData()) && Boolean(this.detailBody.GetUserData().alive))
         {
            alive = true;
            bc = userData(this.detailBody.GetUserData()).bloodColour;
         }
         if(alive)
         {
            skinxml.appendChild(<node label="Blood" func="modifycolour" center="true" tooltip="Pick blood colour. Applies to all blood and gore effects.&#10;&#10;&#10;"/>);
            bloodstr = "#" + uint(bc).toString(16).toUpperCase();
            if(bloodstr == "#0")
            {
               bloodstr = "#000001";
            }
            skinxml.node.(@label == "Blood").@background = bloodstr;
         }
         objTree = GameState.ui.menuObject.getTree("buttons");
         objTree.dataProvider = new TreeDataProvider(skinxml);
         GameState.ui.menuObject.maximiseHeight = (skinxml.node.length() + skinxml.button.length()) * objTree.rowHeight + 32 + 36;
         GameState.ui.menuObject.maximise();
         if(GameState.ui.menuObject.visible && GameState.ui.menuObject.title == "Detail Skin")
         {
            if(this.detailBody)
            {
               GameState.ui.menuObject.getSlider("Opacity").value = int(userData(this.detailBody.GetUserData()).alpha * 100);
            }
         }
      }
      
      public function updateBloodBMD(param1:uint) : BitmapData
      {
         var _loc2_:BitmapData = null;
         _loc2_ = R.getSprite("p_blood");
         _loc2_.floodFill(4,4,4278190080 + param1);
         return _loc2_;
      }
      
      public function updateSmoothBloodBMD(param1:uint) : BitmapData
      {
         var _loc2_:int = 0;
         var _loc3_:BitmapData = null;
         var _loc4_:Matrix = null;
         var _loc5_:Sprite = null;
         _loc2_ = Tweak.smoothBloodSize;
         _loc3_ = new BitmapData(_loc2_,_loc2_,true,0);
         _loc4_ = new Matrix();
         _loc4_.createGradientBox(_loc2_,_loc2_,0,0,0);
         _loc5_ = new Sprite();
         _loc5_.graphics.beginGradientFill(GradientType.RADIAL,[param1,param1,param1,param1],[0.6,0.3,0.1,0],[20,80,160,255],_loc4_);
         _loc5_.graphics.drawCircle(_loc2_ * 0.5,_loc2_ * 0.5,_loc2_);
         _loc5_.graphics.endFill();
         _loc3_.fillRect(_loc3_.rect,0);
         _loc3_.draw(_loc5_,_loc5_.transform.matrix);
         return _loc3_;
      }
      
      private function updateBlood() : void
      {
         var _loc1_:BitmapData = null;
         _loc1_ = this.updateBloodBMD(Tweak.bloodColour);
         R.setSprite("p_blood",_loc1_);
         GameState.particles.blood.graphic = _loc1_;
         this.updateSmoothBloodBMD(Tweak.bloodColour);
      }
      
      private function updateKeys() : *
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:TextField = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         TextField(this.keyhelp.getChildByName("field1")).text = "";
         TextField(this.keyhelp.getChildByName("field2")).text = "";
         _loc1_ = Keymap.getString().split("|");
         _loc2_ = int(_loc1_.length);
         _loc3_ = 0;
         _loc4_ = "";
         _loc5_ = TextField(this.keyhelp.getChildByName("field1"));
         _loc9_ = 0;
         while(_loc9_ < _loc2_)
         {
            _loc6_ = Keymap.IDToName(_loc9_);
            _loc7_ = Keymap.codeToKeyname(Keymap.nameToCode(_loc6_));
            _loc8_ = Keymap.getCategoryByName(_loc6_);
            if(!(_loc8_ == "debug" || _loc8_ == "favourite"))
            {
               _loc10_ = Keymap.IDToAlias(_loc9_);
               if(!(_loc6_ == "Placeholder" || _loc6_ == "Blank"))
               {
                  if(_loc10_.indexOf("Power") == -1)
                  {
                     if(_loc3_ >= 32)
                     {
                        _loc5_ = TextField(this.keyhelp.getChildByName("field2"));
                     }
                     if(_loc7_ != "-")
                     {
                        _loc3_++;
                        if(_loc5_.text.length == 0)
                        {
                           _loc4_ = "";
                        }
                        _loc5_.text = _loc5_.text + _loc4_ + _loc10_ + GeneralUtils.repeatString(" ",16 - _loc10_.length) + _loc7_;
                        _loc4_ = "\n";
                     }
                  }
               }
            }
            _loc9_++;
         }
      }
      
      private function changeMapping(param1:ListEvent) : *
      {
         if(param1.item is LeafNode && Boolean(param1.item.object))
         {
            GameState.ui.menuKeyConfig.getField("Mapped").text = "???";
            GameState.ui.menuKeyConfig.getField("info").text = "Any key to map.\nEsc to cancel.\nDel/Backspace to clear.";
            GameState.mapping = true;
            this.mappingObject = param1.item.object;
         }
      }
      
      private function togglefps() : void
      {
         this.fps.visible = !this.fps.visible;
         GameState.ui.console.toggleConsole();
      }
      
      public function drawShadowsFor(param1:Array, param2:int) : void
      {
         Shadows.shadowDuration = param2;
         Shadows.shadowBodies = param1;
      }
      
      private function AutoSave(param1:TimerEvent) : void
      {
         if(GameState.ui.menuSave.title == "Current Save")
         {
            this.updateSaveMenu("localContent");
         }
         IO.saveWorld();
      }
      
      private function saveSettingsWhenFinished(param1:String) : *
      {
         GameState.ui.menuSettings.getGadget(param1).addEventListener("finished",this.saveSliderFinished);
      }
      
      private function saveSliderFinished(param1:Event) : *
      {
         var _loc2_:Number = NaN;
         if(GameState.ui.menuSettings.getChildByName("Max Particles"))
         {
            _loc2_ = GameState.ui.menuSettings.getValue("Max Particles");
            _loc2_ = Math.round(_loc2_ / 100) * 100;
            GameState.ui.menuSettings.setValue("Max Particles",_loc2_);
            Vars.particlesMax = _loc2_;
         }
         Settings.saveSettings();
      }
      
      public function updateToggles(param1:String = "main") : void
      {
         var goreicon:* = undefined;
         var goredoll:* = undefined;
         var mouseSettings:XML = null;
         var resetSettings:XML = null;
         var goreSettings:XML = null;
         var dollSettings:XML = null;
         var quality:String = null;
         var visualToggles:XML = null;
         var pauseToggles:XML = null;
         var menuToggles:XML = null;
         var physicsSettings:XML = null;
         var mainSettings:XML = null;
         var performanceSettings:XML = null;
         var xml_settings:XML = null;
         var siz:Number = NaN;
         var treeSettings:Tree = null;
         var pausenode:* = undefined;
         var antifreeze:String = null;
         var physicsIterations:String = null;
         var maxParticles:String = null;
         var maxCollisions:String = null;
         var cquality:String = null;
         var iq:Array = null;
         var submenu:String = param1;
         GameState.ui.menuSettings.removeAllChildren();
         GameState.ui.menuSettings.movePosition(Window.BUFFER);
         goreicon = "p_spatter";
         goredoll = "doll_gore";
         if(World.toggleGore == 0)
         {
            goreicon = "empty";
            goredoll = "doll_large";
         }
         mouseSettings = <node label="Mouse" ico="tool_drag">
					<node label="Scrollwheel Zoom" func="scrollwheel" toggleValue={World.scrollWheel} tooltip="Toggle scrollwheel zoom. Reset the camera by spamming Camera tool hotkey.&#10;&#10;"/>
					<node label="Edge Pan" func="edgepan" toggleValue={World.toggleEdgePan} tooltip="Pan camera when mouse is held still near screen edges in large Environments.&#10;&#10;&#10;" submenu="controls"/>
				</node>;
         resetSettings = <node label="Reset" tooltip="Resets are immediate and can't be reverted.&#10;Make sure you're sure you want to do that.&#10;&#10;Scroll down to see the individual categories.&#10;" background="#330000">
					<node label="" func="spacer"/>

					<node label="Settings" func="resetSettings" tooltip="Resets this menu's settings to default.&#10;&#10;"/>

					<node label="" func="spacer"/>

					<node label="Favourites" func="resetFavs" tooltip="Resets favourite items to defaults.&#10;&#10;"/>

					<node label="" func="spacer"/>

					<node label="Powers" func="resetPowersList" tooltip="Resets your Powers list to default order.&#10;&#10;"/>

					<node label="" func="spacer"/>

					<node label="Custom Items" func="resetCustoms" tooltip="Deletes all custom items.&#10;&#10;"/>
				</node>;
         goreSettings = <node label="Blood Effects" ico={goreicon}>
					<node label="Blood & Gore" func="bloodgore" toggleValue={World.toggleGore} tooltip="Toggles all bloody visual effects on or off.&#10;&#10;" submenu="dolls"/>
					<node label="Extra Splatter" func="extragore" toggleValue={World.toggleExtraGore} tooltip="Blood splatters excessively on blunt hits, smearing nearby objects as well.&#10;Disabling will increase performance!&#10;"/>
					<node label="Smooth Blood" func="smoothblood" toggleValue={World.toggleSmoothBlood} tooltip="Smoothens blood rendering, making it appear liquid.&#10;" submenu="dolls"/>
					<node label="Physics Blood" func="physicsblood" toggleValue={World.togglePhysicsBlood} tooltip="Every single blood drop has physics attached. VERY LAGGY. Not remotely recommended to be used.&#10;&#10;"/>
				</node>;
         dollSettings = <node label="Ragdolls" ico="doll_large">
					<node label="Bodypart Health" func="healthbars" toggleValue={World.toggleHealthbars} tooltip="Healthbars on individual alive items.&#10;"/>
					<node label="Total Health" func="dollbars" toggleValue={World.toggleDollbars} tooltip="Displays total health of all alive items jointed together.&#10;&#10;"/>
					<node label="Armour Health" func="armourbars" toggleValue={World.toggleArmourbars} tooltip="Healthbars on equipped pieces of armour.&#10;"/>
					<node label="Can Break" func="dollbreak" toggleValue={World.toggleRagdollBreak} tooltip="Toggles joints breaking, and bodyparts being destroyed when damaged. Doesn't affect most item effects.&#10;&#10;&#10;" submenu="dolls"/>
					<node label="Can Stand" func="dollstand" toggleValue={World.toggleStabi} tooltip="Dolls will stand or handstand as a quality of life feature.&#10;&#10;"/>
					<node label="Can Concuss" func="concuss" toggleValue={World.toggleDollSleep} tooltip="Dolls stop standing when hit hard in the head.&#10;&#10;"/>
					<node label="Status Icons" func="dollicons" toggleValue={World
         .toggleDollicons} tooltip="Status effect icons&#10;Empty skull = Dead 30% total hp.&#10;&#10;Half skull=Crippled 50% total hp, can't stand.&#10;&#10;Red X = Crippled 50% bodypart hp, can't stand.&#10;&#10;"/>
				</node>;
         quality = "Quality " + stage.quality;
         visualToggles = <node label="Visual" ico="paintbrush">
					<node label="Play Joints" func="showjoints" toggleValue={World.toggleJoints} tooltip="Item joints are visible while playing.&#10;"/>
					<node label="Selection Glow" func="selectionglow" toggleValue={World.toggleSelectionGlow} tooltip="Enabled: Selected items glow.&#10;Disabled: Selected items display their collider hull outline.&#10;&#10;&#10;"/>
					<node label="Precise Effects" func="precisefx" toggleValue={World.togglePreciseEffects} tooltip="Visual effects are masked using precise item data instead of its collider hull. Disabling will increase performance drastically.&#10;&#10;&#10;&#10;&#10;"/>
					<node label="Visual Effects" func="effects" toggleValue={World.toggleEffects} tooltip="Additional visual effects such as blood stains and stamps. Some items rely on this setting! Disabling will increase performance.&#10;&#10;&#10;&#10;&#10;"/>
					<node label="Temp. in °F" func="fahrenheit" toggleValue={World.toggleFahrenheit} tooltip="Temperature in Fahrenheit. (Default: °C.)&#10;&#10;"/>
				</node>;
         pauseToggles = <node label="Pause" ico="mode_edit">
					<node label="Blueprint" func="showblueprint" toggleValue={World.toggleBlueprint} tooltip="Blueprint style on pause. LAGGY.&#10;"/>
					<node label="Grid" func="showgrid" toggleValue={World.toggleGrid} tooltip="Grid on pause."/>
					<node label="Velocity" func="showvelo" toggleValue={World.toggleVelocity} tooltip="Body velocity drawn as a line when paused.&#10;"/>
					<node label="Radius" func="showradius" toggleValue={World.toggleRadius} tooltip="Trigger radius drawn when paused.&#10;"/>
				</node>;
         menuToggles = <node label="Menus" ico="tool_crash">
					<node label="Dark Mode" func="darkMode" toggleValue={World.toggleDarkMode} tooltip="Toggle dark mode for menus.&#10;&#10;Requires restarting the game to apply. (Sorry.)&#10;"/>
					<node label="Hover Sound" func="hoverSound" toggleValue={sounds.UISound ? 1 : 0} tooltip="Toggles tiny sound on menu item hover.&#10;"/>
					<node label="Edge Stick" func="edgestick" toggleValue={World.toggleEdgeStick} tooltip="Menus stick to screen edges when dragged. Beware of losing your menus.&#10;&#10;&#10;"/>
					<node label="Reset Confirmation" func="resetConfirm" toggleValue={World.toggleResetConfirm} tooltip="Require confirmation after pressing reset, to avoid accidentally deleting everything.&#10;&#10;&#10;"/>
					<node label="Spawn Menu Hole" func="spawnbg" toggleValue={World.toggleSpawnBG} tooltip="Spawn menu has a hole in it for better previewing against the background.&#10;&#10;&#10;"/>
					<node label="Save Layout" func="saveMenus" center="true" tooltip="Saves current menu positions to be loaded whenever the game is launched.&#10;&#10;"/>
					<node label="Load Layout" func="loadMenus" center="true" tooltip="Loads saved menu positions.&#10;"/>
					<node label="Default Layout" func="resetMenus" center="true" tooltip="Resets menu positions to defaults.&#10;&#10;"/>
					<node label="" func="spacer" center="true"/>
					<node label="Console" func="toggleConsole" center="true" tooltip="Toggles console. It's likely useless for you.&#10;&#10;"/>
					<node label="Settings Folder" func="settingsFolder" center="true" tooltip="Opens settings folder that contains all the files the game stores.&#10;&#10;"/>
					<node label="Credits" func="toggleCredits" center="true" tooltip="Toggles credits.&#10;&#10;"/>
				</node>;
         physicsSettings = <node label="Physics" ico="tool_launch">
					<node label="Auto Slow Motion" func="slomo" toggleValue={World.toggleSlomo} tooltip="Automatic slomo on collisions.&#10;"/>
					<node label="Destroy Shrapnel" func="destroysmall" toggleValue={World.toggleShrapnel} tooltip="Automatically destroys small shrapnel on cut.&#10;"/>
					<node label="Collide Shrapnel" func="shrapnels" toggleValue={World.toggleCutFilter} tooltip="Toggles cut shrapnel collisions. Disabling will increase performance.&#10;&#10;&#10;&#10;"/>
					<node label="Joints Can Break" func="jointbreak" toggleValue={World.toggleJointBreak} tooltip="Non-doll joints break when pulled too hard. Doesn't affect joints that have been saved unbreakable.&#10;&#10;&#10;"/>
				</node>;
         mainSettings = <node label="Settings">
					<node label="Dolls & Blood" ico={goredoll} func="settingsSubmenu" submenu="dolls"/>
					<node label="Graphics" ico="paintbrush" func="settingsSubmenu" submenu="graphics"/>
					<node label="Physics" ico="tool_launch" func="settingsSubmenu" submenu="physics"/>
					<node label="Mouse & Camera" ico="tool_roleplay" func="settingsSubmenu" submenu="controls"/>
					<node label="Menus" ico="tool_crash" func="settingsSubmenu" submenu="menus"/>
					<node label="Performance" ico="gridbig" func="settingsSubmenu" submenu="performance" tooltip="A collection of setting recommendations that may improve performance.&#10;&#10;"/>
					<node label="" func="spacer"/>
				</node>;
         performanceSettings = <node label="Performance" ico="p_grid" tooltip="A collection of setting [recommendations] that improve performance, in order of performance impact.&#10;&#10;&#10;">
					<node label="[ ] Physics Blood" func="physicsblood" toggleValue={World.togglePhysicsBlood} tooltip="ALL blood has physics. VERY LAGGY. Not even recommended to be used.&#10;&#10;&#10;"/>
					<node label="[ ] Precise Effects" func="precisefx" toggleValue={World.togglePreciseEffects} tooltip="Visual effects are masked using precise item data instead of its collider hull. Disabling will increase performance drastically.&#10;&#10;&#10;&#10;&#10;"/>
					<node label="[*] Camera Culling" func="culling" toggleValue={World.toggleCulling} tooltip="Toggle camera culling graphics outside its vision.&#10;&#10;"/>
					<node label="[ ] Blood Splatters" func="extragore" toggleValue={World.toggleExtraGore} tooltip="Blood splatters to nearby objects on hard hits.&#10;Disabling will increase performance!&#10;&#10;&#10;"/>
					<node label="[*] Destroy Shrapnel" func="destroysmall" toggleValue={World
         .toggleShrapnel} tooltip="Automatically destroys small shrapnel on cut.&#10;"/>
					<node label="[ ] Collide Shrapnel" func="shrapnels" toggleValue={World.toggleCutFilter} tooltip="Toggles cut shrapnel collisions. Disabling will increase performance.&#10;&#10;&#10;&#10;"/>
					<node label="[ ] Blueprint" func="showblueprint" toggleValue={World.toggleBlueprint} tooltip="Blueprint style on pause. Very laggy.&#10;"/>
					<node label="[ ] Grid" func="showgrid" toggleValue={World.toggleGrid} tooltip="Grid on pause."/>
				</node>;
         xml_settings = <node label="Root Node"></node>;
         if(submenu != "main")
         {
            xml_settings.appendChild(<node label="Back" func="settingsSubmenu" submenu="main" center="true" tooltip="Back to settings."/>);
         }
         if(submenu == "main")
         {
            xml_settings.appendChild(<node label="Exit Game" func="exitgame" ico="tool_delete" tooltip="Exit.&#10;"/>);
            xml_settings.appendChild(<node label="Main Menu" func="mainmenu" ico="home" tooltip="Reset and return to main menu.&#10;"/>);
            xml_settings.appendChild(<node label="Tutorial" func="tutorial" ico="icontutorial" tooltip="Learn how to play.&#10;"/>);
            xml_settings.appendChild(<node label="Keymapping" func="mappingEdit" ico="keys" tooltip="Map tools and other functionality to keys.&#10;"/>);
            xml_settings.appendChild(mainSettings);
         }
         else if(submenu == "dolls")
         {
            if(World.toggleSmoothBlood == 1)
            {
               GameState.ui.menuSettings.addSlider("Smooth Blood Size",int(Tweak.smoothBloodSize),8,32).originalValueSnap = 0;
               GameState.ui.menuSettings.addTooltip("Smooth Blood Size","Affects smooth blood particle size. Default: 12.\n");
               this.saveSettingsWhenFinished("Smooth Blood Size");
               GameState.ui.menuSettings.getGadget("Smooth Blood Size").addEventListener(Event.CHANGE,GameState.ui.updateSmoothBloodSize);
               GameState.ui.menuSettings.addSlider("Smooth Blood Fluidity",int(Tweak.bloodSmoothing * 100),0,100).originalValueSnap = 0;
               GameState.ui.menuSettings.addTooltip("Smooth Blood Fluidity","Affects blood rendering fluidity. Setting the value to zero will increase performance, for all other values performance hit is identical. Default: 0.4\n\n\n\n\n");
               this.saveSettingsWhenFinished("Smooth Blood Fluidity");
               GameState.ui.menuSettings.getGadget("Smooth Blood Fluidity").addEventListener(Event.CHANGE,GameState.ui.updateBloodSmoothing);
            }
            if(World.toggleHealthbars == 1 || World.toggleDollbars == 1 || Boolean(World.toggleArmourbars))
            {
               GameState.ui.menuSettings.addSlider("% Healthbar Scale",int(Vars.barscale * 100),10,200);
               GameState.ui.menuSettings.addTooltip("% Healthbar Scale","Affects width of all healthbars.\n");
               this.saveSettingsWhenFinished("% Healthbar Scale");
               GameState.ui.menuSettings.getGadget("% Healthbar Scale").addEventListener(Event.CHANGE,GameState.ui.updateBarScale);
            }
            if(World.toggleRagdollBreak == 1)
            {
               goreSettings.appendChild(<node label="Bodyparts Break" func="dollgib" toggleValue={World.toggleBodypartGibs} tooltip="Dead bodyparts break apart when out of health.&#10;&#10;"/>);
               goreSettings.appendChild(<node label="Bodyparts Pulp" func="gibgib" toggleValue={World.toggleGibsGib} tooltip="Bodyparts pulp into blood when out of health (happens after break.)&#10;&#10;"/>);
            }
            xml_settings.appendChild(goreSettings);
            xml_settings.appendChild(dollSettings);
         }
         else if(submenu == "graphics")
         {
            if(!Tweak.download)
            {
               xml_settings.appendChild(<node label={quality} func="changeQuality" tooltip="Toggle overall Flash Player quality.&#10;" submenu="graphics"/>);
            }
            else
            {
               if(World.toggleFullscreen != 0)
               {
                  xml_settings.appendChild(<node label="Windowed" func="windowedMode" tooltip="Toggles fullscreen. Also [Alt+Enter].&#10;&#10;&#10;"/>);
               }
               else
               {
                  xml_settings.appendChild(<node label="Fullscreen (Quality)" func="fullscreenModeQuality" tooltip="Enters fullscreen mode where the game renders in full quality.&#10;&#10;&#10;"/>);
                  xml_settings.appendChild(<node label="Fullscreen (Speed)" func="fullscreenModePerformance" tooltip="Enters fullscreen mode where the window is stretched to fullscreen, making everything look blurrier, but increasing performance.&#10;&#10;&#10;&#10;"/>);
               }
               xml_settings.appendChild(<node label="Scale Renderer" func="scaleMode" toggleValue={World.toggleScaleMode} tooltip="Toggles scaling mode for the game, making it stretch to window size. Enabling reduces rendering performance by a lot.&#10;&#10;&#10;"/>);
            }
            GameState.ui.menuSettings.addSlider("% Particles",int(Vars.particles * 100),1,300);
            GameState.ui.menuSettings.addTooltip("% Particles","Amount of particles spawned. Lowering may increase performance.\n\n");
            this.saveSettingsWhenFinished("% Particles");
            GameState.ui.menuSettings.getGadget("% Particles").addEventListener(Event.CHANGE,GameState.ui.updateParticles);
            GameState.ui.menuSettings.addSlider("Max Particles",int(Vars.particlesMax),100,3000);
            GameState.ui.menuSettings.addTooltip("Max Particles","Maximum amount of particles in a single system at once. Lowering may increase performance.\n\n\n");
            this.saveSettingsWhenFinished("Max Particles");
            GameState.ui.menuSettings.getGadget("Max Particles").addEventListener(Event.CHANGE,GameState.ui.updateMaxParticles);
            xml_settings.appendChild(visualToggles);
            xml_settings.appendChild(pauseToggles);
            pausenode = xml_settings.node.(@label == "Pause");
            pausenode.appendChild(<node label="Joints" func="pausejoints" toggleValue={World.toggleJointsPause} tooltip="Joints visible when paused.&#10;" submenu="graphics"/>);
            if(World.toggleJointsPause == 1)
            {
               pausenode.appendChild(<node label="Selected Joints" func="selectedjoints" toggleValue={World.toggleJointSelected} tooltip="Joints visible only for selected objects.&#10;&#10;"/>);
            }
            if(World.toggleJoints == 1)
            {
               pausenode.appendChild(<node label="Alive Joints" func="alivejoints" toggleValue={World.toggleJointsAlive} tooltip="Alive-Alive joints and ropes visible.&#10;&#10;"/>);
            }
            pausenode.appendChild(<node label="Links" func="pauselinks" toggleValue={World.toggleLinkPause} tooltip="Links visible when paused.&#10;" submenu="graphics"/>);
            if(World.toggleLinkPause == 1)
            {
               pausenode.appendChild(<node label="Selected Links" func="selectedlinks" toggleValue={World.toggleLinkSelected} tooltip="Links and ignores visible only for selected objects.&#10;&#10;"/>);
            }
         }
         else if(submenu == "physics")
         {
            GameState.ui.menuSettings.addSlider("% Simulation Speed",int(Vars.speed * 100),1,500);
            GameState.ui.menuSettings.addTooltip("% Simulation Speed","Affects the timestep of the simulation directly. Largely for amusement purposes only.\n\n\n");
            GameState.ui.menuSettings.getGadget("% Simulation Speed").addEventListener(Event.CHANGE,GameState.ui.updateSpeed);
            this.saveSettingsWhenFinished("% Simulation Speed");
            GameState.ui.menuSettings.addSlider("% Slow Motion Speed",int(Vars.slowspeed * 100),1,200);
            GameState.ui.menuSettings.addTooltip("% Slow Motion Speed","Speed of the slow motion.\n");
            GameState.ui.menuSettings.getGadget("% Slow Motion Speed").addEventListener(Event.CHANGE,GameState.ui.updateSlowSpeed);
            this.saveSettingsWhenFinished("% Slow Motion Speed");
            GameState.ui.menuSettings.addSlider("Physics Iterations",Tweak.m_iterations,1,50).originalValueSnap = 0;
            GameState.ui.menuSettings.addTooltip("Physics Iterations","Physics engine solver iterations. Higher = More accuracy and less jitter. Lower = Better performance. Modifying may wildly affect items and functionalities that rely on collisions.\n\n\n\n\n");
            GameState.ui.menuSettings.getGadget("Physics Iterations").addEventListener(Event.CHANGE,GameState.ui.updateIterations);
            this.saveSettingsWhenFinished("Physics Iterations");
            GameState.ui.menuSettings.addSlider("Max Cuts / Frame",Vars.cutlimit,1,50).originalValueSnap = 0;
            GameState.ui.menuSettings.addTooltip("Max Cuts / Frame","Cuts allowed per frame (rest are discarded.) Lowering may improve performance in high destruction situations, but also break some item functionality.\n\n\n\n\n");
            GameState.ui.menuSettings.getGadget("Max Cuts / Frame").addEventListener(Event.CHANGE,GameState.ui.updateMaxCuts);
            this.saveSettingsWhenFinished("Max Cuts / Frame");
            xml_settings.appendChild(physicsSettings);
         }
         else if(submenu == "controls")
         {
            GameState.ui.menuSettings.addSlider("% Drag Strength",int(Vars.dragEditor * 100),10,500);
            GameState.ui.menuSettings.addSlider("% Roleplay Strength",int(Vars.dragDoll * 100),10,500);
            GameState.ui.menuSettings.addSlider("% Camera Acceleration",int(Vars.cameraAcceleration * 100),10,100);
            GameState.ui.menuSettings.addSlider("% Wheel Rotation",int(Vars.wheelSpeed * 100),10,999);
            GameState.ui.menuSettings.addTooltip("% Drag Strength","Drag Tool joint strength.\n");
            GameState.ui.menuSettings.addTooltip("% Roleplay Strength","Doll Tool joint strength, for roleplaying.\n");
            GameState.ui.menuSettings.addTooltip("% Camera Acceleration","Acceleration of camera panning.\n");
            GameState.ui.menuSettings.addTooltip("% Wheel Rotation","Speed of rotation for dragged item with mouse wheel.\n\n");
            this.saveSettingsWhenFinished("% Drag Strength");
            this.saveSettingsWhenFinished("% Roleplay Strength");
            this.saveSettingsWhenFinished("% Camera Acceleration");
            this.saveSettingsWhenFinished("% Wheel Rotation");
            GameState.ui.menuSettings.getGadget("% Drag Strength").addEventListener(Event.CHANGE,GameState.ui.updateDragForceEditor);
            GameState.ui.menuSettings.getGadget("% Roleplay Strength").addEventListener(Event.CHANGE,GameState.ui.updateDragForceDoll);
            GameState.ui.menuSettings.getGadget("% Camera Acceleration").addEventListener(Event.CHANGE,GameState.ui.updateCameraAcceleration);
            GameState.ui.menuSettings.getGadget("% Wheel Rotation").addEventListener(Event.CHANGE,GameState.ui.updateWheelSpeed);
            xml_settings.appendChild(<node label="Camera Culling" func="culling" toggleValue={World.toggleCulling} tooltip="Toggle camera culling graphics outside its vision. May help performance.&#10;&#10;"/>);
            xml_settings.appendChild(mouseSettings);
            if(!Tweak.download)
            {
               xml_settings.node.(@label == "Mouse").appendChild(<node label="Allow RMB" func="rightclick" toggleValue={World.rightClick} tooltip="Override Flash right click menu to use RMB as a hotkey.&#10;Map the functionality via Keymapping (default: Trigger.)&#10;&#10;Requires FlashPlayer 11.2 or higher.&#10;&#10;&#10;&#10;&#10;"/>);
            }
            xml_settings.node.(@label == "Mouse").appendChild(<node label="Doubleclick Select" func="doubleclick" toggleValue={World.doubleClickSelect} tooltip="Double clicking with Select tool will select all jointed-together bodies.&#10;&#10;"/>);
            if(World.toggleEdgePan == 1)
            {
               GameState.ui.menuSettings.addSlider("Edge Pan Delay",Vars.edgePanDelay,0,60);
               GameState.ui.menuSettings.addTooltip("Edge Pan Delay","Delay before camera starts panning (in frames).\n");
               this.saveSettingsWhenFinished("Edge Pan Delay");
               GameState.ui.menuSettings.getGadget("Edge Pan Delay").addEventListener(Event.CHANGE,GameState.ui.updateEdgePanDelay);
               xml_settings.node.(@label == "Mouse").appendChild(<node label="Floor Pan" func="floorpan" toggleValue={World.toggleFloorPan} tooltip="Also pan camera when mouse is near the floor in Environments with floors enabled.&#10;(There's nothing there.)&#10;&#10;"/>);
            }
         }
         else if(submenu == "menus")
         {
            GameState.ui.menuSettings.addSlider("% Window Scale",Tweak.UIScale * 100,50,150);
            GameState.ui.menuSettings.getGadget("% Window Scale").addEventListener(Event.CHANGE,GameState.ui.updateUIScale);
            this.saveSettingsWhenFinished("% Window Scale");
            xml_settings.appendChild(menuToggles);
            xml_settings.appendChild(<node label="" func="spacer"/>);
            xml_settings.appendChild(resetSettings);
         }
         else if(submenu == "performance")
         {
            antifreeze = "Anti-Freeze FPS [<10]";
            physicsIterations = "Physics Iterations [<10]";
            maxParticles = "Max Particles [<1000]";
            maxCollisions = "Max Collisions [<50]";
            GameState.ui.menuSettings.addSlider(antifreeze,Tweak.AntiFreezeFPS,0,30).originalValueSnap = 0;
            GameState.ui.menuSettings.addTooltip(antifreeze,"If your average frame time drops below this threshold, the game will automatically pause so you can destroy the items causing the issue. 0 to disable.\n\n\n\n\n\n");
            GameState.ui.menuSettings.getGadget(antifreeze).addEventListener(Event.CHANGE,GameState.ui.updateAntiFreeze);
            GameState.ui.menuSettings.addSlider(physicsIterations,Tweak.m_iterations,1,20).originalValueSnap = 0;
            GameState.ui.menuSettings.addTooltip(physicsIterations,"Physics engine solver iterations. Higher = More accuracy and less jitter. Lower = Better performance.\n\n\n");
            GameState.ui.menuSettings.getGadget(physicsIterations).addEventListener(Event.CHANGE,GameState.ui.updateIterations2);
            GameState.ui.menuSettings.addSlider(maxParticles,int(Vars.particlesMax),100,3000);
            GameState.ui.menuSettings.addTooltip(maxParticles,"Maximum amount of particles in a single system at once. Lowering may increase performance.\n\n\n");
            GameState.ui.menuSettings.getGadget(maxParticles).addEventListener(Event.CHANGE,GameState.ui.updateMaxParticles2);
            GameState.ui.menuSettings.addSlider(maxCollisions,int(Vars.collisionsMax),10,100);
            GameState.ui.menuSettings.addTooltip(maxCollisions,"Maximum amount of collision events per frame. Lowering will increase performance, but may cause some things not to trigger collision events consistently.\n\n\n\n\n");
            GameState.ui.menuSettings.getGadget(maxCollisions).addEventListener(Event.CHANGE,GameState.ui.updateMaxCollisions);
            this.saveSettingsWhenFinished(antifreeze);
            this.saveSettingsWhenFinished(physicsIterations);
            this.saveSettingsWhenFinished(maxParticles);
            this.saveSettingsWhenFinished(maxCollisions);
            cquality = "Fast Impacts ";
            iq = ["ITEMS+BULLETS","ITEMS","NONE"];
            cquality += iq[GameState.ImpactQuality];
            performanceSettings.prependChild(<node label={cquality} func="changeImpactQuality" tooltip="Collision impact computation quality. Enabling fast impacts greatly improves collision performance, but causes fast moving objects to pass through things.&#10;&#10;&#10;&#10;&#10;" submenu="performance"/>);
            xml_settings.appendChild(performanceSettings);
         }
         siz = 500 - GameState.ui.menuSettings.sliders.length * 36;
         if(submenu == "main")
         {
            siz = 296;
            siz += 32;
         }
         treeSettings = GameState.ui.menuSettings.addTree("buttons",R.xml_empty,siz,0,30);
         treeSettings.addEventListener(ListEvent.ITEM_CLICK,this.toggleTree);
         treeSettings.selectable = false;
         GameState.ui.menuSettings.getTree("buttons").dataProvider = new TreeDataProvider(xml_settings);
         GameState.ui.menuSettings.getTree("buttons").openAllNodes();
         if(submenu == "main")
         {
            GameState.ui.menuSettings.addSlider("% Volume",int(sounds.vol * 100),0,100);
            GameState.ui.menuSettings.addTooltip("% Volume","Sound effects\nvolume.");
            this.saveSettingsWhenFinished("% Volume");
            GameState.ui.menuSettings.getGadget("% Volume").addEventListener(Event.CHANGE,GameState.ui.updateVolume);
         }
         GameState.ui.menuSettings.maximise();
      }
      
      public function mouse_wheel(param1:MouseEvent) : void
      {
         var _loc2_:b2Body = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:* = undefined;
         var _loc6_:Array = null;
         var _loc7_:Number = NaN;
         if(Boolean(this.m_mouseJoint) || Boolean(GameState.mouseDown && this.selectedBodies.length == 1) || Tool.isLaunch)
         {
            if(Tool.isLaunch)
            {
               this.RotateItems(param1.delta);
               return;
            }
            if(this.m_mouseJoint)
            {
               _loc2_ = this.m_mouseJoint.GetBody2();
            }
            else
            {
               _loc2_ = this.selectedBodies[0];
            }
            if(this.shiftPressed || GameState.paused)
            {
               _loc3_ = _loc2_.GetAngle();
               _loc4_ = _loc3_;
               if(param1.delta > 0)
               {
                  _loc4_ += Vars.toRadians * 15 * Vars.wheelSpeed;
               }
               else
               {
                  _loc4_ -= Vars.toRadians * 15 * Vars.wheelSpeed;
               }
               _loc2_.SetXForm(_loc2_.GetPosition(),_loc4_);
            }
            else
            {
               _loc5_ = 1;
               if(param1.delta < 0)
               {
                  _loc5_ = -1;
               }
               _loc2_.ApplyTorque(_loc5_ * _loc2_.GetMass() * 1000 * Vars.wheelSpeed);
            }
            return;
         }
         if(World.scrollWheel == 1 || Tool.isCamera)
         {
            _loc6_ = [null,"items","canvas"];
            if(_loc6_.indexOf(param1.target.name) == -1)
            {
               return;
            }
            _loc7_ = 1 / (1 - Tweak.ZoomStep * 5);
            if(param1.delta < 0)
            {
               _loc7_ = 1 / _loc7_;
            }
            this.zoom(_loc7_);
         }
      }
      
      public function zoom(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:* = undefined;
         if(GameState.environment is MainMenu)
         {
            return;
         }
         _loc2_ = (mouseX - this.cam.x) * (param1 - 1);
         _loc3_ = (mouseY - this.cam.y) * (param1 - 1);
         _loc4_ = this.cam.scaleX * param1;
         if(_loc4_ < 0.025)
         {
            return;
         }
         if(_loc4_ > 10)
         {
            return;
         }
         _loc5_ = this.cam.scaleX - _loc4_;
         this.cam.scaleX = _loc4_;
         if(this.cam.scaleX < GameState.environment.minScale)
         {
            this.cam.scaleX = GameState.environment.minScale;
         }
         this.cam.scaleY = this.cam.scaleX;
         this.cam.x -= _loc2_;
         this.cam.y -= _loc3_;
         this.bgBM.scaleX -= _loc5_ * 0.1;
         this.bgBM.scaleY = this.bgBM.scaleX;
         this.bgBM.x -= _loc2_ * 0.1;
         this.bgBM.y -= _loc3_ * 0.1;
         if(!this.zoomingCamera)
         {
            this.SnapCam();
         }
         this.CameraCull();
         if(GameState.paused)
         {
            TimeLord.pauseGrid.Redraw();
         }
      }
      
      public function CameraUncull() : void
      {
         var _loc1_:userData = null;
         var _loc2_:b2Body = null;
         _loc2_ = Physics.world.GetBodyList();
         while(_loc2_)
         {
            if(GameState.environment.public::wallBodies.indexOf(_loc2_) == -1)
            {
               _loc1_ = userData(_loc2_.GetUserData());
               if(!_loc1_.dead)
               {
                  if(_loc1_.parent)
                  {
                     if(_loc1_.parent.numChildren <= _loc1_.graphicAt)
                     {
                        _loc1_.parent = null;
                     }
                     else
                     {
                        _loc1_.parent.removeChildAt(_loc1_.graphicAt);
                        _loc1_.parent.addChildAt(_loc1_.graphic,_loc1_.graphicAt);
                        _loc1_.parent = null;
                     }
                  }
               }
            }
            _loc2_ = _loc2_.GetNext();
         }
      }
      
      public function CameraCull() : void
      {
         var _loc1_:b2Vec2 = null;
         var _loc2_:Array = null;
         var _loc3_:b2Vec2 = null;
         var _loc4_:userData = null;
         var _loc5_:b2Body = null;
         var _loc6_:int = 0;
         _loc1_ = new b2Vec2();
         _loc1_.x = (-this.cam.x + GameState.width * 0.5) / this.cam.scaleX;
         _loc1_.y = (-this.cam.y + GameState.height * 0.5) / this.cam.scaleY;
         _loc2_ = Body.GetAroundPoint(_loc1_,GameState.width * 0.5 / this.cam.scaleX,GameState.height * 0.5 / this.cam.scaleY,true);
         _loc5_ = Physics.world.GetBodyList();
         for(; _loc5_; _loc5_ = _loc5_.GetNext())
         {
            if(GameState.environment.public::wallBodies.indexOf(_loc5_) == -1)
            {
               _loc4_ = userData(_loc5_.GetUserData());
               if(!_loc4_.dead)
               {
                  if(_loc4_.parent)
                  {
                     if(_loc4_.parent.numChildren <= _loc4_.graphicAt)
                     {
                        _loc4_.parent = null;
                        continue;
                     }
                     _loc4_.parent.removeChildAt(_loc4_.graphicAt);
                     _loc4_.parent.addChildAt(_loc4_.graphic,_loc4_.graphicAt);
                     _loc4_.parent = null;
                  }
                  if(GameState.paused)
                  {
                     if(World.toggleCulling != 0)
                     {
                        if(_loc2_.indexOf(_loc5_) == -1)
                        {
                           if(_loc4_.graphic)
                           {
                              if(_loc4_.graphic.visible)
                              {
                                 if(_loc4_.graphic.parent)
                                 {
                                    _loc6_ = _loc4_.graphic.parent.getChildIndex(_loc4_.graphic);
                                    if(_loc6_ != -1)
                                    {
                                       _loc4_.parent = _loc4_.graphic.parent;
                                       _loc4_.graphicAt = _loc6_;
                                       _loc4_.graphic.parent.removeChild(_loc4_.graphic);
                                       _loc4_.parent.addChildAt(new Shape(),_loc4_.graphicAt);
                                    }
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      
      public function QuickDeleteOnMouse() : *
      {
         var _loc1_:b2Body = null;
         _loc1_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,GameState.paused,true);
         if(_loc1_)
         {
            if(this.selectedBodies.indexOf(_loc1_) != -1)
            {
               while(this.selectedBodies.length > 0)
               {
                  Body.Destroy(this.selectedBodies.pop(),"tool");
               }
            }
            else
            {
               Body.Destroy(_loc1_,"tool");
            }
            if(Tool.previousTool)
            {
               Tool.setTool(Tool.previousTool);
               this.toolSprite.graphics.clear();
               GameState.ui.updateControls();
            }
         }
      }
      
      public function CameraHome() : *
      {
         this.movingCamera = false;
         this.zoomingCamera = false;
         this.cam.scaleX = 1;
         this.cam.scaleY = 1;
         this.cam.x = 0;
         this.cam.y = 0;
         this.bgBM.x = 0;
         this.bgBM.y = 0;
         this.bgBM.scaleX = 1;
         this.bgBM.scaleY = 1;
         this.cameraVel = new b2Vec2();
         if(GameState.followBody)
         {
            GameState.followBody = null;
         }
         if(GameState.environment.autoPan)
         {
            this.m_sprite.x = 0;
            this.m_sprite.y = 0;
            this.cam.x = -GameState.environment.spawnX + GameState.environment.autoPanOffset.x + GameState.width * 0.5;
            this.cam.y = GameState.environment.spawnHeight + GameState.environment.autoPanOffset.y + GameState.height;
         }
         if(TimeLord.speed == 0)
         {
            TimeLord.pauseGrid.Redraw();
            TimeLord.pauseGrid.Update();
         }
         this.CameraCull();
      }
      
      public function SnapCam(param1:int = 50) : *
      {
         if(this.cam.scaleX < 0.95 || this.cam.scaleX > 1.05)
         {
            return;
         }
         this.cam.scaleX = this.cam.scaleY = 1;
         if(Math.abs(this.cam.x) < param1)
         {
            this.cam.x = 0;
         }
         this.bgBM.x = 0;
         if(Math.abs(this.cam.y) < param1)
         {
            this.cam.y = 0;
         }
         this.bgBM.y = 0;
      }
      
      public function mouse_pressed(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:BitmapData = null;
         var _loc4_:Array = null;
         var _loc5_:DisplayObject = null;
         var _loc6_:Array = null;
         var _loc7_:b2Body = null;
         var _loc8_:b2Body = null;
         var _loc9_:b2Vec2 = null;
         var _loc10_:b2Vec2 = null;
         var _loc11_:b2Body = null;
         var _loc12_:Boolean = false;
         var _loc13_:b2Vec2 = null;
         var _loc14_:b2Body = null;
         var _loc15_:b2Body = null;
         var _loc16_:b2Body = null;
         var _loc17_:int = 0;
         var _loc18_:b2Body = null;
         var _loc19_:b2Body = null;
         var _loc20_:b2Vec2 = null;
         var _loc21_:b2RevoluteJoint = null;
         var _loc22_:Number = NaN;
         var _loc23_:b2Body = null;
         var _loc24_:b2MouseJointDef = null;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         if(IO.incrementalLoading)
         {
            return;
         }
         if(this.scrollhint.visible)
         {
            this.scrollhint.visible = false;
         }
         if(this.scrollhintV.visible)
         {
            this.scrollhintV.visible = false;
         }
         this.cameraKeySpammedBandaid = 0;
         GameState.environmenting = false;
         if(param1.target)
         {
            _loc2_ = param1.target.name;
            if(_loc2_ == "close" || _loc2_ == "slider_handle" || _loc2_ == "slider_back" || _loc2_ == "minimise")
            {
               return;
            }
            if(_loc2_ == null)
            {
               stage.focus = stage;
            }
         }
         if(GameState.ui.menuColour.visible)
         {
            if(param1.target == stage)
            {
               if(param1.altKey)
               {
                  _loc3_ = new BitmapData(stage.width,stage.height);
                  _loc3_.draw(stage);
                  this.updateColour(_loc3_.getPixel(stage.mouseX,stage.mouseY).toString(16));
               }
            }
         }
         if(Boolean(param1.target) && Boolean(_loc2_ != "Prompt") || !GameState.ui.menuPrompt.locked)
         {
            this.canThrowPower = false;
            if(param1.target)
            {
               if(param1.target is Stage || Boolean(param1.target.parent) && Boolean(param1.target.parent.name == "itemholder"))
               {
                  this.canThrowPower = true;
               }
            }
            GameState.mouseDown = true;
            _loc4_ = stage.getObjectsUnderPoint(new Point(mouseX,mouseY));
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_ is Window)
               {
                  GameState.mouseDown = false;
                  break;
               }
            }
         }
         if(Tool.isCamera)
         {
            _loc6_ = [null,"items","canvas"];
            if(Boolean(param1.target) && _loc6_.indexOf(param1.target.name) == -1)
            {
               return;
            }
            stage.focus = stage;
            this.camCullDistance = new b2Vec2(this.cam.x,this.cam.y);
            this.movingCamera = true;
            this.dragCamCurrent = new Point(mouseX,mouseY);
            this.dragCamMoved = new Point(mouseX,mouseY);
            this.dragCamOrig = new Point(this.cam.x,this.cam.y);
            this.dragBGOrig = new Point(this.bgBM.x,this.bgBM.y);
            return;
         }
         if(this.effecting)
         {
            this.finishAttachingEffect();
            return;
         }
         if(GameState.skinning)
         {
            _loc7_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,true,true);
            if(_loc7_)
            {
               userData(_loc7_.GetUserData()).skin = GameState.objects.spawnSkin.slice();
               if(this.detailBody)
               {
                  userData(_loc7_.GetUserData()).bloodColour = userData(this.detailBody.GetUserData()).bloodColour;
               }
               BoxUtils.ReplaceGraphic(userData(_loc7_.GetUserData()),O.getItem(userData(_loc7_.GetUserData()).name).updateGraphic(null));
            }
            return;
         }
         if(GameState.cloning)
         {
            if(GameState.spawningCustom)
            {
               IO.loadWorld(this.dulin,!GameState.paused,true);
               GameState.spawningCustom = false;
               this.toolSprite.graphics.clear();
            }
            else
            {
               this.toolSprite.graphics.clear();
               Body.Clone(this.detailBody,new b2Vec2(this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale));
            }
            GameState.cloning = false;
            return;
         }
         if(GameState.spawningCustom)
         {
            IO.loadWorld(this.dulin,false,true);
            GameState.spawningCustom = false;
            this.toolSprite.graphics.clear();
            return;
         }
         if(GameState.ui.menuLibrary.visible)
         {
            if(param1.target is TreeCellRenderer)
            {
               if(Boolean(param1.target.data) && (Boolean(param1.target.data.custom) || Boolean(param1.target.data.local)))
               {
                  this.spawnPos = new b2Vec2(mouseX,mouseY);
               }
               if(Boolean(param1.target.data) && Boolean(param1.target.data.object))
               {
                  GameState.ui.selectItem(param1.target.data);
                  if(GameState.ui.menuObject.visible && GameState.ui.menuObject.title == "Detail Skin")
                  {
                     this.itemSkin();
                     GameState.ui.dockItemMenu();
                  }
                  this.spawnPos = new b2Vec2(mouseX,mouseY);
               }
            }
         }
         if(GameState.ui.menuTools.visible)
         {
            if(param1.target is TreeCellRenderer)
            {
               if(param1.target.data.power)
               {
                  if(param1.target.data.toggleValue == "1")
                  {
                     this.powerMovePos = new b2Vec2(mouseX,mouseY);
                     this.powerMove = param1.target.data.power;
                  }
               }
            }
         }
         if(Boolean(stage.focus) && Boolean(stage.focus is TextField) && !(param1.target is TextField))
         {
            if(_loc2_ == "canvas")
            {
               stage.focus = null;
            }
            else if(stage.focus.name != "autoCompleteField")
            {
               stage.focus = null;
            }
         }
         if(Boolean(param1.target) && Boolean(_loc2_) && (getQualifiedClassName(param1.target) != getQualifiedClassName(new Sprite()) || _loc2_ == "itemHolder"))
         {
            return;
         }
         if(Tool.isCut)
         {
            this.cutStart = new b2Vec2(this.mouseXWorld,this.mouseYWorld);
            this.cutDelta = -1;
         }
         else if(Tool.isSwing)
         {
            if(this.m_mouseJoint)
            {
               _loc8_ = this.m_mouseJoint.GetBody2();
               _loc8_.WakeUp();
               _loc8_.SetLinearVelocity(new b2Vec2());
               _loc8_.SetAngularVelocity(0);
               if(Math.abs(_loc8_.GetAngularVelocity()) < 1)
               {
                  _loc9_ = BoxUtils.rotateVec(new b2Vec2(500 * _loc8_.GetMass(),0),_loc8_.GetAngle() + Math.PI * 0.5);
                  _loc10_ = new b2Vec2(0,-100 / Physics.scale);
                  this.m_mouseJoint.GetBody2().ApplyForce(_loc9_,_loc10_);
               }
               else
               {
                  _loc8_.SetAngularVelocity(_loc8_.GetAngularVelocity() * 10);
               }
            }
         }
         else if(Tool.isLaunch)
         {
            if(!this.scalingPos)
            {
               return;
            }
            if(Boolean(this.scalingPos) && this.selectedBodies.length > 0)
            {
               _loc12_ = BoxUtils.vectorDist(this.scalingPos,new b2Vec2(this.mouseXWorld,this.mouseYWorld)) <= Tweak.toolDeadzone / Physics.scale;
               if(_loc12_)
               {
                  this.stopAiming();
                  return;
               }
            }
            for each(_loc11_ in this.selectedBodies)
            {
               _loc11_.WakeUp();
               _loc13_ = new b2Vec2((-this.scalingPos.x + this.mouseXWorld) * 10,(-this.scalingPos.y + this.mouseYWorld) * 10);
               _loc11_.SetLinearVelocity(_loc13_);
            }
            this.selectedBodies = new Vector.<b2Body>();
            this.scalingPos = null;
            this.toolSprite.graphics.clear();
         }
         else if(Tool.isScale || Tool.isRotate)
         {
            _loc14_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,true,true);
            if(this.selectedBodies.length == 0)
            {
               if(_loc14_)
               {
                  if(Tool.isScale && userData(_loc14_.GetUserData()).hasBeenCut)
                  {
                     return;
                  }
                  if(Tool.isScale && !userData(_loc14_.GetUserData()).saveable)
                  {
                     return;
                  }
                  this.scalingPos = _loc14_.GetWorldCenter().Copy();
                  _loc14_.PutToSleep();
                  this.selectedBodies.push(_loc14_);
               }
            }
            else
            {
               this.scalingPos = new b2Vec2(this.mouseXWorld,this.mouseYWorld);
               this.rotatePositions = new Vector.<b2Vec2>();
               this.rotateAngles = new Vector.<Number>();
               for each(_loc15_ in this.selectedBodies)
               {
                  _loc15_.PutToSleep();
                  this.rotatePositions.push(_loc15_.GetPosition().Copy());
                  this.rotateAngles.push(_loc15_.GetAngle());
               }
            }
         }
         else if(Tool.isSelect)
         {
            _loc16_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,true,true);
            if(!this.contractArea && Boolean(_loc16_))
            {
               _loc17_ = this.selectedBodies.indexOf(_loc16_);
               if(_loc17_ == -1)
               {
                  this.selectedBodies.push(_loc16_);
                  this.selectDoubleclick = 10;
               }
               else if(Boolean(World.doubleClickSelect) && this.selectDoubleclick > 0)
               {
                  this.selectedBodies = Vector.<b2Body>(BoxUtils.selectCompound(_loc16_));
               }
               else
               {
                  this.selectedBodies.splice(_loc17_,1);
               }
            }
            else if(_loc2_ != "toolIcon")
            {
               this.selectingPos = new b2Vec2(this.mouseXWorld,this.mouseYWorld);
            }
            if(this.detailBody)
            {
               this.showDetails(this.detailBody,this.detailSubmenu);
            }
         }
         else if(Tool.isDestroy)
         {
            if(this.contractArea)
            {
               if(this.contract.removeArea(new b2Vec2(this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale)))
               {
                  this.contractArea = false;
                  Tool.reset();
                  GameState.ui.updateControls();
                  this.updateChallengeMenu();
               }
               return;
            }
            _loc16_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,true,true);
            if(this.contractTarget)
            {
               if(!_loc16_ || this.contract.removeTarget(_loc16_))
               {
                  this.contractTarget = false;
                  Tool.reset();
                  GameState.ui.updateControls();
                  this.updateChallengeMenu();
               }
               return;
            }
            if(!this.contract.allowDestroy(new b2Vec2(this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale)))
            {
               return;
            }
            if(Boolean(_loc16_) && userData(_loc16_.GetUserData()).name != "wall")
            {
               if(this.selectedBodies.indexOf(_loc16_) != -1)
               {
                  if(this.selectedBodies.length < 20)
                  {
                     while(this.selectedBodies.length > 0)
                     {
                        Body.Destroy(this.selectedBodies[0],"tool_delete");
                     }
                  }
                  else
                  {
                     for each(_loc18_ in this.selectedBodies)
                     {
                        this.deletedBodies.push(_loc18_);
                     }
                  }
               }
               else
               {
                  Body.Destroy(_loc16_,"tool_delete");
               }
            }
            else
            {
               this.selectingPos = new b2Vec2(this.mouseXWorld,this.mouseYWorld);
            }
         }
         else if(Tool.isDetail)
         {
            _loc16_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,true);
            if(_loc16_)
            {
               this.showDetails(_loc16_,this.detailSubmenu);
            }
            else
            {
               if(_loc2_ != "toolIcon")
               {
                  this.selectingPos = new b2Vec2(this.mouseXWorld,this.mouseYWorld);
               }
               this.detailBody = null;
               if(this.selectedBodies.length == 1)
               {
                  this.selectedBodies = new Vector.<b2Body>();
               }
               if(GameState.ui.menuDetails.visible)
               {
                  GameState.ui.menuDetails.close();
               }
               if(GameState.ui.menuObject.visible && GameState.ui.menuObject.title.indexOf("Detail") != -1)
               {
                  GameState.ui.menuObject.close();
               }
            }
         }
         else if(Tool.isPin)
         {
            _loc19_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,true,true);
            if(_loc19_)
            {
               Joints.Pin("bgjoint",_loc19_,new b2Vec2(this.mouseXWorld,this.mouseYWorld),Tweak.jointForce);
            }
         }
         else if(Tool.isJoint)
         {
            _loc19_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,true,true);
            if(_loc19_)
            {
               this.jointPos = new b2Vec2(this.mouseXWorld - _loc19_.GetPosition().x,this.mouseYWorld - _loc19_.GetPosition().y);
               this.jointBody = _loc19_;
            }
         }
         else if(Tool.isPiston)
         {
            if(this.jointBody2)
            {
               return;
            }
            _loc19_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,true,true);
            if(_loc19_)
            {
               this.jointPos = new b2Vec2(this.mouseXWorld - _loc19_.GetPosition().x,this.mouseYWorld - _loc19_.GetPosition().y);
               this.jointBody = _loc19_;
            }
         }
         else if(Tool.isRope)
         {
            _loc19_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,true,true);
            if(_loc19_)
            {
               this.jointPos = new b2Vec2(this.mouseXWorld - _loc19_.GetPosition().x,this.mouseYWorld - _loc19_.GetPosition().y);
               this.jointBody = _loc19_;
            }
         }
         else if(Tool.isDoll)
         {
            _loc19_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,true,true);
            if(this.jointBody2)
            {
               _loc20_ = new b2Vec2(this.mouseXWorld,this.mouseYWorld);
               if(Boolean(_loc19_) && (_loc19_ == this.jointBody || _loc19_ == this.jointBody2))
               {
                  _loc22_ = userData(_loc19_.GetUserData()).width;
                  if(userData(_loc19_.GetUserData()).height < _loc22_)
                  {
                     _loc22_ = userData(_loc19_.GetUserData()).height;
                  }
                  _loc22_ *= 0.2;
                  if(_loc22_ > 10)
                  {
                     _loc22_ = 10;
                  }
                  if(Math.sqrt(BoxUtils.vectorDist(_loc19_.GetWorldCenter(),_loc20_)) * Physics.scale < _loc22_)
                  {
                     _loc20_ = _loc19_.GetWorldCenter();
                  }
               }
               if(Tweak.jointLower == 0)
               {
                  Tweak.jointLower = -9000;
               }
               if(Tweak.jointUpper == 0)
               {
                  Tweak.jointUpper = 9000;
               }
               _loc21_ = Joints.Revolution("revolute",this.jointBody,this.jointBody2,_loc20_.x * Physics.scale,_loc20_.y * Physics.scale,Tweak.jointLower,Tweak.jointUpper,true,Tweak.jointForce);
               if(Tweak.jointMotorSpeed != 0)
               {
                  _loc21_.EnableMotor(true);
                  _loc21_.SetMotorSpeed(Tweak.jointMotorSpeed);
                  _loc21_.SetMaxMotorTorque(Tweak.jointMotorForce);
               }
               this.toolSprite.graphics.clear();
               this.jointPos = null;
               this.jointBody = null;
               this.jointBody2 = null;
            }
            else if(_loc19_)
            {
               this.jointPos = new b2Vec2();
               this.jointBody = _loc19_;
            }
         }
         else if(Tool.isWeld)
         {
            _loc19_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,true,true);
            if(_loc19_)
            {
               this.jointPos = new b2Vec2(0,0);
               this.jointBody = _loc19_;
            }
         }
         else if(Tool.isLink || Tool.isIgnore)
         {
            if(!this.jointPos)
            {
               _loc19_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,true,true);
               if(_loc19_)
               {
                  this.jointPos = new b2Vec2(this.mouseXWorld - _loc19_.GetPosition().x,this.mouseYWorld - _loc19_.GetPosition().y);
                  this.jointBody = _loc19_;
               }
            }
         }
         else if(Tool.isTrigger)
         {
            _loc19_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,true,true);
            if(_loc19_)
            {
               if(this.triggerBodyAt(new b2Vec2(this.mouseXWorld,this.mouseYWorld)))
               {
                  if(!(userData(_loc19_.GetUserData()).trigger is Gun))
                  {
                     this.itemTriggered = true;
                  }
                  this.toolSprite.graphics.clear();
                  this.toolSprite.graphics.lineStyle(this.zoomLineStyle(),4097883);
                  this.toolSprite.graphics.drawCircle(this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale,10 / this.cam.scaleX);
                  this.scalingPos = new b2Vec2(this.mouseXWorld,this.mouseYWorld);
               }
            }
         }
         if(!this.contract.allowPower(new b2Vec2(this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale)))
         {
            return;
         }
         if(!this.canThrowPower)
         {
            return;
         }
         if(Tool.isHole)
         {
            _loc23_ = GameState.objects.spawnObject("blackhole",this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale,0,false,true);
            userData(_loc23_.GetUserData()).saveable = false;
            userData(_loc23_.GetUserData()).unbreakable = true;
            userData(_loc23_.GetUserData()).triggerForce = 2 * Tweak.toolEffectForce;
            userData(_loc23_.GetUserData()).triggerRadius = 2 * Tweak.toolEffectRadius;
            _loc23_.m_linearDamping = 0;
            _loc24_ = new b2MouseJointDef();
            _loc24_.userData = new jointUserData("mouse");
            _loc24_.body1 = Physics.world.GetGroundBody();
            _loc24_.body2 = _loc23_;
            _loc24_.target.Set(this.mouseXWorld,this.mouseYWorld);
            _loc24_.maxForce = 10000 * _loc23_.GetMass();
            _loc24_.timeStep = Tweak.m_timeStep;
            this.m_mouseJoint = Physics.world.CreateJoint(_loc24_) as b2MouseJoint;
            _loc23_.WakeUp();
         }
         else if(Tool.isRadiation)
         {
            _loc25_ = Vars.objSize;
            Vars.objSize = 0.1;
            _loc23_ = GameState.objects.delayedSpawnObject("radioactive",this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale,0,false,true);
            Vars.objSize = _loc25_;
            userData(_loc23_.GetUserData()).saveable = false;
            userData(_loc23_.GetUserData()).unbreakable = true;
            userData(_loc23_.GetUserData()).triggerRadius = Tweak.toolRadius;
            userData(_loc23_.GetUserData()).ghost = true;
            userData(_loc23_.GetUserData()).graphic.alpha = 0;
            _loc24_ = new b2MouseJointDef();
            _loc24_.userData = new jointUserData("mouse");
            _loc24_.body1 = Physics.world.GetGroundBody();
            _loc24_.body2 = _loc23_;
            _loc24_.target.Set(this.mouseXWorld,this.mouseYWorld);
            _loc24_.maxForce = 10000 * _loc23_.GetMass();
            _loc24_.timeStep = Tweak.m_timeStep;
            this.m_mouseJoint = Physics.world.CreateJoint(_loc24_) as b2MouseJoint;
            _loc23_.WakeUp();
         }
         else if(Tool.isBlunt)
         {
            _loc26_ = Vars.objDampAngular;
            Vars.objDampAngular = 100;
            _loc27_ = Vars.objDensity;
            Vars.objDensity = 2;
            _loc23_ = GameState.objects.spawnObject("boxingglove",this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale,0,false,true);
            Vars.objDensity = _loc27_;
            Vars.objDampAngular = _loc26_;
            userData(_loc23_.GetUserData()).saveable = false;
            userData(_loc23_.GetUserData()).unbreakable = true;
            _loc24_ = new b2MouseJointDef();
            _loc24_.userData = new jointUserData("mouse");
            _loc24_.body1 = Physics.world.GetGroundBody();
            _loc24_.body2 = _loc23_;
            _loc24_.target.Set(this.mouseXWorld,this.mouseYWorld);
            _loc24_.maxForce = 10000 * _loc23_.GetMass();
            _loc24_.timeStep = Tweak.m_timeStep;
            this.m_mouseJoint = Physics.world.CreateJoint(_loc24_) as b2MouseJoint;
            _loc23_.WakeUp();
         }
         else if(Tool.isSharp)
         {
            _loc23_ = GameState.objects.spawnObject("sawblade",this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale,0,false,true);
            userData(_loc23_.GetUserData()).saveable = false;
            userData(_loc23_.GetUserData()).unbreakable = true;
            _loc24_ = new b2MouseJointDef();
            _loc24_.userData = new jointUserData("mouse");
            _loc24_.body1 = Physics.world.GetGroundBody();
            _loc24_.body2 = _loc23_;
            _loc24_.target.Set(this.mouseXWorld,this.mouseYWorld);
            _loc24_.maxForce = 10000 * _loc23_.GetMass();
            _loc24_.timeStep = Tweak.m_timeStep;
            this.m_mouseJoint = Physics.world.CreateJoint(_loc24_) as b2MouseJoint;
            _loc23_.WakeUp();
         }
         else if(Tool.isRicochet)
         {
            _loc28_ = Vars.objRestitution;
            _loc29_ = Vars.objDensity;
            Vars.objRestitution = 2;
            Vars.objDensity = 4;
            _loc23_ = GameState.objects.spawnObject("circle",this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale,0,false,true);
            userData(_loc23_.GetUserData()).name = "ricochet";
            Vars.objDensity = _loc29_;
            Vars.objRestitution = _loc28_;
            userData(_loc23_.GetUserData()).saveable = false;
            _loc24_ = new b2MouseJointDef();
            _loc24_.userData = new jointUserData("mouse");
            _loc24_.body1 = Physics.world.GetGroundBody();
            _loc24_.body2 = _loc23_;
            _loc24_.target.Set(this.mouseXWorld,this.mouseYWorld);
            _loc24_.maxForce = 10000 * _loc23_.GetMass();
            _loc24_.timeStep = Tweak.m_timeStep;
            this.m_mouseJoint = Physics.world.CreateJoint(_loc24_) as b2MouseJoint;
            _loc23_.WakeUp();
         }
      }
      
      public function mouse_leave(param1:Event) : void
      {
         if(!stage.focus is TextField)
         {
            stage.focus = null;
         }
         this.mouseleft = true;
         this.mousepancounter = Vars.edgePanDelay;
         this.panMouseUp = false;
         this.panMouseDown = false;
         this.panMouseLeft = false;
         this.panMouseRight = false;
      }
      
      private function triggerBodyAt(param1:b2Vec2) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:b2Body = null;
         var _loc4_:userData = null;
         var _loc5_:b2Body = null;
         if(!this.contract.allowTriggering(new b2Vec2(this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale)))
         {
            return false;
         }
         _loc2_ = false;
         _loc3_ = Body.GetOne(param1.x,param1.y,true,true);
         if(_loc3_)
         {
            this.toolSprite.graphics.clear();
            this.toolSprite.graphics.lineStyle(this.zoomLineStyle(),4097883);
            if(this.selectedBodies.indexOf(_loc3_) != -1)
            {
               for each(_loc5_ in this.selectedBodies)
               {
                  _loc4_ = userData(_loc5_.GetUserData());
                  if(_loc4_.trigger)
                  {
                     if(!_loc4_.trigger.temporary)
                     {
                        if(_loc5_ == _loc3_)
                        {
                           if(!this.itemTriggered)
                           {
                              this.toolSprite.graphics.drawCircle(this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale,10 / this.cam.scaleX);
                           }
                        }
                        else
                        {
                           this.toolSprite.graphics.drawCircle(_loc5_.GetWorldCenter().x * Physics.scale,_loc5_.GetWorldCenter().y * Physics.scale,10 / this.cam.scaleX);
                        }
                        _loc2_ = true;
                        _loc4_.triggered = !_loc4_.triggered;
                     }
                  }
               }
            }
            else
            {
               _loc4_ = userData(_loc3_.GetUserData());
               if(Boolean(_loc4_.trigger) && !_loc4_.trigger.temporary)
               {
                  this.toolSprite.graphics.drawCircle(this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale,10 / this.cam.scaleX);
                  _loc2_ = true;
                  _loc4_.triggered = !_loc4_.triggered;
               }
            }
         }
         return _loc2_;
      }
      
      public function mouse_up(param1:MouseEvent) : *
      {
         var _loc2_:Window = null;
         var _loc3_:Vector.<b2Body> = null;
         var _loc4_:userData = null;
         var _loc5_:b2Body = null;
         var _loc6_:Number = NaN;
         var _loc7_:b2Body = null;
         var _loc8_:int = 0;
         var _loc9_:b2Body = null;
         var _loc10_:b2Body = null;
         var _loc11_:Array = null;
         var _loc12_:b2Body = null;
         var _loc13_:Number = NaN;
         var _loc14_:Boolean = false;
         var _loc15_:Array = null;
         var _loc16_:b2Body = null;
         var _loc17_:Vector.<b2Body> = null;
         var _loc18_:b2Body = null;
         var _loc19_:b2Vec2 = null;
         var _loc20_:b2Vec2 = null;
         var _loc21_:Number = NaN;
         var _loc22_:b2Vec2 = null;
         var _loc23_:b2Vec2 = null;
         var _loc24_:b2Body = null;
         var _loc25_:userData = null;
         var _loc26_:userData = null;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:userData = null;
         var _loc30_:Number = NaN;
         var _loc31_:b2Vec2 = null;
         var _loc32_:Array = null;
         var _loc33_:b2Body = null;
         var _loc34_:Power = null;
         if(Tool.isCamera)
         {
            this.movingCamera = false;
            if(this.dragCamOrig.x == this.cam.x && this.dragCamOrig.y == this.cam.y)
            {
               this.zoom(1 / (1 - Tweak.ZoomStep * 5));
            }
            if(this.dragCamOrig.x != 0 && this.dragCamOrig.y != 0)
            {
               this.SnapCam();
            }
         }
         GameState.mouseDown = false;
         this.spawnPos = null;
         if(this.powerMove)
         {
            this.powerMove = null;
            this.powerMovePos = null;
         }
         if(GameState.spawning)
         {
            this.finishSpawningItem();
         }
         if(Tool.isScale)
         {
            _loc3_ = this.selectedBodies.slice();
            for each(_loc5_ in _loc3_)
            {
               _loc4_ = userData(_loc5_.GetUserData());
               _loc6_ = _loc4_.graphic.scaleX * _loc4_.size;
               if(_loc4_.graphic.getChildByName("debug_scalerot"))
               {
                  _loc4_.graphic.removeChild(_loc4_.graphic.getChildByName("debug_scalerot"));
               }
               _loc4_.graphic.scaleX = 1;
               _loc4_.graphic.scaleY = 1;
               Body.Scale(_loc5_,_loc6_,false);
            }
            if(this.selectedBodies.length == 1)
            {
               this.selectedBodies = new Vector.<b2Body>();
            }
            this.toolSprite.graphics.clear();
         }
         else if(Tool.isRotate)
         {
            for each(_loc5_ in this.selectedBodies)
            {
               _loc4_ = userData(_loc5_.GetUserData());
               if(_loc4_.graphic.getChildByName("debug_scalerot"))
               {
                  _loc4_.graphic.removeChild(_loc4_.graphic.getChildByName("debug_scalerot"));
               }
               _loc5_.WakeUp();
            }
            if(this.selectedBodies.length == 1)
            {
               this.selectedBodies = new Vector.<b2Body>();
            }
            this.rotatePositions = new Vector.<b2Vec2>();
            this.rotateAngles = new Vector.<Number>();
            this.toolSprite.graphics.clear();
         }
         else if(Tool.isAim)
         {
            if(this.contract.target > 0)
            {
               _loc7_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,false,true);
               if(_loc7_)
               {
                  _loc8_ = this.contract.target;
                  this.contract.addTargetBody(_loc7_);
                  if(_loc8_ == 4)
                  {
                     this.jointBody = _loc7_;
                     this.jointPos = new b2Vec2(this.mouseXWorld - _loc7_.GetPosition().x,this.mouseYWorld - _loc7_.GetPosition().y);
                     this.contractTarget = true;
                     Tool.link();
                     GameState.ui.updateControls();
                     return;
                  }
               }
               Tool.reset();
               GameState.ui.updateControls();
               return;
            }
            if(!this.scalingPos)
            {
               if(this.m_mouseJoint)
               {
                  _loc9_ = this.m_mouseJoint.GetBody2();
               }
               else
               {
                  if(!(Boolean(this.selectedBodies) && this.selectedBodies.length == 1))
                  {
                     return;
                  }
                  _loc9_ = this.selectedBodies[0];
               }
               if(_loc9_)
               {
                  this.scalingPos = new b2Vec2(_loc9_.GetPosition().x,_loc9_.GetPosition().y);
                  this.selectedBodies = new Vector.<b2Body>();
                  this.selectedBodies.push(_loc9_);
                  _loc11_ = BoxUtils.selectCompound(_loc9_);
                  for each(_loc12_ in _loc11_)
                  {
                     this.selectedBodies.push(_loc12_);
                  }
               }
               this.stopDragging(false);
               for each(_loc10_ in this.selectedBodies)
               {
                  _loc10_.m_linearDamping = 1000;
                  _loc10_.m_angularDamping = 10;
               }
            }
            else if(Boolean(this.scalingPos) && this.selectedBodies.length > 0)
            {
               _loc13_ = BoxUtils.vectorDist(this.scalingPos,new b2Vec2(this.mouseXWorld,this.mouseYWorld));
               _loc14_ = _loc13_ <= Tweak.toolDeadzone / Physics.scale;
               if(_loc14_)
               {
                  this.stopAiming();
               }
               else if(userData(this.selectedBodies[0].GetUserData()).trigger is Gun)
               {
                  Gun(userData(this.selectedBodies[0].GetUserData()).trigger).firearm.forceReload();
                  userData(this.selectedBodies[0].GetUserData()).triggered = false;
               }
            }
         }
         else if(Tool.isLaunch)
         {
            if(this.m_mouseJoint)
            {
               _loc9_ = this.m_mouseJoint.GetBody2();
               this.selectedBodies.push(_loc9_);
            }
            else if(GameState.paused && this.pauseMovingBodies.length > 0)
            {
               _loc9_ = this.pauseMovingBodies[0][0];
            }
            if(!_loc9_)
            {
               return;
            }
            _loc15_ = BoxUtils.selectCompound(_loc9_);
            if(_loc15_.length > 1)
            {
               this.selectedBodies = new Vector.<b2Body>();
               for each(_loc16_ in _loc15_)
               {
                  this.selectedBodies.push(_loc16_);
               }
            }
            this.scalingPos = new b2Vec2(_loc9_.GetPosition().x,_loc9_.GetPosition().y);
            this.stopDragging(false);
            for each(_loc10_ in this.selectedBodies)
            {
               _loc10_.PutToSleep();
            }
         }
         else if((Tool.isSelect || Tool.isDetail) && (Boolean(this.selectingPos) || Boolean(this.quickCreatingCustomItem > 0)))
         {
            if(this.contractArea)
            {
               this.contract.addArea(new b2Vec2(this.selectingPos.x * Physics.scale,this.selectingPos.y * Physics.scale),(-this.selectingPos.x + this.mouseXWorld) * Physics.scale,(-this.selectingPos.y + this.mouseYWorld) * Physics.scale);
               Tool.reset();
               this.selectingPos = null;
               this.toolSprite.graphics.clear();
               this.contractArea = false;
               GameState.ui.updateControls();
               this.updateChallengeMenu();
               return;
            }
            this.FinishSelecting();
            if(this.quickCreatingCustomItem > 0)
            {
               if(this.quickCreatingCustomItem == 1)
               {
                  this.quickCreatingCustomItem = 2;
                  GameState.ui.showTooltip(GameState.ui.menuLibrary,"Click on the item you wish to be the center of the Custom Item.\n\n",0,9000,GameState.ui.menuLibrary.actualWidth);
               }
               else if(this.quickCreatingCustomItem == 2)
               {
                  this.quickCreatingCustomItem = 3;
                  this.updateMassSave();
               }
            }
            else if(Tool.isSelect)
            {
               if(this.selectedBodies.length > 0)
               {
                  Tool.setTool(Tool.previousTool);
                  GameState.ui.updateControls();
               }
            }
            else if(this.selectedBodies.length > 0)
            {
               this.showDetails(this.selectedBodies[0],this.detailSubmenu);
            }
         }
         else if(Tool.isDestroy && Boolean(this.selectingPos))
         {
            if(!this.contract.allowDestroy(new b2Vec2(this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale)))
            {
               return;
            }
            _loc17_ = Body.SelectArea(this.selectingPos,new b2Vec2(this.mouseXWorld,this.mouseYWorld),false,true);
            if(_loc17_.length > 20)
            {
               for each(_loc16_ in _loc17_)
               {
                  this.deletedBodies.push(_loc16_);
               }
            }
            else
            {
               for each(_loc18_ in _loc17_)
               {
                  if(userData(_loc18_.GetUserData()).name != "wall")
                  {
                     if(!userData(_loc18_.GetUserData()).locked)
                     {
                        Body.Destroy(_loc18_,"tool_delete");
                     }
                  }
               }
            }
            this.selectingPos = null;
            this.toolSprite.graphics.clear();
         }
         else if(Tool.isCut && Boolean(this.cutStart))
         {
            if(!this.contract.allowCut(new b2Vec2(this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale)))
            {
               this.cutDelta = 0;
               return;
            }
            if(!this.canThrowPower)
            {
               return;
            }
            GameState.madeby = "cut";
            _loc19_ = new b2Vec2(this.cutStart.x * Physics.scale,this.cutStart.y * Physics.scale);
            _loc20_ = new b2Vec2(this.cutEnd.x * Physics.scale,this.cutEnd.y * Physics.scale);
            _loc21_ = Math.sqrt((this.cutStart.x * Physics.scale - this.cutEnd.x * Physics.scale) * (this.cutStart.x * Physics.scale - this.cutEnd.x * Physics.scale) + (this.cutStart.y * Physics.scale - this.cutEnd.y * Physics.scale) * (this.cutStart.y * Physics.scale - this.cutEnd.y * Physics.scale));
            if(_loc21_ != 0)
            {
               GameState.cutter.CustomCut(_loc19_,_loc20_,1,_loc21_);
            }
            this.cutDelta = 0;
         }
         else if(Tool.isIgnore)
         {
            if(Boolean(this.jointPos) && Boolean(this.jointBody))
            {
               this.IgnoreItems();
               if(this.detailSubmenu == "collision" && Boolean(this.detailBody))
               {
                  this.showDetails(this.detailBody,this.detailSubmenu);
                  Tool.setTool(Tool.DETAIL);
               }
            }
         }
         else if(Tool.isLink)
         {
            if(this.contractTarget && Boolean(this.jointPos))
            {
               userData(this.jointBody.GetUserData()).targetX = this.mouseXWorld * Physics.scale + this.m_sprite.x;
               userData(this.jointBody.GetUserData()).targetY = this.mouseYWorld * Physics.scale + this.m_sprite.y;
               Tool.reset();
               GameState.ui.updateControls();
               this.jointPos = null;
               this.jointBody = null;
               return;
            }
            if(Boolean(this.jointPos) && Boolean(this.jointBody))
            {
               this.LinkItems();
            }
         }
         else if(Tool.isJoint)
         {
            if(Boolean(this.jointPos) && Boolean(this.jointBody))
            {
               _loc22_ = new b2Vec2(this.mouseXWorld,this.mouseYWorld);
               _loc23_ = new b2Vec2(this.jointBody.GetPosition().x + this.jointPos.x,this.jointBody.GetPosition().y + this.jointPos.y);
               _loc24_ = Body.GetOne(_loc22_.x,_loc22_.y,true,true);
               if((Boolean(_loc24_)) && _loc24_ != this.jointBody)
               {
                  Joints.Distance("objjoint",this.jointBody,_loc24_,_loc23_,_loc22_,0,0,Tweak.jointCollide,Tweak.jointForce);
                  _loc25_ = userData(this.jointBody.GetUserData());
                  _loc26_ = userData(_loc24_.GetUserData());
                  if(_loc25_.alive && _loc26_.alive)
                  {
                     if(!_loc25_.id && Boolean(_loc26_.id))
                     {
                        _loc25_.id = _loc26_.id;
                     }
                     else if(Boolean(_loc25_.id) && !_loc26_.id)
                     {
                        _loc26_.id = _loc25_.id;
                     }
                  }
               }
               else
               {
                  Joints.Distance("objjoint",this.jointBody,Physics.world.GetGroundBody(),_loc23_,_loc22_,0,0,Tweak.jointCollide,Tweak.jointForce);
               }
               this.jointPos = null;
               this.jointBody = null;
            }
         }
         else if(Tool.isPiston)
         {
            if(Boolean(this.jointPos) && Boolean(this.jointBody))
            {
               _loc22_ = new b2Vec2(this.mouseXWorld,this.mouseYWorld);
               _loc24_ = Body.GetOne(_loc22_.x,_loc22_.y,true,true);
               if(!Tweak.jointLimited)
               {
                  if(Boolean(_loc24_) && _loc24_ != this.jointBody)
                  {
                     this.jointBody2 = _loc24_;
                  }
               }
               if(this.jointBody2)
               {
                  _loc23_ = this.jointBody2.GetPosition().Copy();
                  Joints.Prismatic("pistonjoint",this.jointBody,this.jointBody2,_loc23_,_loc22_,Tweak.jointForce);
                  _loc25_ = userData(this.jointBody.GetUserData());
                  _loc26_ = userData(this.jointBody2.GetUserData());
                  if(_loc25_.alive && _loc26_.alive)
                  {
                     if(!_loc25_.id && Boolean(_loc26_.id))
                     {
                        _loc25_.id = _loc26_.id;
                     }
                     else if(Boolean(_loc25_.id) && !_loc26_.id)
                     {
                        _loc26_.id = _loc25_.id;
                     }
                  }
                  this.jointPos = null;
                  this.jointBody = null;
                  this.jointBody2 = null;
               }
               else if(Boolean(_loc24_) && _loc24_ != this.jointBody)
               {
                  this.jointBody2 = _loc24_;
               }
               else
               {
                  _loc23_ = this.jointBody.GetPosition().Copy();
                  Joints.Prismatic("pistonjoint",this.jointBody,Physics.world.GetGroundBody(),_loc23_,_loc22_,Tweak.jointForce);
                  this.jointPos = null;
                  this.jointBody = null;
                  this.jointBody2 = null;
               }
            }
         }
         else if(Tool.isRope)
         {
            if(Boolean(this.jointPos) && Boolean(this.jointBody))
            {
               _loc22_ = new b2Vec2(this.mouseXWorld,this.mouseYWorld);
               _loc23_ = new b2Vec2(this.jointBody.GetPosition().x + this.jointPos.x,this.jointBody.GetPosition().y + this.jointPos.y);
               _loc24_ = Body.GetOne(_loc22_.x,_loc22_.y,true,true);
               if((Boolean(_loc24_)) && _loc24_ != this.jointBody)
               {
                  Joints.Distance("ropejoint",this.jointBody,_loc24_,_loc23_,_loc22_,Tweak.jointFrequency,Tweak.jointDamping,Tweak.jointCollide,Tweak.jointForce);
               }
               else
               {
                  Joints.Distance("ropejoint",this.jointBody,Physics.world.GetGroundBody(),_loc23_,_loc22_,Tweak.jointFrequency,Tweak.jointDamping,Tweak.jointCollide,Tweak.jointForce);
               }
               this.jointPos = null;
               this.jointBody = null;
            }
         }
         else if(Tool.isDoll)
         {
            if(Boolean(this.jointPos) && Boolean(this.jointBody))
            {
               _loc22_ = new b2Vec2(this.mouseXWorld,this.mouseYWorld);
               _loc24_ = Body.GetOne(_loc22_.x,_loc22_.y,true,true);
               if((Boolean(_loc24_)) && _loc24_ != this.jointBody)
               {
                  this.jointBody2 = _loc24_;
                  _loc27_ = userData(this.jointBody.GetUserData()).width;
                  if(userData(this.jointBody.GetUserData()).height < _loc27_)
                  {
                     _loc27_ = userData(this.jointBody.GetUserData()).height;
                  }
                  _loc28_ = userData(this.jointBody2.GetUserData()).width;
                  if(userData(this.jointBody2.GetUserData()).height < _loc28_)
                  {
                     _loc28_ = userData(this.jointBody2.GetUserData()).height;
                  }
                  _loc27_ *= 0.2;
                  _loc28_ *= 0.2;
                  if(_loc27_ > 10)
                  {
                     _loc27_ = 10;
                  }
                  if(_loc28_ > 10)
                  {
                     _loc28_ = 10;
                  }
                  this.toolSprite.graphics.clear();
                  this.toolSprite.graphics.lineStyle(this.zoomLineStyle(),16777215);
                  this.toolSprite.graphics.beginFill(16777215,0.2);
                  this.toolSprite.graphics.drawCircle(this.jointBody.GetPosition().x * Physics.scale,this.jointBody.GetPosition().y * Physics.scale,_loc27_ / this.cam.scaleX);
                  this.toolSprite.graphics.drawCircle(this.jointBody2.GetPosition().x * Physics.scale,this.jointBody2.GetPosition().y * Physics.scale,_loc28_ / this.cam.scaleX);
                  this.toolSprite.graphics.endFill();
               }
               else
               {
                  this.jointPos = null;
                  this.jointBody = null;
                  this.jointBody2 = null;
               }
            }
         }
         else if(Tool.isWeld)
         {
            if(Boolean(this.jointPos) && Boolean(this.jointBody))
            {
               _loc22_ = new b2Vec2(this.mouseXWorld,this.mouseYWorld);
               _loc23_ = new b2Vec2(this.jointBody.GetPosition().x + this.jointPos.x,this.jointBody.GetPosition().y + this.jointPos.y);
               _loc24_ = Body.GetOne(_loc22_.x,_loc22_.y,true,true);
               this.finishWelding(this.jointBody,_loc24_);
            }
         }
         else if(Tool.isTrigger)
         {
            this.toolSprite.graphics.clear();
            this.itemTriggered = false;
            this.scalingPos = null;
            _loc24_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,true,true);
            if(!_loc24_)
            {
               return;
            }
            if(this.selectedBodies.indexOf(_loc24_) != -1)
            {
               for each(_loc16_ in this.selectedBodies)
               {
                  _loc29_ = userData(_loc16_.GetUserData());
                  if(_loc29_.trigger is Gun)
                  {
                     if(Gun(_loc29_.trigger).firearm.burstAmount <= 1)
                     {
                        _loc29_.triggered = false;
                        Gun(_loc29_.trigger).firearm.forceReload();
                     }
                  }
               }
            }
            else
            {
               _loc29_ = userData(_loc24_.GetUserData());
               if(_loc29_.trigger is Gun)
               {
                  if(Gun(_loc29_.trigger).firearm.burstAmount <= 1)
                  {
                     _loc29_.triggered = false;
                     Gun(_loc29_.trigger).firearm.forceReload();
                  }
               }
            }
         }
         else if(Tool.isStab)
         {
            this.stabPressBandaid = true;
         }
         if(Boolean(this.m_mouseJoint) && Boolean(!Tool.isSwing) && !Tool.isStab)
         {
            this.stopDragging();
         }
         if(this.pauseMoving)
         {
            if(GameState.stamping && this.pauseMovingBodies.length > 0)
            {
               _loc33_ = this.pauseMovingBodies[0][0];
               this.stampItem(_loc33_);
               _loc33_.SetXForm(b2Vec2(this.pauseMovingBodies[0][2]),_loc33_.GetAngle());
            }
            _loc30_ = Tweak.GridSize / Physics.scale;
            _loc31_ = new b2Vec2();
            for each(_loc32_ in this.pauseMovingBodies)
            {
               _loc24_ = _loc32_[0];
               if(_loc24_)
               {
                  if(World.toggleIntegerSnap == 1)
                  {
                     _loc31_.x = Math.round(_loc24_.GetPosition().x * Physics.scale) / Physics.scale;
                     _loc31_.y = Math.round(_loc24_.GetPosition().y * Physics.scale) / Physics.scale;
                     _loc24_.SetXForm(_loc31_,_loc24_.GetAngle());
                  }
                  if(userData(_loc24_.GetUserData()).gridSnap)
                  {
                     _loc31_.x = Math.round(_loc24_.GetPosition().x / _loc30_) * _loc30_;
                     _loc31_.y = Math.round(_loc24_.GetPosition().y / _loc30_) * _loc30_;
                     _loc24_.SetXForm(_loc31_,_loc24_.GetAngle());
                  }
               }
            }
         }
         if(this.pauseMoving)
         {
            this.pauseMoving = false;
            this.pauseMovingBodies = [];
            if(!this.shiftPressed && Tool.isDrag && !GameState.stamping)
            {
               this.selectedBodies = new Vector.<b2Body>();
            }
         }
         if(!this.contract.allowPower(new b2Vec2(this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale)))
         {
            return;
         }
         if(Tool.isPower)
         {
            _loc34_ = Tool.power;
            if(this.canThrowPower && this.mouseVelAverage.Length() > 2)
            {
               _loc34_.Throw(new b2Vec2(this.mouseXWorld,this.mouseYWorld),this.mouseVelAverage);
            }
            else
            {
               _loc34_.Release();
            }
         }
         this.canThrowPower = true;
         _loc2_ = GameState.menuHandler.menuDragging();
         if(_loc2_)
         {
            _loc2_.stopDragging();
         }
      }
      
      private function FinishSelecting() : void
      {
         var _loc1_:Vector.<b2Body> = null;
         var _loc2_:b2Body = null;
         var _loc3_:int = 0;
         if(this.quickCreatingCustomItem != 2)
         {
            _loc1_ = Body.SelectArea(this.selectingPos,new b2Vec2(this.mouseXWorld,this.mouseYWorld),GameState.paused,true);
            if(_loc1_.length == 0)
            {
               _loc1_ = Body.SelectArea(this.selectingPos,new b2Vec2(this.mouseXWorld,this.mouseYWorld),true,true);
            }
            if(_loc1_.length == 0)
            {
               this.selectedBodies = new Vector.<b2Body>();
               this.quickCreatingCustomItem = 0;
            }
            else
            {
               for each(_loc2_ in _loc1_)
               {
                  if(userData(_loc2_.GetUserData()).locked)
                  {
                     if(!Tool.isDetail)
                     {
                        continue;
                     }
                     if(World.detailLocked == 0)
                     {
                        continue;
                     }
                  }
                  _loc3_ = this.selectedBodies.indexOf(_loc2_);
                  if(_loc3_ != -1)
                  {
                     this.selectedBodies.splice(_loc3_,1);
                  }
                  else
                  {
                     this.selectedBodies.push(_loc2_);
                  }
               }
            }
            this.selectingPos = null;
            this.toolSprite.graphics.clear();
            if(this.detailBody)
            {
               this.showDetails(this.detailBody,this.detailSubmenu);
            }
         }
      }
      
      private function IgnoreItems() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:Vector.<b2Body> = null;
         var _loc3_:b2Body = null;
         var _loc4_:b2Body = null;
         var _loc5_:b2Body = null;
         _loc1_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,true,true);
         if(_loc1_ == this.jointBody)
         {
            return;
         }
         if(this.selectedBodies.length > 0 && this.selectedBodies.indexOf(this.jointBody) == -1 && this.selectedBodies.indexOf(_loc1_) != -1)
         {
            _loc3_ = _loc1_;
            _loc1_ = this.jointBody;
            this.jointBody = _loc3_;
         }
         if(!_loc1_)
         {
            if(this.selectedBodies.length > 0)
            {
               for each(_loc4_ in this.selectedBodies)
               {
                  _loc2_ = userData(_loc4_.GetUserData()).ignored;
                  for each(_loc5_ in _loc2_)
                  {
                     userData(_loc5_.GetUserData()).unignore(_loc4_);
                  }
                  userData(_loc4_.GetUserData()).ignored = new Vector.<b2Body>();
               }
            }
            else
            {
               _loc2_ = userData(this.jointBody.GetUserData()).ignored;
               for each(_loc5_ in _loc2_)
               {
                  userData(_loc5_.GetUserData()).unignore(this.jointBody);
               }
               userData(this.jointBody.GetUserData()).ignored = new Vector.<b2Body>();
            }
         }
         if(_loc1_)
         {
            if(this.selectedBodies.length > 0)
            {
               for each(_loc4_ in this.selectedBodies)
               {
                  if(_loc4_ != _loc1_)
                  {
                     userData(_loc1_.GetUserData()).ignored.push(_loc4_);
                     userData(_loc4_.GetUserData()).ignored.push(_loc1_);
                  }
               }
            }
            else
            {
               _loc2_ = userData(this.jointBody.GetUserData()).ignored;
               if(_loc1_ != this.jointBody && _loc2_.indexOf(_loc1_) == -1)
               {
                  _loc2_.push(_loc1_);
                  userData(_loc1_.GetUserData()).ignored.push(this.jointBody);
               }
            }
         }
         this.jointPos = null;
         this.jointBody = null;
      }
      
      private function LinkItems() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:Vector.<b2Body> = null;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:b2Body = null;
         var _loc6_:Boolean = false;
         var _loc7_:b2Vec2 = null;
         _loc1_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,true,true);
         _loc2_ = userData(this.jointBody.GetUserData()).connected;
         _loc3_ = false;
         _loc4_ = this.selectedBodies.indexOf(this.jointBody) != -1;
         if(!_loc1_ || this.jointBody == _loc1_)
         {
            if(_loc4_)
            {
               for each(_loc5_ in this.selectedBodies)
               {
                  userData(_loc5_.GetUserData()).connected = new Vector.<b2Body>();
               }
            }
            else
            {
               _loc2_ = new Vector.<b2Body>();
            }
            _loc3_ = true;
         }
         if(Boolean(_loc1_) && this.jointBody != _loc1_)
         {
            _loc6_ = this.selectedBodies.indexOf(_loc1_) != -1;
            if(_loc4_ || _loc6_)
            {
               if(!_loc4_ && _loc6_)
               {
                  for each(_loc5_ in this.selectedBodies)
                  {
                     if(_loc2_.indexOf(_loc5_) != -1)
                     {
                        userData(this.jointBody.GetUserData()).disconnect(_loc5_);
                        _loc3_ = true;
                     }
                     else
                     {
                        _loc2_.push(_loc5_);
                     }
                  }
               }
               else if(_loc4_ && !_loc6_)
               {
                  for each(_loc5_ in this.selectedBodies)
                  {
                     if(userData(_loc5_.GetUserData()).connected.indexOf(_loc1_) != -1)
                     {
                        userData(_loc5_.GetUserData()).disconnect(_loc1_);
                        _loc3_ = true;
                     }
                     else
                     {
                        userData(_loc5_.GetUserData()).connected.push(_loc1_);
                     }
                  }
               }
            }
            else if(_loc2_.indexOf(_loc1_) != -1)
            {
               userData(this.jointBody.GetUserData()).disconnect(_loc1_);
               _loc3_ = true;
            }
            else if(_loc1_ != this.jointBody)
            {
               _loc2_.push(_loc1_);
            }
         }
         this.linkStart = this.jointBody.GetPosition().Copy();
         this.linkStart.Add(this.jointPos);
         this.linkEnd = new b2Vec2(this.mouseXWorld,this.mouseYWorld);
         this.linkDelta = 0;
         if(_loc3_)
         {
            _loc7_ = this.linkStart.Copy();
            this.linkStart = this.linkEnd;
            this.linkEnd = _loc7_;
         }
         this.jointPos = null;
         this.jointBody = null;
      }
      
      private function finishAttachingEffect() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:Array = null;
         this.effecting = false;
         this.previewEffectBody = null;
         _loc1_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,false,true);
         if(!_loc1_)
         {
            _loc2_ = Body.GetAroundPoint(new b2Vec2(mouseX,mouseY),50,50,false);
            if(_loc2_.length > 0)
            {
               _loc1_ = _loc2_[0];
            }
         }
         if(_loc1_)
         {
            this.AttachEffect(_loc1_,new b2Vec2(this.mouseXWorld,this.mouseYWorld));
            this.toolSprite.graphics.clear();
         }
      }
      
      private function TogglePowerMenu() : *
      {
         if(!GameState.ui.menuTools.visible || GameState.ui.menuTools.title == "Powers")
         {
            if(!GameState.ui.menuTools.visible)
            {
               GameState.ui.menuTools.x = GameState.ui.menuControls.x - GameState.ui.menuTools.actualWidth - 4;
               GameState.ui.menuTools.y = GameState.ui.menuControls.y;
            }
            GameState.ui.menuTools.toggle();
         }
         Powers.UpdatePowerMenu();
      }
      
      private function ToggleJointsMenu(param1:ListEvent) : *
      {
         var _loc2_:Boolean = false;
         GameState.ui.menuTools.collapseInsteadOfMinimising = true;
         if(!GameState.ui.menuTools.visible || GameState.ui.menuTools.title == "Joints")
         {
            if(!GameState.ui.menuTools.visible)
            {
               GameState.ui.menuTools.x = GameState.ui.menuControls.x - GameState.ui.menuTools.actualWidth - 4;
               GameState.ui.menuTools.y = GameState.ui.menuControls.y;
            }
            GameState.ui.menuTools.toggle();
         }
         if(GameState.ui.menuTools.visible)
         {
            if(GameState.ui.menuTools.title == "Powers")
            {
               Powers.scrollPos = GameState.ui.menuTools.getTree("buttons").verticalScrollPosition;
            }
            _loc2_ = false;
            if(GameState.ui.menuTools.getTree("buttons"))
            {
               _loc2_ = GameState.ui.menuTools.isMinimised;
               GameState.ui.menuTools.getTree("buttons").removeEventListener(ListEvent.ITEM_CLICK,this.jointTreeClick);
            }
            this.jointTreeClick(param1);
            if(_loc2_)
            {
               GameState.ui.menuTools.collapse();
            }
         }
      }
      
      private function TogglePauseSettingsMenu() : *
      {
         var _loc1_:XML = null;
         var _loc2_:Tree = null;
         var _loc3_:HUISlider = null;
         if(!GameState.ui.menuTools.visible)
         {
            GameState.ui.menuTools.x = GameState.ui.menuControls.x - GameState.ui.menuTools.actualWidth - 4;
            GameState.ui.menuTools.y = GameState.ui.menuControls.y;
         }
         if(!GameState.ui.menuTools.visible || GameState.ui.menuTools.title == "Pause Settings")
         {
            GameState.ui.menuTools.toggle();
         }
         GameState.ui.menuTools.title = "Pause Settings";
         GameState.ui.menuTools.removeAllChildren();
         _loc1_ = <node label="Root Node">
										<node label="Blueprint" func="showblueprint" toggleValue={World.toggleBlueprint} tooltip="Blueprint style.&#10;"/>
										<node label="Grid" func="showgrid" toggleValue={World.toggleGrid} tooltip="Display grid."/>
										<node label="Joints" func="pausejoints" toggleValue={World.toggleJointsPause} tooltip="Joints visible.&#10;"/>
										<node label="Links" func="pauselinks" toggleValue={World.toggleLinkPause} tooltip="Links visible.&#10;"/>
										<node label="Radius" func="showradius" toggleValue={World.toggleRadius} tooltip="Display item trigger radius.&#10;"/>
										<node label="Velocity" func="showvelo" toggleValue={World.toggleVelocity} tooltip="Display item velocity vector.&#10;"/>
										<node label="Layers">
											<node label="Background" func="layerback" toggleValue={this.backgroundSprite.visible ? "1" : "0"} tooltip="Background layer visible.&#10;"/>
											<node label="Default" func="layerdefault" toggleValue={this
         .itemSprite.visible ? "1" : "0"} tooltip="Default layer visible.&#10;"/>
											<node label="Foreground" func="layerfront" toggleValue={this.foregroundSprite.visible ? "1" : "0"} tooltip="Foreground visible.&#10;"/>
										</node>
									</node>;
         if(World.toggleGrid)
         {
            _loc3_ = GameState.ui.menuTools.addSlider("px Grid Size",Tweak.GridSize,5,200);
            _loc3_.addEventListener(Event.CHANGE,this.pauseGridChanged);
            _loc3_.addEventListener("finished",this.saveSliderFinished);
         }
         _loc2_ = GameState.ui.menuTools.addTree("buttons",_loc1_,180,0,30);
         _loc2_.selectable = false;
         _loc2_.addEventListener(ListEvent.ITEM_CLICK,this.toggleTree);
         GameState.ui.menuTools.maximise();
      }
      
      private function ToggleToolsMenu() : *
      {
         var _loc1_:Boolean = false;
         var _loc2_:XML = null;
         var _loc3_:XML = null;
         var _loc4_:int = 0;
         GameState.ui.menuTools.collapseInsteadOfMinimising = true;
         if(!GameState.ui.menuTools.visible || GameState.ui.menuTools.title == "Tools")
         {
            if(!GameState.ui.menuTools.visible)
            {
               GameState.ui.menuTools.x = GameState.ui.menuControls.x - GameState.ui.menuTools.actualWidth - 4;
               GameState.ui.menuTools.y = GameState.ui.menuControls.y;
            }
            GameState.ui.menuTools.toggle();
         }
         if(GameState.ui.menuTools.visible)
         {
            if(GameState.ui.menuTools.title == "Powers")
            {
               Powers.scrollPos = GameState.ui.menuTools.getTree("buttons").verticalScrollPosition;
            }
            _loc1_ = false;
            if(GameState.ui.menuTools.getTree("buttons"))
            {
               _loc1_ = GameState.ui.menuTools.isMinimised;
               GameState.ui.menuTools.getTree("buttons").removeEventListener(ListEvent.ITEM_CLICK,this.toolTreeClick);
            }
            GameState.ui.menuTools.removeAllChildren();
            _loc2_ = R.xml_tools.copy();
            for each(_loc3_ in _loc2_.node)
            {
               _loc4_ = Keymap.nameToCode(_loc3_.@key);
               if(_loc4_ != 0)
               {
                  _loc3_.@label = _loc3_.@label + " [" + Keymap.codeToKeyname(_loc4_) + "]";
               }
            }
            GameState.ui.menuTools.addTree("buttons",_loc2_).selectable = false;
            GameState.ui.menuTools.getTree("buttons").addEventListener(ListEvent.ITEM_CLICK,this.toolTreeClick);
            GameState.ui.menuTools.title = "Tools";
            GameState.ui.menuTools.maximiseHeight = 28 + 14 * 32;
            GameState.ui.menuTools.minWidth = 42;
            GameState.ui.menuTools.maximise();
            if(_loc1_)
            {
               GameState.ui.menuTools.collapse();
            }
         }
      }
      
      private function OpenEffects(param1:b2Body) : *
      {
         if(!param1)
         {
            GameState.ui.menuEffects.close();
            return;
         }
         if(!GameState.ui.menuEffects.visible)
         {
            GameState.ui.menuEffects.open();
         }
         GameState.ui.menuDetails.close();
         if(!GameState.ui.menuEffects.undocked)
         {
            GameState.ui.menuEffects.x = GraphicUtils.camY(param1.GetPosition().x * Physics.scale) - GameState.ui.menuEffects.actualWidth * 0.5;
            GameState.ui.menuEffects.y = GraphicUtils.camY(param1.GetPosition().y * Physics.scale) - 320;
            if(GameState.ui.menuEffects.y < 50)
            {
               GameState.ui.menuEffects.y = 50;
            }
         }
         GameState.ui.menuEffects.title = "Effect (" + GeneralUtils.objectToName(userData(param1.GetUserData()).name) + ")";
         this.previewEffectBody = param1;
         if(!this.previewEffect)
         {
            this.previewEffect = new PFXCircle(this.previewEffectBody);
            this.previewEffect.replaceDefault = false;
            this.previewEffect.noRadius = true;
            this.previewEffect.noAmount = true;
            this.previewEffect.noSpeed = true;
            this.previewEffect.noCenter = true;
            this.previewEffect.noScale = true;
            this.previewEffect.elementIcon = "p_empty";
            this.previewEffect.effectIcon = "p_empty";
            this.previewEffect.elementLabel = "Choose Particle";
            this.previewEffect.effectLabel = "Choose Effect";
         }
         else
         {
            this.previewEffect.body = this.previewEffectBody;
            this.selectEffectType(this.previewEffectNode);
         }
         this.updateEffectsMenu();
      }
      
      private function AttachEffect(param1:b2Body, param2:b2Vec2) : *
      {
         var _loc3_:Class = null;
         var _loc4_:b2Body = null;
         var _loc5_:ToolTip = null;
         _loc3_ = getDefinitionByName(getQualifiedClassName(this.previewEffect)) as Class;
         if(getQualifiedClassName(_loc3_) == "shiny::PFXNone")
         {
            if(this.selectedBodies.indexOf(param1) != -1)
            {
               for each(_loc4_ in this.selectedBodies)
               {
                  userData(_loc4_.GetUserData()).pfx = null;
               }
            }
            this.updateEffectsMenu();
            return;
         }
         if(getQualifiedClassName(_loc3_) == "shiny::PFXFirearm")
         {
            if(!(userData(param1.GetUserData()).trigger is Gun))
            {
               _loc5_ = GameState.ui.showTooltip(GameState.ui.menuEffects,"Requires firearm.\n",0,1000,GameState.ui.menuEffects.actualWidth);
               return;
            }
         }
         for each(_loc4_ in this.selectedBodies)
         {
            this.previewEffect.body = _loc4_;
            userData(_loc4_.GetUserData()).pfx = new _loc3_(_loc4_,param2);
            this.previewEffect.PasteProperties(userData(_loc4_.GetUserData()).pfx);
         }
         this.previewEffect.body = null;
         this.updateEffectsMenu();
      }
      
      private function finishSpawningItem(param1:Boolean = true) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Sprite = null;
         var _loc5_:Point = null;
         var _loc6_:int = 0;
         var _loc7_:b2Body = null;
         var _loc8_:Vector.<String> = null;
         var _loc9_:Array = null;
         var _loc10_:Class = null;
         var _loc11_:ParticleEffect = null;
         var _loc12_:String = null;
         if(GameState.quickspawning)
         {
            GameState.ui.menuSpawn.close();
            GameState.quickspawning = false;
         }
         _loc2_ = false;
         if(GameState.ui.menuChallenge.visible)
         {
            if(!(GameState.objects.spawnSprite.x > GameState.ui.menuChallenge.x + GameState.ui.menuChallenge.width || GameState.objects.spawnSprite.x < GameState.ui.menuChallenge.x || GameState.objects.spawnSprite.y > GameState.ui.menuChallenge.y + GameState.ui.menuChallenge.height || GameState.objects.spawnSprite.y < GameState.ui.menuChallenge.y))
            {
               _loc2_ = true;
               _loc5_ = GameState.ui.menuChallenge.globalToLocal(new Point(mouseX,mouseY));
               this.contract.addItem(GameState.objects.spawnName,new b2Vec2(_loc5_.x,_loc5_.y));
            }
         }
         if(!_loc2_)
         {
            if(!this.contract.allowSpawn(new b2Vec2(GraphicUtils.camX(GameState.objects.spawnSprite.x),GraphicUtils.camY(GameState.objects.spawnSprite.y))))
            {
               this.contract.restoreSpawnItem();
               _loc2_ = true;
            }
         }
         _loc3_ = false;
         if(GameState.ui.menuSpawn.visible)
         {
            _loc3_ = !(mouseX > GameState.ui.menuSpawn.x + GameState.ui.menuSpawn.actualWidth || GameState.objects.spawnSprite.x < GameState.ui.menuSpawn.x || GameState.objects.spawnSprite.y > GameState.ui.menuSpawn.y + GameState.ui.menuSpawn.height || mouseY < GameState.ui.menuSpawn.y);
         }
         if(GameState.stamping)
         {
            this.stampItem();
         }
         else if(!_loc2_ && !_loc3_)
         {
            _loc6_ = this.customNames.indexOf(GameState.objects.spawnName);
            if(_loc6_ == -1 && !GameState.objects.spawnCustomContent)
            {
               _loc7_ = GameState.objects.spawnObject(GameState.objects.spawnName,this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale,GameState.objects.spawnAngle,this.flipped,true,GameState.objects.spawnSkin);
               if(Properties.forceObjEffect == 1)
               {
                  if(_loc7_)
                  {
                     _loc8_ = new Vector.<String>();
                     _loc8_.push(GameState.particles.names[int(GameState.particles.names.length * Math.random())]);
                     _loc9_ = [PFXAngular,PFXCenter,PFXCenterEmit,PFXCircle,PFXCircleCycling,PFXCirclePingPong,PFXCirclePulse,PFXCircleRandom,PFXConnected,PFXCorners,PFXCross,PFXFourSides,PFXGlow,PFXHorizontal,PFXHorizontalPingPong,PFXInside,PFXInwards,PFXJoint,PFXJointAnchor,PFXOutline,PFXOutwards,PFXRadius,PFXSpiral,PFXVertical,PFXVerticalPingPong,PFXVoid,PFXZap,PFXPoint,PFXScan,PFXSnake,PFXVoidInwards,PFXSpiralWave,PFXFirefly,PFXCollision];
                     _loc10_ = _loc9_[int(_loc9_.length * Math.random())] as Class;
                     _loc11_ = new _loc10_(_loc7_,BoxUtils.randomPointOnBody(_loc7_));
                     _loc11_.particles = _loc8_;
                     userData(_loc7_.GetUserData()).pfx = _loc11_;
                  }
               }
            }
            else
            {
               _loc12_ = this.customItems[_loc6_];
               if(GameState.objects.spawnCustomContent)
               {
                  _loc12_ = GameState.objects.spawnCustomContent;
               }
               GameState.spawningCustom = true;
               this.customPos = new b2Vec2();
               IO.loadWorld(_loc12_,!GameState.paused,true);
               GameState.spawningCustom = false;
            }
         }
         if(!param1)
         {
            return;
         }
         GameState.spawning = false;
         GameState.objects.spawnScale = 1;
         GameState.objects.spawnAngle = 0;
         _loc4_ = GameState.ui.menuSpawn.getChildByName("itemHolder") as Sprite;
         _loc4_.visible = true;
         if(GameState.objects.spawnSprite)
         {
            GameState.objects.spawnSprite.parent.removeChild(GameState.objects.spawnSprite);
            GameState.objects.spawnSprite = null;
         }
         this.updateSpawnPic();
      }
      
      private function stampItem(param1:b2Body = null) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:b2Vec2 = null;
         var _loc4_:Number = NaN;
         var _loc5_:b2Vec2 = null;
         var _loc6_:b2Body = null;
         var _loc7_:userData = null;
         var _loc8_:Bitmap = null;
         var _loc9_:BitmapData = null;
         var _loc10_:ByteArray = null;
         var _loc11_:Matrix = null;
         var _loc12_:b2Vec2 = null;
         if(!param1 && GameState.objects.spawnSprite.name == "customSprite")
         {
            GameState.ui.showTooltip(GameState.ui.menuSpawn,"Custom Items can\'t be used as stamps.\n",0,500,200);
            return;
         }
         if(!param1)
         {
            _loc2_ = GameState.objects.spawnSprite;
         }
         else
         {
            _loc2_ = userData(param1.GetUserData()).graphic;
         }
         if(!_loc2_)
         {
            return;
         }
         _loc3_ = new b2Vec2(this.mouseXWorld,this.mouseYWorld);
         _loc4_ = _loc2_.rotation * Vars.toRadians;
         _loc5_ = new b2Vec2(_loc2_.scaleX,_loc2_.scaleY);
         if(param1)
         {
            _loc3_ = new b2Vec2(_loc2_.x / Physics.scale,_loc2_.y / Physics.scale);
            _loc4_ = param1.GetAngle();
            _loc5_.x = userData(param1.GetUserData()).size;
            _loc5_.y = userData(param1.GetUserData()).size;
         }
         _loc5_.Multiply(1 / this.cam.scaleX);
         for each(_loc6_ in this.selectedBodies)
         {
            if(_loc6_)
            {
               if(_loc6_ != param1)
               {
                  _loc7_ = userData(_loc6_.GetUserData());
                  if(_loc7_)
                  {
                     _loc8_ = BoxUtils.getEffectBM(_loc6_);
                     _loc9_ = _loc8_.bitmapData;
                     if(_loc9_)
                     {
                        _loc10_ = _loc9_.getPixels(_loc9_.rect);
                        _loc11_ = new Matrix();
                        _loc12_ = _loc6_.GetLocalPoint(_loc3_);
                        _loc12_.Multiply(Physics.scale);
                        _loc12_.x -= _loc8_.x;
                        _loc12_.y -= _loc8_.y;
                        _loc11_.scale(_loc5_.x,_loc5_.y);
                        _loc11_.rotate(_loc4_ - _loc6_.GetAngle());
                        _loc11_.translate(_loc12_.x,_loc12_.y);
                        _loc9_.drawWithQuality(_loc2_,_loc11_,null,null,null,false,World.stampQuality == 1 ? StageQuality.BEST : StageQuality.LOW);
                        if(_loc9_.getPixels(_loc9_.rect) != _loc10_)
                        {
                           _loc7_.saveStains = true;
                        }
                     }
                  }
               }
            }
         }
      }
      
      public function stopDragging(param1:Boolean = true) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:userData = null;
         if(Boolean(GameState.environment) && GameState.environment is PumpkinMoon)
         {
            return;
         }
         if(this.m_mouseJoint)
         {
            _loc2_ = this.m_mouseJoint.GetBody2().GetLinearVelocity().Length();
            if(param1)
            {
               if(_loc2_ > 140)
               {
                  sounds.play("throw2",null,new b2Vec2(this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale),0.35);
               }
               else if(_loc2_ > 30)
               {
                  sounds.play("throw1",null,new b2Vec2(this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale),Math.min(0.25,_loc2_ / 180));
               }
            }
            _loc3_ = userData(this.m_mouseJoint.GetBody2().GetUserData());
            this.m_mouseJoint.GetBody2().SetBullet(false);
            if(_loc2_ > 10)
            {
               Body.ThrowItem(_loc3_,this.m_mouseJoint.GetAnchor2().Copy());
            }
            if(Boolean(Tool.isHole) && Boolean(_loc3_) && _loc3_.name == "blackhole")
            {
               _loc3_.killOnContact = true;
               _loc3_.zerograv = true;
            }
            else if(Boolean(Tool.isRadiation) && Boolean(_loc3_) && _loc3_.name == "radioactivebarrel")
            {
               _loc3_.killOnContact = true;
               _loc3_.zerograv = true;
            }
            else if(Boolean(Tool.isBlunt) && Boolean(_loc3_) && _loc3_.name == "boxingglove")
            {
               _loc3_.name = "bluntprojectile";
               _loc3_.triggerOnContact = true;
               _loc3_.trigger = new TempProjectile(20);
            }
            else if(Boolean(Tool.isSharp) && Boolean(_loc3_) && _loc3_.name == "sawblade")
            {
               _loc3_.name = "bluntprojectile";
               _loc3_.triggerOnContact = true;
               _loc3_.trigger = new TempProjectile(20);
               b2Body(this.m_mouseJoint.GetBody2()).ApplyTorque(-_loc2_ * 10 * b2Body(this.m_mouseJoint.GetBody2()).GetMass());
            }
            else if(Boolean(Tool.isRicochet) && Boolean(_loc3_) && _loc3_.name == "ricochet")
            {
               _loc3_.name = "bluntprojectile";
               _loc3_.triggerOnContact = true;
               _loc3_.trigger = new TempProjectile(200);
               b2Body(this.m_mouseJoint.GetBody2()).ApplyTorque(-_loc2_ * 10 * b2Body(this.m_mouseJoint.GetBody2()).GetMass());
            }
            Physics.world.DestroyJoint(this.m_mouseJoint);
            this.m_mouseJoint = null;
            this.joints.graphics.clear();
         }
      }
      
      public function mouse_moved(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:b2Vec2 = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:b2Body = null;
         var _loc8_:userData = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:TextField = null;
         var _loc12_:TextField = null;
         var _loc13_:Boolean = false;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Array = null;
         var _loc18_:Array = null;
         var _loc19_:Number = NaN;
         var _loc20_:userData = null;
         var _loc21_:int = 0;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:int = 0;
         var _loc26_:b2Vec2 = null;
         var _loc27_:Number = NaN;
         if(this.mouseleft)
         {
            this.mouseleft = false;
         }
         if(this.movingCamera && !this.zoomingCamera)
         {
            this.cam.x = this.dragCamOrig.x + (-this.dragCamCurrent.x + this.dragCamMoved.x);
            this.cam.y = this.dragCamOrig.y + (-this.dragCamCurrent.y + this.dragCamMoved.y);
            this.bgBM.x = this.dragBGOrig.x + (-this.dragCamCurrent.x + this.dragCamMoved.x) * Tweak.BackgroundScroll;
            this.bgBM.y = this.dragBGOrig.y + (-this.dragCamCurrent.y + this.dragCamMoved.y) * Tweak.BackgroundScroll;
            this.dragCamMoved = new Point(mouseX,mouseY);
            if(GameState.paused)
            {
               TimeLord.pauseGrid.Update();
            }
            if(BoxUtils.vectorDist(this.camCullDistance,new b2Vec2(this.cam.x,this.cam.y)) > 250)
            {
               this.camCullDistance.x = this.cam.x;
               this.camCullDistance.y = this.cam.y;
               this.CameraCull();
            }
         }
         if(this.previousBody)
         {
            this.previousBody = null;
         }
         if(this.powerMovePos)
         {
            if(Math.abs(this.powerMovePos.y - mouseY) > 28)
            {
               _loc2_ = Powers.favPowers.indexOf(this.powerMove);
               if(this.powerMovePos.y - mouseY > 0)
               {
                  if(_loc2_ == 0)
                  {
                     return;
                  }
                  Powers.favPowers.splice(_loc2_,1);
                  Powers.favPowers.splice(_loc2_ - 1,0,this.powerMove);
                  this.powerMovePos = new b2Vec2(mouseX,mouseY);
               }
               else
               {
                  if(_loc2_ == Powers.favPowers.length)
                  {
                     return;
                  }
                  Powers.favPowers.splice(_loc2_,1);
                  Powers.favPowers.splice(_loc2_ + 1,0,this.powerMove);
                  this.powerMovePos = new b2Vec2(mouseX,mouseY);
               }
               Powers.updatePowers();
            }
         }
         this.mousepancounter = Vars.edgePanDelay;
         if(GameState.spawning && Boolean(GameState.objects.spawnSprite))
         {
            GameState.objects.spawnSprite.x = mouseX;
            GameState.objects.spawnSprite.y = mouseY;
            if(GameState.stamping)
            {
               GameState.objects.spawnSprite.x = Math.round(GameState.objects.spawnSprite.x);
               GameState.objects.spawnSprite.y = Math.round(GameState.objects.spawnSprite.y);
            }
         }
         if((GameState.spawningCustom || GameState.cloning) && Boolean(this.toolSprite))
         {
            this.toolSprite.graphics.clear();
            this.toolSprite.graphics.lineStyle(this.zoomLineStyle(),16777215);
            this.toolSprite.graphics.beginFill(16777215,0.2);
            this.toolSprite.graphics.drawCircle(this.mouseXWorld * Physics.scale - this.m_sprite.x,this.mouseYWorld * Physics.scale - this.m_sprite.y,10 / this.cam.scaleX);
            this.toolSprite.graphics.endFill();
         }
         if(Boolean(this.effecting) && Boolean(this.toolSprite) && Boolean(this.previewEffect.body))
         {
            this.toolSprite.graphics.clear();
            this.toolSprite.graphics.lineStyle(this.zoomLineStyle(),16777215);
            this.toolSprite.graphics.beginFill(16777215,0.2);
            this.toolSprite.graphics.drawCircle(this.mouseXWorld * Physics.scale - this.m_sprite.x,this.mouseYWorld * Physics.scale - this.m_sprite.y,10 / this.cam.scaleX);
            this.toolSprite.graphics.endFill();
            _loc3_ = new b2Vec2(this.previewEffect.body.GetPosition().x - this.mouseXWorld,this.previewEffect.body.GetPosition().y - this.mouseYWorld);
            _loc3_.Multiply(Physics.scale);
            this.previewEffect.offset = _loc3_;
         }
         if(Tool.isSelect || Tool.isDetail)
         {
            if(this.selectingPos)
            {
               this.toolSprite.graphics.clear();
               this.toolSprite.graphics.lineStyle(this.zoomLineStyle(),10066329);
               this.toolSprite.graphics.beginFill(16777215,0.2);
               this.toolSprite.graphics.drawRect(this.selectingPos.x * Physics.scale,this.selectingPos.y * Physics.scale,this.mouseXWorld * Physics.scale - this.selectingPos.x * Physics.scale,this.mouseYWorld * Physics.scale - this.selectingPos.y * Physics.scale);
               this.toolSprite.graphics.endFill();
            }
         }
         else if(Tool.isDestroy)
         {
            if(this.selectingPos)
            {
               this.toolSprite.graphics.clear();
               this.toolSprite.graphics.lineStyle(this.zoomLineStyle(),11141120);
               this.toolSprite.graphics.beginFill(11141120,0.2);
               this.toolSprite.graphics.drawRect(this.selectingPos.x * Physics.scale,this.selectingPos.y * Physics.scale,this.mouseXWorld * Physics.scale - this.selectingPos.x * Physics.scale,this.mouseYWorld * Physics.scale - this.selectingPos.y * Physics.scale);
               this.toolSprite.graphics.endFill();
            }
         }
         else if(Tool.isScale)
         {
            if(GameState.mouseDown && this.selectedBodies.length > 0)
            {
               this.toolSprite.graphics.clear();
               _loc4_ = this.scalingPos.y * Physics.scale - this.mouseYWorld * Physics.scale;
               _loc5_ = this.scalingPos.x * Physics.scale - this.mouseXWorld * Physics.scale;
               _loc6_ = 1 + (_loc5_ + _loc4_) * Tweak.toolScaleModifier;
               if(_loc6_ > Tweak.ScaleMax)
               {
                  _loc6_ = Tweak.ScaleMax;
               }
               if(_loc6_ < Tweak.ScaleMin)
               {
                  _loc6_ = Tweak.ScaleMin;
               }
               _loc6_ = int(_loc6_ * 10) / 10;
               if(BoxUtils.vectorDist(this.scalingPos,new b2Vec2(this.mouseXWorld,this.mouseYWorld)) <= 0.5 * Tweak.toolDeadzone / Physics.scale)
               {
                  _loc6_ = 1;
               }
               else
               {
                  this.toolSprite.graphics.beginFill(16777215,0.5);
               }
               this.toolSprite.graphics.lineStyle(this.zoomLineStyle(),16777215);
               this.toolSprite.graphics.drawCircle(this.scalingPos.x * Physics.scale,this.scalingPos.y * Physics.scale,Tweak.toolDeadzone);
               this.toolSprite.graphics.moveTo(this.scalingPos.x * Physics.scale,this.scalingPos.y * Physics.scale);
               this.toolSprite.graphics.lineTo(this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale);
               for each(_loc7_ in this.selectedBodies)
               {
                  _loc8_ = userData(_loc7_.GetUserData());
                  if(!_loc8_.hasBeenCut)
                  {
                     if(_loc8_.size * _loc6_ <= Tweak.ScaleMax)
                     {
                        _loc8_.graphic.scaleX = _loc6_;
                        _loc8_.graphic.scaleY = _loc6_;
                        this.toolSprite.graphics.drawCircle(_loc7_.GetPosition().x * Physics.scale,_loc7_.GetPosition().y * Physics.scale,10 / this.cam.scaleX);
                        if(_loc8_.graphic.getChildByName("debug_scalerot"))
                        {
                           _loc11_ = TextField(_loc8_.graphic.getChildByName("debug_scalerot"));
                           _loc11_.text = String(Math.round(_loc8_.size * _loc6_ * 100)) + "%";
                           _loc11_.rotation = -_loc11_.parent.rotation;
                           _loc11_.scaleX = _loc11_.scaleY = 1 / _loc6_;
                           _loc11_.x = 40 * (1 / _loc6_);
                           _loc11_.y = -10 * (1 / _loc6_);
                        }
                        else
                        {
                           _loc12_ = new TextField();
                           _loc12_.defaultTextFormat = new TextFormat(Tweak.FONT,16);
                           _loc12_.setTextFormat(new TextFormat(Tweak.FONT,16));
                           _loc12_.name = "debug_scalerot";
                           _loc8_.graphic.addChild(_loc12_);
                           _loc12_.x = 40;
                           _loc12_.y = -10;
                           _loc12_.embedFonts = true;
                           _loc12_.textColor = 4294967295;
                        }
                        _loc9_ = this.scalingPos.x - this.mouseXWorld;
                        _loc10_ = this.scalingPos.y - this.mouseYWorld;
                        _loc9_ *= 0.2;
                        _loc10_ *= 0.2;
                        this.toolSprite.graphics.moveTo(_loc7_.GetPosition().x * Physics.scale,_loc7_.GetPosition().y * Physics.scale);
                        this.toolSprite.graphics.lineTo((_loc7_.GetPosition().x - _loc9_) * Physics.scale,(_loc7_.GetPosition().y - _loc10_) * Physics.scale);
                     }
                  }
               }
               this.toolSprite.graphics.endFill();
            }
         }
         else if(Tool.isSwing)
         {
            this.MouseDrag();
            if(this.m_mouseJoint)
            {
               this.m_mouseJoint.GetBody2().SetAngularVelocity(this.m_mouseJoint.GetBody2().GetAngularVelocity() * 0.9);
            }
         }
         else if(Tool.isStab)
         {
            this.MouseDrag();
            if(this.m_mouseJoint)
            {
               this.m_mouseJoint.GetBody2().SetAngularVelocity(0);
            }
            else
            {
               this.stabPressBandaid = false;
            }
         }
         else if(Tool.isLaunch)
         {
            if(Boolean(this.scalingPos) && Boolean(this.selectedBodies) && this.selectedBodies.length > 0)
            {
               this.toolSprite.graphics.clear();
               _loc13_ = BoxUtils.vectorDist(this.scalingPos,new b2Vec2(this.mouseXWorld,this.mouseYWorld)) <= Tweak.toolDeadzone / Physics.scale;
               _loc14_ = (-this.mouseYWorld + this.scalingPos.y) * Physics.scale;
               _loc15_ = (-this.mouseXWorld + this.scalingPos.x) * Physics.scale;
               _loc16_ = Math.atan2(_loc14_,_loc15_);
               if(!_loc13_)
               {
                  this.toolSprite.graphics.beginFill(16777215,0.5);
               }
               this.toolSprite.graphics.lineStyle(this.zoomLineStyle(),16777215);
               this.toolSprite.graphics.drawCircle(this.scalingPos.x * Physics.scale,this.scalingPos.y * Physics.scale,Tweak.toolDeadzone);
               this.toolSprite.graphics.moveTo(this.scalingPos.x * Physics.scale,this.scalingPos.y * Physics.scale);
               this.toolSprite.graphics.lineTo(this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale);
               this.toolSprite.graphics.endFill();
               if(_loc13_)
               {
                  return;
               }
               if(this.shiftPressed)
               {
                  _loc17_ = ["grapple","harpoonbullet","doublelightsaber","rpg","blowdart","pencil","boxinggglove","bowie","chainsaw","hook","marlin","spartansword","tranqdart","dart","harpoon","throwingbat","lance","scissors","musket","razorrimmedhat","bayonet","arrow","longarrow","nestofbeesarrow","aimarrow","maimarrow","trapdart","arrowball","dartball","batteringram","gungatchet","boxingglove"];
                  _loc18_ = ["stake","pitchfork","shovel","evehypo","adrenalineshot","armyshovel","gladiatorscissors","hpdrain","pata","broomstick"];
                  _loc19_ = -90 * Vars.toRadians;
                  _loc20_ = this.selectedBodies[0].GetUserData();
                  if(_loc17_.indexOf(_loc20_.name) != -1)
                  {
                     _loc19_ = 0;
                  }
                  if(_loc18_.indexOf(_loc20_.name) != -1)
                  {
                     _loc19_ = 90 * Vars.toRadians;
                  }
                  if(_loc20_.flipped)
                  {
                     _loc19_ += 180 * Vars.toRadians;
                  }
                  _loc21_ = 0;
                  while(_loc21_ < 90)
                  {
                     _loc22_ = _loc16_ + _loc19_ - this.selectedBodies[0].GetAngle();
                     if(Math.abs(_loc22_) < 0.01)
                     {
                        break;
                     }
                     this.RotateItems(_loc22_);
                     _loc21_++;
                  }
               }
            }
            else
            {
               this.MouseDrag();
            }
         }
         else if(Tool.isRotate)
         {
            if(GameState.mouseDown && this.selectedBodies.length > 0 && Boolean(this.scalingPos))
            {
               this.toolSprite.graphics.clear();
               _loc23_ = BoxUtils.vectorDist(this.scalingPos,new b2Vec2(this.mouseXWorld,this.mouseYWorld));
               _loc13_ = _loc23_ <= Tweak.toolDeadzone / Physics.scale;
               _loc14_ = -this.mouseYWorld + this.scalingPos.y;
               _loc15_ = -this.mouseXWorld + this.scalingPos.x;
               _loc16_ = Math.atan2(_loc14_,_loc15_);
               _loc16_ = _loc16_ * Vars.toDegrees;
               _loc16_ = int(_loc16_);
               _loc16_ = _loc16_ * Vars.toRadians;
               if(!_loc13_)
               {
                  this.toolSprite.graphics.beginFill(16777215,0.5);
               }
               this.toolSprite.graphics.lineStyle(this.zoomLineStyle(),16777215);
               this.toolSprite.graphics.drawCircle(this.scalingPos.x * Physics.scale,this.scalingPos.y * Physics.scale,Tweak.toolDeadzone);
               this.toolSprite.graphics.moveTo(this.scalingPos.x * Physics.scale,this.scalingPos.y * Physics.scale);
               this.toolSprite.graphics.lineTo(this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale);
               if(!_loc13_)
               {
                  _loc25_ = int(this.selectedBodies.length);
                  _loc21_ = 0;
                  while(_loc21_ < _loc25_)
                  {
                     _loc7_ = this.selectedBodies[_loc21_];
                     _loc8_ = userData(_loc7_.GetUserData());
                     _loc7_.SetXForm(_loc7_.GetPosition(),_loc16_);
                     if(_loc8_.graphic.getChildByName("debug_scalerot"))
                     {
                        _loc11_ = TextField(_loc8_.graphic.getChildByName("debug_scalerot"));
                        _loc11_.text = Math.round(_loc16_ * Vars.toDegrees).toString() + "°";
                        _loc11_.rotation = -_loc11_.parent.rotation;
                        _loc11_.x = 40 * _loc8_.size;
                        _loc11_.y = -10 * _loc8_.size;
                     }
                     else
                     {
                        _loc12_ = new TextField();
                        _loc12_.defaultTextFormat = new TextFormat(Tweak.FONT,16);
                        _loc12_.setTextFormat(new TextFormat(Tweak.FONT,16));
                        _loc12_.name = "debug_scalerot";
                        _loc8_.graphic.addChild(_loc12_);
                        _loc12_.x = 40;
                        _loc12_.y = -10;
                        _loc12_.embedFonts = true;
                        _loc12_.textColor = 4294967295;
                     }
                     _loc21_++;
                  }
               }
               this.toolSprite.graphics.endFill();
            }
         }
         else if(Tool.isTrigger && this.itemTriggered && GameState.mouseDown && Boolean(this.scalingPos))
         {
            _loc27_ = BoxUtils.vectorDist(new b2Vec2(this.mouseXWorld,this.mouseYWorld),this.scalingPos);
            if(_loc27_ > Tweak.toolDeadzone / Physics.scale)
            {
               this.toolSprite.graphics.clear();
               this.scalingPos = null;
            }
         }
      }
      
      private function zoomLineStyle() : Number
      {
         return 2 / this.cam.scaleX;
      }
      
      private function localSave() : void
      {
         Settings.saveLocalItems();
      }
      
      private function localLoad() : void
      {
         this.loadLocalItems();
      }
      
      public function localItem(param1:String) : void
      {
         var _loc2_:Object = null;
         var _loc3_:LabEvent = null;
         _loc2_ = JSON.parse(param1);
         _loc3_ = new LabEvent(LabEvent.ON_LOAD_COMPLETE);
         _loc3_.customMessage = _loc2_;
         this.lab_EventHandler(_loc3_);
      }
      
      private function dild() : void
      {
      }
      
      private function spawnBatch(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:b2Body = null;
         _loc3_ = 200;
         _loc4_ = -500;
         _loc5_ = -250;
         _loc6_ = 0;
         while(_loc6_ < _loc3_)
         {
            _loc7_ = GameState.objects.delayedSpawnObject(O.names[_loc3_ * param1 + _loc6_ + param2],_loc4_,_loc5_,0,false,true);
            _loc4_ += 100;
            if(_loc4_ > 1500)
            {
               _loc4_ = -500;
               _loc5_ += 100;
            }
            _loc6_++;
         }
      }
      
      private function spawnCustomObject(param1:int) : void
      {
         var _loc2_:Number = NaN;
         _loc2_ = TimeLord.speed;
         GameState.spawningCustom = true;
         this.customPos = new b2Vec2();
         IO.loadWorld(this.customItems[param1],!GameState.paused,true);
         GameState.spawningCustom = false;
         TimeLord.speed = _loc2_;
      }
      
      private function toggleConsole() : void
      {
         GameState.ui.console.toggleConsole();
      }
      
      private function requestAD() : void
      {
      }
      
      private function openOpenWorld() : *
      {
         this.changeEnvironment("openworld");
      }
      
      private function spawnPirate() : *
      {
         GameState.objects.spawnObject("pirateset",this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale);
      }
      
      private function stampQuality(param1:int = 1) : *
      {
         World.stampQuality = param1;
      }
      
      private function detailLocked(param1:int = 1) : *
      {
         World.detailLocked = param1;
      }
      
      private function decode(param1:String) : *
      {
         var _loc2_:String = null;
         _loc2_ = Base64.uncompress(param1);
         GameState.ui.console.setConsoleText(_loc2_);
      }
      
      private function encode(param1:String) : *
      {
         var _loc2_:String = null;
         _loc2_ = Base64.compress(param1);
         GameState.ui.console.setConsoleText(_loc2_);
      }
      
      private function prioritizeSelect(param1:int = 1) : *
      {
         GameState.prioritizeSelection = param1 == 1;
      }
      
      private function simpleIgnores(param1:int = 1) : *
      {
         GameState.simpleIgnores = param1 == 1;
      }
      
      private function modelImport() : *
      {
         IO.lab.loadMultiple();
         GameState.ui.menuLibrary.close();
      }
      
      private function modelManage() : *
      {
         GameState.ui.openLocalItems();
      }
      
      private function debugInfo() : *
      {
         var things:String = null;
         var ud:userData = null;
         if(!this.detailBody)
         {
            GameState.ui.console.setConsoleText("Select something with the Detail Tool and try again.");
            return;
         }
         things = "Debug Info for ";
         ud = userData(this.detailBody.GetUserData());
         things += ud.name;
         if(ud.getProperties().length > 0)
         {
            things += ": properties=\"" + ud.getProperties().join(",");
         }
         if(ud.trigger)
         {
            try
            {
               things += "\" trigger=\"" + getQualifiedClassName(ud.originalTrigger);
               things += "\" triggered=\"" + ud.triggered;
               if(ud.triggerForce)
               {
                  things += "\" triggerForce=\"" + ud.triggerForce;
               }
               if(ud.originalTriggerDuration)
               {
                  things += "\" triggerDuration=\"" + ud.originalTriggerDuration;
               }
               if(ud.triggerRadius)
               {
                  things += "\" triggerRadius=\"" + ud.triggerRadius;
               }
               if(ud.triggerPos)
               {
                  things += "\" triggerPos=\"" + ud.triggerPos;
               }
               if(ud.triggerColour)
               {
                  things += "\" triggerColour=\"" + ud.triggerColour;
               }
               if(ud.triggerSound)
               {
                  things += "\" triggerSound=\"" + ud.triggerSound;
               }
               if(ud.triggerCustom)
               {
                  things += "\" triggerCustom=\"" + ud.triggerCustom;
               }
               if(ud.triggerState)
               {
                  things += "\" triggerState=\"" + ud.triggerState;
               }
            }
            catch(e:*)
            {
               things += "\" trigger=\"error, make a bug report\"";
            }
         }
         if(ud.skin.length > 0)
         {
            things += "\" skin=\"" + ud.skin;
         }
         things += "\" scale=\"" + String(ud.size * 100 >> 0);
         things += "\" weight=\"" + String(this.detailBody.GetShapeList().GetDensity() * 100 >> 0);
         things += "\" friction=\"" + String(this.detailBody.GetShapeList().GetFriction() * 100 >> 0);
         things += "\" bounce=\"" + String(this.detailBody.GetShapeList().GetRestitution() * 100 >> 0);
         things += "\" dampSpin=\"" + String(this.detailBody.m_angularDamping >> 0);
         things += "\" dampSpeed=\"" + String(this.detailBody.m_linearDamping >> 0);
         things += "\"";
         GameState.ui.console.setConsoleText(things);
      }
      
      private function changeSelectColour(param1:String) : *
      {
         this.selectGlowFilter.color = uint("0x" + param1);
      }
      
      private function compress(param1:String) : *
      {
         GameState.ui.console.setConsoleText(Base64.compress(param1));
      }
      
      private function playertype() : *
      {
         GameState.ui.console.setConsoleText(Capabilities.playerType + " " + Capabilities.localFileReadDisable);
      }
      
      private function howmanyitems() : *
      {
         GameState.ui.console.setConsoleText(R.library_names.length + " in library" + " & " + String(O.names.length) + " total including projectiles/legacy/etc");
      }
      
      private function createbmd(param1:int, param2:int) : *
      {
         var _loc3_:BitmapData = new BitmapData(param1,param2);
      }
      
      private function bptest(param1:String) : *
      {
         GameState.ui.console.setConsoleText(this.m_sprite.width + " " + this.m_sprite.height + " / " + this.cam.width + " " + this.cam.height);
         if(param1 == "child")
         {
            this.cam.addChild(this.m_sprite);
         }
         if(param1 == "colour")
         {
            Sprite(this.m_sprite.getChildByName("itemholder")).getChildByName("items").transform.colorTransform = new ColorTransform();
            Sprite(this.m_sprite.getChildByName("itemholder")).getChildByName("itemsFG").transform.colorTransform = new ColorTransform();
            Sprite(this.m_sprite.getChildByName("itemholder")).getChildByName("itemsBG").transform.colorTransform = new ColorTransform();
         }
         if(param1 == "clear")
         {
            this.m_sprite.getChildByName("itemholder").filters = [];
         }
         if(param1 == "blur")
         {
            this.m_sprite.getChildByName("itemholder").filters = [new BlurFilter()];
         }
         if(param1 == "glow")
         {
            this.m_sprite.getChildByName("itemholder").filters = [new GlowFilter()];
         }
         if(param1 == "toggle")
         {
            TimeLord.toggle();
            TimeLord.toggle();
         }
      }
      
      internal function QuickSpawn() : void
      {
         var _loc1_:AutoComplete = null;
         _loc1_ = GameState.ui.menuSpawn.getChildByName("autoComplete") as AutoComplete;
         if(GameState.quickspawning && GameState.ui.menuSpawn.visible)
         {
            if(stage.focus == _loc1_)
            {
               return;
            }
            if(GameState.objects.spawnName)
            {
               GameState.objects.spawnObject(GameState.objects.spawnName,this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale,0,this.flipped,true,GameState.objects.spawnSkin);
               GameState.ui.menuSpawn.close();
               return;
            }
         }
         GameState.quickspawning = true;
         GameState.ui.menuSpawn.open();
         this.spawnMenuSize = GameState.ui.menuSpawn.actualWidth;
         GameState.ui.initSpawnMenu(100);
         this.updateSpawnPic();
         GameState.ui.menuSpawn.x = this.mouseXWorld * Physics.scale - 0.5 * GameState.ui.menuSpawn.actualWidth;
         GameState.ui.menuSpawn.y = this.mouseYWorld * Physics.scale - 0.5 * GameState.ui.menuSpawn.height;
         _loc1_ = GameState.ui.menuSpawn.getChildByName("autoComplete") as AutoComplete;
         _loc1_.keysEnabled = true;
         stage.focus = _loc1_;
      }
      
      public function checkKeys(param1:KeyboardEvent) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc5_:b2Body = null;
         var _loc6_:int = 0;
         var _loc7_:userData = null;
         var _loc8_:String = null;
         var _loc9_:Object = null;
         var _loc10_:String = null;
         var _loc11_:int = 0;
         var _loc12_:b2Body = null;
         var _loc13_:b2Body = null;
         var _loc14_:b2Body = null;
         var _loc15_:String = null;
         var _loc16_:Array = null;
         var _loc17_:int = 0;
         var _loc18_:Number = NaN;
         var _loc19_:int = 0;
         var _loc20_:* = 0;
         var _loc21_:b2Body = null;
         var _loc22_:Array = null;
         var _loc23_:b2Body = null;
         var _loc24_:b2Body = null;
         var _loc25_:userData = null;
         var _loc26_:b2Body = null;
         if(this.scrollhint.visible)
         {
            this.scrollhint.visible = false;
         }
         if(this.scrollhintV.visible)
         {
            this.scrollhintV.visible = false;
         }
         _loc2_ = param1.keyCode;
         if(this.comboRequisite && this.comboRequisite2)
         {
            if(_loc2_ == this.combo4[this.comboProgress4])
            {
               ++this.comboProgress4;
               if(this.comboProgress4 == this.combo4.length)
               {
                  GameState.objects.buffDoll(mouseX,mouseY,0,1);
               }
            }
            else
            {
               this.comboProgress4 = 0;
            }
            if(_loc2_ == this.combo2[this.comboProgress2])
            {
               ++this.comboProgress2;
               if(this.comboProgress2 == this.combo2.length)
               {
                  GameState.ui.showTooltip(GameState.ui.menuMain,"A chant becomes louder and louder.\nbuffdoll. Buffdoll. BUFFdoll. BUFFDOLL. BUFFDOLL! BUFFDOLLBUFFDOLLBUFFDOLLBUFFDOLL!\n\n\n",10,6000,200);
               }
            }
            else
            {
               this.comboProgress2 = 0;
            }
            if(this.comboProgress4 > 4)
            {
               return;
            }
         }
         if(Boolean(GameState.environment) && GameState.environment is PumpkinDefence)
         {
            if(_loc2_ == Keymap.nameToCode("Reset") || _loc2_ == Keymap.nameToCode("Reset2"))
            {
               PumpkinDefence(GameState.environment).reset();
            }
            else if(_loc2_ == 74 || _loc2_ == 81 || _loc2_ == 65)
            {
               userData(PumpkinDefence(GameState.environment).gun.GetUserData()).triggered = true;
            }
            else if(_loc2_ == 75 || _loc2_ == 69 || _loc2_ == 68)
            {
               userData(PumpkinDefence(GameState.environment).gun2.GetUserData()).triggered = true;
            }
            return;
         }
         if(Boolean(GameState.environment) && GameState.environment is PumpkinOffence)
         {
            if(_loc2_ == Keymap.nameToCode("Reset") || _loc2_ == Keymap.nameToCode("Reset2"))
            {
               PumpkinOffence(GameState.environment).reset();
            }
         }
         if(Boolean(GameState.environment) && GameState.environment is PumpkinMoon)
         {
            if(_loc2_ == Keymap.nameToCode("Reset") || _loc2_ == Keymap.nameToCode("Reset2"))
            {
               PumpkinMoon(GameState.environment).reset();
            }
            return;
         }
         if(Boolean(GameState.environment) && GameState.environment is WinterHitList)
         {
            if(_loc2_ == Keymap.nameToCode("Reset") || _loc2_ == Keymap.nameToCode("Reset2"))
            {
               WinterHitList(GameState.environment).reset();
               return;
            }
         }
         _loc3_ = Tool.current;
         if(World.toggleFullscreen != 0)
         {
            if(_loc2_ == 27)
            {
               param1.preventDefault();
            }
         }
         if(_loc2_ == Keyboard.ENTER || _loc2_ == Keyboard.NUMPAD_ENTER)
         {
            if(param1.altKey)
            {
               _loc6_ = 0;
               if(World.toggleFullscreen == 0)
               {
                  _loc6_ = 1;
               }
               this.SetFullscreen(_loc6_);
               return;
            }
         }
         if(GameState.mapping)
         {
            this.finishKeymapping(_loc2_);
            return;
         }
         if(_loc2_ == Keymap.nameToCode("Reset") || _loc2_ == Keymap.nameToCode("Reset2"))
         {
            if(GameState.mappingItem > 0)
            {
               if(this.detailBody)
               {
                  userData(this.detailBody.GetUserData()).triggerKey = -1;
               }
               GameState.mappingItem = 0;
            }
            if(this.shiftPressed)
            {
               this.cleanShrapnel();
            }
            else
            {
               this.PlayerReset();
            }
         }
         if(IO.incrementalLoading)
         {
            return;
         }
         if(Boolean(stage.focus) && stage.focus is TextField)
         {
            return;
         }
         if(GameState.mappingItem > 0 && Boolean(this.detailBody))
         {
            if(GameState.mappingItem == 1)
            {
               userData(this.detailBody.GetUserData()).triggerKey = _loc2_;
            }
            if(GameState.mappingItem == 2)
            {
               userData(this.detailBody.GetUserData()).triggerKeyHold = _loc2_;
            }
            this.showDetails(this.detailBody,this.detailSubmenu);
            GameState.mappingItem = 0;
         }
         _loc4_ = false;
         _loc5_ = Physics.world.GetBodyList();
         while(_loc5_)
         {
            _loc7_ = _loc5_.GetUserData();
            if(_loc7_.triggerKey == _loc2_)
            {
               _loc7_.triggered = !_loc7_.triggered;
               _loc4_ = true;
            }
            if(_loc7_.triggerKeyHold == _loc2_)
            {
               _loc7_.keydown = true;
               _loc4_ = true;
            }
            _loc5_ = _loc5_.GetNext();
         }
         if(_loc4_)
         {
            return;
         }
         if(param1.ctrlKey && !param1.shiftKey && _loc2_ == Keymap.nameToCode("Load"))
         {
            _loc8_ = String(Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT));
            if(_loc8_.substr(0,3) == "MAD" || _loc8_.substr(0,2) == "eN")
            {
               IO.loadWorld(_loc8_,false,true);
               return;
            }
            if(_loc8_.substr(0,4) == "http")
            {
               IO.loadExternalModelFromUrl(_loc8_);
            }
            return;
         }
         if(param1.ctrlKey && param1.shiftKey && _loc2_ == Keymap.nameToCode("Load"))
         {
            _loc8_ = String(Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT));
            _loc9_ = JSON.parse(_loc8_);
            _loc10_ = _loc9_.ItemName;
            if(!_loc10_)
            {
               _loc10_ = _loc9_.Title;
            }
            _loc11_ = this.localNames.indexOf(_loc10_);
            if(_loc11_ != -1)
            {
               O.delItem(_loc10_);
               this.localItems[_loc11_] = _loc8_;
            }
            else
            {
               this.localItems.push(_loc8_);
               this.localNames.push(_loc10_);
            }
            this.loadLocalItems(false);
            this.updateLibrary();
            GameState.objects.spawnObject(_loc10_,mouseX,mouseY);
            return;
         }
         if(_loc2_ == Keymap.nameToCode("Console"))
         {
            if(!stage.focus || !(stage.focus && stage.focus is TextField))
            {
               GameState.ui.console.toggleConsole();
            }
         }
         if(_loc2_ == Keymap.nameToCode("CameraLeft"))
         {
            if(param1.shiftKey)
            {
               if(!(GameState.stamping && GameState.spawning))
               {
                  Body.Move(this.selectedBodies,-1,0);
               }
            }
            else
            {
               this.panLeft = true;
            }
         }
         if(_loc2_ == Keymap.nameToCode("CameraRight"))
         {
            if(param1.shiftKey)
            {
               if(!(GameState.stamping && GameState.spawning))
               {
                  Body.Move(this.selectedBodies,1,0);
               }
            }
            else
            {
               this.panRight = true;
            }
         }
         if(_loc2_ == Keymap.nameToCode("CameraUp"))
         {
            if(param1.shiftKey)
            {
               if(!(GameState.stamping && GameState.spawning))
               {
                  Body.Move(this.selectedBodies,0,-1);
               }
            }
            else
            {
               this.panUp = true;
            }
         }
         if(_loc2_ == Keymap.nameToCode("CameraDown"))
         {
            if(param1.shiftKey)
            {
               if(!(GameState.stamping && GameState.spawning))
               {
                  Body.Move(this.selectedBodies,0,1);
               }
            }
            else
            {
               this.panDown = true;
            }
         }
         if(_loc2_ == Keymap.nameToCode("CameraFollow"))
         {
            _loc12_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld);
            GameState.followBody = _loc12_;
         }
         if(_loc2_ == Keymap.nameToCode("CameraHome"))
         {
            this.CameraHome();
         }
         if(_loc2_ == Keymap.nameToCode("CameraIn"))
         {
            if(this.m_sprite.scaleX == 1)
            {
               this.zoomingCamera = true;
            }
            this.zoom(1 / (1 - Tweak.ZoomStep));
            this.zoomingCamera = false;
         }
         if(_loc2_ == Keymap.nameToCode("CameraOut"))
         {
            if(this.m_sprite.scaleX == 1)
            {
               this.zoomingCamera = true;
            }
            this.zoom(1 / (1 / (1 - Tweak.ZoomStep)));
            this.zoomingCamera = false;
         }
         if(_loc2_ == Keymap.nameToCode("SaveMenu"))
         {
            GameState.ui.menuSave.toggle();
         }
         else if(_loc2_ == Keymap.nameToCode("WorldMenu"))
         {
            GameState.ui.menuSettings.toggle();
         }
         else if(_loc2_ == Keymap.nameToCode("ObjectMenu"))
         {
            GameState.ui.menuObject.toggle();
         }
         else if(_loc2_ == Keymap.nameToCode("MultipleSelect"))
         {
            this.shiftPressed = true;
            if(!GameState.stamping && GameState.spawning && !this.spawnFlipped)
            {
               this.spawnFlipped = true;
               this.flipped = !this.flipped;
               GameState.objects.spawnSprite.scaleX *= -1;
               this.updateFlipIcon();
            }
            else
            {
               if(Tool.isLaunch && Boolean(this.scalingPos))
               {
                  return;
               }
               Tool.select();
            }
         }
         else if(_loc2_ == Keymap.nameToCode("Pause"))
         {
            if(World.togglePauseConfirm == 1)
            {
               return;
            }
            if(!this.pauseReleasedBandaid)
            {
               if(GameState.paused)
               {
                  TimeLord.unpause();
               }
               else
               {
                  TimeLord.pause();
               }
               GameState.ui.updateControls();
               if(stage.frameRate != 60)
               {
                  stage.frameRate = 60;
               }
               this.pauseReleasedBandaid = true;
            }
         }
         if(_loc2_ == Keymap.nameToCode("Clean"))
         {
            this.cleanShrapnel();
         }
         else if(_loc2_ == Keymap.nameToCode("Update"))
         {
            this.UpdateFrame();
         }
         else if(_loc2_ == Keymap.nameToCode("ResetRagdoll"))
         {
            this.cleanAlive();
         }
         else if(_loc2_ == Keymap.nameToCode("Favourite1"))
         {
            this.favOrSpawn(1);
         }
         else if(_loc2_ == Keymap.nameToCode("Favourite2"))
         {
            this.favOrSpawn(2);
         }
         else if(_loc2_ == Keymap.nameToCode("Favourite3"))
         {
            this.favOrSpawn(3);
         }
         else if(_loc2_ == Keymap.nameToCode("Favourite4"))
         {
            this.favOrSpawn(4);
         }
         else if(_loc2_ == Keymap.nameToCode("Favourite5"))
         {
            this.favOrSpawn(5);
         }
         else if(_loc2_ == Keymap.nameToCode("Favourite6"))
         {
            this.favOrSpawn(6);
         }
         else if(_loc2_ == Keymap.nameToCode("Favourite7"))
         {
            this.favOrSpawn(7);
         }
         else if(_loc2_ == Keymap.nameToCode("Favourite8"))
         {
            this.favOrSpawn(8);
         }
         else if(_loc2_ == Keymap.nameToCode("Favourite9"))
         {
            this.favOrSpawn(9);
         }
         else if(_loc2_ == Keymap.nameToCode("Favourite10"))
         {
            this.favOrSpawn(10);
         }
         else if(_loc2_ == Keymap.nameToCode("Favourite11"))
         {
            this.favOrSpawn(11);
         }
         else if(_loc2_ == Keymap.nameToCode("Favourite12"))
         {
            this.favOrSpawn(12);
         }
         else if(_loc2_ == Keymap.nameToCode("Favourite13"))
         {
            this.favOrSpawn(13);
         }
         else if(_loc2_ == Keymap.nameToCode("Favourite14"))
         {
            this.favOrSpawn(14);
         }
         else if(_loc2_ == Keymap.nameToCode("Favourite15"))
         {
            this.favOrSpawn(15);
         }
         else if(_loc2_ == Keymap.nameToCode("Favourite16"))
         {
            this.favOrSpawn(16);
         }
         else if(_loc2_ == Keymap.nameToCode("Favourite17"))
         {
            this.favOrSpawn(17);
         }
         else if(_loc2_ == Keymap.nameToCode("Favourite18"))
         {
            this.favOrSpawn(18);
         }
         else if(_loc2_ == Keymap.nameToCode("Favourite19"))
         {
            this.favOrSpawn(19);
         }
         else if(_loc2_ == Keymap.nameToCode("Favourite20"))
         {
            this.favOrSpawn(20);
         }
         if(_loc2_ == Keymap.nameToCode("Cut"))
         {
            Tool.cut();
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Action"))
         {
            if(Tool.isDrag && Boolean(this.m_mouseJoint))
            {
               this.triggerDragged();
            }
            else
            {
               Tool.trigger();
               this.toolSprite.graphics.clear();
            }
         }
         else if(_loc2_ == Keymap.nameToCode("Select"))
         {
            Tool.select();
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Scalerotate"))
         {
            Tool.scale();
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Rotate"))
         {
            Tool.rotate();
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Drag"))
         {
            if(Tool.isDrag)
            {
               if(this.m_mouseJoint)
               {
                  _loc13_ = this.m_mouseJoint.GetBody2();
                  this.stopDragging(false);
                  this.startDragging(_loc13_,!this.draggingAiming);
               }
            }
            else
            {
               GameState.roleplaying = false;
               Tool.drag();
               this.toolSprite.graphics.clear();
               GameState.ui.updateControls();
            }
         }
         else if(_loc2_ == Keymap.nameToCode("Flip"))
         {
            if(GameState.spawning && !this.spawnFlipped)
            {
               this.spawnFlipped = true;
               this.flipped = !this.flipped;
               GameState.objects.spawnSprite.scaleX *= -1;
               this.updateFlipIcon();
            }
            else
            {
               _loc12_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,true,true);
               if(_loc12_)
               {
                  Body.Flip(_loc12_);
               }
            }
         }
         else if(_loc2_ == Keymap.nameToCode("Freeze"))
         {
            _loc12_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,true,true);
            if(_loc12_)
            {
               Body.ToggleStatic(_loc12_,_loc12_.GetMass() != 0);
            }
         }
         else if(_loc2_ == Keymap.nameToCode("Slomo"))
         {
            if(GameState.paused)
            {
               TimeLord.unpause();
               GameState.slomo = false;
            }
            if(!GameState.slomo)
            {
               if(this.shiftPressed)
               {
                  TimeLord.speed = 0.5 / Vars.slowspeed;
               }
               else
               {
                  TimeLord.speed = Vars.slowspeed;
               }
               GameState.slomo = true;
            }
            else if(TimeLord.speed == Vars.slowspeed && this.shiftPressed)
            {
               TimeLord.speed = 0.5 / Vars.slowspeed;
            }
            else if(TimeLord.speed != Vars.slowspeed && !this.shiftPressed)
            {
               TimeLord.speed = Vars.slowspeed;
            }
            else
            {
               TimeLord.speed = Vars.speed;
               GameState.slomo = false;
            }
            GameState.ui.updateControls();
         }
         else if(_loc2_ == Keymap.nameToCode("Roleplay"))
         {
            GameState.roleplaying = !GameState.roleplaying;
            Tool.drag();
            GameState.ui.updateControls();
            this.toolSprite.graphics.clear();
            if(GameState.dragging)
            {
               _loc14_ = GameState.dragging;
               this.stopDragging(false);
               this.startDragging(_loc14_);
            }
         }
         else if(_loc2_ == Keymap.nameToCode("Ignore"))
         {
            Tool.setTool(Tool.IGNORE);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Flame"))
         {
            Tool.setTool(Tool.FLAME);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Frost"))
         {
            Tool.setTool(Tool.FREEZE);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Wind"))
         {
            Tool.setTool(Tool.WIND);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Water"))
         {
            Tool.setTool(Tool.WATER);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Shock"))
         {
            Tool.setTool(Tool.SHOCK);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Poison"))
         {
            Tool.setTool(Tool.POISON);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Heal"))
         {
            Tool.setTool(Tool.HEAL);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Drain"))
         {
            Tool.setTool(Tool.DRAIN);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Void"))
         {
            Tool.setTool(Tool.VOID);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Web"))
         {
            Tool.setTool(Tool.WEB);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Rend"))
         {
            Tool.setTool(Tool.SLICE);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Dice"))
         {
            Tool.setTool(Tool.DICE);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Blast"))
         {
            Tool.setTool(Tool.EXPLODE);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Snare"))
         {
            Tool.setTool(Tool.SNARE);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Death"))
         {
            Tool.setTool(Tool.DEATH);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Dispel"))
         {
            Tool.setTool(Tool.DISPEL);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Blunt"))
         {
            Tool.setTool(Tool.BLUNT);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Concuss"))
         {
            Tool.setTool(Tool.SLEEP);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Arc"))
         {
            Tool.setTool(Tool.ARC);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Bee"))
         {
            Tool.setTool(Tool.BEE);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Bubble"))
         {
            Tool.setTool(Tool.BUBBLE);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Bullet"))
         {
            Tool.setTool(Tool.BULLET);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Gasoline"))
         {
            Tool.setTool(Tool.GASOLINE);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Glue"))
         {
            Tool.setTool(Tool.GLUE);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Gravity"))
         {
            Tool.setTool(Tool.GRAVITY);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Laser"))
         {
            Tool.setTool(Tool.LASER);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Levity"))
         {
            Tool.setTool(Tool.LEVITY);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Paint"))
         {
            Tool.setTool(Tool.PAINT);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Powder"))
         {
            Tool.setTool(Tool.POWDER);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Random"))
         {
            Tool.setTool(Tool.RANDOM);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Ricochet"))
         {
            Tool.setTool(Tool.RICOCHET);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Sharp"))
         {
            Tool.setTool(Tool.SHARP);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Stasis"))
         {
            Tool.setTool(Tool.STASIS);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Toxic"))
         {
            Tool.setTool(Tool.TOXIC);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Transmute"))
         {
            Tool.setTool(Tool.TRANSMUTE);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Critical"))
         {
            Tool.setTool(Tool.CRIT);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Acid"))
         {
            Tool.setTool(Tool.ACID);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Smoke"))
         {
            Tool.setTool(Tool.SMOKE);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Hole"))
         {
            Tool.setTool(Tool.HOLE);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Disc"))
         {
            Tool.setTool(Tool.DISC);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Hail"))
         {
            Tool.setTool(Tool.HAIL);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Icicle"))
         {
            Tool.setTool(Tool.ICICLE);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Crush"))
         {
            Tool.setTool(Tool.CRUSH);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Teleport"))
         {
            Tool.setTool(Tool.TELEPORT);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Petrify"))
         {
            Tool.setTool(Tool.PETRIFY);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Radiation"))
         {
            Tool.setTool(Tool.RADIATION);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Landslide"))
         {
            Tool.setTool(Tool.EARTHQUAKE);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Blight"))
         {
            Tool.setTool(Tool.BANE);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Adrenaline"))
         {
            Tool.setTool(Tool.ADRENALINE);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Droner"))
         {
            Tool.setTool(Tool.DRONE);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Tidal"))
         {
            Tool.setTool(Tool.TIDAL);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Napalm"))
         {
            Tool.setTool(Tool.HANDSHAKE);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Bling"))
         {
            Tool.setTool(Tool.BLING);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Shockwave"))
         {
            Tool.setTool(Tool.SHOCKWAVE);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Steam"))
         {
            Tool.setTool(Tool.STEAM);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Noise"))
         {
            Tool.setTool(Tool.HORN);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Pierce"))
         {
            Tool.setTool(Tool.PIERCE);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Animate"))
         {
            Tool.setTool(Tool.ANIMATE);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Banish"))
         {
            Tool.setTool(Tool.BANISH);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Bleed"))
         {
            Tool.setTool(Tool.BLEED);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Cookie"))
         {
            Tool.setTool(Tool.COOKIE);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Crash"))
         {
            Tool.setTool(Tool.CRASH);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("ERROR"))
         {
            Tool.setTool(Tool.ERROR);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Faceplant"))
         {
            Tool.setTool(Tool.FACEPLANT);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Forcefield"))
         {
            Tool.setTool(Tool.FORCEFIELD);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Frostfire"))
         {
            Tool.setTool(Tool.FROSTFIRE);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Deepfry"))
         {
            Tool.setTool(Tool.FRY);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Ghost"))
         {
            Tool.setTool(Tool.GHOST);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Gib"))
         {
            Tool.setTool(Tool.GIB);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Glass"))
         {
            Tool.setTool(Tool.GLASS);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Glitch"))
         {
            Tool.setTool(Tool.GLITCH);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Implode"))
         {
            Tool.setTool(Tool.IMPLODE);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Explode"))
         {
            Tool.setTool(Tool.EXPLODE);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Lava"))
         {
            Tool.setTool(Tool.LAVA);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Mutate"))
         {
            Tool.setTool(Tool.MUTATE);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Protect"))
         {
            Tool.setTool(Tool.PROTECT);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Sandstone"))
         {
            Tool.setTool(Tool.SANDSTONE);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Tornado"))
         {
            Tool.setTool(Tool.TORNADO);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Upgrade"))
         {
            Tool.setTool(Tool.UPGRADE);
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Save"))
         {
            if(this.contract.enabled)
            {
               return;
            }
            if(Tweak.download)
            {
               Kongregate.shareAsUnlocked = 1;
            }
            if(param1.ctrlKey)
            {
               if(this.selectedBodies.length > 0)
               {
                  this.MassClone();
                  return;
               }
            }
            IO.saveWorld();
            if(GameState.ui.menuSave.visible)
            {
               this.updateSaveMenu("localContent");
               GameState.ui.showTooltip(GameState.ui.menuSave,"Quicksaved!",0,1000,GameState.ui.menuSave.actualWidth);
            }
         }
         else if(_loc2_ == Keymap.nameToCode("Load"))
         {
            if(false && param1.ctrlKey)
            {
               _loc15_ = Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT) as String;
               IO.loadWorld(_loc15_,false,true);
            }
            else if(this.loadedLevel != "")
            {
               IO.loadWorld(this.loadedLevel);
            }
            else
            {
               IO.loadWorld();
            }
         }
         else if(_loc2_ == Keymap.nameToCode("QuickSpawn"))
         {
            this.QuickSpawn();
         }
         else if(_loc2_ == Keymap.nameToCode("Spawn"))
         {
            GameState.objects.spawnObject(GameState.objects.spawnName,this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale,0,this.flipped,true,GameState.objects.spawnSkin);
         }
         else if(_loc2_ == Keymap.nameToCode("SpawnRandom"))
         {
            GameState.objects.spawnObject(O.names[int(O.names.length * Math.random())],this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale,0,this.flipped,true,GameState.objects.spawnSkin);
         }
         else if(_loc2_ == Keymap.nameToCode("Particles"))
         {
            _loc16_ = GameState.particles.names;
            _loc17_ = 0;
            while(_loc17_ < _loc16_.length)
            {
               GameState.particles.addParticles(this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale,1,_loc16_[_loc17_]);
               _loc17_++;
            }
         }
         else if(_loc2_ == Keymap.nameToCode("BGJoint"))
         {
            _loc12_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,false,true);
            if(Tool.isPin && Boolean(_loc12_))
            {
               Joints.Pin("bgjoint",_loc12_,new b2Vec2(this.mouseXWorld,this.mouseYWorld),Tweak.jointForce);
               Tool.reset();
            }
            else
            {
               Tool.pin();
               this.toolSprite.graphics.clear();
            }
         }
         else if(_loc2_ == Keymap.nameToCode("RopeJoint"))
         {
            if(!this.jointPos)
            {
               _loc12_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,true,true);
               if(Tool.isRope && Boolean(_loc12_))
               {
                  this.jointPos = new b2Vec2(this.mouseXWorld - _loc12_.GetPosition().x,this.mouseYWorld - _loc12_.GetPosition().y);
                  this.jointBody = _loc12_;
               }
               else
               {
                  if(Tool.isDrag && GameState.mouseDown && Boolean(_loc12_))
                  {
                     this.stopDragging();
                     this.jointPos = new b2Vec2(this.mouseXWorld - _loc12_.GetPosition().x,this.mouseYWorld - _loc12_.GetPosition().y);
                     this.jointBody = _loc12_;
                  }
                  Tool.rope();
                  this.toolSprite.graphics.clear();
               }
            }
         }
         else if(_loc2_ == Keymap.nameToCode("PowerPrev"))
         {
            Powers.powerPrevPressed(null);
         }
         else if(_loc2_ == Keymap.nameToCode("PowerNext"))
         {
            Powers.powerNextPressed(null);
         }
         else if(_loc2_ == Keymap.nameToCode("RevoluteJoint"))
         {
            Tool.doll();
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("WeldJoint"))
         {
            if(!this.jointPos)
            {
               _loc12_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,true,true);
               if(Tool.isWeld && Boolean(_loc12_))
               {
                  this.jointPos = new b2Vec2(0,0);
                  this.jointBody = _loc12_;
               }
               else
               {
                  if(Tool.isDrag && GameState.mouseDown && Boolean(_loc12_))
                  {
                     this.stopDragging();
                     this.jointPos = new b2Vec2(0,0);
                     this.jointBody = _loc12_;
                  }
                  Tool.weld();
                  this.toolSprite.graphics.clear();
               }
            }
         }
         else if(_loc2_ == Keymap.nameToCode("ObjJoint"))
         {
            if(!this.jointPos)
            {
               _loc12_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,true,true);
               if(Tool.isJoint && Boolean(_loc12_))
               {
                  this.jointPos = new b2Vec2(this.mouseXWorld - _loc12_.GetPosition().x,this.mouseYWorld - _loc12_.GetPosition().y);
                  this.jointBody = _loc12_;
               }
               else
               {
                  if(Tool.isDrag && GameState.mouseDown && Boolean(_loc12_))
                  {
                     this.stopDragging();
                     this.jointPos = new b2Vec2(this.mouseXWorld - _loc12_.GetPosition().x,this.mouseYWorld - _loc12_.GetPosition().y);
                     this.jointBody = _loc12_;
                  }
                  Tool.joint();
                  this.toolSprite.graphics.clear();
               }
            }
         }
         else if(_loc2_ == Keymap.nameToCode("PistonJoint"))
         {
            if(!this.jointPos)
            {
               _loc12_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,true,true);
               if(Tool.isPiston && Boolean(_loc12_))
               {
                  this.jointPos = new b2Vec2(this.mouseXWorld - _loc12_.GetPosition().x,this.mouseYWorld - _loc12_.GetPosition().y);
                  this.jointBody = _loc12_;
               }
               else
               {
                  if(Tool.isDrag && GameState.mouseDown && Boolean(_loc12_))
                  {
                     this.stopDragging();
                     this.jointPos = new b2Vec2(this.mouseXWorld - _loc12_.GetPosition().x,this.mouseYWorld - _loc12_.GetPosition().y);
                     this.jointBody = _loc12_;
                  }
                  Tool.piston();
                  this.toolSprite.graphics.clear();
               }
            }
         }
         else if(_loc2_ == Keymap.nameToCode("LinkJoint"))
         {
            if(!this.jointPos)
            {
               _loc12_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,true,true);
               if(Tool.isLink && Boolean(_loc12_))
               {
                  this.jointPos = new b2Vec2(this.mouseXWorld - _loc12_.GetPosition().x,this.mouseYWorld - _loc12_.GetPosition().y);
                  this.jointBody = _loc12_;
               }
               else
               {
                  if(Tool.isDrag && GameState.mouseDown && Boolean(_loc12_))
                  {
                     this.stopDragging();
                     this.jointPos = new b2Vec2(this.mouseXWorld - _loc12_.GetPosition().x,this.mouseYWorld - _loc12_.GetPosition().y);
                     this.jointBody = _loc12_;
                  }
                  Tool.link();
                  this.toolSprite.graphics.clear();
               }
            }
         }
         else if(_loc2_ == Keymap.nameToCode("Details"))
         {
            Tool.detail();
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Launch"))
         {
            Tool.launch();
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Swing"))
         {
            Tool.swing();
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Stab"))
         {
            Tool.stab();
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Aim"))
         {
            Tool.aim();
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("ResizeU"))
         {
            if(GameState.environment is OpenWorld)
            {
               this.panUp = true;
               return;
            }
            if(param1.shiftKey && GameState.stamping && GameState.spawning)
            {
               GameState.objects.spawnSprite.scaleY *= 1 / (1 - Tweak.ScaleStep);
               return;
            }
            if(GameState.spawning && !GameState.objects.spawnCustom)
            {
               GameState.objects.spawnScale *= 1 / (1 - Tweak.ScaleStep);
               if(GameState.objects.spawnScale > Tweak.ScaleMax)
               {
                  GameState.objects.spawnScale = Tweak.ScaleMax;
               }
               if(GameState.objects.spawnScale < Tweak.ScaleMin)
               {
                  GameState.objects.spawnScale = Tweak.ScaleMin;
               }
               _loc18_ = Vars.objSize * GameState.objects.spawnScale;
               if(_loc18_ > Tweak.ScaleMax)
               {
                  _loc18_ = Tweak.ScaleMax;
               }
               if(_loc18_ < Tweak.ScaleMin)
               {
                  _loc18_ = Tweak.ScaleMin;
               }
               GameState.objects.spawnSprite.scaleX = _loc18_ * this.cam.scaleX;
               GameState.objects.spawnSprite.scaleY = _loc18_ * this.cam.scaleY;
            }
            else if(this.shiftPressed)
            {
               _loc19_ = int(this.selectedBodies.length);
               _loc20_ = int(_loc19_ - 1);
               while(_loc20_ >= 0)
               {
                  Body.Scale(this.selectedBodies[_loc20_],1 / (1 - Tweak.ScaleStep));
                  _loc20_--;
               }
            }
            else
            {
               _loc21_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,true,true);
               if(!_loc21_ && !GameState.stamping)
               {
                  _loc22_ = Body.GetAroundPoint(new b2Vec2(this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale),15 / this.cam.scaleX,15 / this.cam.scaleX,true);
                  if(_loc22_.length > 0)
                  {
                     _loc21_ = _loc22_[0];
                  }
               }
               if(_loc21_)
               {
                  Body.Scale(_loc21_,1 / (1 - Tweak.ScaleStep));
               }
            }
         }
         else if(_loc2_ == Keymap.nameToCode("ResizeD"))
         {
            if(param1.shiftKey && GameState.stamping && GameState.spawning)
            {
               GameState.objects.spawnSprite.scaleY *= 1 - Tweak.ScaleStep;
               return;
            }
            if(GameState.spawning && !GameState.objects.spawnCustom)
            {
               GameState.objects.spawnScale *= 1 - Tweak.ScaleStep;
               if(GameState.objects.spawnScale > Tweak.ScaleMax)
               {
                  GameState.objects.spawnScale = Tweak.ScaleMax;
               }
               if(GameState.objects.spawnScale < Tweak.ScaleMin)
               {
                  GameState.objects.spawnScale = Tweak.ScaleMin;
               }
               _loc18_ = Vars.objSize * GameState.objects.spawnScale;
               if(_loc18_ > Tweak.ScaleMax)
               {
                  _loc18_ = Tweak.ScaleMax;
               }
               if(_loc18_ < Tweak.ScaleMin)
               {
                  _loc18_ = Tweak.ScaleMin;
               }
               GameState.objects.spawnSprite.scaleX = _loc18_ * this.cam.scaleX;
               GameState.objects.spawnSprite.scaleY = _loc18_ * this.cam.scaleY;
            }
            else if(this.shiftPressed)
            {
               _loc19_ = int(this.selectedBodies.length);
               _loc20_ = int(_loc19_ - 1);
               while(_loc20_ >= 0)
               {
                  Body.Scale(this.selectedBodies[_loc20_],1 - Tweak.ScaleStep);
                  _loc20_--;
               }
            }
            else
            {
               _loc21_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,true,true);
               if(!_loc21_ && !GameState.stamping)
               {
                  _loc22_ = Body.GetAroundPoint(new b2Vec2(this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale),15 / this.cam.scaleX,15 / this.cam.scaleX,true);
                  if(_loc22_.length > 0)
                  {
                     _loc21_ = _loc22_[0];
                  }
               }
               if(_loc21_)
               {
                  Body.Scale(_loc21_,1 - Tweak.ScaleStep);
               }
            }
         }
         else if(_loc2_ == Keymap.nameToCode("RotateR"))
         {
            if(GameState.environment is OpenWorld)
            {
               this.panRight = true;
               return;
            }
            if(param1.shiftKey && GameState.stamping && GameState.spawning)
            {
               GameState.objects.spawnSprite.scaleX *= 1 / (1 - Tweak.ScaleStep);
               return;
            }
            this.RotateItems(1);
         }
         else if(_loc2_ == Keymap.nameToCode("RotateL"))
         {
            if(GameState.environment is OpenWorld)
            {
               this.panLeft = true;
               return;
            }
            if(param1.shiftKey && GameState.stamping && GameState.spawning)
            {
               GameState.objects.spawnSprite.scaleX *= 1 - Tweak.ScaleStep;
               return;
            }
            this.RotateItems(-1);
         }
         else if(_loc2_ == Keymap.nameToCode("RotationReset"))
         {
            _loc23_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,true,true);
            if(_loc23_)
            {
               _loc23_.SetXForm(_loc23_.GetPosition(),0);
               _loc23_.SetLinearVelocity(new b2Vec2());
               _loc23_.SetAngularVelocity(0);
            }
         }
         else if(_loc2_ == Keymap.nameToCode("QuickDelete"))
         {
            this.QuickDeleteOnMouse();
         }
         else if(_loc2_ == Keymap.nameToCode("Delete") || _loc2_ == Keymap.nameToCode("Delete2"))
         {
            if(Tool.isDestroy)
            {
               this.QuickDeleteOnMouse();
               return;
            }
            Tool.destroy();
            this.toolSprite.graphics.clear();
         }
         else if(_loc2_ == Keymap.nameToCode("Camera") || _loc2_ == Keymap.nameToCode("CameraToggle"))
         {
            Tool.camera();
            this.toolSprite.graphics.clear();
            if(this.cameraKeySpammedBandaid >= 2)
            {
               this.CameraHome();
            }
         }
         if(_loc3_ != Tool.current)
         {
            if(_loc3_ == Tool.SCALE || _loc3_ == Tool.ROTATE)
            {
               for each(_loc24_ in this.selectedBodies)
               {
                  _loc25_ = userData(_loc24_.GetUserData());
                  if(_loc25_.graphic.getChildByName("debug_scalerot"))
                  {
                     _loc25_.graphic.removeChild(_loc25_.graphic.getChildByName("debug_scalerot"));
                  }
               }
            }
            if(_loc3_ == Tool.SCALE)
            {
               for each(_loc24_ in this.selectedBodies)
               {
                  userData(_loc24_.GetUserData()).graphic.scaleX = 1;
                  userData(_loc24_.GetUserData()).graphic.scaleY = 1;
                  _loc24_.WakeUp();
               }
               if(this.selectedBodies.length == 1)
               {
                  this.selectedBodies = new Vector.<b2Body>();
               }
            }
            if(_loc3_ == Tool.SCALE)
            {
               for each(_loc24_ in this.selectedBodies)
               {
                  _loc24_.WakeUp();
               }
               if(this.selectedBodies.length == 1)
               {
                  this.selectedBodies = new Vector.<b2Body>();
               }
            }
            if(_loc3_ == Tool.AIM)
            {
               if(this.selectedBodies.length > 0)
               {
                  this.stopAiming();
               }
            }
            if(_loc3_ == Tool.CAMERA)
            {
               this.movingCamera = false;
               this.zoomingCamera = false;
            }
            if(_loc3_ == Tool.LAUNCH || _loc3_ == Tool.SWING)
            {
               for each(_loc26_ in this.selectedBodies)
               {
                  _loc26_.WakeUp();
               }
               this.selectedBodies = new Vector.<b2Body>();
            }
            GameState.ui.updateControls();
            this.toolSprite.graphics.clear();
         }
      }
      
      private function RotateItems(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:b2Body = null;
         var _loc4_:b2Vec2 = null;
         var _loc5_:int = 0;
         var _loc6_:b2Vec2 = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:b2Vec2 = null;
         var _loc10_:Number = NaN;
         var _loc11_:Array = null;
         if(GameState.spawning && !GameState.objects.spawnCustom)
         {
            GameState.objects.spawnAngle += Tweak.RotateStep * param1;
            GameState.objects.spawnSprite.rotation = GameState.objects.spawnAngle;
            return;
         }
         _loc2_ = int(this.selectedBodies.length);
         if(_loc2_ > 1 || Tool.isLaunch)
         {
            _loc4_ = new b2Vec2(this.mouseXWorld,this.mouseYWorld);
            if(Tool.isLaunch)
            {
               _loc4_ = this.selectedBodies[0].GetPosition();
            }
            _loc5_ = 0;
            while(_loc5_ < _loc2_)
            {
               _loc6_ = this.selectedBodies[_loc5_].GetPosition();
               if(!this.shiftPressed || Tool.isLaunch)
               {
                  _loc7_ = Math.sqrt(BoxUtils.vectorDist(_loc4_,_loc6_));
                  _loc8_ = Math.atan2(_loc6_.y - _loc4_.y,_loc6_.x - _loc4_.x) * Vars.toDegrees;
                  _loc9_ = GeneralUtils.pointOnCircle(_loc4_.x * Physics.scale,_loc4_.y * Physics.scale,_loc7_ * Physics.scale,_loc8_ + Tweak.RotateStep * param1);
                  _loc9_.Multiply(1 / Physics.scale);
                  _loc10_ = this.selectedBodies[_loc5_].GetAngle() + Tweak.RotateStep * Vars.toRadians * param1;
                  this.selectedBodies[_loc5_].SetXForm(_loc9_,_loc10_);
               }
               else
               {
                  this.selectedBodies[_loc5_].SetXForm(_loc6_,this.selectedBodies[_loc5_].GetAngle() + Tweak.RotateStep * Vars.toRadians * param1);
               }
               _loc5_++;
            }
            return;
         }
         _loc3_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,true,true);
         if(!_loc3_ && !GameState.stamping)
         {
            _loc11_ = Body.GetAroundPoint(new b2Vec2(this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale),15 / this.cam.scaleX,15 / this.cam.scaleX,true);
            if(_loc11_.length > 0)
            {
               _loc3_ = _loc11_[0];
            }
         }
         if(Boolean(this.m_mouseJoint) && Boolean(this.m_mouseJoint.GetBody2()))
         {
            this.m_mouseJoint.GetBody2().SetAngularVelocity(0);
            this.m_mouseJoint.GetBody2().ApplyTorque(this.m_mouseJoint.GetBody2().GetMass() * 200 * param1);
         }
         else if(_loc3_)
         {
            _loc3_.SetXForm(_loc3_.GetPosition(),_loc3_.GetAngle() + Tweak.RotateStep * Vars.toRadians * param1);
         }
         else if(GameState.ui.menuSpawn.visible)
         {
            if(param1 < 0)
            {
               this.selectNextItem();
            }
            else
            {
               this.selectPrevItem();
            }
         }
         else if(GameState.ui.menuTools.visible && Tool.isPower)
         {
            Powers.powerNextPressed(null);
         }
      }
      
      private function finishKeymapping(param1:uint) : void
      {
         var collision:int;
         var bams:Array = null;
         var item:* = undefined;
         var collide:* = undefined;
         var collisionText:* = undefined;
         var keyCode:uint = param1;
         if(keyCode == 27)
         {
            GameState.mapping = false;
            GameState.ui.menuKeyConfig.getField("Mapped").text = Keymap.codeToKeyname(Keymap.nameToCode(this.mappingObject));
            GameState.ui.menuKeyConfig.getField("info").text = "Mapping canceled.";
            return;
         }
         if(keyCode == 46 || keyCode == 8)
         {
            GameState.mapping = false;
            Keymap.setKeyByName(this.mappingObject,0);
            GameState.ui.menuKeyConfig.getField("Mapped").text = "Not Mapped";
            GameState.ui.menuKeyConfig.getField("info").text = "Mapping cleared.";
            Settings.saveMapping();
            return;
         }
         collision = 0;
         bams = [];
         for each(item in Keymap.KeymapObj)
         {
            if(keyCode == item)
            {
               for each(collide in Keymap.findKeys(keyCode).@ID)
               {
                  bams.push(collide);
               }
               break;
            }
            collision++;
         }
         if(bams.length > 0)
         {
            GameState.ui.menuPrompt.title = "Keymap Collision";
            collisionText = "[" + Keymap.codeToKeyname(keyCode) + "] is already mapped to:\n\n";
            for each(item in bams)
            {
               collisionText += Keymap.IDToAlias(int(item));
               collisionText += "\n";
            }
            collisionText += "\nMapping multiple functionalities to the same key may cause weird things to happen, or only one of them to work in the first place.";
            GameState.ui.menuPrompt.getField("info").text = collisionText;
            R.xml_keymapCollision.node.(@func == "mappingComplete").@key = keyCode;
            GameState.ui.menuPrompt.unlock();
            GameState.ui.menuPrompt.getField("info").type = TextFieldType.DYNAMIC;
            GameState.ui.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_keymapCollision);
            GameState.ui.menuPrompt.visible = true;
            GameState.ui.menuPrompt.unlock();
            GameState.ui.menuPrompt.moveToTop();
            GameState.ui.menuPrompt.center();
            GameState.ui.menuPrompt.lock();
            return;
         }
         this.mapKey(keyCode);
      }
      
      private function mapKey(param1:uint) : void
      {
         Keymap.setKeyByName(this.mappingObject,param1);
         GameState.ui.menuKeyConfig.getField("Mapped").text = Keymap.codeToKeyname(param1);
         GameState.ui.menuKeyConfig.getField("info").text = "Key successfully mapped.";
         if(this.keyhelp.visible)
         {
            this.updateKeys();
         }
         Settings.saveMapping();
         GameState.mapping = false;
      }
      
      private function triggerDragged() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:userData = null;
         if(!this.contract.allowTriggering(new b2Vec2(this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale)))
         {
            return;
         }
         if(!this.m_mouseJoint)
         {
            return;
         }
         _loc1_ = this.m_mouseJoint.GetBody2();
         _loc2_ = userData(_loc1_.GetUserData());
         if(_loc2_.trigger == null)
         {
            this.stopDragging(false);
            this.startDragging(_loc1_,!this.draggingAiming);
         }
         if(_loc2_.trigger is Gun)
         {
            _loc2_.triggered = true;
            if(!this.itemTriggered)
            {
               Gun(_loc2_.trigger).firearm.forceReload();
               this.itemTriggered = true;
            }
         }
         else if(!this.itemTriggered)
         {
            _loc2_.triggered = !_loc2_.triggered;
            this.itemTriggered = true;
         }
      }
      
      public function toggleScreenShotMode() : void
      {
         GameState.ui.menuLibrary.alpha = 1;
         this.toggleAllMenus();
         GameState.ui.console.hideConsole();
         this.fps.visible = false;
         GameState.screenshotMode = !GameState.screenshotMode;
         if(GameState.paused)
         {
            TimeLord.unpause();
            TimeLord.pause();
         }
         else
         {
            TimeLord.pause();
            TimeLord.unpause();
         }
         if(GameState.screenshotMode)
         {
            this.bloodBMD.fillRect(this.bloodBMD.rect,0);
            this.particlesBMD.fillRect(this.particlesBMD.rect,0);
            this.drawParticles();
            TimeLord.speed = 0.1;
            TimeLord.pauseGrid.visible = false;
         }
         else
         {
            TimeLord.speed = Vars.speed;
            TimeLord.pauseGrid.visible = true;
            if(!GameState.paused)
            {
               TimeLord.pause();
            }
         }
         if(TimeLord.speed > 0 && GameState.paused)
         {
            TimeLord.unpause();
         }
         if(TimeLord.speed == 0 && !GameState.paused)
         {
            TimeLord.pause();
         }
      }
      
      private function viewCapability() : void
      {
         GameState.ui.console.setConsoleText(GameState.playerVersion + "|" + GameState.isCapable + "|" + GameState.isRightClickCapable);
      }
      
      private function viewAPI() : void
      {
         Kongregate.debugAPI += "API:" + Kongregate.API;
         if(Kongregate.API)
         {
            if(Kongregate.API.sharedContent)
            {
               Kongregate.debugAPI += "SC:" + Kongregate.API.sharedContent;
            }
            if(Kongregate.API.services)
            {
               Kongregate.debugAPI += "SR:" + Kongregate.API.services;
            }
         }
         GameState.ui.console.setConsoleText(Kongregate.debugAPI);
      }
      
      private function ToggleFoolsOn() : void
      {
         this.ToggleFools(1);
      }
      
      private function SetMenuAlpha(param1:Number = 1) : *
      {
         GameState.menuHandler.setAlpha(param1);
      }
      
      private function ToggleFools(param1:int = -1) : void
      {
         GameState.fooling = param1 != -1;
         GameState.ui.console.toggleConsole();
      }
      
      private function ConsoleFullscreen(param1:int) : void
      {
         this.SetFullscreen(param1);
      }
      
      private function ConsoleIntegerScaling(param1:int = -1) : void
      {
         if(param1 == -1)
         {
            GameState.ui.console.setConsoleText(World.toggleIntegerSnap.toString());
            return;
         }
         World.toggleIntegerSnap = param1;
         GameState.ui.console.toggleConsole();
      }
      
      private function DisablePausing(param1:int) : void
      {
         World.togglePauseConfirm = param1;
         GameState.ui.console.toggleConsole();
      }
      
      private function SetFullscreen(param1:int) : void
      {
         World.toggleFullscreen = param1;
         if(param1 != 0)
         {
            this.previousWindow = stage.nativeWindow.bounds.clone();
            if(param1 == 2)
            {
               stage.fullScreenSourceRect = new Rectangle(0,0,GameState.width,GameState.height);
            }
            stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
         }
         else
         {
            stage.fullScreenSourceRect = null;
            stage.displayState = StageDisplayState.NORMAL;
            if(this.previousWindow)
            {
               stage.nativeWindow.bounds = this.previousWindow;
            }
         }
      }
      
      private function SetStageScaleMode(param1:Boolean) : void
      {
         if(param1)
         {
            stage.scaleMode = StageScaleMode.SHOW_ALL;
         }
         else
         {
            stage.scaleMode = StageScaleMode.NO_SCALE;
         }
      }
      
      private function toggleAllMenus() : void
      {
         if(Boolean(Kongregate.API) || Tweak.download)
         {
            GameState.menuHandler.toggleAll();
         }
      }
      
      private function toggleAllSliders(param1:Boolean) : void
      {
         GameState.menuHandler.toggleAllSliders(param1);
      }
      
      private function resetSettings() : void
      {
         GameState.ui.console.setConsoleText("Settings have been reset to defaults. Please restart the game.");
         World.toggleRagdollBreak = 1;
         World.toggleSlomo = 0;
         World.toggleJointBreak = 1;
         World.toggleObjectBreak = 1;
         World.toggleContact = 1;
         World.toggleStabilise = 1;
         World.toggleEffects = 1;
         World.togglePreciseEffects = 0;
         World.toggleSounds = 1;
         World.toggleStabi = 1;
         World.toggleGore = 1;
         World.toggleHealthbars = 0;
         World.toggleDollbars = 0;
         World.toggleArmourbars = 0;
         World.toggleDollicons = 0;
         World.toggleJoints = 1;
         World.toggleJointsPause = 1;
         World.toggleBlueprint = 0;
         World.toggleGrid = 1;
         World.toggleTemperature = 1;
         World.toggleFahrenheit = 0;
         World.toggleAutorespawn = 0;
         World.toggleSmoothBlood = 1;
         World.togglePhysicsBlood = 0;
         World.toggleStrongDolls = 1;
         World.toggleBodypartGibs = 1;
         World.toggleShadows = 1;
         World.toggleBackground = 1;
         World.toggleEdgePan = 1;
         World.toggleFloorPan = 0;
         World.toggleEdgeStick = 1;
         World.toggleDollSleep = 1;
         World.toggleCutFilter = 1;
         World.toggleVelocity = 1;
         World.toggleRadius = 1;
         World.toggleToolbox = 1;
         World.rightClick = 1;
         World.doubleClickSelect = 1;
         World.scrollWheel = 1;
         World.toggleLoopSides = 1;
         World.toggleExtraGore = 0;
         World.toggleSpawnBG = 1;
         World.firstRunGeneric = 0;
         World.toggleShrapnel = 1;
         World.toggleResetConfirm = 0;
         World.toggleLinkPause = 1;
         World.toggleLinkSelected = 1;
         World.toggleJointSelected = 0;
         World.toggleGibsGib = 1;
         World.toggleSelectionGlow = 1;
         World.toggleDarkMode = 1;
         Vars.speed = 1;
         Vars.slowspeed = 0.1;
         Vars.barscale = 0.5;
         Vars.dragEditor = 1;
         Vars.dragDoll = 1;
         Vars.cameraAcceleration = 0.5;
         Vars.particles = 1;
         Vars.particlesMax = 1000;
         Vars.seed = 42;
         Vars.cutlimit = 10;
         Vars.edgePanDelay = 10;
         stage.quality = StageQuality.HIGH;
         sounds.vol = 0.3;
         Tweak.bloodSmoothing = 0.4;
         Tweak.smoothBloodSize = 12;
         Tweak.MinShrapnelSize = 0.1;
         Tweak.m_iterations = 6;
         Tweak.UIScale = 1;
         Tweak.AntiFreezeFPS = 0;
         World.toggleCulling = 1;
         Settings.saveSettings();
         this.loadSettings();
         var _loc1_:ToolTip = GameState.ui.showTooltip(GameState.ui.menuSettings,"Settings reset.\n",0,1000,GameState.ui.menuSettings.actualWidth);
      }
      
      private function resetCustoms() : void
      {
         this.customNames = [];
         this.customItems = [];
         Settings.saveCustomItems();
         var _loc1_:ToolTip = GameState.ui.showTooltip(GameState.ui.menuSettings,"Custom items reset.\n",0,1000,GameState.ui.menuSettings.actualWidth);
         this.updateLibrary();
      }
      
      private function resetFavs() : void
      {
         var _loc1_:ToolTip = null;
         this.favourites = [];
         this.favourites.push("ragdoll");
         this.favourites.push("square");
         this.favourites.push("");
         this.favourites.push("");
         this.favourites.push("");
         this.favourites.push("");
         this.favourites.push("");
         this.favourites.push("");
         this.favourites.push("");
         this.favourites.push("");
         this.favourites.push("");
         this.favourites.push("");
         this.favourites.push("");
         this.favourites.push("");
         this.favourites.push("");
         this.favourites.push("");
         this.favourites.push("");
         this.favourites.push("");
         this.favourites.push("");
         this.favourites.push("");
         Settings.saveFavourites();
         if(!this.mainmenu.visible)
         {
            _loc1_ = GameState.ui.showTooltip(GameState.ui.menuSettings,"Favourites reset.\n",0,1000,GameState.ui.menuSettings.actualWidth);
         }
      }
      
      private function favOrSpawn(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vector.<Array> = null;
         param1--;
         if(GameState.spawning)
         {
            _loc2_ = this.favourites.indexOf(GameState.objects.spawnName);
            if(_loc2_ != -1)
            {
               this.favourites[_loc2_] = "";
            }
            this.favourites[param1] = GameState.objects.spawnName;
            if(GameState.objects.spawnCustom)
            {
            }
            GameState.ui.showTooltip(GameState.ui.menuSpawn,"Favourited [" + (param1 + 1) + "]",0,500,GameState.ui.menuSpawn.actualWidth);
            Settings.saveFavourites();
            GameState.ui.updateFavs();
         }
         else
         {
            if(!this.favourites[param1])
            {
               return;
            }
            if(this.contract.enabled)
            {
               return;
            }
            _loc3_ = this.customNames.indexOf(this.favourites[param1]);
            if(_loc3_ == -1)
            {
               _loc4_ = GameState.objects.spawnSkin;
               if(GameState.objects.spawnName != this.favourites[param1])
               {
                  GameState.objects.spawnSkin = new Vector.<Array>();
               }
               GameState.objects.spawnObject(this.favourites[param1],this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale,GameState.objects.spawnAngle,this.flipped,GameState.paused,GameState.objects.spawnSkin);
               if(GameState.objects.spawnName != this.favourites[param1])
               {
                  GameState.objects.spawnSkin = _loc4_;
               }
            }
            else
            {
               GameState.spawningCustom = true;
               this.customPos = new b2Vec2();
               IO.loadWorld(this.customItems[_loc3_],!GameState.paused,true);
               GameState.spawningCustom = false;
            }
         }
      }
      
      public function keyUps(param1:KeyboardEvent) : *
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:b2Body = null;
         var _loc6_:userData = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Vec2 = null;
         var _loc9_:b2Body = null;
         var _loc10_:ListEvent = null;
         var _loc11_:b2Body = null;
         _loc2_ = Tool.current;
         _loc3_ = int(param1.keyCode);
         if(_loc3_ != Keymap.nameToCode("Camera"))
         {
            this.cameraKeySpammedBandaid = 0;
         }
         _loc4_ = false;
         _loc5_ = Physics.world.GetBodyList();
         while(_loc5_)
         {
            _loc6_ = _loc5_.GetUserData();
            if(_loc6_.triggerKey == _loc3_)
            {
               _loc6_.keydown = false;
               _loc4_ = true;
            }
            _loc5_ = _loc5_.GetNext();
         }
         if(_loc4_)
         {
            return;
         }
         if(_loc3_ == Keymap.nameToCode("CameraLeft"))
         {
            this.panLeft = false;
         }
         else if(_loc3_ == Keymap.nameToCode("CameraRight"))
         {
            this.panRight = false;
         }
         else if(_loc3_ == Keymap.nameToCode("CameraUp"))
         {
            this.panUp = false;
         }
         else if(_loc3_ == Keymap.nameToCode("CameraDown"))
         {
            this.panDown = false;
         }
         else if(_loc3_ == Keymap.nameToCode("RotateL"))
         {
            if(GameState.environment is OpenWorld)
            {
               this.panLeft = false;
            }
         }
         else if(_loc3_ == Keymap.nameToCode("RotateR"))
         {
            if(GameState.environment is OpenWorld)
            {
               this.panRight = false;
            }
         }
         else if(_loc3_ == Keymap.nameToCode("ResizeU"))
         {
            if(GameState.environment is OpenWorld)
            {
               this.panUp = false;
            }
         }
         else if(_loc3_ == Keymap.nameToCode("Pause"))
         {
            this.pauseReleasedBandaid = false;
         }
         else if(_loc3_ == Keymap.nameToCode("RopeJoint"))
         {
            if(Boolean(this.jointPos) && Boolean(this.jointBody))
            {
               _loc7_ = new b2Vec2(this.mouseXWorld,this.mouseYWorld);
               _loc8_ = new b2Vec2(this.jointBody.GetPosition().x + this.jointPos.x,this.jointBody.GetPosition().y + this.jointPos.y);
               _loc9_ = Body.GetOne(_loc7_.x,_loc7_.y,true,true);
               if((Boolean(_loc9_)) && _loc9_ != this.jointBody)
               {
                  Joints.Distance("ropejoint",this.jointBody,_loc9_,_loc8_,_loc7_,Tweak.jointFrequency,Tweak.jointDamping,Tweak.jointCollide,Tweak.jointForce);
               }
               else
               {
                  Joints.Distance("ropejoint",this.jointBody,Physics.world.GetGroundBody(),_loc8_,_loc7_,Tweak.jointFrequency,Tweak.jointDamping,Tweak.jointCollide,Tweak.jointForce);
               }
               this.jointPos = null;
               this.jointBody = null;
               if(Tool.isRope)
               {
                  Tool.reset();
               }
            }
         }
         else if(_loc3_ == Keymap.nameToCode("WeldJoint"))
         {
            if(Boolean(this.jointPos) && Boolean(this.jointBody))
            {
               _loc7_ = new b2Vec2(this.mouseXWorld,this.mouseYWorld);
               _loc8_ = new b2Vec2(this.jointBody.GetPosition().x + this.jointPos.x,this.jointBody.GetPosition().y + this.jointPos.y);
               _loc9_ = Body.GetOne(_loc7_.x,_loc7_.y,true,true);
               this.finishWelding(this.jointBody,_loc9_);
               if(Tool.isWeld)
               {
                  Tool.reset();
               }
            }
         }
         else if(_loc3_ == Keymap.nameToCode("ObjJoint"))
         {
            if(Boolean(this.jointPos) && Boolean(this.jointBody))
            {
               _loc7_ = new b2Vec2(this.mouseXWorld,this.mouseYWorld);
               _loc8_ = new b2Vec2(this.jointBody.GetPosition().x + this.jointPos.x,this.jointBody.GetPosition().y + this.jointPos.y);
               _loc9_ = Body.GetOne(_loc7_.x,_loc7_.y,true,true);
               if((Boolean(_loc9_)) && _loc9_ != this.jointBody)
               {
                  Joints.Distance("objjoint",this.jointBody,_loc9_,_loc8_,_loc7_,0,0,Tweak.jointCollide,Tweak.jointForce);
               }
               else
               {
                  Joints.Distance("objjoint",this.jointBody,Physics.world.GetGroundBody(),_loc8_,_loc7_,0,0,Tweak.jointCollide,Tweak.jointForce);
               }
               this.jointPos = null;
               this.jointBody = null;
               if(Tool.isJoint)
               {
                  Tool.reset();
               }
            }
         }
         else if(_loc3_ == Keymap.nameToCode("LinkJoint"))
         {
            if(Boolean(this.jointPos) && Boolean(this.jointBody))
            {
               this.LinkItems();
               if(Tool.isLink)
               {
                  Tool.reset();
               }
            }
         }
         else if(_loc3_ == Keymap.nameToCode("Flip"))
         {
            this.spawnFlipped = false;
         }
         else if(_loc3_ == Keymap.nameToCode("Camera"))
         {
            if(Tool.previousTool)
            {
               Tool.setTool(Tool.previousTool);
            }
            ++this.cameraKeySpammedBandaid;
         }
         else if(_loc3_ == Keymap.nameToCode("ToolMenu"))
         {
            this.ToggleToolsMenu();
         }
         else if(_loc3_ == Keymap.nameToCode("JointMenu"))
         {
            _loc10_ = new ListEvent("fake",false,false,-1,-1,-1,{"func":"togglejoints"});
            this.ToggleJointsMenu(_loc10_);
         }
         else if(_loc3_ == Keymap.nameToCode("PowerMenu"))
         {
            this.TogglePowerMenu();
         }
         else if(_loc3_ == Keymap.nameToCode("MultipleSelect"))
         {
            this.shiftPressed = false;
            this.spawnFlipped = false;
            this.selectingPos = null;
            if(Tool.isSelect)
            {
               Tool.reset();
               this.toolSprite.graphics.clear();
            }
         }
         else if(_loc3_ == Keymap.nameToCode("Action"))
         {
            this.itemTriggered = false;
         }
         if(_loc2_ != Tool.current)
         {
            GameState.ui.updateControls();
            this.toolSprite.graphics.clear();
            for each(_loc11_ in this.selectedBodies)
            {
               _loc11_.WakeUp();
            }
         }
      }
      
      private function finishWelding(param1:b2Body, param2:b2Body) : void
      {
         var _loc3_:b2Body = null;
         if(Boolean(param1) && Boolean(param2) && param1 != param2)
         {
            if(this.selectedBodies.indexOf(param1) != -1)
            {
               for each(_loc3_ in this.selectedBodies)
               {
                  Joints.Weld("weldjoint",_loc3_,param2,null,Tweak.jointForce);
               }
            }
            else if(this.selectedBodies.indexOf(param2) != -1)
            {
               for each(_loc3_ in this.selectedBodies)
               {
                  Joints.Weld("weldjoint",param1,_loc3_,null,Tweak.jointForce);
               }
            }
            else
            {
               Joints.Weld("weldjoint",param1,param2,null,Tweak.jointForce);
            }
         }
         this.jointPos = null;
         this.jointBody = null;
      }
      
      public function UpdateFrame() : *
      {
         if(!GameState.paused)
         {
            return;
         }
         TimeLord.unpause();
         this.update(null);
         TimeLord.pause();
      }
      
      public function cleanAlive() : void
      {
         this.cleanShrapnel(true);
         this.SpawnDoll();
      }
      
      public function cleanShrapnel(param1:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc4_:userData = null;
         var _loc5_:b2Body = null;
         this.clear();
         var _loc2_:* = false;
         _loc3_ = 0;
         _loc5_ = Physics.world.GetBodyList();
         while(_loc5_)
         {
            _loc4_ = userData(_loc5_.GetUserData());
            if(_loc4_)
            {
               if(_loc4_.hasBeenCut && !param1 || param1 && _loc4_.alive)
               {
                  Body.Destroy(_loc5_,"reset");
                  _loc2_ = true;
               }
               else if(!_loc5_.IsStatic())
               {
                  _loc3_++;
               }
            }
            _loc5_ = _loc5_.GetNext();
         }
         if(_loc3_ == 0)
         {
            _loc2_ = false;
         }
      }
      
      public function PlayerReset() : *
      {
         var _loc1_:String = null;
         GameState.stamping = false;
         if(IO.incrementalLoading)
         {
            IO.IncrementalLoadCancel();
            return;
         }
         if(GameState.environment is OpenWorld)
         {
            OpenWorld(GameState.environment).reset();
         }
         else
         {
            if(GameState.environment is PumpkinDefence)
            {
               PumpkinDefence(GameState.environment).reset();
               return;
            }
            if(GameState.environment is PumpkinOffence)
            {
               PumpkinOffence(GameState.environment).reset();
               return;
            }
         }
         _loc1_ = GameState.environment.loadContent;
         if(_loc1_)
         {
            IO.loadWorld(_loc1_,false,true);
            GameState.environment.loadContent = _loc1_;
            return;
         }
         if(GameState.environment.name != "mainmenu" && World.toggleResetConfirm == 1)
         {
            GameState.ui.resetPopup();
         }
         else
         {
            if(this.favouriteSaveReset != -1)
            {
               IO.loadWorld(this.favouriteSaves[this.favouriteSaveReset],true);
            }
            else
            {
               this.reset();
            }
            if(GameState.ui.menuSave.visible)
            {
               this.updateSaveMenu();
            }
         }
      }
      
      public function reset(param1:Boolean = true, param2:Boolean = true) : void
      {
         var _loc3_:b2Body = null;
         var _loc4_:Sprite = null;
         this.gamefrozen = [60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60];
         if(GameState.objects.spawnSprite)
         {
            if(GameState.objects.spawnSprite.parent == stage)
            {
               stage.removeChild(GameState.objects.spawnSprite);
            }
         }
         if(Boolean(GameState.spawning) && Boolean(GameState.objects.spawnSprite) && GameState.objects.spawnSprite.name == "customSprite")
         {
            GameState.spawning = false;
            GameState.spawningCustom = false;
            _loc4_ = GameState.ui.menuSpawn.getChildByName("itemHolder") as Sprite;
            _loc4_.visible = true;
         }
         this.clear();
         Physics.contactFilter.cutExclude = new Vector.<b2Body>();
         Physics.contactFilter.cutInclude = new Vector.<b2Body>();
         this.dollNumber = 0;
         _loc3_ = Physics.world.GetBodyList();
         while(_loc3_)
         {
            if(GameState.environment.defaultBodies.indexOf(_loc3_) == -1)
            {
               Body.Destroy(_loc3_,"reset");
            }
            _loc3_ = _loc3_.GetNext();
         }
         GameState.focused = false;
         _loc3_ = Physics.world.GetBodyList();
         while(_loc3_)
         {
            if(userData(_loc3_.GetUserData()).hidden)
            {
               if(userData(_loc3_.GetUserData()).graphic)
               {
                  userData(_loc3_.GetUserData()).graphic.visible = true;
                  userData(_loc3_.GetUserData()).locked = false;
               }
            }
            _loc3_ = _loc3_.GetNext();
         }
         if(GameState.ui.menuSpawn.title == "VIEW CARD")
         {
            GameState.ui.DisableTradingCardStyle();
            GameState.ui.menuSpawn.close();
         }
         this.backBodies = [];
         GameState.spawningCustom = false;
         this.customPos = new b2Vec2();
         this.dulin = null;
         this.toolSprite.graphics.clear();
         this.scalingPos = null;
         this.selectedBodies = new Vector.<b2Body>();
         this.jointPos = null;
         this.jointBody = null;
         if(param2)
         {
            if(this.loadedCustomItem)
            {
               this.loadedCustomItem = "";
            }
            if(this.loadedLevel)
            {
               this.loadedLevel = "";
               this.currentSave = "";
               GameState.ui.updateControls();
            }
            if(this.contract.enabled)
            {
               this.contract.Reset();
               GameState.ui.menuMain.open();
               this.updateChallengeMenu();
               GameState.ui.menuChallenge.x = GameState.ui.menuMain.x + GameState.ui.menuMain.actualWidth + 4;
               GameState.ui.menuChallenge.y = GameState.ui.menuMain.y;
            }
            this.contractSplashShown = false;
         }
         if(!GameState.previewing && param2)
         {
            Kongregate.alreadyShared = false;
         }
         if(Boolean(GameState.environment) && Boolean(!(GameState.environment is PumpkinDefence)) && !(GameState.environment is PumpkinOffence))
         {
            GameState.environment.seed = Vars.seed;
            GameState.environment.setupBackground();
         }
         this.updateSpawnPic();
         if(param1)
         {
            this.SpawnDoll();
         }
         if(TimeLord.speed == 0)
         {
            TimeLord.unpause();
            TimeLord.pause();
         }
         if(!Tool.isPower)
         {
            Tool.drag();
         }
         GameState.ui.updateControls();
         System.pauseForGCIfCollectionImminent(0.25);
      }
      
      private function SpawnDoll() : void
      {
         GameState.objects.doll(GameState.environment.spawnX,GameState.height - GameState.environment.spawnHeight * Vars.objSize * GameState.objects.spawnScale,0,Vars.objSize * GameState.objects.spawnScale);
      }
      
      public function clear() : void
      {
         var _loc1_:ParticleSystem = null;
         var _loc2_:ParticleSystem = null;
         this.bloodBMD.fillRect(this.bloodBMD.rect,0);
         this.particlesBMD.fillRect(this.particlesBMD.rect,0);
         for each(_loc1_ in GameState.particles.systems)
         {
            _loc1_.clear();
         }
         for each(_loc2_ in GameState.environment.public::particleSystems)
         {
            _loc2_.clear();
         }
         GameState.particles.simpleParticleSystem.clear();
      }
      
      public function updateMouse() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:b2Vec2 = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         this.mouseVel = new b2Vec2(mouseX - this.prevMouse.x,mouseY - this.prevMouse.y);
         if(this.mouseVels.length > 5)
         {
            this.mouseVels.pop();
            this.mouseVels.unshift(this.mouseVel);
         }
         else
         {
            this.mouseVels.push(this.mouseVel);
         }
         _loc1_ = 0;
         _loc2_ = 0;
         for each(_loc3_ in this.mouseVels)
         {
            _loc1_ += _loc3_.x;
            _loc2_ += _loc3_.y;
         }
         this.mouseVelAverage.x = _loc1_ * 0.1;
         this.mouseVelAverage.y = _loc2_ * 0.1;
         this.panMouseDown = false;
         this.panMouseUp = false;
         this.panMouseLeft = false;
         this.panMouseRight = false;
         if(Boolean(World.toggleEdgePan) && (Boolean(!GameState.mouseDown || this.pauseMoving)) && this.mousepancounter <= 0)
         {
            _loc4_ = GameState.environment.borderLeft;
            _loc5_ = GameState.environment.borderRight;
            _loc6_ = GameState.environment.borderTop;
            if(_loc4_ != 0 || _loc5_ != GameState.width || _loc6_ != GameState.height)
            {
               if(mouseX > GameState.width - 20)
               {
                  this.panMouseRight = true;
                  if(this.scrollhint.visible)
                  {
                     this.scrollhint.visible = false;
                  }
               }
               else if(mouseX < 20)
               {
                  this.panMouseLeft = true;
                  if(this.scrollhint.visible)
                  {
                     this.scrollhint.visible = false;
                  }
               }
               if(mouseY > GameState.height - 20)
               {
                  this.panMouseDown = true;
                  if(this.scrollhintV.visible)
                  {
                     this.scrollhintV.visible = false;
                  }
               }
               else if(mouseY < 20)
               {
                  this.panMouseUp = true;
                  if(this.scrollhintV.visible)
                  {
                     this.scrollhintV.visible = false;
                  }
               }
            }
         }
         this.mouseXWorld = mouseX;
         this.mouseYWorld = mouseY;
         this.mouseXWorld -= this.m_sprite.x * this.cam.scaleX + this.cam.x;
         this.mouseYWorld -= this.m_sprite.y * this.cam.scaleY + this.cam.y;
         this.mouseXWorld /= Physics.scale * this.cam.scaleX;
         this.mouseYWorld /= Physics.scale * this.cam.scaleY;
         this.prevMouse.x = mouseX;
         this.prevMouse.y = mouseY;
         if(GameState.rightDown)
         {
            this.triggerDragged();
         }
         this.DrawToolLine();
         if((Tool.isDrag || Tool.isBlunt || Tool.isSharp || Tool.isRicochet || Tool.isHole || Tool.isRadiation) && !GameState.menuHandler.isDragging())
         {
            this.MouseDrag();
         }
         if(!Tool.isStab && !Tool.isSwing)
         {
            if(this.mouseleft && !GameState.mouseDown && Boolean(this.m_mouseJoint))
            {
               this.stopDragging(false);
            }
         }
      }
      
      internal function CheckGameFrozen() : Boolean
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(GameState.loading)
         {
            return false;
         }
         if(GameState.environmenting)
         {
            return false;
         }
         if(GameState.environment is MainMenu)
         {
            return false;
         }
         if(GameState.environment is PumpkinDefence)
         {
            return false;
         }
         if(GameState.environment is PumpkinOffence)
         {
            return false;
         }
         if(GameState.paused)
         {
            return false;
         }
         this.gamefrozen.push(this.fps.fps);
         if(this.gamefrozen.length > 20)
         {
            this.gamefrozen.shift();
         }
         _loc1_ = 0;
         for each(_loc2_ in this.gamefrozen)
         {
            _loc1_ += _loc2_;
         }
         if(_loc1_ / this.gamefrozen.length < Tweak.AntiFreezeFPS)
         {
            if(this.wasfrozen < 0)
            {
               this.wasfrozen = TimeLord.speed;
            }
            return true;
         }
         this.gamefrozen.shift();
         return false;
      }
      
      public function update(param1:Event) : void
      {
         var _loc2_:Vector.<b2Body> = null;
         var _loc3_:Vector.<b2Body> = null;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:b2Body = null;
         var _loc7_:int = 0;
         var _loc8_:BitmapData = null;
         var _loc9_:userData = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:b2Vec2 = null;
         var _loc13_:b2Vec2 = null;
         var _loc14_:b2Vec2 = null;
         var _loc15_:b2Vec2 = null;
         var _loc16_:String = null;
         var _loc17_:Boolean = false;
         var _loc18_:b2JointEdge = null;
         var _loc19_:b2Vec2 = null;
         var _loc20_:Boolean = false;
         var _loc21_:Array = null;
         var _loc22_:b2Body = null;
         var _loc23_:b2Vec2 = null;
         var _loc24_:b2Vec2 = null;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:b2Body = null;
         var _loc33_:int = 0;
         var _loc34_:Array = null;
         var _loc35_:b2Vec2 = null;
         var _loc36_:b2Vec2 = null;
         var _loc37_:b2Vec2 = null;
         var _loc38_:Number = NaN;
         var _loc39_:b2Vec2 = null;
         var _loc40_:b2Vec2 = null;
         var _loc41_:Number = NaN;
         var _loc42_:Number = NaN;
         var _loc43_:Number = NaN;
         var _loc44_:b2Vec2 = null;
         var _loc45_:b2Vec2 = null;
         var _loc46_:Number = NaN;
         var _loc47_:Number = NaN;
         var _loc48_:Number = NaN;
         var _loc49_:Number = NaN;
         var _loc50_:int = 0;
         var _loc51_:Number = NaN;
         var _loc52_:Number = NaN;
         var _loc53_:int = 0;
         var _loc54_:BitmapData = null;
         var _loc55_:Sprite = null;
         var _loc56_:b2Body = null;
         var _loc57_:b2Body = null;
         var _loc58_:userData = null;
         var _loc59_:userData = null;
         var _loc60_:Vector.<b2Body> = null;
         var _loc61_:Vector.<b2Body> = null;
         var _loc62_:b2Body = null;
         var _loc63_:b2Body = null;
         var _loc64_:Number = NaN;
         var _loc65_:Number = NaN;
         var _loc66_:int = 0;
         var _loc67_:b2JointEdge = null;
         var _loc68_:jointUserData = null;
         var _loc69_:b2RevoluteJoint = null;
         var _loc70_:Vector.<b2Body> = null;
         var _loc71_:b2Body = null;
         var _loc72_:jointUserData = null;
         var _loc73_:Number = NaN;
         var _loc74_:Number = NaN;
         var _loc75_:Number = NaN;
         var _loc76_:Number = NaN;
         var _loc77_:int = 0;
         var _loc78_:Number = NaN;
         var _loc79_:Number = NaN;
         var _loc80_:String = null;
         var _loc81_:Number = NaN;
         var _loc82_:Number = NaN;
         var _loc83_:Number = NaN;
         var _loc84_:b2Body = null;
         var _loc85_:Number = NaN;
         var _loc86_:DashedLine = null;
         var _loc87_:DashedLine = null;
         var _loc88_:b2Vec2 = null;
         var _loc89_:b2Vec2 = null;
         var _loc90_:b2Vec2 = null;
         var _loc91_:Number = NaN;
         var _loc92_:Number = NaN;
         var _loc93_:Number = NaN;
         var _loc94_:Number = NaN;
         var _loc95_:b2Vec2 = null;
         var _loc96_:Sprite = null;
         var _loc97_:TextField = null;
         var _loc98_:TextField = null;
         var _loc99_:ContractTarget = null;
         var _loc100_:userData = null;
         var _loc101_:Point = null;
         var _loc102_:Point = null;
         var _loc103_:Matrix = null;
         var _loc104_:Boolean = false;
         var _loc105_:String = null;
         var _loc106_:String = null;
         if(this.selectDoubleclick > 0)
         {
            --this.selectDoubleclick;
         }
         if(this.mousepancounter > 0 && !this.mouseleft)
         {
            --this.mousepancounter;
         }
         if(IO.incrementalLoading)
         {
            IO.IncrementalLoad();
         }
         if(O.needsUpdating)
         {
            _loc7_ = 0;
            while(_loc7_ < 50)
            {
               if(!O.processData())
               {
                  O.initCreators();
                  this.updateLibrary();
                  this.m_sprite.visible = true;
                  if(getChildByName("preloader"))
                  {
                     getChildByName("preloader").visible = false;
                  }
                  if(Kongregate.contentToLoad)
                  {
                     IO.loadWorld(Kongregate.contentToLoad,false,true);
                  }
                  else if(this.customItemLoadedBandaid)
                  {
                     this.beginPlay();
                  }
                  else
                  {
                     this.ShowMainMenu();
                  }
                  break;
               }
               _loc7_++;
            }
            return;
         }
         if(this.CheckGameFrozen())
         {
            TimeLord.pause();
            this.gamefrozen = [60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60];
            GameState.ui.showTooltip(GameState.ui.menuTools,"The game has been automatically paused. Your average frame time dropped below the Anti-Freeze setting. Configure via [Settings > Performance]\n\n\n\n",0,5000);
            return;
         }
         Cutter.cutLimit = Vars.cutlimit;
         this.particlesBMD.lock();
         if(this.sharingItem && !IO.incrementalLoading)
         {
            this.sharingItem = false;
            _loc8_ = new BitmapData(400,400,false,0);
            _loc8_.draw(this.backgroundSprite,new Matrix(1,0,0,1,-200,-150));
            _loc8_.draw(this.itemSprite,new Matrix(1,0,0,1,-200,-150));
            _loc8_.draw(this.foregroundSprite,new Matrix(1,0,0,1,-200,-150));
            GameState.steamworks.filenam = GameState.ui.menuDetails.getValue("Name");
            GameState.steamworks.filedes = GameState.ui.menuDetails.getValue("Description");
            Kongregate.shareContentType = "Item";
            GameState.steamworks.ShareContent(Kongregate.shareContentType,GameState.objects.spawnCustomContent,new Bitmap(_loc8_));
         }
         if(GameState.screenshotMode)
         {
            if(!IO.incrementalLoading)
            {
               this.updateScreenshot();
            }
         }
         else
         {
            this.particlesBMD.fillRect(this.particlesBMD.rect,0);
         }
         if(this.deletedBodies.length > 0)
         {
            Body.Destroy(this.deletedBodies[0],"deletetool");
            this.deletedBodies.shift();
         }
         if(TimeLord.speed > 0)
         {
            if(Tool.isStab)
            {
               this.updateStab();
            }
            this.updateShadows();
            GameState.environment.update();
            this.updateFirearms();
            this.breakJoints();
            this.drawParticles();
            if(GameState.ui.menuEffects.visible)
            {
               if(Boolean(this.previewEffect) && Boolean(this.previewEffect.body))
               {
                  this.previewEffect.update();
               }
            }
         }
         this.updateWorld();
         this.updateMouse();
         if(!GameState.paused)
         {
            this.throwPowers();
         }
         this.updateTools();
         this.cameraFollow();
         this.drawJoints();
         this.pauseMove();
         this.drawCut();
         _loc2_ = new Vector.<b2Body>();
         _loc3_ = new Vector.<b2Body>();
         _loc4_ = 0;
         _loc5_ = ["burn1","burn2","burn3","burn4"];
         _loc6_ = Physics.world.GetBodyList();
         for(; _loc6_; _loc6_ = _loc6_.GetNext())
         {
            if(_loc6_ != Physics.world.GetGroundBody())
            {
               if(_loc6_)
               {
                  _loc9_ = userData(_loc6_.GetUserData());
                  _loc10_ = _loc6_.GetMass();
                  _loc11_ = _loc6_.GetAngle() % (Math.PI * 2);
                  _loc12_ = _loc6_.GetPosition().Copy();
                  _loc13_ = _loc6_.GetWorldCenter().Copy();
                  _loc14_ = _loc13_.Copy();
                  _loc14_.Multiply(Physics.scale);
                  _loc15_ = _loc6_.GetLinearVelocity();
                  if(_loc9_)
                  {
                     if(_loc9_.dead)
                     {
                        Body.Destroy(_loc6_,"killed");
                     }
                     else
                     {
                        if(Boolean(_loc9_.graphic) && _loc9_.graphic.filters.length > 0)
                        {
                           _loc9_.graphic.filters = [];
                        }
                        _loc16_ = _loc9_.name;
                        if(_loc16_ != "wall")
                        {
                           if(TimeLord.speed > 0)
                           {
                              if(_loc9_.pfx)
                              {
                                 _loc9_.pfx.update();
                              }
                              if(GameState.environment.loop && _loc2_.indexOf(_loc6_) == -1 && GameState.environment.defaultBodies.indexOf(_loc6_) == -1)
                              {
                                 _loc19_ = _loc13_.Copy();
                                 _loc20_ = false;
                                 if(_loc14_.x < GameState.environment.borderLeft - 100)
                                 {
                                    _loc19_.x = GameState.environment.borderRight / Physics.scale;
                                    _loc20_ = true;
                                 }
                                 else if(_loc14_.x > GameState.environment.borderRight + 100)
                                 {
                                    _loc19_.x = GameState.environment.borderLeft / Physics.scale;
                                    _loc20_ = true;
                                 }
                                 else if(_loc14_.y > GameState.environment.borderTop + 150)
                                 {
                                    _loc19_.y = -GameState.environment.borderTop / Physics.scale;
                                    _loc20_ = true;
                                 }
                                 else if(_loc14_.y < -GameState.environment.borderTop - 150)
                                 {
                                    _loc19_.y = GameState.environment.borderTop / Physics.scale;
                                    _loc20_ = true;
                                 }
                                 if(_loc9_.dead)
                                 {
                                    continue;
                                 }
                                 if(_loc20_)
                                 {
                                    if(!(_loc16_ == "blooddrop" || _loc9_.hasBeenCut))
                                    {
                                       _loc21_ = BoxUtils.selectCompound(_loc6_);
                                       if(_loc21_.length > 1)
                                       {
                                          for each(_loc22_ in _loc21_)
                                          {
                                             if(_loc22_ != _loc6_)
                                             {
                                                if(Boolean(this.m_mouseJoint) && _loc22_ == this.m_mouseJoint.GetBody2())
                                                {
                                                   Physics.world.DestroyJoint(this.m_mouseJoint);
                                                   this.m_mouseJoint = null;
                                                }
                                                _loc23_ = _loc22_.GetLinearVelocity().Copy();
                                                if(_loc23_.x > Tweak.PortalSpeedCap)
                                                {
                                                   _loc23_.x = Tweak.PortalSpeedCap;
                                                }
                                                if(_loc23_.y > Tweak.PortalSpeedCap)
                                                {
                                                   _loc23_.y = Tweak.PortalSpeedCap;
                                                }
                                                _loc24_ = _loc19_;
                                                if(_loc21_.length > 1 && _loc22_ != _loc6_)
                                                {
                                                   _loc24_ = new b2Vec2(_loc19_.x - (_loc6_.GetPosition().x - _loc22_.GetPosition().x),_loc19_.y - (_loc6_.GetPosition().y - _loc22_.GetPosition().y));
                                                }
                                                _loc22_.SetXForm(_loc24_,_loc22_.GetAngle());
                                                _loc22_.SetLinearVelocity(_loc23_);
                                                _loc2_.push(_loc22_);
                                             }
                                          }
                                          _loc6_.SetXForm(_loc19_,_loc6_.GetAngle());
                                       }
                                       else
                                       {
                                          _loc6_.SetXForm(_loc19_,_loc6_.GetAngle());
                                       }
                                       return;
                                    }
                                    _loc9_.dead = true;
                                    continue;
                                 }
                              }
                              if(_loc9_.temperature < 0)
                              {
                                 if(Math.random() > 0.9)
                                 {
                                    _loc25_ = (Math.random() * _loc9_.width - _loc9_.width * 0.5) / Physics.scale;
                                    _loc26_ = (Math.random() * _loc9_.height - _loc9_.height * 0.5) / Physics.scale;
                                    _loc27_ = (_loc12_.x + _loc25_ * Math.cos(_loc11_) - _loc26_ * Math.sin(_loc11_)) * Physics.scale;
                                    _loc28_ = (_loc12_.y + _loc25_ * Math.sin(_loc11_) + _loc26_ * Math.cos(_loc11_)) * Physics.scale;
                                    GameState.particles.addParticles(_loc27_,_loc28_,1,"crystal",_loc15_.x,_loc15_.y);
                                 }
                              }
                              if(_loc9_.radioactive)
                              {
                                 Body.Radioactive(_loc6_,100);
                              }
                              if(_loc9_.regenerating)
                              {
                                 _loc9_.health += _loc9_.maxhealth * 0.001 * _loc9_.multiRegen;
                              }
                              if((Vars.gravity != 0 || Vars.wind != 0) && !_loc6_.IsSleeping())
                              {
                                 _loc29_ = 1;
                                 if(_loc9_.antigrav)
                                 {
                                    _loc29_ = -1;
                                 }
                                 if(_loc9_.zerograv)
                                 {
                                    _loc29_ = 0;
                                 }
                                 if(this.m_mouseJoint)
                                 {
                                    _loc32_ = this.m_mouseJoint.GetBody2();
                                    if(_loc32_ == _loc6_ && (this.draggingFirearm || Tool.isSwing || Tool.isStab || this.draggingAiming))
                                    {
                                       _loc29_ = 0;
                                    }
                                 }
                                 _loc30_ = Vars.gravity;
                                 _loc31_ = Vars.wind;
                                 if(_loc9_.resistGravity)
                                 {
                                    _loc30_ = 20;
                                    _loc31_ = 0;
                                 }
                                 _loc6_.ApplyForce(new b2Vec2(_loc31_ * _loc10_,_loc29_ * _loc30_ * _loc10_),_loc13_);
                              }
                              if(_loc9_.triggered || _loc9_.keydown)
                              {
                                 this.trigger.action(_loc6_);
                              }
                              if(Boolean(_loc9_.armour) && !(_loc9_.trigger is Armour))
                              {
                                 _loc9_.armour.trigger(_loc6_,_loc9_);
                              }
                              _loc9_.UpdateStabs();
                              _loc17_ = _loc9_.health > 0;
                              if(_loc9_.multiBleedDamage < 0)
                              {
                                 _loc17_ = true;
                              }
                              if(_loc17_ && _loc9_.bleeding.length > 0 && _loc9_.stabs.length == 0)
                              {
                                 _loc33_ = 0;
                                 for each(_loc34_ in _loc9_.bleeding)
                                 {
                                    if(_loc9_.resistBleed || _loc9_.multiBleedDamage == 0)
                                    {
                                       _loc9_.bleeding = [];
                                       break;
                                    }
                                    _loc35_ = _loc34_[0] as b2Vec2;
                                    _loc36_ = _loc34_[1] as b2Vec2;
                                    if(_loc34_[2])
                                    {
                                       _loc37_ = _loc34_[2] as b2Vec2;
                                    }
                                    _loc38_ = 2;
                                    if(_loc34_[3] != undefined)
                                    {
                                       _loc38_ = Number(_loc34_[3]);
                                    }
                                    else
                                    {
                                       _loc34_[3] = 2;
                                    }
                                    if(_loc38_ != 0)
                                    {
                                       _loc39_ = _loc6_.GetWorldPoint(_loc35_);
                                       _loc40_ = _loc6_.GetWorldPoint(_loc36_);
                                       _loc41_ = BoxUtils.vectorDist(_loc39_,_loc40_);
                                       if(_loc34_[3] > 1)
                                       {
                                          _loc34_[3] -= 0.001;
                                       }
                                       if(_loc9_.regenerating && !_loc9_.hasBeenCut)
                                       {
                                          _loc34_[3] -= 0.01;
                                       }
                                       if(_loc41_ < 1 && _loc34_[3] < 1)
                                       {
                                          _loc35_.x += (_loc36_.x - _loc35_.x) * 0.0005;
                                          _loc35_.y += (_loc36_.y - _loc35_.y) * 0.0005;
                                          _loc36_.x -= (_loc36_.x - _loc35_.x) * 0.0005;
                                          _loc36_.y -= (_loc36_.y - _loc35_.y) * 0.0005;
                                          if(Math.abs(_loc35_.x - _loc36_.x) < 0.1)
                                          {
                                             _loc9_.bleeding.splice(_loc33_,1);
                                          }
                                       }
                                       _loc42_ = _loc40_.y - _loc39_.y;
                                       _loc43_ = _loc40_.x - _loc39_.x;
                                       if(_loc43_ != 0 && _loc42_ != 0)
                                       {
                                          _loc47_ = _loc42_ / _loc43_;
                                          _loc48_ = _loc39_.x + Math.random() * _loc43_;
                                          _loc49_ = _loc39_.y + _loc47_ * (_loc48_ - _loc39_.x);
                                          _loc44_ = new b2Vec2(_loc48_,_loc49_);
                                       }
                                       else
                                       {
                                          _loc44_ = _loc39_;
                                       }
                                       _loc45_ = new b2Vec2();
                                       if(_loc37_)
                                       {
                                          _loc45_ = BoxUtils.rotateVec(_loc37_,_loc11_);
                                       }
                                       else
                                       {
                                          _loc45_ = new b2Vec2(_loc44_.x - _loc12_.x,_loc44_.y - _loc12_.y);
                                       }
                                       _loc45_.x += _loc15_.x * 0.1;
                                       _loc45_.y += _loc15_.y * 0.1;
                                       _loc46_ = _loc41_ * _loc38_ + 0.2;
                                       if(_loc46_ < 0.8)
                                       {
                                          _loc46_ = 0.8;
                                       }
                                       if(_loc41_ == 0)
                                       {
                                          if(Math.random() > 0.8)
                                          {
                                             Body.Damage(_loc6_,_loc46_ * _loc9_.multiBleedDamage,_loc44_,_loc45_,new b2Vec2(1,1));
                                          }
                                       }
                                       else
                                       {
                                          _loc50_ = 0;
                                          while(_loc50_ < _loc41_ * _loc38_)
                                          {
                                             Body.Damage(_loc6_,5 * _loc9_.multiBleedDamage,_loc44_,new b2Vec2(_loc45_.x * Math.random(),_loc45_.y * Math.random()),new b2Vec2(2,2),Math.random() > 0.8);
                                             _loc44_.x = _loc39_.x + Math.random() * _loc43_;
                                             _loc44_.y = _loc39_.y + _loc47_ * (_loc48_ - _loc39_.x);
                                             _loc50_++;
                                          }
                                       }
                                       _loc33_++;
                                    }
                                 }
                                 if(_loc9_.bleeding.length > 10)
                                 {
                                    _loc9_.bleeding.shift();
                                 }
                              }
                              if(_loc9_.ignition)
                              {
                                 _loc9_.burning = _loc9_.temperature >= _loc9_.ignition;
                                 if(!_loc9_.resistFlame && _loc9_.burning)
                                 {
                                    _loc4_++;
                                    _loc9_.health -= ((_loc9_.temperature - _loc9_.ignition) * 0.25 + _loc9_.health * 0.0005) * TimeLord.speed;
                                    if(_loc9_.temperature > 0)
                                    {
                                       if(_loc15_.Length() > 20)
                                       {
                                          _loc9_.temperature -= _loc15_.Length() * 0.01;
                                       }
                                       else if(_loc9_.temperature < _loc9_.ignition * 2)
                                       {
                                          _loc9_.temperature += 0.4;
                                       }
                                    }
                                    else
                                    {
                                       _loc9_.temperature -= 0.4;
                                    }
                                    if(_loc9_.bleeding.length > 0)
                                    {
                                       if(Math.random() > 0.9)
                                       {
                                          _loc9_.bleeding = [];
                                       }
                                    }
                                    if((_loc9_.soft || _loc9_.ignition == 50) && _loc9_.health <= 1)
                                    {
                                       if(Math.random() > 0.99)
                                       {
                                          if(_loc10_ < 0.75)
                                          {
                                             _loc9_.trigger = new Disintegrate("smoke",20,0.1);
                                             _loc9_.triggered = true;
                                          }
                                          else
                                          {
                                             this.brittleArray.push(_loc6_);
                                          }
                                       }
                                    }
                                    if(TimeLord.speed >= 1 || TimeLord.speed < 1 && Math.random() * TimeLord.speed < TimeLord.speed * 0.1)
                                    {
                                       _loc25_ = Math.random() * 100 - 50;
                                       _loc26_ = Math.random() * 100 - 50;
                                       if(Boolean(_loc9_.width) && Boolean(_loc9_.height))
                                       {
                                          _loc25_ = Math.random() * _loc9_.width - _loc9_.width * 0.5;
                                          _loc26_ = Math.random() * _loc9_.height - _loc9_.height * 0.5;
                                          _loc53_ = 0;
                                          while(!GeneralUtils.pointInPolygon(_loc25_,_loc26_,_loc9_.hull) && _loc53_ < 10)
                                          {
                                             _loc25_ = Math.random() * _loc9_.width - _loc9_.width * 0.5;
                                             _loc26_ = Math.random() * _loc9_.height - _loc9_.height * 0.5;
                                             _loc53_++;
                                          }
                                       }
                                       _loc25_ /= Physics.scale;
                                       _loc26_ /= Physics.scale;
                                       _loc27_ = (_loc12_.x + _loc25_ * Math.cos(_loc11_) - _loc26_ * Math.sin(_loc11_)) * Physics.scale;
                                       _loc28_ = (_loc12_.y + _loc25_ * Math.sin(_loc11_) + _loc26_ * Math.cos(_loc11_)) * Physics.scale;
                                       _loc51_ = _loc15_.x;
                                       _loc52_ = _loc15_.y;
                                       if(_loc9_.temperature < 0)
                                       {
                                          GameState.particles.addParticles(_loc27_,_loc28_,1,"frostfire",_loc51_ * 0.1,_loc52_ * 0.1,0);
                                       }
                                       else
                                       {
                                          if(Math.random() > 0.75)
                                          {
                                             GameState.particles.addParticles(_loc27_,_loc28_,1,"fire2",_loc51_ * 0.1,_loc52_ * 0.1,0);
                                          }
                                          if(Math.random() > 0.75)
                                          {
                                             GameState.particles.addParticles(_loc27_,_loc28_,1,"fire3",_loc51_ * 0.1,_loc52_ * 0.1,0,0);
                                          }
                                          if(Math.random() > 0.9)
                                          {
                                             GameState.particles.addParticles(_loc27_,_loc28_,1,"smoke",_loc51_ * 0.1,_loc52_ * 0.1,0,0);
                                          }
                                       }
                                       if(World.toggleGore == 1 && _loc9_.alive)
                                       {
                                          _loc54_ = BoxUtils.getEffectBMD(_loc6_);
                                          if(_loc54_)
                                          {
                                             _loc55_ = new Sprite();
                                             if(Math.random() > 0.3)
                                             {
                                                _loc55_.graphics.beginFill(2236962,Math.random());
                                             }
                                             else
                                             {
                                                _loc55_.graphics.beginFill(Tweak.bloodColour,Math.random());
                                             }
                                             _loc55_.graphics.drawCircle(-10 + Math.random() * (_loc9_.width + 20),-10 + Math.random() * (_loc9_.height + 20),Math.random() * 5);
                                             _loc55_.graphics.endFill();
                                             _loc54_.draw(_loc55_);
                                          }
                                       }
                                    }
                                 }
                              }
                              if(World.toggleTemperature == 1 && _loc9_.conductivity > 0)
                              {
                                 _loc60_ = new Vector.<b2Body>();
                                 _loc61_ = new Vector.<b2Body>();
                                 _loc18_ = _loc6_.GetJointList();
                                 while(_loc18_)
                                 {
                                    _loc56_ = _loc18_.joint.GetBody1();
                                    _loc57_ = _loc18_.joint.GetBody2();
                                    _loc58_ = userData(_loc56_.GetUserData());
                                    _loc59_ = userData(_loc57_.GetUserData());
                                    if(!(!_loc58_.temperature || !_loc59_.temperature))
                                    {
                                       if(!(!_loc58_.conductivity || !_loc59_.conductivity))
                                       {
                                          if(_loc58_.temperature != _loc59_.temperature)
                                          {
                                             _loc64_ = _loc58_.temperature;
                                             _loc65_ = _loc59_.temperature;
                                             _loc66_ = _loc64_ < 0 ? -1 : 1;
                                             _loc58_.temperature += (_loc65_ - _loc64_) * 0.0001 * (_loc58_.burning ? 1 : 4) * TimeLord.speed;
                                             _loc59_.temperature += (_loc64_ - _loc65_) * 0.0001 * (_loc59_.burning ? 1 : 4) * TimeLord.speed;
                                             if(_loc64_ < 0 && _loc58_.temperature > 0)
                                             {
                                                _loc60_.push(_loc56_);
                                             }
                                             else if(_loc64_ > 0 && jointUserData(_loc18_.joint.GetUserData()).name == "frozen" && !(_loc58_.trigger is Concussion))
                                             {
                                                _loc60_.push(_loc57_);
                                             }
                                             if(_loc65_ < 0 && _loc59_.temperature > 0)
                                             {
                                                _loc60_.push(_loc57_);
                                             }
                                             else if(_loc65_ > 0 && jointUserData(_loc18_.joint.GetUserData()).name == "frozen" && !(_loc58_.trigger is Concussion))
                                             {
                                                _loc60_.push(_loc57_);
                                             }
                                             if(_loc64_ > 0 && _loc58_.temperature < 0)
                                             {
                                                _loc61_.push(_loc56_);
                                             }
                                             if(_loc65_ > 0 && _loc59_.temperature < 0)
                                             {
                                                _loc61_.push(_loc57_);
                                             }
                                          }
                                       }
                                    }
                                    _loc18_ = _loc18_.next;
                                 }
                                 if(GameState.environment)
                                 {
                                    _loc64_ = Vars.temperature;
                                    _loc65_ = _loc9_.temperature;
                                    _loc9_.temperature += (_loc64_ - _loc65_) * 0.001 * TimeLord.speed;
                                    if(_loc65_ < 0 && _loc9_.temperature > 0)
                                    {
                                       if(_loc60_.indexOf(_loc6_) == -1)
                                       {
                                          _loc60_.push(_loc6_);
                                       }
                                    }
                                    if(_loc65_ > 0 && _loc9_.temperature < 0)
                                    {
                                       if(_loc61_.indexOf(_loc6_) == -1)
                                       {
                                          _loc61_.push(_loc6_);
                                       }
                                    }
                                 }
                                 for each(_loc62_ in _loc60_)
                                 {
                                    _loc67_ = _loc62_.GetJointList();
                                    while(_loc67_)
                                    {
                                       _loc68_ = jointUserData(_loc67_.joint.GetUserData());
                                       if(_loc68_.name == "frozen")
                                       {
                                          _loc69_ = Joints.Revolution("rag",_loc67_.joint.m_body1,_loc67_.joint.m_body2,_loc67_.joint.GetAnchor1().x * Physics.scale,_loc67_.joint.GetAnchor1().y * Physics.scale,_loc68_.defaultLA,_loc68_.defaultUA,true);
                                          jointUserData(_loc69_.GetUserData()).forceLimit = _loc68_.defaultFL;
                                          Physics.world.DestroyJoint(_loc67_.joint);
                                       }
                                       _loc67_ = _loc67_.next;
                                    }
                                    userData(_loc62_.GetUserData()).brittle = false;
                                 }
                                 for each(_loc63_ in _loc61_)
                                 {
                                    Body.Freeze(_loc63_,-1);
                                 }
                              }
                              _loc18_ = _loc6_.GetJointList();
                              while(_loc18_)
                              {
                                 _loc56_ = _loc18_.joint.GetBody1();
                                 _loc57_ = _loc18_.joint.GetBody2();
                                 _loc58_ = userData(_loc56_.GetUserData());
                                 _loc59_ = userData(_loc57_.GetUserData());
                                 if(_loc58_.name != "ground")
                                 {
                                    if(_loc59_.name != "ground")
                                    {
                                       _loc68_ = jointUserData(_loc18_.joint.GetUserData());
                                       if(_loc68_.dead)
                                       {
                                          Physics.world.DestroyJoint(_loc18_.joint);
                                       }
                                       else
                                       {
                                          _loc70_ = new Vector.<b2Body>();
                                          if(_loc58_.trigger is Electrified && _loc68_.name == "ana")
                                          {
                                             _loc70_.push(_loc56_);
                                          }
                                          if(_loc59_.trigger is Electrified && _loc68_.name == "ana")
                                          {
                                             _loc70_.push(_loc57_);
                                          }
                                          for each(_loc71_ in _loc70_)
                                          {
                                             _loc67_ = _loc71_.GetJointList();
                                             while(_loc67_)
                                             {
                                                _loc72_ = jointUserData(_loc67_.joint.GetUserData());
                                                if(_loc72_.name == "ana")
                                                {
                                                   _loc69_ = Joints.Revolution("rag",_loc67_.joint.m_body1,_loc67_.joint.m_body2,_loc67_.joint.GetAnchor1().x * Physics.scale,_loc67_.joint.GetAnchor1().y * Physics.scale,_loc72_.defaultLA,_loc72_.defaultUA,true);
                                                   jointUserData(_loc69_.GetUserData()).forceLimit = _loc72_.defaultFL;
                                                   Physics.world.DestroyJoint(_loc67_.joint);
                                                }
                                                _loc67_ = _loc67_.next;
                                             }
                                          }
                                          if(_loc68_.name == "snarejoint" || _loc68_.name == "webjoint")
                                          {
                                             if(_loc58_.burning || _loc59_.burning || _loc58_.temperature < 0 || _loc59_.temperature < 0)
                                             {
                                                _loc73_ = _loc18_.joint.GetAnchor1().x * Physics.scale;
                                                _loc74_ = _loc18_.joint.GetAnchor1().y * Physics.scale;
                                                _loc75_ = _loc18_.joint.GetAnchor2().x * Physics.scale;
                                                _loc76_ = _loc18_.joint.GetAnchor2().y * Physics.scale;
                                                _loc47_ = (_loc76_ - _loc74_) / (_loc75_ - _loc73_);
                                                _loc77_ = 0;
                                                while(_loc77_ < 6)
                                                {
                                                   _loc78_ = _loc73_ + _loc77_ / 6 * (_loc75_ - _loc73_);
                                                   _loc79_ = _loc74_ + _loc47_ * (_loc78_ - _loc73_);
                                                   if(_loc58_.burning || _loc59_.burning)
                                                   {
                                                      _loc80_ = "fire2";
                                                   }
                                                   else
                                                   {
                                                      _loc80_ = "crystal";
                                                   }
                                                   GameState.particles.addParticles(_loc78_,_loc79_,1,_loc80_,(-_loc73_ + _loc78_) * 0.05,(-_loc74_ + _loc79_) * 0.05,0,0);
                                                   _loc77_++;
                                                }
                                                Physics.world.DestroyJoint(_loc18_.joint);
                                             }
                                             if(_loc58_.health > 0)
                                             {
                                                _loc58_.health -= 0.01;
                                             }
                                             if(_loc59_.health > 0)
                                             {
                                                _loc59_.health -= 0.01;
                                             }
                                          }
                                          if(_loc68_.name == "rag" && _loc58_.alive && _loc59_.alive)
                                          {
                                             _loc81_ = _loc58_.health / _loc58_.maxhealth;
                                             _loc82_ = _loc59_.health / _loc59_.maxhealth;
                                             if(!(_loc81_ > 0.9 && _loc82_ > 0.9))
                                             {
                                                if(Math.abs(_loc58_.health - _loc59_.health) >= 100)
                                                {
                                                   _loc83_ = 0.2;
                                                   if(_loc81_ > _loc82_ && _loc59_.health < _loc59_.maxhealth)
                                                   {
                                                      if(_loc59_.bleeding.length > 0)
                                                      {
                                                         _loc83_ += 10;
                                                      }
                                                      if(_loc59_.health < _loc58_.maxhealth * 0.3)
                                                      {
                                                         _loc83_ += 10;
                                                      }
                                                      _loc58_.health -= _loc83_ * TimeLord.speed;
                                                      _loc59_.health += _loc83_ * TimeLord.speed;
                                                   }
                                                   else if(_loc82_ > _loc81_ && _loc58_.health < _loc58_.maxhealth)
                                                   {
                                                      if(_loc58_.bleeding.length > 0)
                                                      {
                                                         _loc83_ += 5;
                                                      }
                                                      if(_loc58_.health < _loc58_.maxhealth * 0.3)
                                                      {
                                                         _loc83_ += 5;
                                                      }
                                                      _loc58_.health += _loc83_ * TimeLord.speed;
                                                      _loc59_.health -= _loc83_ * TimeLord.speed;
                                                   }
                                                }
                                             }
                                          }
                                       }
                                    }
                                 }
                                 _loc18_ = _loc18_.next;
                              }
                           }
                           if(_loc9_.graphic)
                           {
                              _loc9_.graphic.x = _loc12_.x * Physics.scale;
                              _loc9_.graphic.y = _loc12_.y * Physics.scale;
                              _loc9_.graphic.rotation = _loc11_ * Vars.toDegrees % 360;
                           }
                           if(GameState.paused && !GameState.screenshotMode)
                           {
                              if(World.toggleLinkPause == 1)
                              {
                                 for each(_loc84_ in _loc9_.connected)
                                 {
                                    if(_loc84_)
                                    {
                                       if(!(!userData(_loc84_.GetUserData()).saveable || !_loc9_.saveable))
                                       {
                                          if(!(World.toggleLinkSelected == 1 && this.selectedBodies.indexOf(_loc84_) == -1 && this.selectedBodies.indexOf(_loc6_) == -1))
                                          {
                                             _loc3_.push(_loc6_);
                                             _loc85_ = 0;
                                             if(userData(_loc84_.GetUserData()).connected.indexOf(_loc6_) != -1)
                                             {
                                                _loc85_ = 5;
                                             }
                                             _loc86_ = new DashedLine(2,13434828,[5,10],6,0);
                                             _loc87_ = new DashedLine(1,3368499,[5,10],6,0);
                                             _loc88_ = new b2Vec2(GraphicUtils.camX(_loc12_.x * Physics.scale + this.m_sprite.x),GraphicUtils.camY(_loc12_.y * Physics.scale + this.m_sprite.y));
                                             _loc89_ = new b2Vec2(GraphicUtils.camX(_loc84_.GetPosition().Copy().x * Physics.scale + this.m_sprite.x),GraphicUtils.camY(_loc84_.GetPosition().Copy().y * Physics.scale + this.m_sprite.y));
                                             _loc90_ = new b2Vec2(_loc88_.x - _loc89_.x,_loc88_.y - _loc89_.y);
                                             _loc90_.Normalize();
                                             _loc90_.Multiply(25);
                                             _loc89_.Add(_loc90_);
                                             _loc86_.moveTo(_loc88_.x,_loc88_.y);
                                             _loc86_.lineTo(_loc89_.x,_loc89_.y);
                                             _loc87_.moveTo(_loc88_.x,_loc88_.y + 2);
                                             _loc87_.lineTo(_loc89_.x,_loc89_.y + 2);
                                             this.particlesBMD.draw(_loc87_);
                                             this.particlesBMD.draw(_loc86_);
                                          }
                                       }
                                    }
                                 }
                                 for each(_loc84_ in _loc9_.ignored)
                                 {
                                    if(_loc84_)
                                    {
                                       if(!(!userData(_loc84_.GetUserData()).saveable || !_loc9_.saveable))
                                       {
                                          if(_loc2_.indexOf(_loc84_) == -1)
                                          {
                                             if(!(World.toggleLinkSelected == 1 && this.selectedBodies.indexOf(_loc84_) == -1 && this.selectedBodies.indexOf(_loc6_) == -1))
                                             {
                                                _loc91_ = GraphicUtils.camX(_loc12_.x * Physics.scale + this.m_sprite.x);
                                                _loc92_ = GraphicUtils.camY(_loc12_.y * Physics.scale + this.m_sprite.y);
                                                _loc93_ = GraphicUtils.camX(_loc84_.GetPosition().Copy().x * Physics.scale + this.m_sprite.x);
                                                _loc94_ = GraphicUtils.camY(_loc84_.GetPosition().Copy().y * Physics.scale + this.m_sprite.y);
                                                if(GameState.simpleIgnores)
                                                {
                                                   GraphicUtils.efla(this.particlesBMD,_loc91_,_loc92_,_loc93_,_loc94_,2868851507,false);
                                                }
                                                else
                                                {
                                                   _loc86_ = new DashedLine(2,16724787,[5,10]);
                                                   _loc86_.moveTo(GraphicUtils.camX(_loc12_.x * Physics.scale + this.m_sprite.x),GraphicUtils.camY(_loc12_.y * Physics.scale + this.m_sprite.y + 5));
                                                   _loc86_.lineTo(GraphicUtils.camX(_loc84_.GetPosition().Copy().x * Physics.scale + this.m_sprite.x),GraphicUtils.camY(_loc84_.GetPosition().Copy().y * Physics.scale + this.m_sprite.y + 5));
                                                   this.particlesBMD.draw(_loc86_);
                                                }
                                             }
                                          }
                                       }
                                    }
                                 }
                              }
                              if(Boolean(_loc9_.drawRadius && World.toggleRadius) && Boolean(_loc9_.triggerRadius) && _loc9_.saveable)
                              {
                                 _loc95_ = new b2Vec2();
                                 if(_loc9_.triggerPos)
                                 {
                                    _loc95_ = BoxUtils.rotateVec(new b2Vec2(_loc9_.triggerPos.x * _loc9_.size * (_loc9_.flipped ? -1 : 1),_loc9_.triggerPos.y * _loc9_.size),_loc11_);
                                 }
                                 _loc96_ = new Sprite();
                                 _loc96_.graphics.lineStyle(1,16777215);
                                 _loc96_.graphics.drawCircle(GraphicUtils.camX(_loc14_.x + _loc95_.x + this.m_sprite.x),GraphicUtils.camY(_loc14_.y + _loc95_.y + this.m_sprite.y),_loc9_.triggerRadius * _loc9_.size * this.cam.scaleX);
                                 this.particlesBMD.draw(_loc96_);
                              }
                              if(_loc9_.debug)
                              {
                                 if(_loc9_.graphic.getChildByName("debug_pos"))
                                 {
                                    TextField(_loc9_.graphic.getChildByName("debug_pos")).rotation = -_loc9_.graphic.rotation;
                                    TextField(_loc9_.graphic.getChildByName("debug_pos")).text = int(_loc14_.x).toString() + "x " + int(_loc14_.y).toString() + "y " + String(int(_loc9_.size * 100) / 100) + "s";
                                 }
                                 else
                                 {
                                    _loc97_ = new TextField();
                                    _loc97_.name = "debug_pos";
                                    _loc9_.graphic.addChild(_loc97_);
                                    _loc97_.textColor = 4294967295;
                                 }
                                 if(_loc9_.graphic.getChildByName("debug_scalerot"))
                                 {
                                    TextField(_loc9_.graphic.getChildByName("debug_scalerot")).rotation = -_loc9_.graphic.rotation;
                                    TextField(_loc9_.graphic.getChildByName("debug_scalerot")).text = Math.round(_loc11_ * Vars.toDegrees) + "°";
                                 }
                                 else
                                 {
                                    _loc98_ = new TextField();
                                    _loc98_.name = "debug_scalerot";
                                    _loc9_.graphic.addChild(_loc98_);
                                    _loc98_.y = -100;
                                    _loc98_.textColor = 4294967295;
                                 }
                                 GraphicUtils.efla(this.particlesBMD,_loc14_.x - 100,_loc14_.y,_loc14_.x + 100,_loc14_.y,4289374890);
                                 GraphicUtils.efla(this.particlesBMD,_loc14_.x,_loc14_.y - 100,_loc14_.x,_loc14_.y + 100,4289374890);
                              }
                              if(World.toggleVelocity)
                              {
                                 if(_loc15_.Length() > 10 && _loc9_.saveable)
                                 {
                                    if(!_loc9_.alive || _loc9_.name == "doll_head" || _loc9_.alive && !_loc6_.GetJointList())
                                    {
                                       _loc96_ = new Sprite();
                                       _loc96_.graphics.lineStyle(1,16777215);
                                       _loc96_.graphics.moveTo(GraphicUtils.camX(_loc14_.x + this.m_sprite.x),GraphicUtils.camY(_loc14_.y + this.m_sprite.y));
                                       _loc96_.graphics.lineTo(GraphicUtils.camX(_loc14_.x + this.m_sprite.x + _loc15_.x),GraphicUtils.camY(_loc14_.y + this.m_sprite.y + _loc15_.y));
                                       this.particlesBMD.draw(_loc96_);
                                    }
                                 }
                              }
                              if(this.contract.enabled)
                              {
                                 for each(_loc99_ in this.contract.targets)
                                 {
                                    _loc100_ = userData(_loc99_.body.GetUserData());
                                    if(_loc99_.type == 4 && Boolean(_loc100_.targetX))
                                    {
                                       _loc101_ = new Point(_loc99_.body.GetPosition().x * Physics.scale,_loc99_.body.GetPosition().y * Physics.scale);
                                       _loc102_ = new Point(_loc100_.targetX,_loc100_.targetY);
                                       _loc103_ = new Matrix();
                                       _loc103_.rotate(Vars.PI);
                                       _loc103_.translate(GraphicUtils.camX(_loc100_.targetX + 32),GraphicUtils.camY(_loc100_.targetY - 32));
                                       this.particlesBMD.draw(R.getSprite("tool_relocate"),_loc103_);
                                       GraphicUtils.efla(this.particlesBMD,_loc101_.x + this.m_sprite.x,_loc101_.y + this.m_sprite.y,_loc102_.x + this.m_sprite.x,_loc102_.y + this.m_sprite.y,872415231);
                                    }
                                 }
                              }
                           }
                           if(!GameState.screenshotMode && TimeLord.speed != 0 && (Boolean(_loc9_.alive) || Boolean(_loc9_.armour)))
                           {
                              if(World.toggleHealthbars == 1)
                              {
                                 BoxUtils.drawHealthBar(_loc6_);
                              }
                              if(World.toggleDollbars == 1 || World.toggleDollicons == 1)
                              {
                                 if(_loc16_ == "doll_head")
                                 {
                                    BoxUtils.drawCompoundHealthBar(_loc6_);
                                 }
                              }
                           }
                           _loc2_.push(_loc6_);
                        }
                     }
                  }
               }
            }
         }
         this.outlineSelected();
         this.drawLink();
         if(TimeLord.speed > 0)
         {
            this.updateContactListener();
         }
         if(_loc4_ > 0)
         {
            _loc104_ = true;
            for each(_loc105_ in _loc5_)
            {
               if(sounds.isPlaying(_loc105_))
               {
                  _loc104_ = false;
                  break;
               }
            }
            if(_loc104_ || Math.random() > 0.95)
            {
               _loc106_ = _loc5_[Math.random() * _loc5_.length >> 0];
               sounds.play(_loc106_,null,_loc14_,0.3);
            }
         }
         this.particlesBMD.unlock();
      }
      
      private function drawCut() : void
      {
         var _loc1_:b2Vec2 = null;
         if(this.cutDelta == -1)
         {
            return;
         }
         _loc1_ = GeneralUtils.lerp(this.cutStart,this.cutEnd,this.cutDelta);
         GraphicUtils.efla(this.particlesBMD,this.cutEnd.x * Physics.scale + this.m_sprite.x,this.cutEnd.y * Physics.scale + this.m_sprite.y,_loc1_.x * Physics.scale + this.m_sprite.x,_loc1_.y * Physics.scale + this.m_sprite.y,4291611852);
         this.cutDelta += 0.2;
         if(this.cutDelta > 1)
         {
            this.cutDelta = -1;
            this.cutStart = null;
         }
      }
      
      private function drawLink() : void
      {
         var _loc1_:b2Vec2 = null;
         var _loc2_:DashedLine = null;
         var _loc3_:b2Body = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:userData = null;
         var _loc7_:userData = null;
         var _loc8_:b2Body = null;
         if(this.linkDelta == -1 && Boolean(this.jointPos))
         {
            _loc3_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,false,true);
            _loc4_ = this.selectedBodies.indexOf(this.jointBody) != -1;
            _loc5_ = this.selectedBodies.indexOf(_loc3_) != -1;
            if(_loc3_)
            {
               if(_loc4_ && _loc5_)
               {
                  return;
               }
               _loc6_ = userData(_loc3_.GetUserData());
               _loc7_ = userData(this.jointBody.GetUserData());
               if(Tool.isLink && _loc7_.connected.indexOf(_loc3_) != -1 || Tool.isIgnore)
               {
                  this.highlightGlowFilter.color = this.ignoreColour;
               }
               else if(Tool.isLink)
               {
                  this.highlightGlowFilter.color = this.linkColour;
               }
               else
               {
                  this.highlightGlowFilter.color = this.selectColour;
               }
               if(_loc5_ && (Tool.current == Tool.WELD || Tool.current == Tool.IGNORE || Tool.current == Tool.LINK))
               {
                  for each(_loc8_ in this.selectedBodies)
                  {
                     this.outline(_loc8_,this.highlightGlowFilter,null);
                  }
               }
               else
               {
                  this.outline(_loc3_,this.highlightGlowFilter,null);
               }
            }
         }
         if(this.linkDelta == -1)
         {
            return;
         }
         _loc1_ = GeneralUtils.lerp(this.linkStart,this.linkEnd,this.linkDelta);
         _loc2_ = new DashedLine(3,this.highlightGlowFilter.color,[10,10]);
         _loc2_.moveTo(GraphicUtils.camX(_loc1_.x * Physics.scale + this.m_sprite.x),GraphicUtils.camY(_loc1_.y * Physics.scale + this.m_sprite.y));
         _loc2_.lineTo(GraphicUtils.camX(this.linkEnd.x * Physics.scale + this.m_sprite.x),GraphicUtils.camY(this.linkEnd.y * Physics.scale + this.m_sprite.y));
         this.particlesBMD.draw(_loc2_);
         this.linkDelta += 0.2;
         if(this.linkDelta > 1)
         {
            this.linkDelta = -1;
            this.linkStart = null;
            this.linkEnd = null;
         }
      }
      
      private function DrawToolLine() : *
      {
         var _loc1_:Boolean = false;
         var _loc2_:uint = 0;
         var _loc3_:DashedLine = null;
         var _loc4_:* = undefined;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:b2Vec2 = null;
         if(GameState.mouseDown && Tool.isCut && Boolean(this.cutStart))
         {
            this.cutEnd.x = this.mouseXWorld;
            this.cutEnd.y = this.mouseYWorld;
            this.segment.p1 = new b2Vec2(this.cutStart.x,this.cutStart.y);
            this.segment.p2 = new b2Vec2(this.cutEnd.x - this.cutStart.x,this.cutEnd.y - this.cutStart.y);
            this.segment.p2 = b2Math.AddVV(this.segment.p2,this.segment.p1);
            _loc3_ = new DashedLine(2,16777215,[8,4]);
            _loc3_.moveTo(GraphicUtils.camX(this.cutStart.x * Physics.scale + this.m_sprite.x),GraphicUtils.camY(this.cutStart.y * Physics.scale + this.m_sprite.y));
            _loc3_.lineTo(GraphicUtils.camX(this.mouseXWorld * Physics.scale + this.m_sprite.x),GraphicUtils.camY(this.mouseYWorld * Physics.scale + this.m_sprite.y));
            this.particlesBMD.draw(_loc3_);
         }
         _loc1_ = true;
         if(Tool.isPiston && Boolean(this.jointBody2))
         {
            _loc1_ = false;
         }
         _loc2_ = 16777215;
         if(Boolean(this.jointPos) && _loc1_)
         {
            if(Tool.isLink)
            {
               _loc2_ = this.linkColour;
            }
            else if(Tool.isIgnore)
            {
               _loc2_ = this.ignoreColour;
            }
            else
            {
               _loc2_ = uint("0x" + Joints.Colour(Joints.ToolToJoint(Tool.current)));
            }
            _loc4_ = 3;
            if((Tool.isLink || Tool.isWeld || Tool.isIgnore) && this.selectedBodies.indexOf(this.jointBody) != -1 && this.selectedBodies.length > 1)
            {
               _loc4_ = 5;
            }
            _loc3_ = new DashedLine(3,1118481,[10,10]);
            _loc3_.moveTo(GraphicUtils.camX((this.jointBody.GetPosition().x + this.jointPos.x) * Physics.scale + this.m_sprite.x),GraphicUtils.camY((this.jointBody.GetPosition().y + this.jointPos.y) * Physics.scale + this.m_sprite.y) + 1);
            _loc3_.lineTo(GraphicUtils.camX(this.mouseXWorld * Physics.scale + this.m_sprite.x),GraphicUtils.camY(this.mouseYWorld * Physics.scale + this.m_sprite.y) + 1);
            this.particlesBMD.draw(_loc3_);
            _loc3_ = new DashedLine(3,_loc2_,[10,10]);
            _loc3_.moveTo(GraphicUtils.camX((this.jointBody.GetPosition().x + this.jointPos.x) * Physics.scale + this.m_sprite.x),GraphicUtils.camY((this.jointBody.GetPosition().y + this.jointPos.y) * Physics.scale + this.m_sprite.y));
            _loc3_.lineTo(GraphicUtils.camX(this.mouseXWorld * Physics.scale + this.m_sprite.x),GraphicUtils.camY(this.mouseYWorld * Physics.scale + this.m_sprite.y));
            this.particlesBMD.draw(_loc3_);
         }
         if(Tool.isDoll && Boolean(this.jointBody2))
         {
            _loc3_ = new DashedLine(1,16777215,[10,5]);
            _loc3_.moveTo(GraphicUtils.camX(this.jointBody2.GetPosition().x * Physics.scale + this.m_sprite.x),GraphicUtils.camY(this.jointBody2.GetPosition().y * Physics.scale + this.m_sprite.y));
            _loc3_.lineTo(GraphicUtils.camX(this.mouseXWorld * Physics.scale + this.m_sprite.x),GraphicUtils.camY(this.mouseYWorld * Physics.scale + this.m_sprite.y));
            this.particlesBMD.draw(_loc3_);
         }
         if(Boolean(Tool.isPiston) && Boolean(this.jointBody) && Boolean(this.jointBody2))
         {
            _loc5_ = 0;
            while(_loc5_ < 2)
            {
               if(!(_loc5_ == 0 && !Tweak.jointLimitedLower))
               {
                  if(!(_loc5_ == 1 && !Tweak.jointLimitedUpper))
                  {
                     _loc3_ = new DashedLine(1,16777215,[10,5]);
                     _loc3_.moveTo(GraphicUtils.camX(this.jointBody2.GetPosition().x * Physics.scale + this.m_sprite.x),GraphicUtils.camY(this.jointBody2.GetPosition().y * Physics.scale + this.m_sprite.y));
                     _loc6_ = Math.sqrt(BoxUtils.vectorDist(this.jointBody2.GetPosition(),new b2Vec2(this.mouseXWorld,this.mouseYWorld)));
                     if(_loc5_ == 1)
                     {
                        _loc6_ *= -1;
                     }
                     _loc7_ = this.jointBody2.GetPosition().Copy();
                     _loc7_.Subtract(this.jointBody.GetPosition().Copy());
                     _loc7_.Normalize();
                     _loc7_.Multiply(_loc6_);
                     _loc7_.Add(this.jointBody2.GetPosition().Copy());
                     _loc7_.Multiply(Physics.scale);
                     _loc3_.lineTo(GraphicUtils.camX(_loc7_.x + this.m_sprite.x),GraphicUtils.camY(_loc7_.y + this.m_sprite.y));
                     this.particlesBMD.draw(_loc3_);
                  }
               }
               _loc5_++;
            }
            _loc5_ = 0;
            while(_loc5_ < 2)
            {
               if(!(_loc5_ == 0 && !Tweak.jointLimitedLower))
               {
                  if(!(_loc5_ == 1 && !Tweak.jointLimitedUpper))
                  {
                     _loc3_ = new DashedLine(1,16777215,[10,5]);
                     _loc3_.moveTo(GraphicUtils.camX(this.jointBody.GetPosition().x * Physics.scale + this.m_sprite.x),GraphicUtils.camY(this.jointBody.GetPosition().y * Physics.scale + this.m_sprite.y));
                     _loc6_ = Math.sqrt(BoxUtils.vectorDist(this.jointBody2.GetPosition(),new b2Vec2(this.mouseXWorld,this.mouseYWorld)));
                     if(_loc5_ == 1)
                     {
                        _loc6_ *= -1;
                     }
                     _loc7_ = this.jointBody.GetPosition().Copy();
                     _loc7_.Subtract(this.jointBody2.GetPosition().Copy());
                     _loc7_.Normalize();
                     _loc7_.Multiply(_loc6_);
                     _loc7_.Add(this.jointBody.GetPosition().Copy());
                     _loc7_.Multiply(Physics.scale);
                     _loc3_.lineTo(GraphicUtils.camX(_loc7_.x + this.m_sprite.x),GraphicUtils.camY(_loc7_.y + this.m_sprite.y));
                     this.particlesBMD.draw(_loc3_);
                  }
               }
               _loc5_++;
            }
         }
      }
      
      private function updateFirearms() : void
      {
         var _loc1_:Firearm = null;
         for each(_loc1_ in this.firearmArray)
         {
            _loc1_.reload();
         }
      }
      
      private function updateShadows() : void
      {
         if(World.toggleShadows == 1)
         {
            Shadows.drawShadows(this.particlesBMD);
         }
      }
      
      private function updateStab() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:userData = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Number = NaN;
         var _loc6_:b2Vec2 = null;
         if(!this.stabPressBandaid)
         {
            return;
         }
         if(this.m_mouseJoint)
         {
            _loc1_ = this.m_mouseJoint.GetBody2();
            _loc1_.WakeUp();
            _loc1_.SetLinearVelocity(new b2Vec2());
            _loc1_.SetAngularVelocity(0);
            _loc2_ = userData(_loc1_.GetUserData());
            if(GameState.mouseDown)
            {
               _loc3_ = ["grapple","harpoonbullet","doublelightsaber","rpg","blowdart","pencil","boxinggglove","bowie","chainsaw","hook","marlin","spartansword","tranqdart","dart","harpoon","throwingbat","lance","scissors","musket","razorrimmedhat","bayonet","arrow","longarrow","nestofbeesarrow","aimarrow","maimarrow","trapdart","arrowball","dartball","batteringram","gungatchet"];
               _loc4_ = ["stake","pitchfork","shovel","evehypo","adrenalineshot","armyshovel","gladiatorscissors","hpdrain","pata","broomstick"];
               _loc5_ = 0;
               if(_loc3_.indexOf(_loc2_.name) != -1)
               {
                  _loc5_ = -90 * Vars.toRadians;
               }
               if(_loc4_.indexOf(_loc2_.name) != -1)
               {
                  _loc5_ = 180 * Vars.toRadians;
               }
               if(_loc2_.flipped)
               {
                  _loc5_ += 180 * Vars.toRadians;
               }
               _loc6_ = BoxUtils.rotateVec(new b2Vec2(0,-200 * _loc1_.GetMass()),_loc5_ + _loc1_.GetAngle());
               this.m_mouseJoint.GetBody2().ApplyImpulse(_loc6_,_loc1_.GetWorldCenter());
            }
         }
      }
      
      private function throwPowers() : void
      {
         var _loc1_:b2Vec2 = null;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc5_:Power = null;
         if(!Tool.isPower)
         {
            return;
         }
         if(!GameState.mouseDown)
         {
            return;
         }
         if(!this.canThrowPower)
         {
            return;
         }
         _loc1_ = new b2Vec2(this.mouseXWorld * Physics.scale - this.m_sprite.x,this.mouseYWorld * Physics.scale - this.m_sprite.y);
         _loc2_ = Math.random() * 360 >> 0;
         _loc3_ = Tweak.toolRadius;
         var _loc4_:b2Vec2 = GeneralUtils.pointOnCircle(_loc1_.x,_loc1_.y,_loc3_,_loc2_);
         if(!this.contract.allowPower(new b2Vec2(this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale)))
         {
            return;
         }
         _loc5_ = Tool.power;
         _loc5_.Particles(_loc1_,this.mouseVel);
         _loc5_.Press(_loc1_,this.mouseVelAverage);
      }
      
      private function pauseMove() : void
      {
         var _loc1_:int = 0;
         var _loc2_:b2Vec2 = null;
         if(TimeLord.speed == 0 && this.pauseMoving)
         {
            if(this.pauseMovingBodies.length != 0)
            {
               if(!this.contract.allowDragging(new b2Vec2(this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale)))
               {
                  this.pauseMovingBodies = [];
                  this.pauseMoving = false;
                  return;
               }
               _loc1_ = 0;
               while(_loc1_ < this.pauseMovingBodies.length)
               {
                  _loc2_ = this.pauseMovingBodies[_loc1_][1];
                  this.pauseMovingBodies[_loc1_][0].SetXForm(new b2Vec2(_loc2_.x + this.mouseXWorld,_loc2_.y + this.mouseYWorld),this.pauseMovingBodies[_loc1_][0].GetAngle());
                  _loc1_++;
               }
            }
         }
      }
      
      private function updateContactListener() : void
      {
         if(!GameState.contact)
         {
            return;
         }
         this.m_contactListener.contacts = 0;
         this.contactStick();
         this.contactBleed();
         this.contactCut();
         this.contactBrittle();
      }
      
      private function contactStick() : void
      {
         var _loc1_:b2WeldJoint = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(this.jointArray.length < 4)
         {
            return;
         }
         _loc1_ = Joints.Weld("weak",this.jointArray[0],this.jointArray[1],this.jointArray[1].GetWorldCenter());
         _loc2_ = b2Body(this.jointArray[0]).GetMass();
         _loc3_ = b2Body(this.jointArray[1]).GetMass();
         _loc4_ = _loc2_;
         if(_loc3_ > _loc4_)
         {
            _loc4_ = _loc3_;
         }
         if(b2Body(this.jointArray[0]).IsStatic() || b2Body(this.jointArray[1]).IsStatic())
         {
            _loc4_ = 10;
         }
         if(_loc4_ < 1)
         {
            _loc4_ = 10;
         }
         if(_loc1_)
         {
            jointUserData(_loc1_.GetUserData()).forceLimit = 500 * _loc4_;
            jointUserData(_loc1_.GetUserData()).defaultFL = 500 * _loc4_;
         }
         this.jointArray = [];
      }
      
      private function contactChunks() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:b2Vec2 = null;
         var _loc4_:b2Vec2 = null;
         var _loc5_:b2Body = null;
         _loc1_ = this.m_contactListener.chunkArray.shift();
         if(_loc1_)
         {
            _loc2_ = 1 + (Math.random() * 3 >> 0);
            _loc3_ = _loc1_[0] as b2Vec2;
            _loc4_ = _loc1_[1] as b2Vec2;
            _loc5_ = GameState.objects.spawnObject("chunk" + _loc2_.toString(),_loc3_.x,_loc3_.y,Math.random() * 360,Math.random() > 0.5,true);
            if(_loc5_)
            {
               _loc4_.Multiply(0.1 * Math.random() * _loc5_.GetMass());
               _loc5_.ApplyImpulse(_loc4_,_loc5_.GetPosition());
            }
         }
      }
      
      private function contactBleed() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:b2Vec2 = null;
         var _loc5_:b2Vec2 = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         if(this.m_contactListener.bloodArray.length == 0)
         {
            return;
         }
         _loc1_ = int(this.m_contactListener.bloodArray.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.m_contactListener.bloodArray.shift();
            if(_loc3_.length > 0)
            {
               if(!_loc3_ || _loc3_.length < 5)
               {
                  return;
               }
               _loc7_ = int(_loc3_[1]);
               _loc4_ = _loc3_[2];
               _loc5_ = _loc3_[3];
               _loc6_ = _loc3_[4];
               _loc8_ = Boolean(_loc3_[5]);
               _loc9_ = Boolean(_loc3_[6]);
               Body.Damage(_loc3_[0],_loc7_,_loc4_,_loc5_,_loc6_,_loc8_,_loc9_);
            }
            _loc2_++;
         }
         this.m_contactListener.bloodArray = [];
      }
      
      private function contactCut() : void
      {
         var _loc1_:b2Vec2 = null;
         var _loc2_:b2Vec2 = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Vector.<b2Body> = null;
         var _loc6_:Vector.<b2Body> = null;
         var _loc7_:* = undefined;
         this.cutArray = this.m_contactListener.cutArray;
         if(this.cutArray.length > 0)
         {
            _loc7_ = 0;
            while(_loc7_ < this.cutArray.length)
            {
               GameState.madeby = this.cutArray[_loc7_][0];
               _loc1_ = this.cutArray[_loc7_][1];
               _loc2_ = this.cutArray[_loc7_][2];
               _loc3_ = Number(this.cutArray[_loc7_][3]);
               _loc4_ = Number(this.cutArray[_loc7_][4]);
               _loc5_ = this.cutArray[_loc7_][5];
               _loc6_ = this.cutArray[_loc7_][6];
               GameState.cutter.Include(_loc5_);
               GameState.cutter.Exclude(_loc6_);
               GameState.cutter.CustomCut(_loc1_,_loc2_,1,_loc3_,_loc4_);
               Physics.contactFilter.cutInclude = new Vector.<b2Body>();
               Physics.contactFilter.cutExclude = new Vector.<b2Body>();
               this.cutArray.shift();
               _loc7_++;
            }
            this.m_contactListener.cutArray = [];
         }
      }
      
      private function contactBrittle() : void
      {
         var _loc1_:int = 0;
         if(this.brittleArray.length > 0)
         {
            if(this.brittleArray[0])
            {
               Body.brittle(b2Body(this.brittleArray[0]));
               _loc1_ = 0;
               while(_loc1_ < 10)
               {
                  if(!b2Body(this.brittleArray[0]))
                  {
                     break;
                  }
                  Body.brittle(b2Body(this.brittleArray[0]));
                  _loc1_++;
               }
               this.brittleArray.shift();
            }
         }
      }
      
      private function breakJoints() : void
      {
         var _loc1_:b2Joint = null;
         var _loc2_:Number = NaN;
         var _loc3_:String = null;
         var _loc4_:Number = NaN;
         var _loc5_:b2Body = null;
         var _loc6_:b2Body = null;
         var _loc7_:userData = null;
         var _loc8_:userData = null;
         var _loc9_:b2Vec2 = null;
         var _loc10_:b2Vec2 = null;
         var _loc11_:b2Vec2 = null;
         var _loc12_:b2Vec2 = null;
         var _loc13_:b2Vec2 = null;
         var _loc14_:b2Vec2 = null;
         var _loc15_:b2Vec2 = null;
         var _loc16_:b2Vec2 = null;
         var _loc17_:int = 0;
         _loc1_ = Physics.world.GetJointList();
         for(; _loc1_; _loc1_ = _loc1_.GetNext())
         {
            _loc2_ = jointUserData(_loc1_.GetUserData()).forceLimit;
            _loc3_ = jointUserData(_loc1_.GetUserData()).name;
            if(_loc2_ != 0)
            {
               if(_loc3_ != "mouse")
               {
                  _loc4_ = _loc1_.GetReactionForce().Length() >> 0;
                  if(_loc4_ > _loc2_ / TimeLord.speed)
                  {
                     if(_loc3_ == "rag")
                     {
                        if(World.toggleRagdollBreak == 1)
                        {
                           if(!GameState.slomo && World.toggleSlomo == 1)
                           {
                              TimeLord.slowTo(50);
                           }
                           _loc5_ = _loc1_.GetBody1();
                           _loc6_ = _loc1_.GetBody2();
                           _loc7_ = userData(_loc5_.GetUserData());
                           _loc8_ = userData(_loc6_.GetUserData());
                           if(_loc7_.unbreakable || _loc8_.unbreakable)
                           {
                              continue;
                           }
                           if(_loc7_.resistAliveBreak || _loc8_.resistAliveBreak)
                           {
                              continue;
                           }
                           if(_loc7_.alive || _loc8_.alive)
                           {
                              _loc9_ = _loc5_.GetPosition();
                              _loc10_ = _loc6_.GetPosition();
                              if(_loc7_.alive)
                              {
                                 _loc12_ = _loc1_.GetAnchor1();
                                 _loc13_ = _loc1_.GetAnchor1();
                                 if(_loc7_.name == "doll_arm" || _loc7_.name == "doll_hand" || _loc8_.name == "doll_arm" || _loc8_.name == "doll_hand")
                                 {
                                    _loc14_ = new b2Vec2(0,-_loc7_.height * 0.35 / Physics.scale);
                                    _loc15_ = new b2Vec2(0,_loc7_.height * 0.35 / Physics.scale);
                                 }
                                 else
                                 {
                                    _loc14_ = new b2Vec2(-_loc7_.width * 0.35 / Physics.scale,0);
                                    _loc15_ = new b2Vec2(_loc7_.width * 0.35 / Physics.scale,0);
                                 }
                                 _loc12_.Add(BoxUtils.rotateVec(_loc14_,_loc5_.GetAngle()));
                                 _loc13_.Add(BoxUtils.rotateVec(_loc15_,_loc5_.GetAngle()));
                                 if(!_loc7_.resistBleed)
                                 {
                                    _loc7_.bleeding.push([_loc5_.GetLocalPoint(_loc12_),_loc5_.GetLocalPoint(_loc13_)]);
                                 }
                                 _loc16_ = new b2Vec2(-(_loc15_.y - _loc14_.y) + _loc5_.GetLinearVelocity().x * 0.1,_loc15_.x - _loc14_.x + _loc5_.GetLinearVelocity().y * 0.1);
                                 _loc17_ = 0;
                                 while(_loc17_ < userData(_loc5_.GetUserData()).maxhealth * 0.02)
                                 {
                                    Body.Damage(_loc5_,5,_loc1_.GetAnchor1(),_loc16_,new b2Vec2(_loc4_ * 0.00002,_loc4_ * 0.00002));
                                    _loc17_++;
                                 }
                              }
                              if(_loc8_.alive)
                              {
                                 _loc12_ = _loc1_.GetAnchor2();
                                 _loc13_ = _loc1_.GetAnchor2();
                                 if(_loc7_.name == "doll_arm" || _loc7_.name == "doll_hand" || _loc8_.name == "doll_arm" || _loc8_.name == "doll_hand")
                                 {
                                    _loc14_ = new b2Vec2(0,-_loc8_.height * 0.35 / Physics.scale);
                                    _loc15_ = new b2Vec2(0,_loc8_.height * 0.35 / Physics.scale);
                                 }
                                 else
                                 {
                                    _loc14_ = new b2Vec2(-_loc8_.width * 0.35 / Physics.scale,0);
                                    _loc15_ = new b2Vec2(_loc8_.width * 0.35 / Physics.scale,0);
                                 }
                                 _loc12_.Add(BoxUtils.rotateVec(_loc14_,_loc6_.GetAngle()));
                                 _loc13_.Add(BoxUtils.rotateVec(_loc15_,_loc6_.GetAngle()));
                                 if(!_loc7_.resistBleed)
                                 {
                                    _loc8_.bleeding.push([_loc6_.GetLocalPoint(_loc12_),_loc6_.GetLocalPoint(_loc13_)]);
                                 }
                                 _loc16_ = new b2Vec2(-(_loc15_.y - _loc14_.y) + _loc6_.GetLinearVelocity().x * 0.1,_loc15_.x - _loc14_.x + _loc6_.GetLinearVelocity().y * 0.1);
                                 _loc17_ = 0;
                                 while(_loc17_ < userData(_loc6_.GetUserData()).maxhealth * 0.1)
                                 {
                                    Body.Damage(_loc6_,1,_loc1_.GetAnchor2(),_loc16_,new b2Vec2(_loc4_ * 0.00004,_loc4_ * 0.00004));
                                    _loc17_++;
                                 }
                              }
                              _loc11_ = new b2Vec2(_loc1_.GetAnchor1().x * Physics.scale,_loc1_.GetAnchor1().y * Physics.scale);
                              if(_loc7_.name == "doll_head" || _loc8_.name == "doll_head")
                              {
                                 sounds.play("breakneck",null,_loc11_);
                              }
                              else
                              {
                                 sounds.random(["breaklimb1","breaklimb2"],null,_loc11_);
                              }
                           }
                           Physics.world.DestroyJoint(_loc1_);
                        }
                     }
                     else if(World.toggleJointBreak == 1 || _loc3_ == "weak" || _loc3_ == "stabjoint")
                     {
                        Physics.world.DestroyJoint(_loc1_);
                     }
                  }
               }
            }
         }
      }
      
      private function drawJoints() : void
      {
         var _loc1_:b2Vec2 = null;
         var _loc2_:b2Joint = null;
         var _loc3_:jointUserData = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:Number = NaN;
         var _loc7_:uint = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:b2Vec2 = null;
         var _loc13_:b2Vec2 = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:uint = 0;
         var _loc19_:b2Body = null;
         var _loc20_:int = 0;
         var _loc21_:b2JointEdge = null;
         var _loc22_:* = undefined;
         var _loc23_:* = undefined;
         var _loc24_:* = undefined;
         var _loc25_:* = undefined;
         var _loc26_:Sprite = null;
         if(Physics.world.GetJointCount() == 0)
         {
            if(!this.jointsCleared)
            {
               this.joints.graphics.clear();
               this.jointsCleared = true;
            }
            return;
         }
         if(!this.jointsCleared)
         {
            this.joints.graphics.clear();
            this.jointsCleared = true;
         }
         this.jointsCleared = false;
         _loc1_ = new b2Vec2(this.m_sprite.x,this.m_sprite.y);
         _loc2_ = Physics.world.GetJointList();
         for(; _loc2_; _loc2_ = _loc2_.GetNext())
         {
            _loc3_ = jointUserData(_loc2_.GetUserData());
            _loc4_ = _loc3_.name;
            if(_loc4_ != "snarejoint" && _loc4_ != "grapplejoint" && _loc4_ != "netjoint" && _loc4_ != "vinejoint" && _loc4_ != "webjoint")
            {
               if(!GameState.paused)
               {
                  if(World.toggleJoints == 0)
                  {
                     continue;
                  }
               }
               else
               {
                  if(World.toggleJointsPause == 0)
                  {
                     continue;
                  }
                  if(World.toggleJointSelected == 1 && this.selectedBodies.length == 0)
                  {
                     continue;
                  }
               }
            }
            if(GameState.paused && World.toggleJointSelected == 1)
            {
               if(this.selectedBodies.indexOf(_loc2_.GetBody1()) == -1 && this.selectedBodies.indexOf(_loc2_.GetBody2()) == -1)
               {
                  if(_loc4_ != "snarejoint" && _loc4_ != "grapplejoint" && _loc4_ != "netjoint" && _loc4_ != "vinejoint" && _loc4_ != "webjoint")
                  {
                     continue;
                  }
               }
            }
            _loc5_ = ["snarejoint","webjoint","vinejoint"];
            if(!(TimeLord.speed == 0 && _loc5_.indexOf(_loc4_) != -1))
            {
               if(!(_loc4_ == "mouse" && GameState.roleplaying))
               {
                  if(!(_loc4_ == "mouse" && (Tool.isStab || Tool.isSwing)))
                  {
                     if(_loc4_ != "weak")
                     {
                        if(World.toggleBlueprint == 0 || World.toggleBlueprint == 1 && TimeLord.speed != 0)
                        {
                           if(!_loc3_.lineVisible)
                           {
                              if(World.toggleJointSelected == 0)
                              {
                                 continue;
                              }
                              if(this.selectedBodies.indexOf(_loc2_.GetBody1()) == -1 && this.selectedBodies.indexOf(_loc2_.GetBody2()) == -1)
                              {
                                 continue;
                              }
                           }
                           _loc6_ = _loc3_.lineWidth;
                           if(this.cam.scaleX > 1)
                           {
                              _loc6_ /= this.cam.scaleX;
                              if(_loc6_ < 0.51)
                              {
                                 _loc6_ = 0.51;
                              }
                           }
                           if(_loc3_.lineColour)
                           {
                              this.joints.graphics.lineStyle(_loc6_,_loc3_.lineColour,_loc3_.lineAlpha);
                              if(_loc4_ == "bgjoint")
                              {
                                 this.joints.graphics.beginFill(_loc3_.lineColour);
                              }
                           }
                           else if(_loc4_ == "mouse")
                           {
                              this.joints.graphics.lineStyle(2 * _loc6_,11250603,1);
                           }
                           else if(_loc4_ == "rag")
                           {
                              this.joints.graphics.lineStyle(2 * _loc6_,16777164,1);
                           }
                           else if(_loc4_ == "pistonjoint")
                           {
                              this.joints.graphics.lineStyle(4 * _loc6_,3355477,1);
                           }
                           else if(_loc4_ == "revolute")
                           {
                              this.joints.graphics.lineStyle(2 * _loc6_,13434879,1);
                           }
                           else if(_loc4_ == "bgjoint")
                           {
                              this.joints.graphics.lineStyle(2 * _loc6_,16777215,1);
                              this.joints.graphics.beginFill(16777215);
                           }
                           else if(_loc4_ == "ropejoint")
                           {
                              this.joints.graphics.lineStyle(2 * _loc6_,6697728,1);
                           }
                           else if(_loc4_ == "objjoint")
                           {
                              this.joints.graphics.lineStyle(2 * _loc6_,16777164,1);
                           }
                           else if(_loc4_ == "weldjoint")
                           {
                              this.joints.graphics.lineStyle(2 * _loc6_,8421504,1);
                           }
                           else if(_loc4_ == "snarejoint")
                           {
                              this.joints.graphics.lineStyle(2 / this.cam.scaleX,5149504,1);
                           }
                           else if(_loc4_ == "webjoint")
                           {
                              this.joints.graphics.lineStyle(10 / this.cam.scaleX,15921128,0.32);
                           }
                           else if(_loc4_ == "grapplejoint")
                           {
                              this.joints.graphics.lineStyle(2 / this.cam.scaleX,11184810,1);
                           }
                           else if(_loc4_ == "netjoint")
                           {
                              _loc7_ = uint("0x" + userData(_loc2_.GetBody1().GetUserData()).name);
                              this.joints.graphics.lineStyle(2 / this.cam.scaleX,_loc7_,1);
                           }
                           else if(_loc4_ == "vinejoint")
                           {
                              _loc7_ = uint("0x" + userData(_loc2_.GetBody1().GetUserData()).name);
                              this.joints.graphics.lineStyle(4 / this.cam.scaleX,_loc7_,1);
                           }
                           else
                           {
                              if(_loc4_ != "equip")
                              {
                                 continue;
                              }
                              this.joints.graphics.lineStyle(2 / this.cam.scaleX,14540253,1);
                           }
                        }
                        else
                        {
                           this.joints.graphics.lineStyle(2,16777215,1);
                        }
                        if(_loc4_ == "bgjoint")
                        {
                           if(Math.abs(_loc2_.GetAnchor1().x - _loc2_.GetAnchor2().x) < 1 && Math.abs(_loc2_.GetAnchor1().y - _loc2_.GetAnchor2().y) < 1)
                           {
                              this.joints.graphics.drawCircle(_loc2_.GetAnchor1().x * Physics.scale + _loc1_.x,_loc2_.GetAnchor1().y * Physics.scale + _loc1_.y,2);
                              this.joints.graphics.endFill();
                           }
                           else
                           {
                              this.joints.graphics.moveTo(_loc2_.GetAnchor1().x * Physics.scale + _loc1_.x,_loc2_.GetAnchor1().y * Physics.scale + _loc1_.y);
                              this.joints.graphics.lineTo(_loc2_.GetAnchor2().x * Physics.scale + _loc1_.x,_loc2_.GetAnchor2().y * Physics.scale + _loc1_.y);
                           }
                        }
                        else if(_loc4_ == "snarejoint")
                        {
                           _loc8_ = _loc2_.GetAnchor1().x * Physics.scale + _loc1_.x;
                           _loc9_ = _loc2_.GetAnchor1().y * Physics.scale + _loc1_.y;
                           _loc10_ = _loc2_.GetAnchor2().x * Physics.scale + _loc1_.x;
                           _loc11_ = _loc2_.GetAnchor2().y * Physics.scale + _loc1_.y;
                           this.joints.graphics.moveTo(_loc8_,_loc9_);
                           this.joints.graphics.lineTo(_loc10_,_loc11_);
                        }
                        else if(_loc4_ == "equip")
                        {
                           if(TimeLord.speed == 0)
                           {
                              this.joints.graphics.moveTo(_loc2_.GetBody1().GetPosition().x * Physics.scale + _loc1_.x,_loc2_.GetBody1().GetPosition().y * Physics.scale + _loc1_.y);
                              this.joints.graphics.lineTo(_loc2_.GetBody2().GetPosition().x * Physics.scale + _loc1_.x,_loc2_.GetBody2().GetPosition().y * Physics.scale + _loc1_.y);
                           }
                        }
                        else if(_loc4_ == "revolute")
                        {
                           this.joints.graphics.moveTo(_loc2_.GetBody1().GetPosition().x * Physics.scale + _loc1_.x,_loc2_.GetBody1().GetPosition().y * Physics.scale + _loc1_.y);
                           this.joints.graphics.lineTo(_loc2_.GetAnchor1().x * Physics.scale + _loc1_.x,_loc2_.GetAnchor1().y * Physics.scale + _loc1_.y);
                           this.joints.graphics.lineTo(_loc2_.GetBody2().GetPosition().x * Physics.scale + _loc1_.x,_loc2_.GetBody2().GetPosition().y * Physics.scale + _loc1_.y);
                           if(b2RevoluteJoint(_loc2_).IsMotorEnabled())
                           {
                              this.joints.graphics.drawCircle(_loc2_.GetAnchor1().x * Physics.scale + _loc1_.x,_loc2_.GetAnchor1().y * Physics.scale + _loc1_.y,4);
                           }
                        }
                        else if(_loc4_ == "weldjoint")
                        {
                           this.joints.graphics.moveTo(_loc2_.GetBody1().GetPosition().x * Physics.scale + _loc1_.x,_loc2_.GetBody1().GetPosition().y * Physics.scale + _loc1_.y);
                           this.joints.graphics.lineTo(_loc2_.GetBody2().GetPosition().x * Physics.scale + _loc1_.x,_loc2_.GetBody2().GetPosition().y * Physics.scale + _loc1_.y);
                        }
                        else if(_loc4_ == "webjoint")
                        {
                           _loc8_ = _loc2_.GetAnchor1().x * Physics.scale + _loc1_.x;
                           _loc9_ = _loc2_.GetAnchor1().y * Physics.scale + _loc1_.y;
                           _loc10_ = _loc2_.GetAnchor2().x * Physics.scale + _loc1_.x;
                           _loc11_ = _loc2_.GetAnchor2().y * Physics.scale + _loc1_.y;
                           this.joints.graphics.lineStyle();
                           this.joints.graphics.beginFill(15921128,0.3);
                           this.joints.graphics.drawCircle(_loc8_,_loc9_,5);
                           this.joints.graphics.endFill();
                           this.joints.graphics.beginFill(15921128,0.3);
                           this.joints.graphics.drawCircle(_loc10_,_loc11_,5);
                           this.joints.graphics.endFill();
                           this.joints.graphics.lineStyle(10,15921128,0.3);
                           this.joints.graphics.moveTo(_loc8_,_loc9_);
                           this.joints.graphics.lineTo(_loc10_,_loc11_);
                           this.joints.graphics.lineStyle();
                        }
                        else if(_loc4_ == "randomjoint")
                        {
                           _loc12_ = _loc2_.GetBody1().GetWorldCenter().Copy();
                           _loc12_.Multiply(Physics.scale);
                           _loc13_ = _loc2_.GetBody2().GetWorldCenter().Copy();
                           _loc13_.Multiply(Physics.scale);
                           if(!GameState.paused)
                           {
                              _loc12_ = BoxUtils.randomPointOnBody(_loc2_.GetBody1(),true);
                              _loc13_ = BoxUtils.randomPointOnBody(_loc2_.GetBody2(),true);
                           }
                           this.joints.graphics.moveTo(_loc12_.x + _loc1_.x,_loc12_.y + _loc1_.y);
                           this.joints.graphics.lineTo(_loc13_.x + _loc1_.x,_loc13_.y + _loc1_.y);
                        }
                        else if(_loc4_ == "pistonjoint")
                        {
                           _loc14_ = _loc2_.GetBody1().GetPosition().x * Physics.scale + _loc1_.x;
                           _loc15_ = _loc2_.GetBody1().GetPosition().y * Physics.scale + _loc1_.y;
                           _loc16_ = _loc2_.GetBody2().GetPosition().x * Physics.scale + _loc1_.x;
                           _loc17_ = _loc2_.GetBody2().GetPosition().y * Physics.scale + _loc1_.y;
                           _loc8_ = _loc2_.GetAnchor1().x * Physics.scale + _loc1_.x;
                           _loc9_ = _loc2_.GetAnchor1().y * Physics.scale + _loc1_.y;
                           _loc10_ = _loc2_.GetAnchor2().x * Physics.scale + _loc1_.x;
                           _loc11_ = _loc2_.GetAnchor2().y * Physics.scale + _loc1_.y;
                           if(_loc2_.GetBody1() == Physics.world.GetGroundBody())
                           {
                              _loc16_ = _loc8_;
                              _loc17_ = _loc9_;
                           }
                           else if(_loc2_.GetBody2() == Physics.world.GetGroundBody())
                           {
                              _loc16_ = _loc10_;
                              _loc17_ = _loc11_;
                           }
                           _loc18_ = 3355448;
                           if(_loc3_.lineColour)
                           {
                              _loc18_ = _loc3_.lineColour;
                           }
                           this.joints.graphics.lineStyle(5 * _loc6_,_loc18_);
                           this.joints.graphics.moveTo(_loc14_,_loc15_);
                           this.joints.graphics.lineTo(_loc16_,_loc17_);
                           this.joints.graphics.moveTo(0,0);
                           this.joints.graphics.lineStyle(1 * _loc6_,GraphicUtils.scalehex(_loc18_,0.8));
                           this.joints.graphics.beginFill(_loc18_);
                           this.joints.graphics.drawCircle(_loc14_,_loc15_,5);
                           this.joints.graphics.endFill();
                           this.joints.graphics.beginFill(_loc18_);
                           this.joints.graphics.drawCircle(_loc16_,_loc17_,5);
                           this.joints.graphics.endFill();
                           this.joints.graphics.lineStyle();
                        }
                        else if(_loc4_ == "ropejoint" || _loc4_ == "objjoint")
                        {
                           if(!(World.toggleJointsAlive == 0 && TimeLord.speed != 0 && userData(_loc2_.GetBody1().GetUserData()).alive && userData(_loc2_.GetBody2().GetUserData()).alive))
                           {
                              this.joints.graphics.moveTo(_loc2_.GetAnchor1().x * Physics.scale + _loc1_.x,_loc2_.GetAnchor1().y * Physics.scale + _loc1_.y);
                              this.joints.graphics.lineTo(_loc2_.GetAnchor2().x * Physics.scale + _loc1_.x,_loc2_.GetAnchor2().y * Physics.scale + _loc1_.y);
                           }
                        }
                        else if(!(TimeLord.speed != 0 && userData(_loc2_.GetBody1().GetUserData()).alive && userData(_loc2_.GetBody2().GetUserData()).alive))
                        {
                           this.joints.graphics.moveTo(_loc2_.GetAnchor1().x * Physics.scale + _loc1_.x,_loc2_.GetAnchor1().y * Physics.scale + _loc1_.y);
                           this.joints.graphics.lineTo(_loc2_.GetAnchor2().x * Physics.scale + _loc1_.x,_loc2_.GetAnchor2().y * Physics.scale + _loc1_.y);
                        }
                     }
                  }
               }
            }
         }
         if(this.hoveredJointBody != -1)
         {
            _loc19_ = this.selectedBodies[this.hoveredJointBody];
            if(!_loc19_)
            {
               return;
            }
            _loc20_ = -1;
            _loc21_ = _loc19_.GetJointList();
            while(_loc21_)
            {
               if(++_loc20_ == this.hoveredJoint)
               {
                  _loc22_ = GraphicUtils.camX(_loc21_.joint.GetAnchor1().x * Physics.scale);
                  _loc23_ = GraphicUtils.camY(_loc21_.joint.GetAnchor1().y * Physics.scale);
                  _loc24_ = GraphicUtils.camX(_loc21_.joint.GetAnchor2().x * Physics.scale);
                  _loc25_ = GraphicUtils.camY(_loc21_.joint.GetAnchor2().y * Physics.scale);
                  _loc26_ = new Sprite();
                  _loc26_.graphics.lineStyle(6,16711680,0.5);
                  _loc26_.graphics.drawCircle(_loc22_,_loc23_,6);
                  _loc26_.graphics.drawCircle(_loc24_,_loc25_,6);
                  _loc26_.graphics.moveTo(_loc22_,_loc23_);
                  _loc26_.graphics.lineTo(_loc24_,_loc25_);
                  this.particlesBMD.draw(_loc26_);
               }
               _loc21_ = _loc21_.next;
            }
         }
      }
      
      private function updateScreenshot() : void
      {
         var _loc1_:String = null;
         TimeLord.pause();
         if(Kongregate.savingContent)
         {
            if(Boolean(Kongregate.API) || true)
            {
               Kongregate.savingContent = false;
               this.currentSave = "unlocked=" + Kongregate.shareAsUnlocked + ";" + this.currentSave;
               _loc1_ = Base64.compress(this.currentSave);
               _loc1_ = _loc1_.replace(/-/g,"/");
               if(_loc1_.substr(0,3) == "MAD")
               {
                  _loc1_ = _loc1_.substr(3);
               }
               if(Base64.uncompress(_loc1_) != "error")
               {
                  GameState.steamworks.ShareContent(Kongregate.shareContentType,_loc1_,this.screenie());
               }
            }
            else
            {
               GameState.ui.menuPrompt.title = "Share Error";
               GameState.ui.menuPrompt.getField("info").text = "No Kongregate API detected, levels can\'t be shared.";
               this.toggleScreenShotMode();
            }
         }
      }
      
      private function updateWorld() : void
      {
         if(TimeLord.speed > 0)
         {
            Physics.world.Step(Tweak.m_timeStep * TimeLord.speed,Tweak.m_iterations);
            this.oob();
         }
      }
      
      private function oob() : void
      {
         var _loc1_:Vector.<b2Body> = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.m_boundaryListener.contact)
         {
            _loc1_ = this.m_boundaryListener.bodies;
            _loc2_ = 0;
            _loc3_ = int(_loc1_.length);
            while(_loc2_ < _loc3_)
            {
               Body.Destroy(_loc1_[_loc2_],"oob");
               _loc2_++;
            }
            this.m_boundaryListener.done();
         }
      }
      
      private function outlineSelected(param1:Boolean = false) : void
      {
         var _loc2_:b2Body = null;
         if(this.selectedBodies.length > 0)
         {
            if(Tool.isAim && Trigger(userData(this.selectedBodies[0].GetUserData()).trigger) is Gun)
            {
               return;
            }
            for each(_loc2_ in this.selectedBodies)
            {
               if(param1)
               {
                  this.outline(_loc2_,null,null);
               }
               else
               {
                  this.outline(_loc2_,this.selectGlowFilter,this.selectColourFilter,this.selectShadowFilter);
               }
            }
         }
      }
      
      private function outline(param1:b2Body, param2:GlowFilter, param3:ColorMatrixFilter, param4:DropShadowFilter = null) : void
      {
         var _loc5_:userData = null;
         var _loc6_:Array = null;
         _loc5_ = userData(param1.GetUserData());
         if(!_loc5_ || !_loc5_.graphic)
         {
            return;
         }
         if(_loc5_.graphic)
         {
            _loc5_.graphic.filters = [];
         }
         if(_loc5_.name == "invisiblesquare" || GameState.paused && _loc5_.invisible)
         {
            GameState.hullHandler.drawHull(_loc5_.hull,(param1.GetPosition().x * Physics.scale + this.m_sprite.x) / Physics.scale,(param1.GetPosition().y * Physics.scale + this.m_sprite.y) / Physics.scale,1,param1.GetAngle(),this.particlesBMD,4293848814);
         }
         if(this.detailBody == param1 && GameState.ui.menuObject.visible && GameState.ui.menuObject.alpha > 0 && GameState.ui.menuObject.title == "Detail Skin")
         {
            return;
         }
         if(GameState.stamping)
         {
            return;
         }
         if(Boolean(_loc5_) && Boolean(_loc5_.hull))
         {
            if(Boolean(!param2 && !param3 || World.toggleBlueprint && GameState.paused || _loc5_.invisible) || Boolean(World.toggleSelectionGlow == 0) || _loc5_.graphic.alpha == 0)
            {
               GameState.hullHandler.drawHull(_loc5_.hull,(param1.GetPosition().x * Physics.scale + this.m_sprite.x) / Physics.scale,(param1.GetPosition().y * Physics.scale + this.m_sprite.y) / Physics.scale,1,param1.GetAngle(),this.particlesBMD,4293848814);
            }
            else
            {
               _loc6_ = [];
               if(param2)
               {
                  _loc6_.push(param2);
               }
               if(param3)
               {
                  _loc6_.push(param3);
               }
               if(param4)
               {
                  _loc6_.push(param4);
               }
               _loc5_.graphic.filters = _loc6_;
            }
         }
      }
      
      private function cameraFollow() : void
      {
         var _loc1_:b2Vec2 = null;
         var _loc2_:b2Vec2 = null;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:* = undefined;
         var _loc6_:Number = NaN;
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Vec2 = null;
         var _loc9_:Number = NaN;
         if(GameState.environment is MainMenu)
         {
            return;
         }
         if(GameState.environment)
         {
            if(GameState.followBody)
            {
               _loc1_ = GameState.followBody.GetPosition().Copy();
               _loc1_.Multiply(Physics.scale);
               this.cam.x = GameState.width * 0.5 - (_loc1_.x - this.cameraVel.x) * this.cam.scaleX;
               this.cam.y = GameState.height * 0.5 - (_loc1_.y - this.cameraVel.y) * this.cam.scaleY;
               _loc2_ = GameState.followBody.GetLinearVelocity();
               if(TimeLord.speed == 0)
               {
                  _loc2_ = new b2Vec2();
               }
               if(_loc2_.Length() > 10)
               {
                  this.cameraVel.x += _loc2_.x * 0.1;
                  this.cameraVel.y += _loc2_.y * 0.1;
               }
               this.cameraVel.x *= 0.9;
               this.cameraVel.y *= 0.9;
            }
            if(!(GameState.environment is OpenWorld))
            {
               if(Boolean(GameState.followBody) && (this.panLeft || this.panRight || this.panUp || this.panDown))
               {
                  GameState.followBody = null;
               }
               if(this.panLeft)
               {
                  this.cameraVel.x -= Vars.cameraAcceleration;
               }
               if(this.panRight)
               {
                  this.cameraVel.x += Vars.cameraAcceleration;
               }
               if(this.panUp)
               {
                  this.cameraVel.y -= Vars.cameraAcceleration;
               }
               if(this.panDown)
               {
                  this.cameraVel.y += Vars.cameraAcceleration;
               }
               if(this.panMouseLeft)
               {
                  this.cameraVel.x -= Vars.cameraAcceleration;
               }
               if(this.panMouseRight)
               {
                  this.cameraVel.x += Vars.cameraAcceleration;
               }
               if(this.panMouseUp)
               {
                  this.cameraVel.y -= Vars.cameraAcceleration;
               }
               if(this.panMouseDown)
               {
                  this.cameraVel.y += Vars.cameraAcceleration;
               }
               _loc3_ = GameState.environment.floor;
               _loc4_ = _loc3_ && World.toggleFloorPan == 1 || !_loc3_;
               if(!_loc4_)
               {
                  _loc4_ = this.cam.y > 0;
                  _loc9_ = GameState.height * (1 - this.cam.scaleX);
                  if(this.cam.y < _loc9_)
                  {
                     this.cameraVel.y = 0;
                     this.cam.y = _loc9_;
                  }
               }
               _loc5_ = this.panLeft || this.panRight || this.panUp || this.panDown || this.panMouseDown || this.panMouseUp || this.panMouseLeft || this.panMouseRight;
               if(this.panLeft && this.cameraVel.x > 0)
               {
                  _loc5_ = false;
               }
               if(this.panRight && this.cameraVel.x < 0)
               {
                  _loc5_ = false;
               }
               if(this.panUp && this.cameraVel.y > 0)
               {
                  _loc5_ = false;
               }
               if(this.panDown && this.cameraVel.y < 0)
               {
                  _loc5_ = false;
               }
               if(_loc5_)
               {
                  this.CameraCull();
               }
               if(_loc5_)
               {
                  this.cameraVel.Multiply(1 + 0.01 * Vars.cameraAcceleration);
               }
               else
               {
                  this.cameraVel.Multiply(0.9);
               }
               _loc6_ = 25;
               if(this.cameraVel.x > _loc6_)
               {
                  this.cameraVel.x = _loc6_;
               }
               if(this.cameraVel.x < -_loc6_)
               {
                  this.cameraVel.x = -_loc6_;
               }
               if(this.cameraVel.y > _loc6_)
               {
                  this.cameraVel.y = _loc6_;
               }
               if(this.cameraVel.y < -_loc6_)
               {
                  this.cameraVel.y = -_loc6_;
               }
               this.cam.x -= this.cameraVel.x;
               this.cam.y -= this.cameraVel.y;
               if(GameState.paused)
               {
                  TimeLord.pauseGrid.Update();
               }
               _loc7_ = GameState.environment.minPan.Copy();
               _loc8_ = GameState.environment.maxPan.Copy();
               _loc7_.Multiply(this.cam.scaleX);
               _loc8_.Multiply(this.cam.scaleX);
               if(this.cam.x > _loc8_.x)
               {
                  this.cameraVel.x *= -0.5;
                  this.cam.x = _loc8_.x;
               }
               else if(this.cam.x < _loc7_.x + GameState.width)
               {
                  this.cameraVel.x *= -0.5;
                  this.cam.x = _loc7_.x + GameState.width;
               }
               if(this.cam.y > _loc8_.y)
               {
                  this.cameraVel.y *= -0.5;
                  this.cam.y = _loc8_.y;
               }
               else if(this.cam.y < _loc7_.y)
               {
                  this.cameraVel.y *= -0.5;
                  this.cam.y = _loc7_.y;
               }
            }
            this.bgBM.x = this.cam.x * Tweak.BackgroundScroll;
            this.bgBM.y = this.cam.y * Tweak.BackgroundScroll;
            if(TimeLord.speed == 0 && this.cameraVel.Length() > 0)
            {
               TimeLord.pauseGrid.Update();
            }
            if(this.cameraVel.Length() < 0.1)
            {
               this.cameraVel.x = 0;
               this.cameraVel.y = 0;
            }
         }
      }
      
      private function drawParticles() : void
      {
         var _loc2_:ParticleSystem = null;
         var _loc3_:MyLittleParticle = null;
         var _loc4_:Vector.<MyLittleParticle> = null;
         var _loc5_:ParticleSystem = null;
         var _loc6_:int = 0;
         var _loc7_:Point = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:BitmapData = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:BitmapData = null;
         var _loc14_:int = 0;
         var _loc1_:b2Vec2 = new b2Vec2(this.cam.x,this.cam.y);
         if(GameState.environment)
         {
            for each(_loc5_ in GameState.environment.public::particleSystems)
            {
               if(_loc5_.particles != 0)
               {
                  _loc4_ = _loc5_.holder;
                  _loc6_ = 0;
                  while(_loc6_ < _loc4_.length)
                  {
                     _loc3_ = _loc4_[_loc6_];
                     _loc7_ = new Point(_loc3_.x,_loc3_.y);
                     _loc7_.x = GraphicUtils.camX(_loc7_.x);
                     _loc7_.y = GraphicUtils.camY(_loc7_.y);
                     _loc7_.x -= _loc5_.pWHalf;
                     _loc7_.y -= _loc5_.pHHalf;
                     this.particlesBMD.copyPixels(_loc5_.graphic,new Rectangle(0,0,_loc5_.pW,_loc5_.pH),_loc7_,null,null,true);
                     _loc6_++;
                  }
               }
            }
         }
         for each(_loc2_ in GameState.particles.systems)
         {
            _loc8_ = _loc2_.particles;
            if(_loc8_ != 0)
            {
               _loc2_.update(Vars.gravity,Vars.wind,TimeLord.speed);
               _loc4_ = _loc2_.holder;
               _loc9_ = int(_loc4_.length);
               _loc6_ = 0;
               while(_loc6_ < _loc9_)
               {
                  _loc3_ = _loc4_[_loc6_];
                  if(_loc2_.simple)
                  {
                     this.particlesBMD.setPixel32(GraphicUtils.camX(_loc3_.x),GraphicUtils.camY(_loc3_.y),_loc2_.pixelColour);
                  }
                  else if(World.toggleSmoothBlood == 1 && _loc2_.name == "blood")
                  {
                     if(!_loc3_.sprite)
                     {
                        _loc3_.sprite = "smooth_blood_" + Tweak.bloodColour;
                     }
                     _loc10_ = R.getSprite(_loc3_.sprite);
                     _loc11_ = _loc10_.width;
                     _loc12_ = _loc10_.height;
                     if(_loc10_)
                     {
                        this.bloodBMD.copyPixels(_loc10_,new Rectangle(0,0,_loc11_,_loc12_),new Point(GraphicUtils.camX(_loc3_.x) - _loc11_ * 0.5,GraphicUtils.camY(_loc3_.y) - _loc12_ * 0.5),null,null,true);
                     }
                  }
                  else if(_loc2_.name == "blood")
                  {
                     if(!_loc3_.sprite)
                     {
                        _loc3_.health = -9000;
                     }
                     else
                     {
                        _loc13_ = R.getSprite(_loc3_.sprite);
                        if(_loc13_)
                        {
                           this.particlesBMD.copyPixels(_loc13_,_loc2_.particlerect,new Point(GraphicUtils.camX(_loc3_.x) - _loc2_.pWHalf,GraphicUtils.camY(_loc3_.y) - _loc2_.pHHalf),null,null,true);
                        }
                     }
                  }
                  else if(_loc2_.smooth)
                  {
                     GraphicUtils.efla(this.particlesBMD,_loc3_.px,_loc3_.py,_loc3_.x,_loc3_.y,_loc3_.colour);
                  }
                  else
                  {
                     this.particlesBMD.copyPixels(_loc2_.graphic,_loc2_.particlerect,new Point(GraphicUtils.camX(_loc3_.x) - _loc2_.pWHalf,GraphicUtils.camY(_loc3_.y) - _loc2_.pHHalf),null,null,true);
                  }
                  _loc6_++;
               }
            }
         }
         if(GameState.particles.simpleParticleSystem.particles > 0)
         {
            GameState.particles.simpleParticleSystem.update(Vars.gravity,Vars.wind,TimeLord.speed);
            _loc4_ = GameState.particles.simpleParticleSystem.holder;
            _loc14_ = 0;
            while(_loc14_ < _loc4_.length)
            {
               _loc3_ = _loc4_[_loc14_];
               this.particlesBMD.setPixel32(GraphicUtils.camX(_loc3_.x),GraphicUtils.camY(_loc3_.y),_loc3_.colour);
               _loc14_++;
            }
         }
         if(World.toggleSmoothBlood == 1 && (World.togglePhysicsBlood == 1 || ParticleSystem(GameState.particles.systems[0]).particles > 0))
         {
            this.bloodBMD.lock();
            if(Tweak.bloodSmoothing > 0.01)
            {
               this.bloodBMD.threshold(this.bloodBMD,this.bloodBMD.rect,new Point(),"<",4278190080 * Tweak.bloodSmoothing,0,4294967295,false);
            }
            this.particlesBMD.copyPixels(this.bloodBMD,this.bloodBMD.rect,new Point(),null,null,true);
            this.bloodBMD.fillRect(this.bloodBMD.rect,0);
            this.bloodBMD.unlock();
         }
      }
      
      public function startDragging(param1:b2Body, param2:Boolean = false, param3:Number = 0.7, param4:Number = 5) : *
      {
         var _loc5_:userData = null;
         var _loc6_:b2MouseJointDef = null;
         var _loc7_:Number = NaN;
         var _loc8_:b2Body = null;
         if(!this.canThrowPower)
         {
            return;
         }
         _loc5_ = userData(param1.GetUserData());
         if(_loc5_.armour)
         {
            _loc8_ = _loc5_.armour.attachedBody;
            if((Boolean(_loc8_)) && !userData(_loc8_.GetUserData()).dead)
            {
               param1 = _loc8_;
            }
         }
         this.draggingFirearm = false;
         if(_loc5_.trigger is Gun && _loc5_.name != "gunsword" && _loc5_.name != "pulverizer")
         {
            this.draggingFirearm = true;
         }
         param1.SetBullet(true);
         _loc6_ = new b2MouseJointDef();
         _loc6_.dampingRatio = param3;
         _loc6_.frequencyHz = param4;
         _loc6_.userData = new jointUserData("mouse");
         _loc6_.body1 = Physics.world.GetGroundBody();
         _loc6_.body2 = param1;
         _loc6_.target.Set(this.mouseXWorld,this.mouseYWorld);
         if(param2)
         {
            this.draggingAiming = true;
         }
         else
         {
            this.draggingAiming = false;
         }
         if(GameState.roleplaying)
         {
            _loc7_ = Vars.dragDoll * 500;
         }
         else
         {
            _loc7_ = Vars.dragEditor * 20000 * param1.GetMass();
            if(_loc7_ < 100000)
            {
               _loc7_ = 100000;
            }
         }
         _loc6_.maxForce = _loc7_;
         _loc6_.timeStep = Tweak.m_timeStep;
         this.m_mouseJoint = Physics.world.CreateJoint(_loc6_) as b2MouseJoint;
         param1.WakeUp();
      }
      
      public function MouseDrag() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:int = 0;
         var _loc3_:b2Body = null;
         var _loc4_:int = 0;
         var _loc5_:b2Vec2 = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Body = null;
         var _loc9_:userData = null;
         var _loc10_:b2Vec2 = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:* = undefined;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:b2JointEdge = null;
         if(GameState.mouseDown && !this.m_mouseJoint && !GameState.spawning && !this.effecting)
         {
            if(!this.contract.allowDragging(new b2Vec2(this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale)))
            {
               return;
            }
            _loc1_ = Body.GetOne(this.mouseXWorld,this.mouseYWorld,GameState.paused,true);
            if(Boolean(_loc1_) && TimeLord.speed != 0)
            {
               if(Tool.isStab)
               {
                  this.startDragging(_loc1_,false,0.2,0.4);
               }
               else
               {
                  this.startDragging(_loc1_);
               }
            }
            if(Boolean(_loc1_ && TimeLord.speed == 0) && Boolean(!this.pauseMoving) && this.canThrowPower)
            {
               this.pauseMoving = true;
               if(this.selectedBodies.indexOf(_loc1_) == -1)
               {
                  this.selectedBodies.push(_loc1_);
                  this.previousBody = _loc1_;
               }
               _loc2_ = int(this.selectedBodies.length);
               _loc4_ = 0;
               for(; _loc4_ < _loc2_; _loc4_++)
               {
                  _loc3_ = this.selectedBodies[_loc4_];
                  if(GameState.stamping)
                  {
                     if(_loc3_ == this.detailBody)
                     {
                        continue;
                     }
                  }
                  _loc5_ = new b2Vec2(_loc3_.GetPosition().x - this.mouseXWorld,_loc3_.GetPosition().y - this.mouseYWorld);
                  _loc6_ = new b2Vec2(_loc3_.GetPosition().x,_loc3_.GetPosition().y);
                  this.pauseMovingBodies.push([_loc3_,_loc5_,_loc6_]);
               }
            }
         }
         if(this.m_mouseJoint)
         {
            if(!this.contract.allowDragging(new b2Vec2(this.mouseXWorld * Physics.scale,this.mouseYWorld * Physics.scale)))
            {
               this.stopDragging(false);
               return;
            }
            _loc7_ = new b2Vec2(this.mouseXWorld,this.mouseYWorld);
            this.m_mouseJoint.SetTarget(_loc7_);
            _loc8_ = this.m_mouseJoint.GetBody2();
            if(GameState.paused && _loc8_.IsStatic())
            {
               _loc8_.SetXForm(new b2Vec2(this.mouseXWorld,this.mouseYWorld),_loc8_.GetAngle());
            }
            _loc9_ = _loc8_.GetUserData();
            if(_loc9_.name == "boxingglove" && Tool.isBlunt || _loc9_.name == "sawblade" && Tool.isSharp || _loc9_.name == "ricochet" && Tool.isRicochet)
            {
               _loc10_ = _loc8_.GetPosition();
               if(Math.abs(_loc10_.y - this.mouseYWorld) > 0.1 || Math.abs(_loc10_.x - this.mouseXWorld) > 0.1)
               {
                  _loc11_ = _loc8_.GetAngle();
                  _loc12_ = Math.atan2(_loc10_.y - this.mouseYWorld,_loc10_.x - this.mouseXWorld);
                  if(userData(_loc8_.GetUserData()).flipped)
                  {
                     _loc12_ += Vars.PI;
                  }
                  if(_loc12_ > 150 * Vars.toRadians && _loc11_ < -150 * Vars.toRadians)
                  {
                     _loc11_ = -_loc11_;
                  }
                  else if(_loc11_ > 150 * Vars.toRadians && _loc12_ < -150 * Vars.toRadians)
                  {
                     _loc11_ = -_loc11_;
                  }
                  _loc13_ = _loc12_ - _loc11_;
                  if(Tool.isBlunt)
                  {
                     _loc14_ = 45 * Vars.toRadians;
                  }
                  else if(this.draggingFirearm)
                  {
                     _loc14_ = 5 * Vars.toRadians;
                  }
                  else
                  {
                     _loc14_ = 15 * Vars.toRadians;
                  }
                  _loc15_ = _loc11_ + Math.min(_loc14_,Math.max(-_loc14_,_loc13_));
                  _loc8_.SetXForm(_loc10_,_loc15_);
               }
            }
            if(this.draggingFirearm)
            {
               if(!this.draggingAiming)
               {
                  _loc8_.SetAngularVelocity(0);
                  _loc16_ = _loc8_.GetJointList();
                  while(_loc16_)
                  {
                     if(!(_loc16_.joint is b2MouseJoint))
                     {
                        _loc16_.joint.GetBody1().SetAngularVelocity(0);
                        _loc16_.joint.GetBody2().SetAngularVelocity(0);
                     }
                     _loc16_ = _loc16_.next;
                  }
               }
            }
            else
            {
               _loc8_.SetAngularVelocity(_loc8_.GetAngularVelocity() * 0.99);
               if(this.draggingAiming)
               {
                  _loc8_.SetAngularVelocity(0);
               }
            }
         }
      }
      
      public function stopAiming() : void
      {
         var _loc1_:b2Body = null;
         for each(_loc1_ in this.selectedBodies)
         {
            _loc1_.m_linearDamping = 0;
            _loc1_.m_angularDamping = 0;
            _loc1_.WakeUp();
         }
         this.selectedBodies = new Vector.<b2Body>();
         this.scalingPos = null;
         this.toolSprite.graphics.clear();
      }
   }
}

