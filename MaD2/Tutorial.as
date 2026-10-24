package
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.yahoo.astra.fl.controls.Tree;
   import com.yahoo.astra.fl.controls.treeClasses.LeafNode;
   import com.yahoo.astra.fl.controls.treeClasses.TreeDataProvider;
   import fl.events.ListEvent;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class Tutorial extends Sprite
   {
      
      private var tutorialMain:Window;
      
      private var tutorialHelp:Window;
      
      private var tempMenu:Window;
      
      private var currentTutorialID:int = -1;
      
      private var currentTutorialText:Array = [];
      
      private var currentTutorialStep:int = 0;
      
      private const tutorialNames:Array = ["Exit Tutorial","","Spawning","Reseting","Pausing","Tools","Cutting","Jointing","Equipping","Shooting and Triggering","Linking","Saving","Controls and Keymapping","Custom Items"];
      
      private const tutorialShortNames:Array = ["Nothing","spacer","Spawning","Clearing","Pausing","Tools","Cutting","Jointing","Equipping","Triggering","Portals","Saving","Controls","Custom"];
      
      internal var faketimer:int = -1;
      
      public function Tutorial()
      {
         super();
         GameState.menuHandler.getMenu("Main").close();
         this.setupTutorialMenu();
         this.setupMainMenu();
         this.addChild(GameState.menuHandler.getMenu("Tutorials"));
         this.addChild(GameState.menuHandler.getMenu("Tutorial"));
         this.tutorialHelp.alpha = 0;
         this.tutorialHelp.close();
         this.addEventListener(Event.ENTER_FRAME,this.update);
      }
      
      private function update(param1:Event) : void
      {
         if(this.currentTutorialID == -1)
         {
            this.goToTut(0);
            GameState.tutorialActive = true;
            this.removeEventListener(Event.ENTER_FRAME,this.update);
         }
      }
      
      private function setupMainMenu() : void
      {
         var _loc4_:XML = null;
         var _loc1_:XML = <node label="Root Node"></node>;
         var _loc2_:int = int(this.tutorialNames.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = <node/>;
            _loc4_.@label = this.tutorialNames[_loc3_];
            _loc4_.@func = this.tutorialShortNames[_loc3_];
            _loc4_.@center = "true";
            _loc1_.appendChild(_loc4_);
            _loc3_++;
         }
         this.tutorialMain = new Window(400,400,"Tutorials",false,false);
         this.tutorialMain.title = "Tutorial";
         this.tutorialMain.center();
         this.tutorialMain.lock();
         this.tutorialMain.addTree("buttons",_loc1_,396,0,30).selectable = false;
         this.tutorialMain.getTree("buttons").rowHeight = 28;
         this.tutorialMain.getTree("buttons").addEventListener(ListEvent.ITEM_CLICK,this.handleMenuClick);
         this.tutorialMain.getTree("buttons").addEventListener(ListEvent.ITEM_DOUBLE_CLICK,this.handleMenuClick);
      }
      
      private function setupTutorialMenu() : void
      {
         var _loc1_:XML = <node label="Root Node">
									<node label="Back" func="tut_back" ico="icontutorial0"/>
									<node label="Next" func="tut_next" ico="iconnext"/>
									<node label="Previous" func="tut_prev" ico="iconprev"/>
								</node>;
         this.tutorialHelp = new Window(400,100,"Tutorial",false);
         this.tutorialHelp.x = 24;
         this.tutorialHelp.y = 24;
         var _loc2_:TextField = this.tutorialHelp.addField("help","",null,192);
         _loc2_.border = false;
         var _loc3_:TextFormat = new TextFormat();
         _loc3_.align = TextFormatAlign.CENTER;
         _loc2_.defaultTextFormat = _loc3_;
         _loc2_.setTextFormat(_loc3_);
         this.tutorialHelp.addTree("buttons",_loc1_);
         this.tutorialHelp.getTree("buttons").addEventListener(ListEvent.ITEM_CLICK,this.handleMenuClick);
         this.tutorialHelp.getTree("buttons").selectable = false;
      }
      
      private function setupTempMenu() : void
      {
         if(GameState.menuHandler.getMenu("Practice") != null)
         {
            return;
         }
         this.tempMenu = new Window(300,240,"Practice");
         this.tempMenu.x = GameState.width - this.tempMenu.actualWidth - 24;
         this.tempMenu.y = GameState.height - this.tempMenu.height - 24;
         var _loc1_:* = this.tempMenu.addField("Example text","Text example");
         this.tempMenu.movePosition(4);
         this.tempMenu.addInput("Text input example","Potato",null,null,"a-zA-Z",9000);
         this.tempMenu.movePosition(4);
         this.tempMenu.addInput("Number input example",10);
         this.tempMenu.movePosition(4);
         var _loc2_:XML = <node label="Root Node">
									<node label="Button Category">
											<node label="Button example"/>
											<node label="Second button example"/>
									</node>
									<node label="Another button example"/>
									<node label="One more button example"/>
					</node>;
         this.tempMenu.movePosition(4);
         var _loc3_:Tree = this.tempMenu.addTree("Example",_loc2_,100);
         _loc3_.selectable = false;
         this.addChild(this.tempMenu);
      }
      
      private function handleMenuClick(param1:ListEvent) : void
      {
         var _loc2_:String = null;
         if(param1.item is LeafNode)
         {
            _loc2_ = param1.item.func;
            if(_loc2_)
            {
               if(_loc2_ != "Nothing")
               {
                  this.tutorialMain.visible = false;
                  this.tutorialHelp.open();
               }
               if(_loc2_ == "Nothing")
               {
                  this.setupTutorialStuff("reset");
                  this.tutorialMain.close();
                  this.tutorialHelp.close();
                  GameState.menuHandler.getMenu("Main").open();
                  GameState.menuHandler.getMenu("Main").alpha = 1;
                  GameState.menuHandler.getMenu("Toolbox").alpha = 1;
                  GameState.menuHandler.getMenu("Main").open();
                  GameState.menuHandler.getMenu("Toolbox").open();
                  Main.instance.reset();
                  GameState.tutorialActive = false;
                  GameState.menuHandler.resetDocks();
               }
               else if(_loc2_ == "tut_main")
               {
                  this.tutorialMain.visible = true;
                  this.tutorialMain.moveToTop();
                  this.setupTutorialStuff("reset");
               }
               else if(_loc2_ == "tut_next")
               {
                  if(this.currentTutorialStep < this.currentTutorialText.length - 1)
                  {
                     this.nextStep();
                  }
                  else if(this.currentTutorialID < this.tutorialNames.length - 1)
                  {
                     this.nextTutorial();
                  }
               }
               else if(_loc2_ == "tut_prev")
               {
                  if(this.currentTutorialStep > 0)
                  {
                     this.prevStep();
                  }
                  else if(this.currentTutorialID > 0)
                  {
                     this.prevTutorial();
                  }
               }
               else
               {
                  this.goToTut(this.tutorialShortNames.indexOf(_loc2_));
               }
            }
         }
      }
      
      private function goToTut(param1:int) : void
      {
         Main.instance.reset(false);
         this.currentTutorialID = param1;
         if(this.currentTutorialID != -1)
         {
            this.currentTutorialStep = 0;
            this.setupTutorialStuff(this.tutorialShortNames[this.currentTutorialID]);
            this.setupTutorialStep(this.currentTutorialName);
            Main.instance.CameraHome();
            this.handleTreeXML();
         }
      }
      
      private function get currentTutorialName() : String
      {
         if(this.currentTutorialID == -1)
         {
            return "";
         }
         return this.tutorialShortNames[this.currentTutorialID];
      }
      
      private function nextTutorial() : void
      {
         ++this.currentTutorialID;
         this.goToTut(this.currentTutorialID);
      }
      
      private function prevTutorial() : void
      {
         --this.currentTutorialID;
         this.goToTut(this.currentTutorialID);
      }
      
      private function nextStep() : void
      {
         ++this.currentTutorialStep;
         this.tutorialHelp.setValue("help",this.currentTutorialText[this.currentTutorialStep]);
         this.handleTreeXML();
         this.setupTutorialStep(this.currentTutorialName);
      }
      
      private function prevStep() : void
      {
         --this.currentTutorialStep;
         this.tutorialHelp.setValue("help",this.currentTutorialText[this.currentTutorialStep]);
         this.handleTreeXML();
         this.setupTutorialStep(this.currentTutorialName);
      }
      
      private function handleTreeXML() : void
      {
         var _loc2_:XML = null;
         var _loc1_:XML = <node label="Root Node"></node>;
         if(this.currentTutorialStep < this.currentTutorialText.length - 1)
         {
            _loc2_ = <node/>;
            _loc2_.@label = "Next step";
            _loc2_.@func = "tut_next";
            _loc2_.@ico = "iconnext";
            _loc2_.@center = "true";
            _loc2_.@noReadabilityTint = "true";
            _loc1_.appendChild(_loc2_);
         }
         else
         {
            _loc2_ = <node/>;
            _loc2_.@label = "";
            _loc2_.@func = "spacer";
            _loc1_.appendChild(_loc2_);
         }
         if(this.currentTutorialStep > 0)
         {
            _loc2_ = <node/>;
            _loc2_.@label = "Previous step";
            _loc2_.@func = "tut_prev";
            _loc2_.@ico = "iconprev";
            _loc2_.@center = "true";
            _loc2_.@noReadabilityTint = "true";
            _loc1_.appendChild(_loc2_);
         }
         else
         {
            _loc2_ = <node/>;
            _loc2_.@label = "";
            _loc2_.@func = "spacer";
            _loc1_.appendChild(_loc2_);
         }
         _loc2_ = <node/>;
         _loc2_.@label = "Tutorials list";
         _loc2_.@func = "tut_main";
         _loc2_.@ico = "icontutorial0";
         _loc2_.@center = "true";
         _loc2_.@noReadabilityTint = "true";
         _loc1_.appendChild(_loc2_);
         this.tutorialHelp.getTree("buttons").dataProvider = new TreeDataProvider(_loc1_);
      }
      
      private function setupTutorialStuff(param1:String) : void
      {
         var _loc3_:Window = null;
         var _loc4_:Window = null;
         var _loc5_:Window = null;
         var _loc6_:Window = null;
         var _loc7_:Window = null;
         var _loc8_:Window = null;
         var _loc9_:Window = null;
         var _loc10_:Window = null;
         var _loc11_:String = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:Window = null;
         var _loc15_:String = null;
         var _loc16_:String = null;
         var _loc17_:String = null;
         var _loc18_:int = 0;
         var _loc19_:String = null;
         var _loc20_:String = null;
         var _loc21_:String = null;
         var _loc22_:String = null;
         var _loc23_:String = null;
         var _loc24_:String = null;
         var _loc25_:String = null;
         var _loc26_:String = null;
         var _loc27_:String = null;
         var _loc28_:String = null;
         var _loc29_:String = null;
         var _loc30_:String = null;
         var _loc31_:String = null;
         var _loc32_:String = null;
         var _loc33_:String = null;
         var _loc34_:String = null;
         var _loc35_:String = null;
         var _loc36_:String = null;
         var _loc37_:String = null;
         var _loc38_:String = null;
         var _loc39_:String = null;
         var _loc40_:String = null;
         var _loc41_:String = null;
         var _loc42_:String = null;
         var _loc43_:String = null;
         var _loc44_:String = null;
         var _loc45_:String = null;
         var _loc46_:Window = null;
         if(param1 != "Pausing" && GameState.paused)
         {
            TimeLord.unpause();
         }
         if(param1 != "Menus" && Boolean(this.tempMenu))
         {
            this.tempMenu.close();
         }
         if(param1 != "Spawning")
         {
            _loc3_ = GameState.menuHandler.getMenu("Spawn");
            if(Boolean(_loc3_) && _loc3_.visible)
            {
               _loc3_.close();
            }
            _loc4_ = GameState.menuHandler.getMenu("Properties");
            if((Boolean(_loc4_)) && _loc4_.visible)
            {
               _loc4_.close();
            }
            _loc5_ = GameState.menuHandler.getMenu("Library");
            if((Boolean(_loc5_)) && _loc5_.visible)
            {
               _loc5_.close();
            }
         }
         if(param1 != "Saving")
         {
            _loc3_ = GameState.menuHandler.getMenu("Spawn");
            if(Boolean(_loc3_) && _loc3_.visible)
            {
               _loc3_.close();
            }
            _loc6_ = GameState.menuHandler.getMenu("Save");
            if((Boolean(_loc6_)) && _loc6_.visible)
            {
               _loc6_.close();
            }
         }
         if(param1 != "Keymapping")
         {
            _loc7_ = GameState.menuHandler.getMenu("Controls");
            if((Boolean(_loc7_)) && _loc7_.visible)
            {
               _loc7_.close();
            }
            _loc8_ = GameState.menuHandler.getMenu("Settings");
            if((Boolean(_loc8_)) && _loc8_.visible)
            {
               _loc8_.close();
            }
         }
         if(param1 != "Spawning")
         {
            _loc9_ = GameState.menuHandler.getMenu("Properties");
            _loc9_.setValue("% Scale",100);
            _loc9_.setValue("% Weight",100);
            _loc9_.setValue("% Friction",50);
            _loc9_.setValue("% Bounce",20);
            _loc9_.setValue("° Angle",0);
            _loc9_.setValue("Damp Speed",0);
            _loc9_.setValue("Damp Spin",0);
            Vars.objSize = 1;
            Vars.objAngle = 0;
            Vars.objDensity = 1;
            Vars.objFriction = 0.5;
            Vars.objRestitution = 0.2;
            Vars.objDampLinear = 0;
            Vars.objDampAngular = 0;
         }
         var _loc2_:Array = [];
         if(param1 == "Tutorial")
         {
            _loc2_ = ["Welcome to the tutorial tutorial.\n\nNavigate this and all other tutorials using the buttons below.\n\nGo to the next step to continue.","The Tutorials list contains all the separate tutorials.\n\nClicking on any will start (or restart) that particular tutorial.\n\nThis menu will then guide you through the selected tutorial."];
         }
         else if(param1 == "Quickstart")
         {
            _loc2_ = ["Welcome to MaD2, a physics sandbox with over 2000 items for building, destroying, or of course mutilating ragdolls.","The main menu (left) contains all the submenus:\n\n[Spawn]\nTweak & Spawn items.\n[Library]\nBrowse categorized items.\n[Environment]\nTweak & Change environment\n[Content]\nSave & Load content created in the game.\n[Settings]\nConfigure things to your liking.","The toolbox (right) contains ways to interact with the game:\n\n\n[Reset] - Clears the screen and spawns a new doll.\n[Play/Pause] - Toggles passage of time, and physics.\n[Slowmotion On/Off] - Toggles speed of game. \n[Tools] - Interact with items.\n[Joints] - Connect items together, or to the background.\n[Powers] - Unleash destructive powers."];
            this.tutorialHelp.center();
            _loc10_ = GameState.menuHandler.getMenu("Main");
            _loc10_.open();
         }
         else if(param1 == "Menus")
         {
            _loc2_ = ["All the menus in MaD2 can be dragged and minimised, and most of them can be closed.\n\nThere\'s a practice menu set up for you in the lower right hand corner.\n\nNext couple steps of this tutorial will elaborate on what you can actually do with the practice menu.","To move a menu, simply grab any empty spot on the menu, such as the title bar, and move your mouse.\n\nDon\'t worry about misplacing your menus, they can not be dragged outside the screen.","To minimise a menu to save some space,\nclick the [-] button top-right of a menu.\n\nTo maximise it again, press the same button, now marked with [+].","Closing a menu is done with the [X] button.\n\nSome menus don\'t have a close button at all, so you can\'t end up permanently menuless.\n\n(The practice menu will reappear upon closing for tutorial purposes.)","The menus can contain various different items, such as:\nText fields\nInput fields\nNumber fields\nButtons\netc.\n\nYou can test all of these in the practice menu.","Some buttons are categorised to save space and organise things a bit better. Click on a category to open/close it.\n\nYou might also occasionally encounter a scroll bar due to space limitations or large lists. Scroll it to see all the menu items."];
            this.setupTempMenu();
         }
         else if(param1 == "Spawning")
         {
            _loc2_ = ["To find an item to spawn, browse the Library\'s categories, or use the Spawn menu\'s [search field], [arrow buttons], or [random button].\n\nSpawn items simply by dragging them from the Spawn menu or Library onto the stage.\n\nUse [arrow keys] to scale and rotate and [Tab] to flip the item while dragging it out of the menu.","Spawn settings can be tweaked in the Spawn menu via the [Settings icon].\n\nNote that Weight, Friction, and Bounce can\'t be modified later and require the item to be respawned.","Use the [Properties icon] to apply properties to the item, such as Anti-Gravity or Explosive.\n\nUse [Colours icon] to modify the item\'s colour palette (aka skin.)\n\nMirror the item via the [Flip Icon].\n\nFavourite the item via the [Favourite icon] to spawn it with a single key press later."];
            _loc3_ = GameState.menuHandler.getMenu("Spawn");
            _loc5_ = GameState.menuHandler.getMenu("Library");
            _loc3_.x = GameState.width - _loc3_.actualWidth - 24 - _loc5_.actualWidth;
            _loc3_.y = GameState.height - _loc3_.height - 78;
            _loc5_.x = _loc3_.x + _loc3_.actualWidth + 4;
            _loc5_.y = _loc3_.y;
            _loc3_.open();
            _loc5_.open();
         }
         else if(param1 == "Clearing")
         {
            _loc11_ = Keymap.codeToKeyname(Keymap.nameToCode("reset"));
            _loc2_ = ["Should the screen ever become cluttered with spawned items, shrapnel from general destruction, or bits and pieces of a ragdoll...\n\nPress the [Reset] button in the toolbox in the upper right corner of the screen, or use the hotkey [" + _loc11_ + "].\n\nWhen reseting, all existing items are deleted, the camera will reset, and a brand new ragdoll will automatically spawn in the middle."];
            _loc12_ = 0;
            while(_loc12_ < 4)
            {
               _loc13_ = 0;
               while(_loc13_ < 4)
               {
                  GameState.objects.spawnObject("square",_loc12_ * 100 + 300 + Math.random() * 20 - 10,_loc13_ * 100 + 300 + Math.random() * 10);
                  _loc13_++;
               }
               _loc12_++;
            }
         }
         else if(param1 == "Settings")
         {
            _loc2_ = ["Speed = Simulation speed percentage. 100 means normal speed, 200 would be double.\n\nParticles = Percentage of particles spawned. Lowering this might increase performance. Use very high values at your own risk.\n\nGravity and Wind both apply force to all objects on stage, and both of them can be set to negative values as well.","Toggles:\nSlow Motion = automatic slow motion on hard collisions and other events.\n\nDolls Break = enable or disable ragdolls joints and bodyparts getting damaged (cutting still works).\n\nJoints break = Enable or disable user-created joints breaking when force is applied.","Sounds = Enables or disables sounds.\n\nEffects = Enables or disables persistent effects such as burning and bruising. Enabling may lower performance.\n\nContacts = Disables all collision calculations when unticked, greatly improving performance, but then again pretty much nothing works without collisions."];
            _loc14_ = GameState.menuHandler.getMenu("Settings");
            _loc14_.open();
         }
         else if(param1 == "Pausing")
         {
            _loc15_ = Keymap.codeToKeyname(Keymap.nameToCode("pause"));
            _loc2_ = ["The game is now paused, meaning:\n\n- Items are unaffected by physics.\n\n- Item functionalities won\'t trigger.\n\n- Items can be freely moved around, rotated, and scaled (even through other items.)\n\nUse the [Pause button] in the Toolbox to unpause and pause, or press the pause hotkey [" + _loc15_ + "]."];
            Main.instance.reset(false);
            GameState.objects.spawnObject("square",600,450);
            GameState.objects.spawnObject("square",500,450);
            TimeLord.pause();
            GameState.ui.updateControls();
         }
         else if(param1 == "Selecting")
         {
            _loc16_ = Keymap.codeToKeyname(Keymap.nameToCode("Select"));
            _loc17_ = Keymap.codeToKeyname(Keymap.nameToCode("MultipleSelect"));
            _loc2_ = ["Selecting objects lets you do a multitude of things to them.\n\nThe game has been paused and an array of boxes has been prepared for you to experiment on.","To select objects one by one, hold " + _loc16_ + " and click on an object you want to add to the selection.\n\nClick on a selected object to deselect it.","To select multiple objects at once,\nhold " + _loc17_ + ", click and hold while moving your mouse,\nthen release the mouse to select all objects that fall under the area.\n\nMulti-selecting will override previously selected objects, and multi-selecting an empty area will clear all selected objects.","While the game is paused, all the selected objects will move when dragged.\n\nWhile unpaused selection does not matter and only the object under the mouse will be dragged."];
            Main.instance.reset(false);
            _loc18_ = 0;
            while(_loc18_ < 4)
            {
               GameState.objects.spawnObject("square",600,380 + _loc18_ * 55);
               _loc18_++;
            }
            TimeLord.pause();
         }
         else if(param1 == "Tools")
         {
            _loc19_ = Keymap.codeToKeyname(Keymap.nameToCode("Drag"));
            _loc20_ = Keymap.codeToKeyname(Keymap.nameToCode("Camera"));
            _loc21_ = Keymap.codeToKeyname(Keymap.nameToCode("CameraHome"));
            _loc22_ = Keymap.codeToKeyname(Keymap.nameToCode("CameraIn"));
            _loc23_ = Keymap.codeToKeyname(Keymap.nameToCode("CameraOut"));
            _loc24_ = Keymap.codeToKeyname(Keymap.nameToCode("CameraLeft"));
            _loc25_ = Keymap.codeToKeyname(Keymap.nameToCode("CameraRight"));
            _loc26_ = Keymap.codeToKeyname(Keymap.nameToCode("CameraUp"));
            _loc27_ = Keymap.codeToKeyname(Keymap.nameToCode("CameraDown"));
            _loc28_ = Keymap.codeToKeyname(Keymap.nameToCode("CameraToggle"));
            _loc16_ = Keymap.codeToKeyname(Keymap.nameToCode("Select"));
            _loc17_ = Keymap.codeToKeyname(Keymap.nameToCode("MultipleSelect"));
            _loc29_ = Keymap.codeToKeyname(Keymap.nameToCode("Cut"));
            _loc30_ = Keymap.codeToKeyname(Keymap.nameToCode("Delete"));
            _loc31_ = Keymap.codeToKeyname(Keymap.nameToCode("Delete2"));
            _loc32_ = Keymap.codeToKeyname(Keymap.nameToCode("Scalerotate"));
            _loc33_ = Keymap.codeToKeyname(Keymap.nameToCode("Rotate"));
            _loc34_ = Keymap.codeToKeyname(Keymap.nameToCode("Action"));
            _loc35_ = Keymap.codeToKeyname(Keymap.nameToCode("Aim"));
            _loc36_ = Keymap.codeToKeyname(Keymap.nameToCode("Swing"));
            _loc37_ = Keymap.codeToKeyname(Keymap.nameToCode("Stab"));
            _loc38_ = Keymap.codeToKeyname(Keymap.nameToCode("Details"));
            _loc2_ = ["Tools are a way of interacting with items.\n\nClick on the [Tool icon] in the Toolbox to change tools.\n\nTools are toggled on when selected. Select the Drag Tool to move things again after using another tool.","Drag tool, hotkey [" + _loc19_ + "]\n\nDrag items to move them around\nin both Play and Pause modes.\n\nRelease while dragging to throw items\nin Play mode.\n\nDoll tool is a lower force variant of this tool. Change drag forces in Settings.","Camera tool\nToggle with [" + _loc28_ + "]\nHold with [" + _loc20_ + "]\n(changes to previous Tool on release)\n\nDrag to pan the camera around.\nClick/Right Click to zoom in/out.\nAlternatively use [" + _loc26_ + _loc24_ + _loc27_ + _loc25_ + "] to pan and\n[" + _loc22_ + "] and [" + _loc23_ + "] to zoom in/out.\nUse [" + _loc21_ + "] to reset camera.","Select tool\nToggle with [" + _loc16_ + "]\nHold with [" + _loc17_ + "]\n(changes to previous Tool on release)\n\nClick on an item to select/deselect it.\nDrag and release to select an area of items.\n\nUsed in combination with other tools that can interact with multipler items."
            ,"Scale tool [" + _loc32_ + "]\n\nClick and drag to scale selected items.\n\nRotate tool [" + _loc33_ + "]\n\nClick and drag to rotate selected items.\n\nIf no items are selected, the item under the mouse will be modified.","Cut tool [" + _loc29_ + "].\n\nClick, drag and release to cut items and joints.\n\nCuts can only be made fully through an item, chunks can\'t be carved out.\n\nWhen cutting alive items, the tool will cut wounds when the cut is not fully through the item.","Delete tool [" + _loc30_ + "] or [" + _loc31_ + "]\n\nClick on an object to delete it.\nClick, drag and release to delete an area of objects.\n\nWhen a selected object is clicked, all selected objects will be deleted.\n\n","Aim [" + _loc35_ + "] (for firearms) and\n\nSwing [" + _loc36_ + "] + Stab [" + _loc37_ + "] (for melee) tools\n\nUse to interact with items in very specific ways, to do exactly what the tool names imply.\nHover over tools for usage instructions.","Detail Tool [" + _loc38_ + "]\n\nExposes advanced item functionality, and tweakable values.\n\nSettings can be used to modify force, duration and radius for most items with functionality."
            ,"Triggering and jointing are covered in other tutorial topics."];
            Main.instance.reset(false);
            _loc18_ = 0;
            while(_loc18_ < 4)
            {
               GameState.objects.spawnObject("square",600,380 + _loc18_ * 55);
               _loc18_++;
            }
            TimeLord.unpause();
         }
         else if(param1 == "Cutting")
         {
            _loc29_ = Keymap.codeToKeyname(Keymap.nameToCode("Cut"));
            _loc2_ = ["To cut things, use the Cut tool either by clicking on the [Tool icon] in the toolbox, or by pressing [" + _loc29_ + "].\n\nThen use the mouse (click, drag and release) to cut.","Joints can be cut as well.\n\nCut the rope on the right to start the small contraption.","And obviously, alive items can be cut as well, damaging them and making them bleed.\n\nThere\'s a pile of heads all set up for you on the screen you can test with."];
         }
         else if(param1 == "Jointing")
         {
            _loc39_ = Keymap.codeToKeyname(Keymap.nameToCode("ObjJoint"));
            _loc40_ = Keymap.codeToKeyname(Keymap.nameToCode("RopeJoint"));
            _loc41_ = Keymap.codeToKeyname(Keymap.nameToCode("BGJoint"));
            _loc42_ = Keymap.codeToKeyname(Keymap.nameToCode("RevoluteJoint"));
            _loc15_ = Keymap.codeToKeyname(Keymap.nameToCode("pause"));
            _loc2_ = ["To joint two items together, or one item to the background, select the JOINT TOOL from the toolbox, or by pressing the hotkey (" + _loc39_ + ")\n\nOnce the tool is selected, CLICK on something, DRAG while holding the mouse down, and then RELEASE the mouse to create the joint.","To PIN something in place, select the PIN TOOL from the toolbox, or by pressing the hotkey (" + _loc41_ + ").\n\nOnce the tool is selected, CLICK on any item you want to pin.\n\n(Tip: Heavier items might require multiple pins to stay in place.)","To REVOLUTE something, or create a MOTOR, select the REVOLUTE TOOL, or by pressing the hotkey (" + _loc42_ + ").\n\nRevolute joint requires an additional point on top of the usual two, so the workflow is:\nDRAG (body) + RELEASE (body) + CLICK (anchor).\nAnchor will be the rotation point of the motor, click on either of the circles to make it in the center of the body.","Most joint tools have a quick-use method:\n\n1) Select any joint tool.\n2) Tap the hotkey again while the mouse is on top of an item.\n3) Hold the hotkey down and release it after moving the mouse over a target.\n\n(Pin Joint doesn\'t require two targets, tapping the hotkey twice will be enough.)"];
            _loc18_ = 0;
            while(_loc18_ < 4)
            {
               GameState.objects.spawnObject("square",600,380 + _loc18_ * 55);
               _loc18_++;
            }
            TimeLord.unpause();
         }
         else if(param1 == "Equipping")
         {
            _loc34_ = Keymap.codeToKeyname(Keymap.nameToCode("Action"));
            _loc2_ = ["To start EQUIPPING, select the Trigger Tool from the toolbox, or by pressing [" + _loc34_ + "]\n and click on an arm, or the head.\n\nAn indicator will appear to show that the bodypart is ready to equip.\nDrag any item to the indicator to equip it.\n\nTo unequip, trigger the same bodypart again."];
            GameState.objects.spawnObject("ragdoll",400,400);
            GameState.objects.spawnObject("buckler",500,500,90);
            GameState.objects.spawnObject("vikinghelmet",300,500);
            GameState.objects.spawnObject("trout",200,500);
            TimeLord.unpause();
         }
         else if(param1 == "Triggering")
         {
            _loc34_ = Keymap.codeToKeyname(Keymap.nameToCode("Action"));
            _loc2_ = ["Some items trigger automatically when certain conditions are met.\n\nIf an item has a range, you can see it when the game is paused.\n\nTest automatic triggering by dragging the box close to the Tesla Coil to make it arc.","All items that have actions can be triggered with special trigger items, such as buttons or a variety of sensors.\n\nTest triggering by placing the square on the button to make the pistol shoot.","You can manually trigger any item with an action by selecting the Trigger tool from the toolbox, or by pressing the hotkey (" + _loc34_ + ") and clicking on the item.\n\nTest manual triggering on the items on the screen.","Guns among certain other items require constant triggering to continue working.\n\nTo continously shoot with guns, select the Trigger Tool, click on a blank spot on the screen, and drag your mouse on top of the gun you want to continously trigger.\n\nAlternatively, you can frantically click on a gun to shoot as fast as you want.","You can also trigger any item by pressing the trigger hotkey [" + _loc34_ + "] while dragging an item.\n\nTest it on the items on screen."];
         }
         else if(param1 == "Portals")
         {
            _loc43_ = Keymap.codeToKeyname(Keymap.nameToCode("LinkJoint"));
            _loc2_ = ["Before an item can trigger another item, it must first be linked to it.\n\n(Hint: Links are visible while the game is paused.)","Select the Link tool from the toolbox, or by pressing the hotkey (" + _loc43_ + ").\n\nTo link two items together, click on an item, drag the mouse on top of another item and release to link them.\n\nTest it by linking the button to the cryo grenade and then drag the box on the button to trigger it.","Various items such as Portals require linking before they work in the first place.\n\nTo connect two portals together, select the Link tool from the toolbox, or press the hotkey (" + _loc43_ + ").\n\nThen simply click on one portal, drag the mouse over another portal, and release to link them together.","Once the linking is successful, particles will appear to indicate they\'re active, and you can drag any item over one portal to make it teleport.\n\nThe same item can\'t re-enter the same portal instantly to prevent weird behaviour. This is indicated by particles around the item."];
         }
         else if(param1 == "Linking")
         {
            _loc43_ = Keymap.codeToKeyname(Keymap.nameToCode("LinkJoint"));
            _loc2_ = ["Before an item can trigger another item, it must first be linked to it.\n\n(Hint: Links are visible while the game is paused.)","Select the Link tool from the toolbox, or by pressing the hotkey (" + _loc43_ + ").\n\nTo link two items together, click on an item, drag the mouse on top of another item and release to link them.\n\nTest it by linking the button to the cryo grenade and then drag the box on the button to trigger it."];
         }
         else if(param1 == "Saving")
         {
            _loc44_ = Keymap.codeToKeyname(Keymap.nameToCode("Save"));
            _loc45_ = Keymap.codeToKeyname(Keymap.nameToCode("Load"));
            _loc15_ = Keymap.codeToKeyname(Keymap.nameToCode("pause"));
            _loc2_ = ["To save a level, place some items on the stage and press the Save button, or use the quicksave hotkey (" + _loc44_ + ").\n\nThe game will proceed to encode all intact items (cut items won\'t be saved) and all permanent properties (temporary physics effects and any visual effects won\'t be saved) into a save string.","To load previously saved content, click on the Load Content button and select Favourites (if you have any) or Save History, which stores a rolling list of most recent saves, as well as backup saves from your previous session.\n\nThen unpause the game either via the Toolbox, or by pressing the hotkey (" + _loc15_ + ") to start the level.\n\nPress the Load button to restart the level, or use the quickload hotkey (" + _loc45_ + ")"];
            _loc6_ = GameState.menuHandler.getMenu("Save");
            _loc6_.open();
            _loc6_.x = 500;
            _loc6_.y = this.tutorialHelp.y;
            Main.instance.updateSaveMenu();
            _loc3_ = GameState.menuHandler.getMenu("Spawn");
            _loc3_.open();
            _loc3_.x = 500;
            _loc3_.y = _loc6_.y + _loc6_.height + 44;
         }
         else if(param1 == "Controls")
         {
            _loc2_ = ["Controls are found under Settings.\n\nTo view the list of hotkeys, choose the Keymapping setting, and press the Toggle List button in the menu","To KEYMAP something, choose a key from the list, and double click on a key you want to bind. Then press any key to keymap it, or Esc to cancel keymapping. (Esc can not be mapped, and will always function as the Reset key.)\n\nConflicts are not checked, so you might want to double check the key you\'re setting is not bound yet by pressing it.","Keymaps can be saved so you can bring your own keymap with you in case you have to change computers or whatnot.\n\nTo save or load a keymap, click on the export/import buttons in the Keymap Menu.\n\nYou can also reset the keymap to the newest official version by selecting Reset Keymap and confirming in the popup menu."];
            _loc7_ = GameState.menuHandler.getMenu("Settings");
            _loc7_.toggle();
            _loc7_.x = GameState.width - _loc7_.actualWidth - 24;
            _loc7_.y = GameState.height - _loc7_.height - 164;
            _loc46_ = GameState.menuHandler.getMenu("Keymapping");
            _loc46_.x = _loc7_.x - _loc46_.actualWidth - 4;
            _loc46_.y = _loc7_.y;
         }
         else if(param1 == "Custom")
         {
            _loc38_ = Keymap.codeToKeyname(Keymap.nameToCode("Details"));
            _loc2_ = ["Create a custom item by selecting everything you want to include with the Select Tool, and then using the Detail Tool (" + _loc38_ + ") to Create Custom Item.\n\nThe body you click with the Detail Tool will be the spawning point of the Custom Item.\n\nYou can test creating a custom viking doll below.","After you\'ve created a custom item, you can spawn it by opening [Library > Custom Items] and dragging on its name to spawn it.\n\nIf you wish to modify your custom item, spawn it, edit it, and re-save it with the same name.\n\nIf you wish to delete it, enter the [Manage Items] view."];
         }
         else if(param1 == "Nothing")
         {
            _loc2_ = ["Go back to Main."];
         }
         if(param1 == "reset")
         {
            return;
         }
         this.tutorialMain.getTree("buttons").selectedIndex = this.currentTutorialID;
         this.currentTutorialText = _loc2_;
         this.tutorialHelp.title = this.tutorialNames[this.currentTutorialID] + " (1/" + this.currentTutorialText.length + ")";
         this.tutorialHelp.setValue("help",this.currentTutorialText[this.currentTutorialStep]);
      }
      
      private function setupTutorialStep(param1:String) : void
      {
         var _loc2_:b2Body = null;
         var _loc3_:b2Body = null;
         var _loc4_:b2Body = null;
         var _loc5_:b2Body = null;
         var _loc6_:int = 0;
         var _loc7_:b2Body = null;
         var _loc8_:b2Body = null;
         var _loc9_:b2Body = null;
         var _loc10_:b2Body = null;
         var _loc11_:Window = null;
         var _loc12_:b2Body = null;
         var _loc13_:b2Body = null;
         this.tutorialHelp.title = this.tutorialNames[this.currentTutorialID] + " (" + (this.currentTutorialStep + 1) + "/" + this.currentTutorialText.length + ")";
         if(param1 == "Cutting")
         {
            Main.instance.reset(false);
            if(this.currentTutorialStep == 0)
            {
               IO.loadWorld("MADeNplz71uwyAQAOAXotIB52ALMXTq1ChjMmIXRaQEWoxTtcrDlwOpQ7Nx3Hd-1634YIszQi-Z2ZKyedncWnrk3owAjjCC1FsMaXmvP6BdvPmc4tXFYoKd9WKvLluDAEwC6HO2N1++a6n+8pEK5trs3QZ-c4azFlySj2Wt0ZJisQs97-tXM9sQUorscDQ7gexwMqiA-bicqGnlJfvz2eW6BtfV23W1WyjkBzl1j+x5b54moPz6udnsKI0CWlpONCenD9dWYEdeJw3sxA2Oih1FjRQ7CTOoiRqk+fLnUKrmhpEcKk4Op-HBgWhuB+RkPYDcqB6dbE7I7gQ5OT7OReiOt7m77ib87wbs-bDdMWB3Cu73X9j4krQ=",true,true);
            }
            else if(this.currentTutorialStep == 1)
            {
               Vars.objDampLinear = 9000;
               Vars.objDampAngular = 9000;
               Vars.objDensity = 0;
               _loc2_ = GameState.objects.spawnObject("tripwire",670,450);
               _loc3_ = GameState.objects.spawnObject("assaultm",700,440);
               _loc2_.GetUserData().connected.push(_loc3_);
               _loc3_.GetUserData().connected.push(_loc2_);
               Vars.objDensity = 1;
               Vars.objDampLinear = 0;
               Vars.objDampAngular = 0;
               Vars.objSize = 0.5;
               _loc4_ = GameState.objects.spawnObject("triangle",500,200);
               Vars.objSize = 1;
               _loc5_ = GameState.objects.spawnObject("square",300,450);
               Joints.Distance("objjoint",_loc4_,Physics.world.GetGroundBody(),_loc4_.GetWorldCenter().Copy(),new b2Vec2(_loc4_.GetWorldCenter().x,_loc4_.GetWorldCenter().y - 100 / Physics.scale),2,0);
               Joints.Distance("objjoint",_loc5_,Physics.world.GetGroundBody(),new b2Vec2(_loc5_.GetWorldCenter().x,_loc5_.GetWorldCenter().y - 20 / Physics.scale),new b2Vec2(_loc5_.GetWorldCenter().x,_loc5_.GetWorldCenter().y - 100 / Physics.scale),2,0);
            }
            else if(this.currentTutorialStep == 2)
            {
               _loc6_ = 0;
               while(_loc6_ < 4)
               {
                  GameState.objects.spawnObject("doll_head",600,500 + _loc6_ * 25);
                  _loc6_++;
               }
            }
         }
         else if(param1 == "Triggering")
         {
            Main.instance.reset(false);
            if(this.currentTutorialStep == 0)
            {
               GameState.objects.spawnObject("square",600,380 + _loc6_ * 55);
               _loc7_ = GameState.objects.spawnObject("tesla",350,500);
               userData(_loc7_.GetUserData()).triggered = true;
            }
            else if(this.currentTutorialStep == 1)
            {
               Vars.objDampLinear = 9000;
               Vars.objDampAngular = 9000;
               _loc3_ = GameState.objects.spawnObject("pistol",450,440);
               Vars.objDampLinear = 0;
               Vars.objDampAngular = 0;
               _loc8_ = GameState.objects.spawnObject("button",700,550);
               _loc8_.GetUserData().connected.push(_loc3_);
               _loc3_.GetUserData().connected.push(_loc8_);
               _loc4_ = GameState.objects.spawnObject("square",540,550);
            }
            else if(this.currentTutorialStep == 2)
            {
               Vars.objDampLinear = 9000;
               Vars.objDampAngular = 9000;
               _loc3_ = GameState.objects.spawnObject("lightsaber",450,450,-90);
               _loc3_ = GameState.objects.spawnObject("extinguisher",550,450);
               _loc3_ = GameState.objects.spawnObject("lantern",650,450);
               Vars.objDampLinear = 0;
               Vars.objDampAngular = 0;
            }
            else if(this.currentTutorialStep == 3)
            {
               Vars.objDensity = 0;
               _loc3_ = GameState.objects.spawnObject("pistol",650,200);
               _loc9_ = GameState.objects.spawnObject("revolver",650,300);
               _loc10_ = GameState.objects.spawnObject("flaregun",650,400);
               Vars.objDensity = 1;
            }
            else if(this.currentTutorialStep == 4)
            {
               GameState.objects.spawnObject("paintgun",450,500);
               GameState.objects.spawnObject("fan",550,500);
               GameState.objects.spawnObject("repulsor",650,500);
            }
         }
         else if(param1 == "Linking")
         {
            Main.instance.reset(false);
            if(this.currentTutorialStep == 1)
            {
               Vars.objDampLinear = 1000;
               Vars.objDampAngular = 1000;
               _loc3_ = GameState.objects.spawnObject("cryo",450,440);
               Vars.objDampLinear = 0;
               Vars.objDampAngular = 0;
               _loc8_ = GameState.objects.spawnObject("button",700,550);
               _loc4_ = GameState.objects.spawnObject("square",540,550);
            }
         }
         else if(param1 == "Custom")
         {
            Main.instance.reset(false);
            if(this.currentTutorialStep == 0)
            {
               IO.loadWorld("eNqllE1z2jAQhv+QOmPrwx+j0SWdaXNoOjlkOnDqCCzAibCoLUMzkx/f1QqDQyChrS9YWr3Pvuyute59bbU3isp5a7R3rfram87HlakUTVKR5DSVfWPd/Al2Ummabd26Zm0ar6yeyZl1rlJlmcAjZ0uVyJ22tlM5PnIB4Vb5tjeyqyvTxdfWuUV82+jW13M7BOZ6bVqteJIQBjwQb9RC285I3Xu3q5tqv+wMuOFULlu9rf0zWJUYTaQ36w0wfN8axXI5g//ypG29NSoluHh0deO7YeVmj2aOy7lrvMbXl+93qnLW/lwZXZH7iWKZIPdTxRknt7cKnJG7+PNwBznIw2eVkB9TJUqyzyQHgm7XCGARIIoASCMgPQBAmyUXteU/aFe6ic6T4j3xO84HAqf0GsIZD9Ys0YJA/4LyS/7PZB+0+UfaM3kXzvmYOEcx4K9PfBDn7APxmcwzVz2P5yWjQUyjmP6lOM//Q1xemXlbP9XNcmXs2sS/nXHUJ2JcpXCy29RwA3Sr2tg4FyKJc5GN2Whop9utafRvE87RvMRzlI3PhU/M/OrrDblJYYBuqEop+fItVDhcJOMowyi/EOUYZa+jrV6SSYrTM01xeiYUOzql2FHQZUFXkAmL+0wJVhLrdqZVn0Kb+w3cIthwIHMqXoPFKzDM2REsAjhHcNj/AJyfgDMEh/ahY4FgSAPgNA3kbGw5oQOZiz2Yiiu44i1XjB0fuXTgcnG2EHsuzGrgZsgNWQI3tjVFcIgwxQs+gAfuu9iMjrGQBLAlUpMxNSvPU0+LUEYq3GRADfdaoMIKqDRQeYByYAco7B+6NjSNnW8aG3PDjXvkYm0ZmqVvuOw4DYErMijD5SqUYsTFKlDkFuwitxBXcNkbbmwZz0+4hTipw4WuMT7uWkYPn3g5bho/NI0OdumxDC8vfwCT12Bk",false,true);
            }
            else if(this.currentTutorialStep == 1)
            {
               _loc11_ = GameState.menuHandler.getMenu("Library");
               _loc11_.open();
               _loc11_.x = this.tutorialHelp.x + this.tutorialHelp.actualWidth + 8;
               _loc11_.y = this.tutorialHelp.y;
            }
         }
         else if(param1 == "Portals")
         {
            if(this.currentTutorialStep == 2)
            {
               Main.instance.reset(false);
               _loc12_ = GameState.objects.spawnObject("portal1",600,200);
               _loc13_ = GameState.objects.spawnObject("portal2",600,400);
               GameState.objects.spawnObject("square",600,300);
            }
            else if(this.currentTutorialStep == 0)
            {
               Vars.objDampLinear = 9000;
               Vars.objDampAngular = 9000;
               _loc3_ = GameState.objects.spawnObject("cryo",450,440);
               Vars.objDampLinear = 0;
               Vars.objDampAngular = 0;
               _loc8_ = GameState.objects.spawnObject("button",700,550);
               _loc4_ = GameState.objects.spawnObject("square",540,550);
            }
         }
      }
   }
}

