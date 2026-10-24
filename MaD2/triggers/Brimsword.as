package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Brimsword extends Trigger
   {
      
      public function Brimsword()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:b2Vec2 = null;
         var _loc5_:b2Vec2 = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Vec2 = null;
         var _loc9_:String = null;
         super.trigger(param1,param2);
         if(Math.random() > 0.9)
         {
            _loc3_ = Math.random() * 100 - 65;
            _loc4_ = new b2Vec2(triggerPos.x * param2.size * (param2.flipped ? -1 : 1),triggerPos.y * param2.size);
            _loc5_ = BoxUtils.rotateVec(_loc4_,bodyAngle);
            _loc6_ = new b2Vec2(pixelCenter.x + _loc5_.x,pixelCenter.y + _loc5_.y);
            _loc7_ = new b2Vec2(Math.sin(_loc3_),_loc3_);
            _loc8_ = BoxUtils.rotateVec(_loc7_,bodyAngle);
            _loc9_ = "lava";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc9_ = param2.pfx.getParticle();
            }
            GameState.particles.addParticles(_loc6_.x + _loc8_.x * param2.size,_loc6_.y + _loc8_.y * param2.size,1,_loc9_,bodyVel.x * 0.1,bodyVel.y * 0.1,0,0);
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param3.name != "ff0000")
         {
            return false;
         }
         Body.Lava(param1);
         return true;
      }
   }
}

