package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import environment.Environment;
   
   public class ContactGrenade extends Trigger
   {
      
      public function ContactGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(BoxUtils.vectorDist(param1.GetPosition(),param2.triggerPos) > 3 * param2.size)
         {
            return;
         }
         if(param2.triggerDuration <= 0)
         {
            param2.trigger = new Disintegrate("shock",100,20);
         }
         --param2.triggerDuration;
         var _loc3_:b2Vec2 = new b2Vec2(pixelCenter.x + (Math.random() * 500 - 250),pixelCenter.y + (Math.random() * 500 - 250));
         var _loc4_:Environment = GameState.environment;
         var _loc5_:int = 0;
         while(_loc5_ < 10 && (_loc3_.x < _loc4_.borderLeft || _loc3_.x > _loc4_.borderRight))
         {
            _loc3_.x = pixelCenter.x + (Math.random() * 500 - 250);
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < 10 && (_loc3_.y < -_loc4_.borderTop + GameState.height || _loc3_.y > GameState.height))
         {
            _loc3_.y = pixelCenter.y + (Math.random() * 500 - 250);
            _loc5_++;
         }
         _loc3_.Multiply(1 / Physics.scale);
         var _loc6_:b2Vec2 = new b2Vec2(param1.GetPosition().x - _loc3_.x,param1.GetPosition().y - _loc3_.y);
         _loc6_.Multiply(10);
         BoxUtils.randomSlopeParticles("shock",new b2Vec2(_loc3_.x * Physics.scale,_loc3_.y * Physics.scale),pixelCenter);
         param1.SetXForm(_loc3_,Math.random() * Math.PI * 2);
         param1.SetLinearVelocity(_loc6_);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param1.IsStatic())
         {
            return false;
         }
         Body.Damage(param1,200,param5,new b2Vec2(),new b2Vec2(1,1),false);
         ud.triggerLock = false;
         ud.triggered = true;
         ud.triggerPos = param5.Copy();
         ud.triggerLock = true;
         return true;
      }
   }
}

