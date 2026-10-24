package
{
   import com.adobe.images.PNGEncoder;
   import com.amanitadesign.steam.*;
   import com.yahoo.astra.fl.controls.treeClasses.TNode;
   import com.yahoo.astra.fl.controls.treeClasses.TreeDataProvider;
   import flash.display.Bitmap;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.text.TextFieldType;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class SteamWorks
   {
      
      public var API:FRESteamWorks;
      
      private var _appId:uint;
      
      private var _userId:String;
      
      internal var previewnam:String;
      
      internal var filenam:String;
      
      internal var filedes:String = "test description";
      
      internal var filecon:String;
      
      internal var thumbnail:ByteArray;
      
      public var workshopContent:Array = [];
      
      public var workshopContentDownloadFinished:Boolean = false;
      
      public var logs:String;
      
      internal var tags:Dictionary = new Dictionary();
      
      internal var updatingExistingFile:Boolean = false;
      
      private var IDS:Array = [];
      
      private var id:String;
      
      private var ugcHandle:String;
      
      private var publishedFile:String;
      
      private var authHandle:uint = 0;
      
      private var authTicket:ByteArray = null;
      
      private var sharedFiles:int = 0;
      
      private var onContentShared:Function;
      
      private var onContentLoaded:Function;
      
      private var contentResult:Object = {};
      
      internal var currentUser:*;
      
      internal var currentPage:int = 0;
      
      internal var currentResults:int = 0;
      
      internal var pagesTotal:int = 0;
      
      public function SteamWorks()
      {
         super();
      }
      
      public function loadLocalWorkshop() : *
      {
         var _loc6_:* = undefined;
         var _loc1_:Object = Settings.loadLocalWorkshop();
         if(!_loc1_.names)
         {
            return;
         }
         if(!_loc1_.content)
         {
            return;
         }
         GameState.steamworks.workshopContent = [];
         var _loc2_:Array = _loc1_.names.split("#");
         var _loc3_:Array = _loc1_.content.split("#");
         var _loc4_:int = int(_loc2_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = new Object();
            _loc6_.title = _loc2_[_loc5_];
            _loc6_.content = _loc3_[_loc5_];
            _loc6_.description = "Local copy of subscribed Workshop content.\n";
            GameState.steamworks.workshopContent.push(_loc6_);
            _loc5_++;
         }
      }
      
      internal function onWorkshopContentLoaded(param1:Object) : *
      {
         this.workshopContent.push(param1);
         Main.instance.updateLibrary();
         var _loc2_:TNode = GameState.ui.menuLibrary.getTree("buttons").findNode("func","workshopSubscribed");
         GameState.ui.menuLibrary.getTree("buttons").showNode(_loc2_);
      }
      
      public function workshopContentDownloaded() : void
      {
         this.workshopContentDownloadFinished = true;
         Main.instance.updateLibrary();
         GameState.ui.showTooltip(GameState.ui.menuLibrary,"Subscribed content downloaded!\n",0,500,GameState.ui.menuLibrary.actualWidth);
      }
      
      private function log(param1:String) : *
      {
         var _loc2_:Window = null;
         this.logs += "\n" + param1;
         if(param1 == "FAILED_GETFILE")
         {
            _loc2_ = GameState.menuHandler.getMenu("Prompt");
            _loc2_.unlock();
            _loc2_.getField("info").type = TextFieldType.DYNAMIC;
            _loc2_.visible = true;
            _loc2_.moveToTop();
            _loc2_.center();
            _loc2_.lock();
            _loc2_.title = "Workshop Error";
            _loc2_.getField("info").text = "A subscribed file failed to load. It may have been removed by the author.\n\nSteam should handle unsubscribing automatically.\n\nPlease try redownloading your subscribed content in a short while.";
            _loc2_.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_done);
         }
         if(param1 == "FAILED!")
         {
            _loc2_ = GameState.menuHandler.getMenu("Prompt");
            _loc2_.unlock();
            _loc2_.getField("info").type = TextFieldType.DYNAMIC;
            _loc2_.visible = true;
            _loc2_.moveToTop();
            _loc2_.center();
            _loc2_.lock();
            _loc2_.title = "Workshop Error";
            _loc2_.getField("info").text = "Something went wrong, here are the logs:\n" + this.logs;
            _loc2_.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_done);
         }
      }
      
      public function ShowWorkShopLogs() : *
      {
         var _loc1_:Window = GameState.menuHandler.getMenu("Prompt");
         _loc1_.unlock();
         _loc1_.getField("info").type = TextFieldType.DYNAMIC;
         _loc1_.visible = true;
         _loc1_.moveToTop();
         _loc1_.center();
         _loc1_.lock();
         _loc1_.title = "Workshop Logs";
         _loc1_.getField("info").text = "Here are the logs:\n" + this.logs;
         _loc1_.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_done);
      }
      
      public function init(param1:Stage) : *
      {
         this.API = new FRESteamWorks();
         if(!this.API.init())
         {
            this.log("STEAMWORKS API is NOT available");
            return;
         }
         this.log("CONNECTED TO STEAMWORKS");
         this._userId = this.API.getUserID();
         this.log("User ID: " + this._userId);
         this._appId = this.API.getAppID();
         this.log("App ID: " + this._appId);
         this.log("Persona name: " + this.API.getPersonaName());
         this.API.addEventListener(SteamEvent.STEAM_RESPONSE,this.onSteamResponse);
         this.API.addOverlayWorkaround(param1,true);
         this.API.setCloudEnabledForApp(true);
      }
      
      public function enumerateSubscribedFiles(param1:Function) : void
      {
         if(!this.API.isReady)
         {
            return;
         }
         this.currentPage = 0;
         this.log("enumerateUserSubscribedFiles(0) == " + this.API.enumerateUserSubscribedFiles(0));
         this.onContentLoaded = param1;
      }
      
      private function enumerateSharedFiles(param1:Event = null) : void
      {
         if(!this.API.isReady)
         {
            return;
         }
         this.currentPage = 0;
         var _loc2_:Boolean = Boolean(this.API.enumerateUserSharedWorkshopFiles(this._userId,0,[],[]));
         this.log("enumerateSharedFiles(" + this._userId + ", 0, [], []) == " + _loc2_);
      }
      
      public function SetTag(param1:String, param2:int) : *
      {
         this.tags[param1] = param2;
      }
      
      public function ShareContent(param1:String, param2:String, param3:Bitmap, param4:Function = null) : *
      {
         this.logs = "";
         this.filenam = "[" + param1 + "] " + this.filenam;
         this.previewnam = this.filenam + ".png";
         this.thumbnail = PNGEncoder.encode(param3.bitmapData);
         this.filecon = param2;
         if(Boolean(param4))
         {
            this.onContentShared = param4;
         }
         if(param1 != "Item")
         {
            Main.instance.toggleScreenShotMode();
         }
         GameState.ui.showTooltip(GameState.menuHandler.getMenu("Library"),"Sharing content...",0,500,200,36);
         this.log("Checking existing content...");
         this.updatingExistingFile = true;
         this.enumerateSharedFiles();
      }
      
      private function UpdateExistingFile(param1:String) : *
      {
         var _loc2_:Boolean = false;
         this.updatingExistingFile = true;
         var _loc3_:String = this.API.createPublishedFileUpdateRequest(param1);
         this.log("createPublishedFileUpdateRequest() == " + _loc3_);
         if(_loc3_ == WorkshopConstants.FILEUPDATEHANDLE_Invalid)
         {
            this.log("FAILED");
            this.log("while creating file handle");
            return;
         }
         _loc2_ = Boolean(this.API.updatePublishedFileFile(_loc3_,this.filenam));
         this.log("updatePublishedFileFile(" + _loc3_ + ", " + this.filenam + ") == " + _loc2_);
         if(!_loc2_)
         {
            this.log("FAILED");
            return;
         }
         _loc2_ = Boolean(this.API.updatePublishedFilePreviewFile(_loc3_,this.previewnam));
         this.log("updatePublishedFilePreviewFile(...) == " + _loc2_);
         if(!_loc2_)
         {
            this.log("FAILED");
            return;
         }
         _loc2_ = Boolean(this.API.updatePublishedFileDescription(_loc3_,this.filedes));
         this.log("updatePublishedFileDescription(...) == " + _loc2_);
         if(!_loc2_)
         {
            this.log("FAILED");
            return;
         }
         _loc2_ = Boolean(this.API.updatePublishedFileTitle(_loc3_,this.filenam));
         this.log("updatePublishedFileTitle(...) == " + _loc2_);
         if(!_loc2_)
         {
            this.log("FAILED");
            return;
         }
         _loc2_ = Boolean(this.API.commitPublishedFileUpdate(_loc3_));
         this.log("commitPublishedFileUpdate(...) == " + _loc2_);
         this.UploadFiles();
      }
      
      private function UploadFiles() : void
      {
         var _loc1_:Boolean = this.writeFileToCloud(this.filenam,this.filecon);
         var _loc2_:Boolean = Boolean(this.API.fileWrite(this.previewnam,this.thumbnail));
         this.log("writeFileToCloud(\'" + this.filenam + ") == " + _loc1_);
         this.log("writeFileToCloud(\'" + this.previewnam + "\') == " + _loc2_);
         if(this.updatingExistingFile)
         {
            this.log("Updating existing files...");
            GameState.ui.showTooltip(GameState.menuHandler.getMenu("Library"),"Publishing update...",0,500,200,36);
         }
         else if(_loc1_ && _loc2_)
         {
            this.log("Content & Thumbnail files successfully written to cloud. Begin publishing.");
            this.publishFile();
            GameState.ui.showTooltip(GameState.menuHandler.getMenu("Library"),"Publishing content...",0,500,200,36);
         }
      }
      
      private function PublishOnWorkShop() : *
      {
         this.log("fileShareResult() == " + this.API.fileShareResult());
         this.log(this.filenam + " " + this.previewnam + " " + this._appId + " " + this.filenam + " " + this.filedes);
         var _loc1_:Timer = new Timer(500,1);
         _loc1_.addEventListener(TimerEvent.TIMER,this.publish);
         _loc1_.start();
      }
      
      private function publish(param1:TimerEvent) : *
      {
         var _loc2_:Array = this.ParseTags();
         var _loc3_:Boolean = Boolean(this.API.publishWorkshopFile(this.filenam,this.previewnam,this._appId,this.filenam,this.filedes,WorkshopConstants.VISIBILITY_Public,_loc2_,WorkshopConstants.FILETYPE_Community));
         this.log("publishWorkshopFile(\'" + this.filenam + "\' ...) == " + _loc3_);
         this.log("tags(\'" + this.filenam + "\' ...) == " + _loc2_);
         GameState.ui.showTooltip(GameState.menuHandler.getMenu("Library"),"Preparing to publish...",0,500,200,36);
      }
      
      public function ParseTags() : Array
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc1_:Array = [];
         this.log("PARSED TAGS:");
         for(_loc2_ in this.tags)
         {
            _loc3_ = int(this.tags[_loc2_]);
            _loc4_ = _loc2_.toString();
            if(_loc3_ == 1)
            {
               _loc1_.push(_loc4_);
               this.log(_loc4_);
            }
         }
         return _loc1_;
      }
      
      private function publishFile() : void
      {
         if(!this.API.isReady)
         {
            return;
         }
         this.sharedFiles = 0;
         this.log("Attempting to publish:");
         this.log("readFileFromCloud(\'" + this.filenam + "\') == " + this.readFileFromCloud(this.filenam));
         var _loc1_:* = this.API.fileShare(this.previewnam);
         this.log("fileShare(\'" + this.previewnam + "\') == " + _loc1_);
      }
      
      public function writeFileToCloud(param1:String, param2:String) : Boolean
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeUTFBytes(param2);
         return this.API.fileWrite(param1,_loc3_);
      }
      
      public function readFileFromCloud(param1:String) : String
      {
         var _loc2_:ByteArray = new ByteArray();
         if(this.API.fileRead(param1,_loc2_))
         {
            return _loc2_.readUTFBytes(_loc2_.length);
         }
         return "";
      }
      
      private function onSteamResponse(param1:SteamEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:ItemVoteDetailsResult = null;
         var _loc6_:UserVoteDetails = null;
         switch(param1.req_type)
         {
            case SteamConstants.RESPONSE_OnUserStatsStored:
               this.log("RESPONSE_OnUserStatsStored: " + param1.response);
               break;
            case SteamConstants.RESPONSE_OnUserStatsReceived:
               this.log("RESPONSE_OnUserStatsReceived: " + param1.response);
               break;
            case SteamConstants.RESPONSE_OnAchievementStored:
               this.log("RESPONSE_OnAchievementStored: " + param1.response);
               break;
            case SteamConstants.RESPONSE_OnFileShared:
               this.log("RESPONSE_OnFileShared: " + param1.response);
               if(param1.response == 9)
               {
                  if(this.updatingExistingFile)
                  {
                     GameState.ui.showTooltip(GameState.ui.menuLibrary,"Updated!\n",0,5000,GameState.ui.menuLibrary.actualWidth);
                     break;
                  }
               }
               if(param1.response != SteamResults.OK)
               {
                  this.log("FAILED!");
                  break;
               }
               this.OnFileShared();
               break;
            case SteamConstants.RESPONSE_OnCommitPublishedFileUpdate:
               this.log("RESPONSE_OnCommitPublishedFileUpdate: " + param1.response);
               if(param1.response == 9)
               {
                  if(this.updatingExistingFile)
                  {
                     GameState.ui.showTooltip(GameState.ui.menuLibrary,"Updated!\n",0,5000,GameState.ui.menuLibrary.actualWidth);
                     break;
                  }
               }
               if(param1.response != SteamResults.OK)
               {
                  this.log("FAILED!");
                  break;
               }
               this.OnFileShared();
               break;
            case SteamConstants.RESPONSE_OnPublishWorkshopFile:
               this.log("RESPONSE_OnPublishWorkshopFile: " + param1.response);
               if(param1.response != SteamResults.OK)
               {
                  this.log("FAILED!");
                  break;
               }
               this.OnPublishWorkshopFile();
               break;
            case SteamConstants.RESPONSE_OnEnumerateUserSubscribedFiles:
               this.log("RESPONSE_OnEnumerateUserSubscribedFiles: " + param1.response);
               if(param1.response != SteamResults.OK)
               {
                  this.log("FAILED!");
                  break;
               }
               this.OnEnumerateUserSubscribedFiles();
               break;
            case SteamConstants.RESPONSE_OnEnumerateUserSharedWorkshopFiles:
            case SteamConstants.RESPONSE_OnEnumerateUserPublishedFiles:
               _loc4_ = param1.req_type == SteamConstants.RESPONSE_OnEnumerateUserSharedWorkshopFiles;
               this.log((_loc4_ ? "RESPONSE_OnEnumerateUserSharedWorkshopFile: " : "RESPONSE_OnEnumerateUserPublishedFiles: ") + param1.response);
               if(param1.response != SteamResults.OK)
               {
                  break;
               }
               this.OnEnumerateFiles(_loc4_);
               break;
            case SteamConstants.RESPONSE_OnEnumeratePublishedWorkshopFiles:
               this.log("RESPONSE_OnEnumeratePublishedWorkshopFiles: " + param1.response);
               if(param1.response != SteamResults.OK)
               {
                  this.log("FAILED!");
                  break;
               }
               this.OnEnumeratePublishedFiles();
               break;
            case SteamConstants.RESPONSE_OnEnumeratePublishedFilesByUserAction:
               this.log("RESPONSE_OnEnumeratePublishedFilesByUserAction: " + param1.response);
               if(param1.response != SteamResults.OK)
               {
                  this.log("FAILED!");
                  break;
               }
               this.OnEnumeratePublishedFilesByUserAction();
               break;
            case SteamConstants.RESPONSE_OnGetPublishedFileDetails:
               this.log("RESPONSE_OnGetPublishedFileDetails: " + param1.response);
               if(param1.response != SteamResults.OK)
               {
                  this.log("FAILED_GETFILE");
                  break;
               }
               this.OnGetPublishedFileDetails();
               break;
            case SteamConstants.RESPONSE_OnUGCDownload:
               this.log("RESPONSE_OnUGCDownload: " + param1.response);
               if(param1.response != SteamResults.OK)
               {
                  this.log("FAILED!");
                  break;
               }
               this.OnDownload();
               break;
            case SteamConstants.RESPONSE_OnGetPublishedItemVoteDetails:
               this.log("RESPONSE_OnGetPublishedItemVoteDetails: " + param1.response);
               if(param1.response != SteamResults.OK)
               {
                  this.log("FAILED!");
                  break;
               }
               _loc5_ = this.API.getPublishedItemVoteDetailsResult();
               this.log("getPublishedItemVoteDetails() == " + (_loc5_ ? _loc5_.result : "null"));
               if(!_loc5_)
               {
                  return;
               }
               this.log("votes: " + _loc5_.votesFor + "//" + _loc5_.votesAgainst + ", score: " + _loc5_.score + ", reports: " + _loc5_.reports);
               break;
            case SteamConstants.RESPONSE_OnGetUserPublishedItemVoteDetails:
               this.log("RESPONSE_OnGetUserPublishedItemVoteDetails: " + param1.response);
               if(param1.response != SteamResults.OK)
               {
                  this.log("FAILED!");
                  break;
               }
               _loc6_ = this.API.getUserPublishedItemVoteDetailsResult();
               this.log("getUserPublishedItemVoteDetails() == " + (_loc6_ ? _loc6_.result : "null"));
               if(!_loc6_)
               {
                  return;
               }
               this.log("vote: " + _loc6_.vote);
               break;
            default:
               this.log("Generic STEAM RESPONSE:" + param1.req_type + " response:" + param1.response);
         }
      }
      
      private function OnDownload() : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         var _loc1_:DownloadUGCResult = this.API.getUGCDownloadResult(this.ugcHandle);
         this.log("Result for " + this.ugcHandle + ": " + _loc1_);
         if(_loc1_)
         {
            this.log("File: " + _loc1_.fileName + ", handle: " + _loc1_.fileHandle + ", size: " + _loc1_.size);
            _loc2_ = new ByteArray();
            _loc3_ = Boolean(this.API.UGCRead(_loc1_.fileHandle,_loc1_.size,0,_loc2_));
            this.log("UGCRead(...) == " + _loc3_);
            if(_loc3_)
            {
               _loc4_ = _loc2_.readUTFBytes(_loc1_.size);
               this.log("Result: " + _loc4_);
               this.contentResult.content = _loc4_;
               if(this.onContentLoaded != null)
               {
                  this.onContentLoaded.call(this,this.contentResult);
               }
            }
            if(this.IDS.length > 0)
            {
               this.id = this.IDS.shift();
               _loc3_ = Boolean(this.API.getPublishedFileDetails(this.id));
               this.log(this.id + " - " + _loc3_);
            }
            else
            {
               this.log("Checking for more content... " + this.currentPage + " / " + this.pagesTotal);
               if(this.currentPage < this.pagesTotal)
               {
                  ++this.currentPage;
                  this.log("enumerateUserSubscribedFiles(" + this.currentPage + ") == " + this.API.enumerateUserSubscribedFiles(this.currentPage * 50));
                  return;
               }
               this.log("FINISHED ITERATING CONTENT");
               this.workshopContentDownloaded();
            }
         }
      }
      
      private function OnEnumeratePublishedFilesByUserAction() : void
      {
         var _loc1_:FilesByUserActionResult = this.API.enumeratePublishedFilesByUserActionResult();
         this.log("Files for action " + _loc1_.action + ": " + _loc1_.resultsReturned + "/" + _loc1_.totalResults);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.resultsReturned)
         {
            this.log(_loc2_ + ": " + _loc1_.publishedFileId[_loc2_] + " - " + _loc1_.timeUpdated[_loc2_]);
            if(_loc1_.action == WorkshopConstants.FILEACTION_Played)
            {
               this.log("setUserPublishedFileAction(..., Completed) == " + this.API.setUserPublishedFileAction(_loc1_.publishedFileId[_loc2_],WorkshopConstants.FILEACTION_Completed));
            }
            _loc2_++;
         }
      }
      
      private function OnGetPublishedFileDetails() : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Window = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Boolean = false;
         var _loc1_:FileDetailsResult = this.API.getPublishedFileDetailsResult(this.id);
         this.FileDetailsToContent(_loc1_);
         this.log("Result for " + this.id + ": " + _loc1_);
         if(_loc1_)
         {
            if(this.updatingExistingFile)
            {
               _loc4_ = _loc1_.fileName;
               _loc5_ = this.filenam;
               this.log("Checking content: " + _loc1_.fileName + ", handle: " + _loc1_.fileHandle);
               if(_loc4_ != _loc5_)
               {
                  _loc4_ = _loc4_.replace("[Item]","");
                  _loc4_ = _loc4_.replace("[Level]","");
                  _loc4_ = _loc4_.replace("[Contract]","");
                  if(_loc4_.substr(0,1) == " ")
                  {
                     _loc4_ = _loc4_.substr(1);
                  }
               }
               this.log(_loc5_ + " == " + _loc4_ + "?");
               if(_loc5_ == _loc4_)
               {
                  this.log("Found existing content: " + _loc4_ + " " + _loc1_.fileHandle);
                  this.UpdateExistingFile(this.id);
               }
               else if(this.IDS.length > 0)
               {
                  this.id = this.IDS.shift();
                  _loc2_ = Boolean(this.API.getPublishedFileDetails(this.id));
               }
               else
               {
                  if(this.currentPage < this.pagesTotal)
                  {
                     ++this.currentPage;
                     _loc6_ = Boolean(this.API.enumerateUserSharedWorkshopFiles(this._userId,this.currentPage * 50,[],[]));
                     this.log("enumerateSharedFiles(" + this._userId + ", " + this.currentPage + ") == " + _loc6_);
                     return;
                  }
                  this.updatingExistingFile = false;
                  this.UploadFiles();
               }
               return;
            }
            this.log("File: " + _loc1_.fileName + ", handle: " + _loc1_.fileHandle);
            this.ugcHandle = _loc1_.fileHandle;
            _loc2_ = Boolean(this.API.UGCDownload(_loc1_.fileHandle,0));
            this.log("UGCDownload(...) == " + _loc2_);
            _loc3_ = GameState.menuHandler.getMenu("Library");
            GameState.ui.showTooltip(_loc3_,"Downloading...\n" + _loc1_.fileName + "\n",0,500,_loc3_.actualWidth);
         }
         else
         {
            GameState.ui.showTooltip(_loc3_,"Failed...\n",0,500,_loc3_.actualWidth);
         }
      }
      
      private function FileDetailsToContent(param1:FileDetailsResult) : void
      {
         this.contentResult = {};
         this.contentResult.title = param1.title;
         this.contentResult.description = param1.description;
         this.contentResult.tags = param1.tags;
         this.contentResult.creator = param1.owner;
         this.contentResult.url = param1.url;
      }
      
      private function OnEnumerateFiles(param1:Boolean) : void
      {
         var _loc4_:Boolean = false;
         var _loc2_:UserFilesResult = param1 ? this.API.enumerateUserSharedWorkshopFilesResult() : this.API.enumerateUserPublishedFilesResult();
         this.IDS = _loc2_.publishedFileId;
         if(!this.IDS || this.IDS.length == 0 || _loc2_.totalResults == 0)
         {
            this.log("No existing content.");
            this.updatingExistingFile = false;
            this.UploadFiles();
            return;
         }
         this.currentResults = _loc2_.resultsReturned;
         this.pagesTotal = this.currentResults / 50 >> 0;
         this.log("User " + (param1 ? "shared" : "published") + " files: " + this.currentResults + " (page " + this.currentPage + 1 + "/" + this.pagesTotal + 1 + ")");
         var _loc3_:int = 0;
         while(_loc3_ < this.currentResults)
         {
            this.id = _loc2_.publishedFileId[_loc3_];
            this.log(_loc3_ + ": " + this.id);
            _loc3_++;
         }
         if(this.IDS.length > 0)
         {
            this.id = this.IDS.shift();
            _loc4_ = Boolean(this.API.getPublishedFileDetails(this.id));
            this.log(_loc3_ + ": " + this.id + " - " + _loc4_);
         }
      }
      
      private function OnEnumeratePublishedFiles() : void
      {
         var _loc2_:* = undefined;
         var _loc4_:FileDetailsResult = null;
         var _loc1_:WorkshopFilesResult = this.API.enumeratePublishedWorkshopFilesResult();
         this.log("Workshop files: " + _loc1_.resultsReturned + "/" + _loc1_.totalResults);
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.resultsReturned)
         {
            this.log(_loc3_ + ": " + _loc2_ + " - " + _loc1_.score[_loc3_]);
            _loc2_ = _loc1_.publishedFileId[_loc3_];
            this.log(_loc3_ + ": " + _loc2_);
            _loc4_ = this.API.getPublishedFileDetailsResult(_loc2_);
            this.contentResult = {};
            this.contentResult.creator = _loc4_.owner;
            this.log("Result for " + _loc2_ + ": " + _loc4_);
            this.log(_loc4_.result + " " + _loc4_.file + " " + _loc4_.title + " " + _loc4_.description);
            if(_loc4_)
            {
               this.log("File: " + _loc4_.fileName + ", handle: " + _loc4_.fileHandle);
            }
            this.publishedFile = _loc1_.publishedFileId[0];
            _loc3_++;
         }
      }
      
      private function OnEnumerateUserSubscribedFiles() : void
      {
         var _loc3_:Boolean = false;
         var _loc1_:SubscribedFilesResult = this.API.enumerateUserSubscribedFilesResult();
         this.IDS = _loc1_.publishedFileId;
         this.currentResults = _loc1_.resultsReturned;
         this.pagesTotal = this.currentResults / 50 >> 0;
         this.log("User subscribed files: " + this.currentResults + " (page " + this.currentPage + 1 + "/" + this.pagesTotal + 1 + ")");
         var _loc2_:int = 0;
         while(_loc2_ < this.currentResults)
         {
            this.id = _loc1_.publishedFileId[_loc2_];
            this.log(_loc2_ + ": " + this.id);
            _loc2_++;
         }
         if(this.IDS.length > 0)
         {
            this.id = this.IDS.shift();
            _loc3_ = Boolean(this.API.getPublishedFileDetails(this.id));
            this.log(this.id + " - " + _loc3_);
         }
      }
      
      private function OnPublishWorkshopFile() : void
      {
         this.publishedFile = this.API.publishWorkshopFileResult();
         this.log("File published as " + this.publishedFile);
         if(this.publishedFile == WorkshopConstants.PUBLISHEDFILEID_Invalid)
         {
            this.log("FAILED!");
            return;
         }
         this.log("subscribePublishedFile(...) == " + this.API.subscribePublishedFile(this.publishedFile));
         var _loc1_:String = "Content shared!\nIt may take a while for it to appear on the Workshop publicly.\nSee your subscribed items to find it.\n\n\n";
         this.log(_loc1_);
         GameState.ui.showTooltip(GameState.menuHandler.getMenu("Library"),_loc1_,0,5000,200,36);
      }
      
      public function Test() : *
      {
         if(!this.API)
         {
            return;
         }
         this.API.setCloudEnabledForApp(true);
      }
      
      private function OnFileShared() : void
      {
         var _loc1_:* = undefined;
         ++this.sharedFiles;
         if(this.sharedFiles == 1)
         {
            _loc1_ = this.API.fileShare(this.filenam);
            this.log("fileShare(\'" + this.filenam + "\') == " + _loc1_);
         }
         if(this.sharedFiles == 2)
         {
            this.log("Ready to publish!");
            this.PublishOnWorkShop();
         }
         GameState.ui.showTooltip(GameState.menuHandler.getMenu("Library"),"Preparing to publish...",0,500,200,36);
      }
   }
}

