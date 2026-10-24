package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class PaintGrenade extends Trigger
   {
      
      public function PaintGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:* = undefined;
         var _loc8_:userData = null;
         var _loc9_:b2Body = null;
         super.trigger(param1,param2);
         Body.Destroy(param1,"functionality");
         sounds.play("explosion5",param1,pixelCenter);
         var _loc3_:int = 0;
         while(_loc3_ < 40)
         {
            _loc4_ = 50 + Math.random() * 200 >> 0;
            _loc5_ = 50 + Math.random() * 200 >> 0;
            _loc6_ = 50 + Math.random() * 200 >> 0;
            _loc7_ = _loc4_.toString(16) + _loc5_.toString(16) + _loc6_.toString(16);
            _loc8_ = Properties.objTemp(_loc7_);
            _loc8_.projectileName = "pnt";
            _loc9_ = Spawn.circle(pixelCenter.x + Math.random() * 50 - 25,pixelCenter.y + Math.random() * 50 - 25,1,_loc8_,[1,1,1]);
            _loc9_.SetBullet(true);
            _loc9_.SetLinearVelocity(new b2Vec2(bodyVel.x * 0.5,bodyVel.y * 0.5));
            _loc9_.ApplyImpulse(new b2Vec2((Math.random() * triggerForce - triggerForce * 0.5) * _loc9_.GetMass() * param2.size,(Math.random() * triggerForce - triggerForce * 0.5) * _loc9_.GetMass() * param2.size),_loc9_.GetPosition());
            _loc8_ = _loc9_.GetUserData();
            _loc8_.trigger = new Paint();
            _loc8_.triggered = true;
            _loc8_.killOnContact = true;
            _loc3_++;
         }
      }
   }
}

