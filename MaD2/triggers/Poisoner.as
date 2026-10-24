package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Poisoner extends BarrelAttachment
   {
      
      private var origVol:Number;
      
      private var origBullet:String;
      
      public function Poisoner()
      {
         super();
         rayFrom = new b2Vec2(10 / Physics.scale,0);
         rayTo = new b2Vec2(15 / Physics.scale,0);
         rayRange = 6;
      }
      
      override protected function Attach(param1:b2Body) : void
      {
         super.Attach(param1);
         attachedFirearm.SetBulletProperty("poisoning",true);
      }
      
      override protected function Detach() : void
      {
         super.Detach();
         if(attachedBody)
         {
            attachedFirearm.SetBulletProperty("poisoning",false);
         }
      }
   }
}

