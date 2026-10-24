package
{
   import flash.utils.describeType;
   
   public class ShapeUserData
   {
      
      public var name:String;
      
      public var alpha:Number = 1;
      
      public var sticky:Boolean;
      
      public var sharp:Boolean;
      
      public var sensor:Boolean;
      
      public var invisible:Boolean = false;
      
      public var decorative:Boolean = false;
      
      public var randomDecoration:Boolean = false;
      
      public function ShapeUserData(param1:String, param2:String = "")
      {
         super();
         this.name = param1;
         this.updateProperties(param2,",");
      }
      
      public function setProperties(param1:String) : void
      {
         this.updateProperties(param1,",");
      }
      
      private function updateProperties(param1:String, param2:String) : void
      {
         var _loc6_:String = null;
         if(!param1 || param1.length == 0)
         {
            return;
         }
         var _loc3_:Array = ["sticky","sharp","sensor","ghost","unbreakable"];
         param1 = param1.toLowerCase();
         var _loc4_:Array = param1.split(param2);
         var _loc5_:int = int(_loc4_.length);
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_)
         {
            _loc6_ = _loc4_[_loc7_];
            if(_loc3_.indexOf(_loc6_) != -1)
            {
               this[_loc6_] = true;
            }
            else
            {
               this[_loc6_] = false;
            }
            _loc7_++;
         }
      }
      
      public function copyProperties(param1:ShapeUserData) : *
      {
         var _loc4_:String = null;
         var _loc2_:XML = describeType(param1);
         var _loc3_:XMLList = _loc2_..variable.@name + _loc2_..accessor.@name;
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_ != "width" && _loc4_ != "height" && _loc4_ != "cycle" && _loc4_ != "graphic")
            {
               this[_loc4_] = param1[_loc4_];
            }
         }
      }
      
      public function getProperties() : Array
      {
         var _loc5_:* = undefined;
         var _loc1_:Array = [];
         var _loc2_:Array = ["sticky","sharp","sensor"];
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            if(this[_loc5_])
            {
               _loc1_.push(_loc5_);
            }
            _loc4_++;
         }
         return _loc1_;
      }
      
      internal function serialize() : Object
      {
         var _loc1_:Object = new Object();
         if(this.sticky)
         {
            _loc1_.sticky = true;
         }
         if(this.sharp)
         {
            _loc1_.sharp = true;
         }
         if(this.sensor)
         {
            _loc1_.sensor = true;
         }
         if(this.invisible)
         {
            _loc1_.invisible = true;
         }
         if(this.decorative)
         {
            _loc1_.decorative = true;
         }
         if(this.randomDecoration)
         {
            _loc1_.randomDecoration = true;
         }
         return _loc1_;
      }
   }
}

