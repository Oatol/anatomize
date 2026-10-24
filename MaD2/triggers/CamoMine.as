package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class CamoMine extends Trigger
   {
      
      private var camocol:String;
      
      private var camocols:Array;
      
      internal var exploding:* = false;
      
      internal var camod:Boolean = false;
      
      internal var timeroo:Number = 0;
      
      internal var camobody:b2Body;
      
      public function CamoMine()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(param2.triggerState == 2)
         {
            param2.trigger = new Grenade();
            param2.triggerLock = false;
            param2.triggerDuration = 10;
            param2.triggerForce = 100;
            param2.triggerRadius = 200;
            param2.triggered = true;
            param2.triggered = true;
            param2.triggerLock = true;
            return;
         }
         this.camod = true;
         this.camo();
         this.timeroo -= TimeLord.timerSpeed;
         if(this.timeroo <= 0)
         {
            this.camod = false;
            param2.triggerLock = false;
            param2.triggered = false;
            param2.triggerLock = true;
         }
      }
      
      private function camo() : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:b2Vec2 = null;
         var _loc1_:BitmapData = BoxUtils.getEffectBMD(body);
         if(_loc1_)
         {
            _loc2_ = new Sprite();
            _loc2_.graphics.lineStyle(0,0,0);
            _loc3_ = new b2Vec2();
            _loc3_.Multiply(Physics.scale);
            _loc3_.x -= Bitmap(ud.graphic.getChildByName("effects")).x;
            _loc3_.y -= Bitmap(ud.graphic.getChildByName("effects")).y;
            _loc2_.graphics.beginFill(uint("0x" + this.camocols[Math.random() * this.camocols.length >> 0]),Math.random() * 0.5 + 0.5);
            _loc2_.graphics.drawCircle(_loc3_.x + Math.random() * ud.width - ud.width * 0.5,_loc3_.y + Math.random() * ud.height - ud.height * 0.5,ud.size * Math.random() * 10 + 1);
            _loc2_.graphics.endFill();
            _loc1_.draw(_loc2_);
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc10_:Vector.<Array> = null;
         var _loc11_:int = 0;
         var _loc12_:* = undefined;
         var _loc13_:uint = 0;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(Boolean(this.camobody) && param1 != this.camobody)
         {
            ud.triggerState = 2;
            return true;
         }
         if(this.camod)
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if(_loc7_.name == "wall")
         {
            return false;
         }
         if(_loc7_.hasBeenCut)
         {
            return false;
         }
         if(!_loc7_)
         {
            return false;
         }
         var _loc8_:Array = O.getItem(_loc7_.name).colours;
         this.camocols = new Array();
         var _loc9_:int = 0;
         for(; _loc9_ < _loc8_.length; _loc9_++)
         {
            _loc10_ = _loc7_.skin;
            _loc11_ = Math.random() * _loc8_.length >> 0;
            _loc12_ = _loc8_[_loc11_];
            if(_loc12_ is ShapeUserData)
            {
               if(ShapeUserData(_loc12_).invisible)
               {
                  continue;
               }
               _loc12_ = ShapeUserData(_loc12_).name;
            }
            _loc13_ = BoxUtils.getSkinColour(_loc10_,_loc12_);
            if(_loc13_ != 16711935)
            {
               _loc12_ = _loc13_.toString(16);
            }
            this.camocols.push(_loc12_);
         }
         ud.triggerLock = false;
         ud.triggerState = 1;
         ud.triggered = true;
         ud.triggerLock = true;
         this.timeroo = 60;
         this.camobody = param1;
         return true;
      }
   }
}

