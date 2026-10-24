package
{
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.net.FileFilter;
   import flash.net.FileReference;
   import flash.net.FileReferenceList;
   import flash.utils.ByteArray;
   
   public class MaDLab extends Sprite
   {
      
      private var fileReference:FileReference = new FileReference();
      
      private var fileReferenceList:FileReferenceList = new FileReferenceList();
      
      private var meta:Object = {
         "Title":"",
         "Creator":"",
         "Shapes":0,
         "Vertices":"",
         "Settings":"",
         "Colours":"",
         "Properties":""
      };
      
      private var evt:LabEvent;
      
      private const FILE_FILTER:FileFilter = new FileFilter("PNGs","*.png;");
      
      private const CHAR_SET:String = "iso-8859-1";
      
      private const IDAT_ID:uint = 1229209940;
      
      private const tEXt_ID:uint = 1950701684;
      
      public function MaDLab()
      {
         super();
      }
      
      public function loadMultiple() : void
      {
         this.fileReferenceList.addEventListener(Event.SELECT,this.fileSelectedMultiple);
         this.fileReferenceList.browse([this.FILE_FILTER]);
      }
      
      public function load() : void
      {
         this.fileReference.addEventListener(Event.SELECT,this.fileSelected);
         this.fileReference.browse([this.FILE_FILTER]);
      }
      
      private function fileSelected(param1:Event) : void
      {
         this.fileReference.removeEventListener(Event.SELECT,this.fileSelected);
         this.fileReference.addEventListener(Event.COMPLETE,this.fileLoadComplete);
         this.fileReference.load();
         this.meta = new Object();
      }
      
      private function fileSelectedMultiple(param1:Event) : void
      {
         this.fileReferenceList.removeEventListener(Event.SELECT,this.fileSelected);
         var _loc2_:Array = FileReferenceList(param1.target).fileList;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:FileReference = new FileReference();
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = _loc2_[_loc5_] as FileReference;
            _loc4_.addEventListener(Event.COMPLETE,this.fileLoadCompleteMultiple);
            _loc4_.load();
            _loc5_++;
         }
      }
      
      private function fileLoadCompleteMultiple(param1:Event) : void
      {
         param1.target.removeEventListener(Event.COMPLETE,this.fileLoadCompleteMultiple);
         var _loc2_:Object = this.getMetaData(param1.target.data);
         this.evt = new LabEvent(LabEvent.ON_LOAD_COMPLETE);
         this.evt.customMessage = _loc2_;
         dispatchEvent(this.evt);
      }
      
      private function fileLoadComplete(param1:Event) : void
      {
         this.fileReference.removeEventListener(Event.COMPLETE,this.fileLoadComplete);
         var _loc2_:Loader = new Loader();
         _loc2_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.contentLoaderComplete);
         _loc2_.loadBytes(this.fileReference.data);
      }
      
      private function contentLoaderComplete(param1:Event) : void
      {
         var _loc2_:LoaderInfo = param1.target as LoaderInfo;
         _loc2_.removeEventListener(Event.COMPLETE,this.contentLoaderComplete);
         this.meta = this.getMetaData(this.fileReference.data);
         this.parse(this.meta);
      }
      
      public function parse(param1:Object) : *
      {
         var _loc3_:String = null;
         var _loc2_:int = 0;
         for(_loc3_ in param1)
         {
            _loc2_++;
         }
         if(_loc2_ == 0)
         {
            return;
         }
         this.evt = new LabEvent(LabEvent.ON_LOAD_COMPLETE);
         this.evt.customMessage = param1;
         dispatchEvent(this.evt);
      }
      
      public function getMetaData(param1:ByteArray) : Object
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:Object = {};
         _loc3_ = 0;
         while(_loc3_ < param1.length - 4)
         {
            param1.position = _loc3_;
            if(param1.readUnsignedInt() == this.tEXt_ID)
            {
               param1.position = _loc3_ - 4;
               _loc7_ = int(param1.readUnsignedInt());
               _loc8_ = 0;
               _loc4_ = 0;
               while(_loc4_ < _loc7_)
               {
                  param1.position = _loc3_ + 4 + _loc4_;
                  if(param1.readByte() == 0)
                  {
                     _loc8_ = _loc4_;
                     break;
                  }
                  _loc4_++;
               }
               param1.position = _loc3_ + 4;
               _loc5_ = param1.readMultiByte(_loc8_,this.CHAR_SET);
               param1.position = _loc3_ + 4 + _loc8_ + 1;
               _loc6_ = param1.readMultiByte(_loc7_ - (_loc8_ + 1),this.CHAR_SET);
               _loc2_[_loc5_] = _loc6_;
            }
            if(param1.readUnsignedInt() == this.IDAT_ID)
            {
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
   }
}

