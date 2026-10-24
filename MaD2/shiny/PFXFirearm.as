package shiny
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Gun.Firearm;
   import triggers.Gun;
   
   public class PFXFirearm extends ParticleEffect
   {
      
      internal var firearm:Firearm;
      
      public function PFXFirearm(param1:b2Body, param2:b2Vec2 = null)
      {
         super(param1,param2);
         this.init();
      }
      
      override protected function init() : void
      {
         if(!ud.trigger || !(ud.trigger is Gun))
         {
            ud.pfx = null;
         }
         if(ud.trigger is Gun)
         {
            this.firearm = Gun(ud.trigger).firearm;
         }
      }
      
      override public function update() : void
      {
         var _loc5_:* = undefined;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         super.update();
         if(!ud.triggered)
         {
            return;
         }
         if(!(ud.trigger is Gun) || !this.firearm.readyToFire)
         {
            return;
         }
         var _loc1_:b2Vec2 = this.firearm.shootPos;
         var _loc2_:int = -1;
         if(ud.flipped)
         {
            _loc2_ = 1;
         }
         var _loc3_:Number = amount;
         amount = 1;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_ * 10)
         {
            _loc5_ = Math.random();
            _loc6_ = _loc2_ * this.firearm.shootForce * Math.cos(body.GetAngle()) * (_loc5_ * 0.1) * speed;
            _loc7_ = _loc2_ * this.firearm.shootForce * Math.sin(body.GetAngle()) * (_loc5_ * 0.1) * speed;
            addParticles(_loc1_.x * Physics.scale,_loc1_.y * Physics.scale,this.firearm.bulletAmount,"sparkle",_loc6_,_loc7_,1,1);
            _loc4_++;
         }
         amount = _loc3_;
      }
   }
}

