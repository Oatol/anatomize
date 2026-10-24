package triggers
{
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class PurityStaff extends Trigger
   {
      
      internal var decals:Sprite;
      
      internal var fx:BitmapData;
      
      public function PurityStaff()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         this.decals = ud.graphic.getChildByName("decals") as Sprite;
         this.fx = BoxUtils.getEffectBMD(param1);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:userData = null;
         var _loc5_:b2Body = null;
         var _loc6_:BitmapData = null;
         super.trigger(param1,param2);
         var _loc4_:Vector.<b2Body> = param2.connected;
         for each(_loc5_ in _loc4_)
         {
            _loc3_ = userData(_loc5_.GetUserData());
            _loc3_.health = _loc3_.maxhealth;
            if(_loc3_.bleeding.length > 0)
            {
               _loc3_.bleeding = [];
            }
            _loc3_.resistAliveBreak = true;
            _loc3_.temperature = param2.temperature;
            _loc6_ = BoxUtils.getEffectBMD(_loc5_);
            if(_loc6_)
            {
               _loc6_.fillRect(_loc6_.rect,0);
            }
         }
      }
   }
}

