package
{
   import com.yahoo.astra.fl.controls.treeClasses.TreeDataProvider;
   import environment.MainMenu;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.text.TextFieldType;
   
   public class Kongregate
   {
      
      public static var API:*;
      
      public static var contentToLoad:String;
      
      public static var shareAsUnlocked:int = 1;
      
      public static var playerName:String = "NONE";
      
      public static var shareContentType:String = "Level";
      
      public static var debugAPI:String = "API DEBUG: ";
      
      public static var savingContent:Boolean = false;
      
      public static var alreadyShared:Boolean = false;
      
      public function Kongregate()
      {
         super();
      }
      
      public static function onApiLoaded(param1:Event) : void
      {
         var e:Event = param1;
         var apifail:Boolean = false;
         try
         {
            API = e.target.content;
            API.sharedContent.addLoadListener("Level",onLoadLevel);
            API.sharedContent.addLoadListener("Roleplay",onLoadRoleplay);
            API.sharedContent.addLoadListener("Custom Item",onLoadItem);
            API.sharedContent.addLoadListener("Contract",onLoadContract);
            API.services.addEventListener("login",onKongregateInPageLogin);
            API.services.connect();
            playerName = API.services.getUsername();
            debugAPI += "API LOADED|" + "IS GUEST: " + API.services.isGuest() + "|PLAYER:" + playerName;
         }
         catch(errObject:Error)
         {
            apifail = true;
            debugAPI += "API NOT LOADED: " + errObject.name + ", " + errObject.message + "|";
         }
         if(playerName == "NONE")
         {
            debugAPI += "playerName fail";
            apifail = true;
         }
         if(!API)
         {
            debugAPI += "!API fail";
            apifail = true;
         }
         if(apifail)
         {
            debugAPI += "onAPILoaded fail";
            GameState.ui.showIncompatiblePlayer();
         }
      }
      
      private static function onKongregateInPageLogin(param1:Event) : *
      {
         debugAPI += "LOGIN EVENT";
      }
      
      public static function initAPI() : void
      {
         var paramObj:Object = null;
         var api_url:String = null;
         var request:URLRequest = null;
         var loader:Loader = null;
         try
         {
            paramObj = LoaderInfo(Main.instance.stage.root.loaderInfo).parameters;
            api_url = paramObj.api_path;
            debugAPI = "LOADING API|";
            if(api_url)
            {
               debugAPI += "API URL FOUND|";
               request = new URLRequest(api_url);
               loader = new Loader();
               loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onApiLoaded);
               loader.load(request);
               Main.instance.stage.addChild(loader);
            }
            else
            {
               GameState.ui.showIncompatiblePlayer();
               debugAPI += "API URL NOT FOUND|";
            }
         }
         catch(errObject:Error)
         {
            debugAPI += "|" + errObject.message;
            GameState.ui.showIncompatiblePlayer();
         }
      }
      
      public static function getSave() : void
      {
         if(Boolean(Main.instance.loadedLevel) && Boolean(API))
         {
            if(API.services.getUsername() == "0rava")
            {
               GameState.ui.console.setConsoleText("save: " + Base64.compress(Main.instance.loadedLevel));
            }
         }
      }
      
      public static function username() : void
      {
         GameState.ui.console.setConsoleText(API.services.getUsername());
      }
      
      public static function userid() : void
      {
         GameState.ui.console.setConsoleText(API.services.getUserId());
      }
      
      public static function viewContent(param1:String, param2:* = "") : void
      {
         if(param1 != "Contract")
         {
            GameState.ui.menuPrompt.unlock();
            GameState.ui.menuPrompt.title = "Content Loaded?";
            GameState.ui.menuPrompt.getField("info").text = "Did the content fail to load?\n\n1) Try reopening the level via the browser again.\n\n2) Make sure you\'re connected to Kongregate (green icon in upper right of chat.)\n\n3) If you\'re on Chrome, make sure Flash is enabled (see FAQ, link in description.)";
            GameState.ui.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_done);
            GameState.ui.menuPrompt.moveToTop();
            GameState.ui.menuPrompt.center();
            GameState.ui.menuPrompt.lock();
         }
         var _loc3_:String = GameState.ContentFilter;
         if(API)
         {
            if(param2 != "")
            {
               API.sharedContent.browse(param1,_loc3_,param2);
            }
            else
            {
               API.sharedContent.browse(param1,_loc3_);
            }
         }
         else
         {
            GameState.steamworks.enumerateSubscribedFiles(GameState.steamworks.onWorkshopContentLoaded);
         }
      }
      
      private static function onLoadRoleplay(param1:Object) : *
      {
         onLoadLevel(param1);
      }
      
      private static function onLoadContract(param1:Object) : *
      {
         Main.instance.currentSave = "";
         Main.instance.loadedCustomItem = "";
         onLoadLevel(param1,false);
      }
      
      private static function onLoadLevel(param1:Object, param2:Boolean = true) : *
      {
         var _loc8_:String = null;
         Main.instance.stage.focus = null;
         var _loc3_:Number = Number(param1.id);
         var _loc4_:String = param1.name;
         var _loc5_:String = param1.permalink;
         var _loc6_:String = param1.content;
         var _loc7_:String = param1.label;
         GameState.ui.menuMain.visible = true;
         GameState.ui.menuControls.visible = true;
         GameState.ui.menuMain.alpha = 1;
         GameState.ui.menuControls.alpha = 1;
         GameState.ui.menuMain.open();
         GameState.ui.menuControls.open();
         Main.instance.contract.title = param1.name;
         if(!O.needsUpdating)
         {
            IO.loadWorld(_loc6_,false,true);
         }
         else
         {
            contentToLoad = _loc6_;
         }
         debugAPI += "Level " + _loc3_ + " " + _loc7_ + " loaded";
         if(Main.instance.mainmenu.visible)
         {
            Main.instance.closeMainMenu();
            if(GameState.environment is MainMenu)
            {
               Main.instance.reset();
               Main.instance.changeEnvironment("lab");
               GameState.ui.updateVolume(null);
               GameState.environmenting = false;
            }
         }
         if(param2)
         {
            GameState.ui.menuPrompt.unlock();
            GameState.ui.menuPrompt.getField("info").type = TextFieldType.DYNAMIC;
            GameState.ui.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_done);
            GameState.ui.menuPrompt.visible = true;
            GameState.ui.menuPrompt.title = "Content Loaded";
            GameState.ui.menuPrompt.moveToTop();
            GameState.ui.menuPrompt.center();
            GameState.ui.menuPrompt.lock();
            _loc8_ = param1.name;
            _loc8_ = _loc8_.split("\"").join("");
            GameState.ui.menuPrompt.getField("info").text = "Content #" + param1.id + " - " + _loc8_ + " loaded!\n\nPlease see its description on the right, as it usually contains instructions and other useful stuff!\n\nTo start, close this menu and unpause the game.\nTo restart it, use the Restart button in the Toolbox, or use the quickload hotkey (" + Keymap.codeToKeyname(Keymap.nameToCode("load")) + ").";
         }
      }
      
      private static function onLoadItem(param1:Object) : *
      {
         var _loc2_:Number = Number(param1.id);
         var _loc3_:String = param1.name;
         var _loc4_:String = param1.permalink;
         var _loc5_:String = param1.content;
         var _loc6_:String = param1.label;
         if(Main.instance.loadedCustomItem == _loc5_)
         {
            return;
         }
         Main.instance.loadedCustomItem = _loc5_;
         _loc5_ = _loc5_.replace(/-/g,"/");
         if(_loc5_.substr(0,3) == "MAD")
         {
            _loc5_ = _loc5_.substr(3);
         }
         var _loc7_:String = Base64.uncompress(_loc5_);
         var _loc8_:String = String(_loc7_.split(";")[1]).replace("creator=","");
         var _loc9_:String = _loc3_;
         if(Boolean(_loc8_) && _loc8_ != "Guest")
         {
            _loc9_ = _loc3_ + " by " + _loc8_;
         }
         Main.instance.customNames.unshift(_loc9_);
         Main.instance.customItems.unshift(_loc5_);
         Main.instance.updateLibrary();
         GameState.ui.menuPrompt.unlock();
         GameState.ui.menuPrompt.getField("info").type = TextFieldType.DYNAMIC;
         GameState.ui.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_done);
         GameState.ui.menuPrompt.visible = true;
         GameState.ui.menuPrompt.title = "Content Loaded";
         GameState.ui.menuPrompt.moveToTop();
         GameState.ui.menuPrompt.center();
         GameState.ui.menuPrompt.lock();
         var _loc10_:String = "";
         _loc10_ = _loc10_ + ("Custom Item loaded!\n" + _loc3_);
         if(Boolean(_loc8_) && _loc8_ != "Guest")
         {
            _loc10_ += "\nby " + _loc8_;
         }
         _loc10_ += "\n\nSpawn it via [Library > Custom Items.]\n\nThe item is currently temporary, and will be deleted when you restart the game.\n\nTo save it permanently, use\n[Custom Items > Manage > Save].\n\n";
         GameState.ui.menuPrompt.getField("info").text = _loc10_;
         if(!GameState.ui.menuMain.visible)
         {
            GameState.ui.menuMain.visible = true;
         }
         if(!GameState.ui.menuControls.visible)
         {
            GameState.ui.menuControls.visible = true;
         }
         if(Main.instance.mainmenu.visible)
         {
            Main.instance.closeMainMenu();
         }
         GameState.ui.menuMain.alpha = 1;
         GameState.ui.menuControls.alpha = 1;
         GameState.ui.menuMain.open();
         GameState.ui.menuControls.open();
         Main.instance.customItemLoadedBandaid = true;
      }
      
      public static function shareCustomItems() : void
      {
         if(Tweak.download && false)
         {
            GameState.ui.kongPopup();
         }
         else
         {
            GameState.ui.openCustomItems("share");
         }
      }
   }
}

