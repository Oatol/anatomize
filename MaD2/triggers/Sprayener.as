package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Sprayener extends BarrelAttachment
   {
      
      private var origSpread:Number;
      
      public function Sprayener()
      {
         super();
         rayFrom = new b2Vec2(25 / Physics.scale,0);
         rayTo = new b2Vec2(30 / Physics.scale,0);
         rayRange = 4;
      }
      
      override protected function Attach(param1:b2Body) : void
      {
         super.Attach(param1);
         this.origSpread = attachedFirearm.scatter;
         var _loc2_:Number = 0;
         if(this.origSpread == 0)
         {
            _loc2_ = 1;
         }
         var _loc3_:Number = ud.triggerForce * 0.1;
         attachedFirearm.scatter = (_loc2_ + this.origSpread) * _loc3_;
      }
      
      override protected function Detach() : void
      {
         super.Detach();
         if(attachedBody)
         {
            attachedFirearm.scatter = this.origSpread;
         }
      }
   }
}

