package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Explode extends Trigger
   {
      
      protected var particles:Array = ["explosive","fire2","fire3","explosive","fire2","fire3","bigSmoke","smoke","shock","slice"];
      
      protected var sfx:Array = ["explosion","explosion2","explosion4"];
      
      public function Explode()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc7_:b2Vec2 = null;
         super.trigger(param1,param2);
         var _loc3_:Boolean = true;
         var _loc4_:Object = param2.ParseTriggerCustom();
         if(_loc4_["particles"])
         {
            this.particles = _loc4_["particles"].split(",");
         }
         if(_loc4_["sounds"])
         {
            this.sfx = _loc4_["sounds"].split(",");
         }
         if(_loc4_["cuts"])
         {
            _loc3_ = _loc4_["cuts"] == "true";
         }
         var _loc5_:Number = 200;
         var _loc6_:Number = 4000;
         if(param2.triggerRadius)
         {
            _loc5_ = param2.triggerRadius;
         }
         if(param2.triggerForce)
         {
            _loc6_ = param2.triggerForce;
         }
         Body.Destroy(param1,"explosion");
         World.explode("explosion",pixelCenter,_loc6_ * param2.size,_loc5_ * param2.size,false,_loc3_ ? 10 : 0);
         _loc7_ = new b2Vec2();
         var _loc8_:int = _loc6_ * param2.size >> 0;
         if(_loc8_ > 100)
         {
            _loc8_ = 100;
         }
         var _loc9_:int = 0;
         while(_loc9_ < _loc8_)
         {
            _loc7_.x = pixelCenter.x + Math.random() * _loc5_ * 0.5 - _loc5_ * 0.25;
            _loc7_.y = pixelCenter.y + Math.random() * _loc5_ * 0.5 - _loc5_ * 0.25;
            GameState.particles.addParticles(_loc7_.x,_loc7_.y,1,this.particles[Math.random() * this.particles.length >> 0],bodyVel.x * 0.01,bodyVel.y * 0.01,pixelCenter.x - _loc7_.x,pixelCenter.y - _loc7_.y);
            _loc9_++;
         }
         sounds.random(this.sfx,null,pixelCenter,0.5);
      }
   }
}

