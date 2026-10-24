package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class DustForge extends Trigger
   {
      
      internal var tcg:String;
      
      public function DustForge()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc6_:b2Body = null;
         var _loc7_:userData = null;
         var _loc8_:Dust = null;
         super.trigger(param1,param2);
         param2.triggerDuration -= TimeLord.speed;
         var _loc3_:b2Vec2 = param2.triggerPos.Copy();
         _loc3_.Multiply(param2.size);
         if(param2.flipped)
         {
            _loc3_.x *= -1;
         }
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc5_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y);
         GameState.particles.addParticles(_loc5_.x,_loc5_.y,1,Math.random() > 0.5 ? "smoke" : "petal",0,0,1,1);
         if(param2.triggerDuration <= 0)
         {
            if(!this.tcg)
            {
               param2.triggered = false;
               return;
            }
            Properties.forceObjVanilla = 0;
            _loc6_ = GameState.objects.spawnObject("moltendust",_loc5_.x,_loc5_.y,0,false,true);
            param2.triggerLock = false;
            param2.triggered = false;
            param2.triggerLock = true;
            if(_loc6_)
            {
               _loc7_ = userData(_loc6_.GetUserData());
               _loc8_ = _loc7_.trigger as Dust;
               _loc8_.item = this.tcg;
               _loc7_.triggerCustom = this.tcg;
            }
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc7_:userData = null;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param3.sticky)
         {
            _loc7_ = userData(param1.GetUserData());
            if(_loc7_)
            {
               _loc7_.dead = true;
               if(Boolean(_loc7_.name) && Boolean(O.getItem(_loc7_.name)))
               {
                  this.tcg = _loc7_.name;
                  ud.triggerDuration = 120;
                  ud.triggerLock = false;
                  ud.triggered = true;
                  ud.triggerLock = true;
               }
            }
         }
         return true;
      }
   }
}

