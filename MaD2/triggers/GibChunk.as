package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class GibChunk extends Trigger
   {
      
      public function GibChunk()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:uint = 0;
         super.trigger(param1,param2);
         if(bodyVel.Length() < 1 && Math.random() > 0.95)
         {
            this.Gib();
         }
         else if(Math.random() > 0.99)
         {
            this.Gib();
         }
         if(Math.random() > 0.9)
         {
            _loc3_ = Tweak.bloodColour;
            Tweak.bloodColour = param2.bloodColour;
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,"blood",bodyVel.x * 0.1,bodyVel.y * 0.1);
            Tweak.bloodColour = _loc3_;
         }
      }
      
      private function Gib() : void
      {
         var _loc1_:Number = 1;
         if(Boolean(ud.triggerForce) && ud.triggerForce != 0)
         {
            _loc1_ = Math.random() * ud.triggerForce - ud.triggerForce * 0.5;
         }
         ud.trigger = new Disintegrate("blood",Math.random() * 50 + 10,_loc1_);
         ud.triggered = true;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(Math.random() > 0.9)
         {
            this.Gib();
         }
         return super.OnCollision(param1,param2,param3,param4,param5,param6);
      }
      
      override public function OnCut() : Boolean
      {
         this.Gib();
         return true;
      }
   }
}

