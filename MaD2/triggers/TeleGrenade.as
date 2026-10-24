package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class TeleGrenade extends Trigger
   {
      
      public function TeleGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc6_:b2Body = null;
         var _loc7_:String = null;
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = new b2Vec2((50 + Math.random() * 700) / Physics.scale,(50 + Math.random() * 500) / Physics.scale);
         var _loc4_:int = 0;
         while(_loc4_ < 20)
         {
            _loc7_ = "void";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc7_ = param2.pfx.getParticle();
            }
            GameState.particles.addParticles(_loc3_.x * Physics.scale,_loc3_.y * Physics.scale,1,_loc7_,0,0,4,4);
            _loc4_++;
         }
         var _loc5_:* = Body.GetAround(param1,param2.triggerRadius,param2.triggerRadius);
         for each(_loc6_ in _loc5_)
         {
            if(userData(_loc6_.GetUserData()).name != "telegrenade")
            {
               _loc6_.SetXForm(_loc3_,Math.random() * Math.PI * 2);
            }
         }
         param2.trigger = new Disintegrate("void",50,1);
         sounds.play("swish",param1,pixelCenter);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         ud.triggered = true;
         return true;
      }
   }
}

