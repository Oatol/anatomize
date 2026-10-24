package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class HailStaff extends Trigger
   {
      
      private var windFrom:b2Vec2;
      
      public function HailStaff()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:b2Vec2 = null;
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = new b2Vec2(0,-75 * param2.size);
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         this.windFrom = new b2Vec2(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y);
         if(param2.triggerRadius > 10)
         {
            _loc5_ = param2.triggerRadius * 0.1 * TimeLord.speed;
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = "hail";
               if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
               {
                  _loc7_ = param2.pfx.getParticle();
               }
               _loc8_ = GeneralUtils.pointOnCircle(this.windFrom.x,this.windFrom.y,triggerRadius,Math.random() * 360);
               GameState.particles.addParticles(_loc8_.x,_loc8_.y,1,_loc7_,(this.windFrom.x - _loc8_.x) * -0.1 + bodyVel.x * 0.1,(this.windFrom.y - _loc8_.y) * -0.1 + bodyVel.y * 0.1,1,1);
               _loc6_++;
            }
         }
         if(param2.triggerRadius < 0)
         {
            param2.triggerRadius += TimeLord.speed;
         }
         if(param2.triggerRadius > 0)
         {
            param2.triggerRadius += TimeLord.speed;
            param2.triggerRadius *= 1 + 0.2 * TimeLord.speed;
            if(param2.triggerRadius > 50)
            {
               this.Effect();
            }
         }
         if(param2.triggerRadius > triggerForce)
         {
            param2.triggerRadius = -60;
         }
      }
      
      override public function OnSharp(param1:b2Body, param2:Number = 0) : void
      {
         super.OnSharp(param1);
         if(ud.triggerRadius > 0)
         {
            return;
         }
         if(param1.IsStatic())
         {
            return;
         }
         if(userData(param1.GetUserData()).temperature < 0)
         {
            return;
         }
         ud.triggerRadius = 10;
      }
      
      public function Effect() : void
      {
         var _loc1_:b2Vec2 = null;
         var _loc3_:b2Body = null;
         var _loc4_:userData = null;
         if(TimeLord.speed < 1 && Math.random() * TimeLord.speed > TimeLord.speed * 0.1)
         {
            return;
         }
         sounds.play("hiss",body,pixelCenter,Math.random());
         var _loc2_:int = 0;
         while(_loc2_ < 10)
         {
            _loc1_ = GeneralUtils.pointOnCircle(this.windFrom.x,this.windFrom.y,triggerRadius,Math.random() * 360);
            _loc3_ = GameState.objects.spawnItem(O.getItem("circle").vertices,[1],0.2 * ud.size,"hailbullet",_loc1_.x,_loc1_.y,0,["hailbullet"],"hailbullet");
            _loc3_.SetBullet(true);
            _loc3_.SetLinearVelocity(new b2Vec2(bodyVel.x * 0.5,bodyVel.y * 0.5));
            _loc3_.ApplyImpulse(new b2Vec2((_loc3_.GetPosition().x - bodyCenter.x) * _loc3_.GetMass() * 100,(_loc3_.GetPosition().y - bodyCenter.y) * _loc3_.GetMass() * 100),_loc3_.GetPosition());
            _loc4_ = _loc3_.GetUserData();
            _loc4_.ignore = "blizzardstaff";
            _loc4_.trigger = new HailBullet();
            _loc4_.triggered = true;
            _loc4_.killOnContact = true;
            _loc2_++;
         }
      }
   }
}

