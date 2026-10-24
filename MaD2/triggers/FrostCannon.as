package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Gun.Firearm;
   import com.anegmetex.Soundmanager.sounds;
   
   public class FrostCannon extends Firearm
   {
      
      internal var ud:userData;
      
      public var charging:Number = 100;
      
      internal var shots:int = 0;
      
      public function FrostCannon(param1:b2Body)
      {
         super("burstpistol",param1,3,200,20,20,"frost",1,1);
         this.ud = userData(param1.GetUserData());
      }
      
      override public function shoot() : Boolean
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:b2Vec2 = null;
         var _loc4_:b2Vec2 = null;
         var _loc5_:b2Vec2 = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:int = 0;
         var _loc8_:b2Vec2 = null;
         var _loc9_:Vector.<MyLittleParticle> = null;
         this.charging -= TimeLord.speed;
         if(this.charging <= 0)
         {
            this.charging = 100;
            this.ud.triggered = false;
            _loc1_ = "snowBig";
            _loc2_ = "snow";
            if(Boolean(this.ud.pfx) && this.ud.pfx.replaceDefault)
            {
               _loc1_ = this.ud.pfx.getParticle();
               _loc2_ = this.ud.pfx.getParticle();
            }
            _loc3_ = new b2Vec2(-60 * this.ud.size * (this.ud.flipped ? -1 : 1),-4 * this.ud.size);
            _loc4_ = BoxUtils.rotateVec(_loc3_,body.GetAngle());
            _loc5_ = new b2Vec2(body.GetWorldCenter().x * Physics.scale,body.GetWorldCenter().y * Physics.scale);
            _loc6_ = new b2Vec2(_loc5_.x + _loc4_.x,_loc5_.y + _loc4_.y);
            _loc7_ = 0;
            while(_loc7_ < 16)
            {
               GameState.particles.addParticles(_loc6_.x,_loc6_.y,1,_loc1_,(_loc6_.x - _loc5_.x) * 0.4,(_loc6_.y - _loc5_.y) * 0.4,10,10);
               GameState.particles.addParticles(_loc6_.x,_loc6_.y,1,_loc2_,0,0,20,20);
               _loc7_++;
            }
            sounds.play("swish",body,_loc5_);
            return super.shoot();
         }
         if(Math.random() > 0.6)
         {
            _loc1_ = "snow";
            if(Boolean(this.ud.pfx) && this.ud.pfx.replaceDefault)
            {
               _loc1_ = this.ud.pfx.getParticle();
            }
            _loc3_ = new b2Vec2(60 * this.ud.size * (this.ud.flipped ? -1 : 1),-4 * this.ud.size);
            _loc4_ = BoxUtils.rotateVec(_loc3_,body.GetAngle());
            _loc6_ = new b2Vec2(body.GetWorldCenter().x * Physics.scale + _loc4_.x,body.GetWorldCenter().y * Physics.scale + _loc4_.y);
            _loc8_ = GeneralUtils.pointOnCircle(_loc6_.x,_loc6_.y,this.charging * (Math.random() * 0.4 + 1.8),body.GetAngle() * Vars.toDegrees + Math.random() * (-100 + Math.random() * 200) + (this.ud.flipped ? 180 : 0));
            _loc9_ = GameState.particles.addParticles(_loc8_.x,_loc8_.y,1,_loc1_,(_loc6_.x - _loc8_.x) * 0.2 + body.GetLinearVelocity().x * 0.1,(_loc6_.y - _loc8_.y) * 0.2 + body.GetLinearVelocity().y * 0.1,1,1);
            if((Boolean(_loc9_)) && Boolean(_loc9_[0]))
            {
               _loc9_[0].friction = 0.8;
            }
         }
         return false;
      }
   }
}

