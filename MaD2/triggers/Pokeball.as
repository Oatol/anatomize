package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import environment.Environment;
   
   public class Pokeball extends Trigger
   {
      
      protected var radius:Number = 300;
      
      protected var pokemon:String = "empty";
      
      public function Pokeball()
      {
         super();
      }
      
      override public function OnLoadCustom() : void
      {
         if(ud.triggerCustom)
         {
            this.pokemon = ud.triggerCustom;
         }
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(param2.triggerDuration > 0)
         {
            param2.triggerDuration -= TimeLord.speed;
            if(param2.triggerDuration <= 0)
            {
               param2.triggered = false;
               param2.triggerDuration = 0;
            }
            BoxUtils.randomParticlesOnBody(param1,"sparkle");
            return;
         }
         if(this.pokemon == "empty")
         {
            return;
         }
         var _loc3_:b2Vec2 = new b2Vec2(pixelCenter.x + (Math.random() * this.radius - this.radius * 0.5),pixelCenter.y + (Math.random() * this.radius - this.radius * 0.5));
         if(Math.abs(_loc3_.x) < 20)
         {
            _loc3_.x *= Math.random() * this.radius - this.radius * 0.5;
         }
         if(Math.abs(_loc3_.y) < 20)
         {
            _loc3_.y *= Math.random() * this.radius - this.radius * 0.5;
         }
         var _loc4_:Environment = GameState.environment;
         var _loc5_:int = 0;
         while(_loc5_ < 10 && (_loc3_.x < _loc4_.borderLeft || _loc3_.x > _loc4_.borderRight))
         {
            _loc3_.x = pixelCenter.x + (Math.random() * this.radius - this.radius * 0.5);
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < 10 && (_loc3_.y < -_loc4_.borderTop + GameState.height || _loc3_.y > GameState.height))
         {
            _loc3_.y = pixelCenter.y + (Math.random() * this.radius - this.radius * 0.5);
            _loc5_++;
         }
         GameState.objects.spawnObject(this.pokemon,_loc3_.x,_loc3_.y,0,false,true);
         this.pokemon = "empty";
         param2.triggerCustom = this.pokemon;
         param2.triggerDuration = param2.originalTriggerDuration;
         BoxUtils.randomSlopeParticles("sparkle",pixelCenter,_loc3_);
      }
      
      override public function OnJoint(param1:b2Body, param2:String) : Boolean
      {
         if(param2 == "weak")
         {
            return false;
         }
         return true;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(ud.triggerDuration > 0)
         {
            return false;
         }
         if(this.pokemon != "empty")
         {
            return false;
         }
         if(param1.IsStatic())
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if(!_loc7_.saveable)
         {
            return false;
         }
         this.pokemon = _loc7_.name;
         ud.triggerCustom = this.pokemon;
         _loc7_.dead = true;
         Body.Disintegrate(param1,"sparkle",100,1,1);
         ud.triggerDuration = ud.originalTriggerDuration;
         ud.triggered = true;
         return true;
      }
   }
}

