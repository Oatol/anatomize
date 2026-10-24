package
{
   import com.anegmetex.Soundmanager.sounds;
   import com.yahoo.astra.fl.controls.treeClasses.TreeDataProvider;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.net.SharedObject;
   import flash.system.Capabilities;
   import flash.text.TextFieldType;
   
   public class Settings
   {
      
      public function Settings()
      {
         super();
      }
      
      private static function flushClose(param1:SharedObject) : void
      {
         var sharedObj:SharedObject = param1;
         try
         {
            sharedObj.flush();
         }
         catch(e:Error)
         {
            if(O.needsUpdating)
            {
               return;
            }
            return;
         }
         finally
         {
            sharedObj.close();
         }
      }
      
      public static function defaultMenus() : void
      {
         var _loc1_:SharedObject = SharedObject.getLocal("orava/mutilate/menus","/");
         _loc1_.data.menuMainX = null;
         _loc1_.data.menuMainY = null;
         _loc1_.data.menuControlsX = null;
         _loc1_.data.menuControlsY = null;
         _loc1_.data.menuSettingsX = null;
         _loc1_.data.menuSettingsY = null;
         _loc1_.data.menuObjectX = null;
         _loc1_.data.menuObjectY = null;
         _loc1_.data.menuSaveX = null;
         _loc1_.data.menuSaveY = null;
         _loc1_.data.menuSpawnX = null;
         _loc1_.data.menuSpawnY = null;
         _loc1_.data.menuLibraryX = null;
         _loc1_.data.menuLibraryY = null;
         _loc1_.data.menuEffectsX = null;
         _loc1_.data.menuEffectsY = null;
         _loc1_.data.menuToolsX = null;
         _loc1_.data.menuToolsY = null;
         _loc1_.data.menuWorldX = null;
         _loc1_.data.menuWorldY = null;
         _loc1_.data.spawnSize = null;
         flushClose(_loc1_);
      }
      
      public static function saveFavourites() : void
      {
         var _loc1_:SharedObject = SharedObject.getLocal("orava/mutilate/settings","/");
         _loc1_.data.favourites = Main.instance.favourites.join("|");
         flushClose(_loc1_);
      }
      
      public static function loadFavourites() : Array
      {
         var _loc1_:SharedObject = SharedObject.getLocal("orava/mutilate/settings","/");
         var _loc2_:Array = [];
         if(_loc1_.data.favourites)
         {
            _loc2_ = _loc1_.data.favourites.split("|");
         }
         _loc1_.close();
         return _loc2_;
      }
      
      public static function saveFavouriteSaves() : void
      {
         var _loc3_:String = null;
         var _loc1_:SharedObject = SharedObject.getLocal("orava/mutilate/saves","/");
         _loc1_.data.reset = Main.instance.favouriteSaveReset;
         _loc1_.data.names = Main.instance.favouriteSaveNames.join("|");
         var _loc2_:Array = [];
         for each(_loc3_ in Main.instance.favouriteSaves)
         {
            _loc2_.push(Base64.compress(_loc3_));
         }
         _loc1_.data.saves = _loc2_.join("|");
         flushClose(_loc1_);
      }
      
      public static function backupCustomItem(param1:String, param2:String) : void
      {
         var _loc3_:SharedObject = null;
         _loc3_ = SharedObject.getLocal("orava/mutilate/itemsBackup","/");
         if(!_loc3_.data.names)
         {
            _loc3_.data.names = param2;
         }
         else
         {
            _loc3_.data.names = _loc3_.data.names + "|" + param2;
         }
         if(!_loc3_.data.items)
         {
            _loc3_.data.items = param1;
         }
         else
         {
            _loc3_.data.items = _loc3_.data.items + "|" + param1;
         }
         flushClose(_loc3_);
      }
      
      public static function backupCustomItemJSON(param1:String, param2:String) : void
      {
         var ciobj:Object = null;
         var customItem:String = param1;
         var customName:String = param2;
         try
         {
            ciobj = new Object();
            ciobj.name = customName;
            ciobj.save = customItem;
            backupCustomItemBackup(ciobj);
         }
         catch(err:Error)
         {
            GameState.ui.showTooltip(GameState.ui.console,"Custom Item backup failed. Please report this as a bug.\n" + err.message,100,5000,200);
         }
      }
      
      public static function backupCustomItemBackup(param1:Object) : *
      {
         var _loc2_:String = "\n" + JSON.stringify(param1);
         var _loc3_:String = File.applicationStorageDirectory.nativePath;
         var _loc4_:File = new File(_loc3_);
         _loc4_ = _loc4_.resolvePath("itemsBackup.json");
         var _loc5_:FileStream = new FileStream();
         _loc5_.open(_loc4_,FileMode.APPEND);
         _loc5_.writeUTF(_loc2_);
         _loc5_.close();
      }
      
      public static function backupLocalItem(param1:String) : void
      {
         var _loc2_:SharedObject = null;
         _loc2_ = SharedObject.getLocal("orava/mutilate/modelsBackup","/");
         if(!_loc2_.data.items)
         {
            _loc2_.data.items = param1;
         }
         else
         {
            _loc2_.data.items = _loc2_.data.items + "#" + param1;
         }
         flushClose(_loc2_);
      }
      
      public static function saveCustomItems() : void
      {
         var _loc1_:SharedObject = SharedObject.getLocal("orava/mutilate/items","/");
         _loc1_.data.names = Main.instance.customNames.join("|");
         _loc1_.data.items = Main.instance.customItems.join("|");
         flushClose(_loc1_);
      }
      
      public static function loadCustomItems(param1:Boolean = false) : Object
      {
         var _loc2_:SharedObject = null;
         var _loc3_:String = "orava/mutilate/items";
         if(param1)
         {
            _loc3_ = "orava/mutilate/itemsBackup";
         }
         _loc2_ = SharedObject.getLocal(_loc3_,"/");
         var _loc4_:Object = _loc2_.data;
         _loc2_.close();
         return _loc4_;
      }
      
      public static function loadMapping() : void
      {
         var _loc1_:SharedObject = SharedObject.getLocal("orava/mutilate/settings","/");
         if(!_loc1_)
         {
            return;
         }
         if(Boolean(_loc1_.data) && Boolean(_loc1_.data.keymap))
         {
            Keymap.setKeymap(Keymap.updateKeymap(_loc1_.data.keymap));
         }
         else
         {
            Keymap.setKeymap("default");
            saveMapping();
         }
         _loc1_.close();
      }
      
      public static function saveMapping() : void
      {
         var _loc1_:String = Keymap.getString();
         var _loc2_:SharedObject = SharedObject.getLocal("orava/mutilate/settings","/");
         _loc2_.data.keymap = _loc1_;
         flushClose(_loc2_);
      }
      
      public static function savePowers() : void
      {
         var _loc1_:SharedObject = SharedObject.getLocal("orava/mutilate/settings","/");
         _loc1_.data.powers = Powers.favPowers.join("|");
         _loc1_.data.ForcePowerAutoUpdate = Main.instance.PowerAutoUpdate.toString();
         flushClose(_loc1_);
      }
      
      public static function loadPowers() : Array
      {
         var _loc1_:SharedObject = SharedObject.getLocal("orava/mutilate/settings","/");
         var _loc2_:Array = [];
         if(_loc1_.data.powers)
         {
            _loc2_ = String(_loc1_.data.powers).split("|");
         }
         _loc1_.close();
         return _loc2_;
      }
      
      public static function saveLocalItems() : void
      {
         var _loc1_:SharedObject = SharedObject.getLocal("orava/mutilate/models","/");
         _loc1_.data.items = Main.instance.localItems.join("#");
         flushClose(_loc1_);
      }
      
      public static function loadLocalItems() : Array
      {
         var _loc1_:SharedObject = SharedObject.getLocal("orava/mutilate/models","/");
         var _loc2_:Array = [];
         if(_loc1_.data.items)
         {
            _loc2_ = _loc1_.data.items.split("#");
         }
         _loc1_.close();
         return _loc2_;
      }
      
      public static function backupLocalItems(param1:Boolean = true) : void
      {
         var _loc2_:SharedObject = SharedObject.getLocal("orava/mutilate/models","/");
         var _loc3_:SharedObject = SharedObject.getLocal("orava/mutilate/modelsBackup","/");
         if(!_loc2_.data || !_loc2_.data.items || _loc2_.data.items.split("#").length == 0)
         {
            _loc2_.close();
            _loc3_.close();
            return;
         }
         if(Boolean(param1) && Boolean(_loc3_.data) && Boolean(_loc3_.data.items))
         {
            _loc2_.close();
            _loc3_.close();
            return;
         }
         _loc3_.data.items = _loc2_.data.items;
         flushClose(_loc3_);
         _loc2_.close();
      }
      
      public static function saveQuicksaves() : void
      {
         var _loc1_:SharedObject = SharedObject.getLocal("orava/mutilate/saves","/");
         var _loc2_:Array = [];
         var _loc3_:* = int(Main.instance.qSaveArray.length - 1);
         while(_loc3_ >= 0)
         {
            if(Main.instance.qSaveTimeArray[_loc3_] != 0)
            {
               _loc2_.push(Base64.compress(Main.instance.qSaveArray[_loc3_]));
            }
            _loc3_--;
         }
         _loc1_.data.recovery = null;
         _loc1_.data.recovery = _loc2_.join("|");
         flushClose(_loc1_);
      }
      
      public static function loadLocalSaves() : Object
      {
         var _loc1_:SharedObject = SharedObject.getLocal("orava/mutilate/saves","/");
         var _loc2_:Object = _loc1_.data;
         _loc1_.close();
         return _loc2_;
      }
      
      public static function saveLocalWorkshop() : void
      {
         var _loc5_:String = null;
         var _loc1_:SharedObject = SharedObject.getLocal("orava/mutilate/workshop","/");
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:int = int(GameState.steamworks.workshopContent.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ = GameState.steamworks.workshopContent[_loc6_].title;
            _loc5_.split("#").join("");
            _loc2_.push(_loc5_);
            _loc3_.push(GameState.steamworks.workshopContent[_loc6_].content);
            _loc6_++;
         }
         _loc1_.data.names = _loc2_.join("#");
         _loc1_.data.content = _loc3_.join("#");
         flushClose(_loc1_);
         GameState.ui.showTooltip(GameState.ui.menuLibrary,"Saved.",0,-1,GameState.ui.menuLibrary.actualWidth);
      }
      
      public static function loadLocalWorkshop() : Object
      {
         var _loc1_:SharedObject = SharedObject.getLocal("orava/mutilate/workshop","/");
         if(!_loc1_.data || !_loc1_.data.names || !_loc1_.data.content)
         {
            _loc1_.close();
            return {};
         }
         _loc1_.close();
         return _loc1_.data;
      }
      
      public static function saveSettings() : void
      {
         var _loc1_:SharedObject = SharedObject.getLocal("orava/mutilate/settings","/");
         var _loc2_:String = World.toggleSlomo.toString() + "|" + World.toggleRagdollBreak.toString() + "|" + World.toggleJointBreak.toString() + "|" + World.toggleObjectBreak.toString() + "|" + World.toggleContact.toString() + "|" + World.toggleSounds.toString() + "|" + World.toggleEffects.toString() + "|" + World.toggleStabi.toString() + "|" + World.toggleGore.toString() + "|" + World.toggleHealthbars.toString() + "|" + World.toggleJoints.toString() + "|" + World.toggleBlueprint.toString() + "|" + World.toggleTemperature.toString() + "|" + World.toggleFahrenheit.toString() + "|" + World.toggleAutorespawn.toString() + "|" + World.toggleGrid.toString() + "|" + World.toggleSmoothBlood.toString() + "|" + World.togglePhysicsBlood.toString() + "|" + World.toggleStrongDolls.toString() + "|" + World.toggleBodypartGibs.toString() + "|" + World.toggleBackground.toString() + "|" + World.toggleEdgePan.toString() + "|" + Tweak.toolRadius.toString() + "|" + Tweak.toolSpeed.toString() + "|" + Tweak.toolSpread
         .toString() + "|" + Tweak.toolProjectiles.toString() + "|" + World.toggleDollSleep.toString() + "|" + World.toggleCutFilter.toString() + "|" + World.toggleVelocity.toString() + "|" + World.toggleRadius.toString() + "|" + World.toggleToolbox.toString() + "|" + World.rightClick.toString() + "|" + World.toggleExtraGore.toString() + "|" + World.toggleDollbars.toString() + "|" + World.toggleDollicons.toString() + "|" + World.toggleSpawnBG.toString() + "|" + World.firstRunGeneric.toString() + "|" + World.toggleShrapnel.toString() + "|" + World.toggleJointsPause.toString() + "|" + Tweak.toolThrowRadius.toString() + "|" + Tweak.toolDuration.toString() + "|" + Tweak.toolEffectRadius.toString() + "|" + (sounds.UISound ? "1" : "0") + "|" + World.toggleResetConfirm.toString() + "|" + World.toggleLinkPause.toString() + "|" + World.toggleLinkSelected.toString() + "|" + World.toggleGibsGib.toString() + "|" + World.toggleEdgeStick.toString() + "|" + World.togglePreciseEffects.toString() + "|" + World.toggleSelectionGlow
         .toString() + "|" + World.toggleJointSelected.toString() + "|" + World.toggleDarkMode.toString() + "|" + World.scrollWheel.toString() + "|" + World.toggleFloorPan.toString() + "|" + World.toggleFullscreen.toString() + "|" + World.toggleScaleMode.toString() + "|" + World.toggleJointsAlive.toString() + "|" + World.toggleArmourbars.toString() + "|" + Tweak.GridSize.toString() + "|" + Tweak.AntiFreezeFPS.toString() + "|" + int(Tweak.UIScale * 100).toString() + "|" + World.toggleCulling.toString() + "|" + World.doubleClickSelect.toString();
         var _loc3_:String = Main.instance.stage.quality;
         var _loc4_:String = int(Vars.speed * 100) + "|" + int(Vars.particles * 100) + "|" + int(sounds.vol * 100) + "|" + _loc3_ + "|" + int(Vars.slowspeed * 100) + "|" + int(Vars.barscale * 100) + "|" + int(Vars.dragEditor * 100) + "|" + int(Vars.dragDoll * 100) + "|" + int(Vars.cameraAcceleration * 100) + "|" + int(Vars.particlesMax) + "|" + Tweak.m_iterations + "|" + int(Tweak.MinShrapnelSize * 100) + "|" + Vars.cutlimit + "|" + Vars.edgePanDelay + "|" + Tweak.smoothBloodSize + "|" + int(Tweak.bloodSmoothing * 100);
         if(Capabilities.playerType.toLowerCase().indexOf("desktop") != -1)
         {
            _loc4_ += "|" + int(Main.instance.stage.nativeWindow.x) + "|" + int(Main.instance.stage.nativeWindow.y);
         }
         _loc4_ += "|" + int(Vars.collisionsMax);
         _loc4_ = _loc4_ + ("|" + int(Vars.loadSpeed));
         _loc4_ = _loc4_ + ("|" + int(Vars.wheelSpeed * 100));
         _loc1_.data.gamesettings = _loc2_;
         _loc1_.data.gamefields = _loc4_;
         _loc1_.data.lastrun = World.firstRunCurrent;
         flushClose(_loc1_);
         GameState.ui.showTooltip(GameState.ui.menuSettings,"Settings saved.",0,500,GameState.ui.menuSettings.actualWidth);
      }
      
      public static function loadWorldSettings() : Array
      {
         var _loc2_:Array = null;
         var _loc1_:SharedObject = SharedObject.getLocal("orava/mutilate/settings","/");
         _loc2_ = [];
         if(_loc1_.data.gamesettings)
         {
            _loc2_ = String(_loc1_.data.gamesettings).split("|");
         }
         _loc1_.close();
         return _loc2_;
      }
      
      public static function loadSettings() : Array
      {
         var _loc2_:Array = null;
         var _loc1_:SharedObject = SharedObject.getLocal("orava/mutilate/settings","/");
         _loc2_ = [];
         if(_loc1_.data.gamefields)
         {
            _loc2_ = String(_loc1_.data.gamefields).split("|");
         }
         if(_loc1_.data.lastrun)
         {
            World.firstRunCurrent = _loc1_.data.lastrun;
         }
         _loc1_.close();
         return _loc2_;
      }
      
      public static function saveMenus() : void
      {
         var _loc1_:SharedObject = SharedObject.getLocal("orava/mutilate/menus","/");
         _loc1_.data.menuMainX = Math.round(GameState.ui.menuMain.x);
         _loc1_.data.menuMainY = Math.round(GameState.ui.menuMain.y);
         _loc1_.data.menuControlsX = Math.round(GameState.ui.menuControls.x);
         _loc1_.data.menuControlsY = Math.round(GameState.ui.menuControls.y);
         _loc1_.data.menuSettingsX = Math.round(GameState.ui.menuSettings.x);
         _loc1_.data.menuSettingsY = Math.round(GameState.ui.menuSettings.y);
         _loc1_.data.menuObjectX = Math.round(GameState.ui.menuObject.x);
         _loc1_.data.menuObjectY = Math.round(GameState.ui.menuObject.y);
         _loc1_.data.menuSaveX = Math.round(GameState.ui.menuSave.x);
         _loc1_.data.menuSaveY = Math.round(GameState.ui.menuSave.y);
         _loc1_.data.menuSpawnX = Math.round(GameState.ui.menuSpawn.x);
         _loc1_.data.menuSpawnY = Math.round(GameState.ui.menuSpawn.y);
         _loc1_.data.menuLibraryX = Math.round(GameState.ui.menuLibrary.x);
         _loc1_.data.menuLibraryY = Math.round(GameState.ui.menuLibrary.y);
         _loc1_.data.menuEffectsX = Math.round(GameState.ui.menuEffects.x);
         _loc1_.data.menuEffectsY = Math.round(GameState.ui.menuEffects.y);
         _loc1_.data.menuToolsX = Math.round(GameState.ui.menuTools.x);
         _loc1_.data.menuToolsY = Math.round(GameState.ui.menuTools.y);
         _loc1_.data.menuWorldX = Math.round(GameState.ui.menuWorld.x);
         _loc1_.data.menuWorldY = Math.round(GameState.ui.menuWorld.y);
         _loc1_.data.spawnSize = GameState.ui.menuSpawn.actualWidth;
         flushClose(_loc1_);
         GameState.ui.showTooltip(GameState.ui.menuSettings,"Layout saved.\n",0,1000,GameState.ui.menuSettings.actualWidth);
      }
      
      public static function loadMenus() : Object
      {
         var _loc1_:SharedObject = SharedObject.getLocal("orava/mutilate/menus","/");
         var _loc2_:Object = {};
         if(_loc1_.data)
         {
            _loc2_ = _loc1_.data;
         }
         _loc1_.close();
         return _loc2_;
      }
   }
}

