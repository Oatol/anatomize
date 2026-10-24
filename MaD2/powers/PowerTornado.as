package powers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PowerTornado extends Power
   {
      
      internal var windAngle:Number = 0;
      
      internal var windPos:b2Vec2;
      
      internal var counter:Number = 0;
      
      public function PowerTornado()
      {
         super(Tool.TORNADO,"air");
         this.windPos = new b2Vec2();
         noThrow = true;
         noEffectForce = false;
      }
      
      override public function Press(param1:b2Vec2, param2:b2Vec2) : void
      {
         super.Press(param1,param2);
         this.counter += Math.random() * 10 + 4;
         if(this.counter > 800)
         {
            this.counter = 0;
         }
         this.windAngle += Math.random() * 4 - 2;
         if(this.windAngle > 15)
         {
            this.windAngle = 15;
         }
         if(this.windAngle < -15)
         {
            this.windAngle = -15;
         }
         this.windPos = new b2Vec2(Math.sin(this.counter * 0.032) * Math.sqrt(this.counter),this.counter * 0.2);
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         var _loc2_:b2Vec2 = null;
         super.OnBodyPress(param1);
         _loc2_ = pressPos.Copy();
         _loc2_.y -= Tweak.toolRadius * 0.7;
         _loc2_.Multiply(1 / Physics.scale);
         _loc2_.Subtract(bodyPos);
         _loc2_.Multiply(10 * Tweak.toolEffectForce);
         if(Math.random() > 0.98)
         {
            _loc2_.Add(new b2Vec2(this.windPos.x * 100 * Tweak.toolEffectForce,bodyPos.y - this.windPos.y - 100 * Tweak.toolEffectForce * param1.GetMass()));
         }
         param1.GetLinearVelocity().Multiply(0.99);
         param1.ApplyForce(_loc2_,bodyPos);
      }
      
      override public function Particles(param1:b2Vec2, param2:b2Vec2) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc6_:b2Vec2 = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:String = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc5_:int = 0;
         while(_loc5_ < Tweak.toolRadius * 0.1)
         {
            _loc3_ = this.counter;
            if(Math.random() > 0.5)
            {
               _loc3_ *= Math.random();
            }
            if(_loc5_ > 5)
            {
               _loc3_ = Math.random() * 800;
            }
            _loc3_ *= Tweak.toolEffectForce / 100;
            _loc6_ = new b2Vec2(Math.sin(_loc3_ * 0.032) * Math.sqrt(_loc3_),_loc3_ * 0.2);
            _loc7_ = BoxUtils.rotateVec(_loc6_,Vars.toRadians * this.windAngle);
            _loc8_ = particle;
            _loc4_ = 0;
            if(Math.random() > 0.9)
            {
               _loc8_ = "poof";
               _loc4_ += Math.random() * 10 - 5;
            }
            _loc9_ = param1.x - _loc7_.x * Tweak.toolRadius / 100;
            _loc10_ = param1.y - _loc7_.y * Tweak.toolRadius / 100;
            GameState.particles.addParticles(_loc9_,_loc10_,1,_loc8_,_loc4_ + param2.x * 0.1,param2.y * 0.1 - 1,Math.random(),0.5);
            _loc5_++;
         }
      }
   }
}

