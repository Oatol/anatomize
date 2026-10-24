package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Gun.Firearm;
   
   public class Handshake extends Firearm
   {
      
      internal var ud:userData;
      
      public var charging:Number = 100;
      
      internal var shots:int = 0;
      
      public function Handshake(param1:b2Body)
      {
         super("burstpistol",param1,3,20,20,20,"shake",0.8,1);
         this.ud = userData(param1.GetUserData());
      }
      
      override public function shoot() : Boolean
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:b2Vec2 = null;
         var _loc4_:Vector.<MyLittleParticle> = null;
         this.charging -= TimeLord.speed;
         if(this.charging < 20)
         {
            if(this.charging < 0)
            {
               this.charging = 100;
               this.ud.triggered = false;
            }
            return super.shoot();
         }
         _loc1_ = "fire3";
         if(Boolean(this.ud.pfx) && this.ud.pfx.replaceDefault)
         {
            _loc1_ = this.ud.pfx.getParticle();
         }
         _loc2_ = 0;
         while(_loc2_ < this.charging * 0.02)
         {
            _loc3_ = GeneralUtils.pointOnCircle(shootPos.x * Physics.scale,shootPos.y * Physics.scale,this.charging * (Math.random() * 0.4 + 1.8),Math.random() * 360);
            _loc4_ = GameState.particles.addParticles(_loc3_.x,_loc3_.y,1,_loc1_,(shootPos.x * Physics.scale - _loc3_.x) * 0.1 + body.GetLinearVelocity().x * 0.1,(shootPos.y * Physics.scale - _loc3_.y) * 0.1 + body.GetLinearVelocity().y * 0.1,1,1);
            if((Boolean(_loc4_)) && Boolean(_loc4_[0]))
            {
               _loc4_[0].friction = 0.8;
            }
            _loc2_++;
         }
         return false;
      }
   }
}

