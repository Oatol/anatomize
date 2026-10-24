package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Meteor extends Trigger
   {
      
      public function Meteor()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:MyLittleParticle = null;
         var _loc5_:Number = NaN;
         var _loc6_:b2Vec2 = null;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:b2Body = null;
         super.trigger(param1,param2);
         if(param2.triggerState < 0)
         {
            param2.dead = true;
            Body.Disintegrate(param1,"stump",20,10,10);
            if(param2.triggerState <= -5)
            {
               return;
            }
            param2.triggerState *= -1;
            _loc5_ = GameState.objects.spawnScale;
            _loc6_ = new b2Vec2();
            _loc7_ = param2.size * 1.5 / param2.triggerState;
            GameState.objects.spawnScale = _loc7_;
            _loc8_ = 0;
            while(_loc8_ < 2)
            {
               _loc6_.x = pixelCenter.x + Math.random() * 100 * _loc7_ - 50 * _loc7_;
               _loc6_.y = pixelCenter.y + Math.random() * 100 * _loc7_ - 50 * _loc7_;
               _loc9_ = GameState.objects.spawnObject("meteor",_loc6_.x,_loc6_.y,Math.random() * 360,false,true,param2.skin);
               if(_loc9_)
               {
                  _loc9_.ApplyForce(new b2Vec2(Math.random() * 1000 - 500,Math.random() * 1000 - 500),_loc9_.GetWorldCenter());
                  userData(_loc9_.GetUserData()).triggerState = param2.triggerState;
               }
               _loc8_++;
            }
            GameState.objects.spawnScale = _loc5_;
            return;
         }
         if(param1.GetLinearVelocity().Length() < 500)
         {
            param1.GetLinearVelocity().Multiply(1.1);
         }
         var _loc3_:Vector.<MyLittleParticle> = BoxUtils.randomParticlesOnBody(param1,"fire3",2);
         for each(_loc4_ in _loc3_)
         {
            _loc4_.vx = bodyVel.x * 0.1;
            _loc4_.vy = bodyVel.y * 0.1;
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if(!_loc7_ || _loc7_.name == "meteor")
         {
            return false;
         }
         if(Math.random() > 0.9)
         {
            ud.triggerState *= -1;
            --ud.triggerState;
         }
         return true;
      }
   }
}

