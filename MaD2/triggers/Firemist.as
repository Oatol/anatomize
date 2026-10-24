package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Firemist extends Trigger
   {
      
      public function Firemist()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         var _loc3_:Number = Math.random() * 50 - 25;
         var _loc4_:String = "fire3";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc4_ = param2.pfx.getParticle();
         }
         var _loc5_:b2Vec2 = new b2Vec2(triggerPos.x * param2.size * (param2.flipped ? -1 : 1),triggerPos.y * param2.size);
         var _loc6_:b2Vec2 = BoxUtils.rotateVec(_loc5_,bodyAngle);
         var _loc7_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc6_.x,pixelCenter.y + _loc6_.y);
         var _loc8_:b2Vec2 = new b2Vec2(Math.sin(_loc3_),_loc3_);
         var _loc9_:b2Vec2 = BoxUtils.rotateVec(_loc8_,bodyAngle);
         GameState.particles.addParticles(_loc7_.x + _loc9_.x * param2.size,_loc7_.y + _loc9_.y * param2.size,1,_loc4_,-bodyVel.x * 0.1,-bodyVel.y * 0.1,0,0);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(!ud.triggered)
         {
            return true;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if(!_loc7_)
         {
            return false;
         }
         if(param3.sensor)
         {
            if(_loc7_.temperature < 200)
            {
               _loc7_.temperature += 2;
            }
         }
         else if(param3.sticky)
         {
            if(_loc7_.temperature < 200)
            {
               _loc7_.temperature += 200;
            }
         }
         return true;
      }
   }
}

