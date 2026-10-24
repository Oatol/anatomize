package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Dust extends Trigger
   {
      
      public var item:String;
      
      public function Dust()
      {
         super();
      }
      
      override public function OnLoadCustom() : void
      {
         super.OnLoadCustom();
         this.item = ud.triggerCustom;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         super.trigger(param1,param2);
         var _loc3_:int = Properties.forceObjVanilla;
         if(triggerState == 1)
         {
            if(param2.temperature < 1000)
            {
               ++param2.temperature;
            }
            if(param2.temperature < 0)
            {
               Properties.forceObjVanilla = 0;
               _loc4_ = GameState.objects.spawnObject("crystaldust",pixelCenter.x,pixelCenter.y,0,false,true);
               if(_loc4_)
               {
                  param2.dead = true;
                  Dust(userData(_loc4_.GetUserData()).trigger).item = this.item;
                  userData(_loc4_.GetUserData()).triggerCustom = this.item;
                  this.particles();
               }
            }
         }
         else if(triggerState == 2)
         {
            Properties.forceObjVanilla = 0;
            _loc4_ = GameState.objects.spawnObject("dustpile",pixelCenter.x,pixelCenter.y,0,false,true);
            if(_loc4_)
            {
               param2.dead = true;
               Dust(userData(_loc4_.GetUserData()).trigger).item = this.item;
               userData(_loc4_.GetUserData()).triggerCustom = this.item;
               this.particles();
            }
            param2.triggerLock = false;
            param2.triggered = false;
            param2.triggerLock = true;
         }
         Properties.forceObjVanilla = _loc3_;
      }
      
      private function particles() : void
      {
         var _loc2_:b2Vec2 = null;
         var _loc1_:String = "petal";
         if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
         {
            _loc1_ = ud.pfx.getParticle();
         }
         var _loc3_:int = 0;
         while(_loc3_ < 40)
         {
            _loc2_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,Math.random() * 30 * ud.size,Math.random() * 360);
            GameState.particles.addParticles(_loc2_.x,_loc2_.y,1,_loc1_,0,0,Math.random() * 10,Math.random() * 10);
            _loc3_++;
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(ud.triggerState != 2)
         {
            return false;
         }
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param4 > 50000)
         {
            ud.triggerLock = false;
            ud.triggered = true;
            ud.triggerLock = true;
         }
         return true;
      }
   }
}

