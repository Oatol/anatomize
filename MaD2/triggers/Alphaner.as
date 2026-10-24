package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Alphaner extends BarrelAttachment
   {
      
      private var origBullet:String;
      
      public function Alphaner()
      {
         super();
         rayFrom = new b2Vec2(20 / Physics.scale,0);
         rayTo = new b2Vec2(25 / Physics.scale,0);
         rayRange = 6;
      }
      
      override protected function Attach(param1:b2Body) : void
      {
         super.Attach(param1);
         userData(attachedBody.GetUserData()).invisibling = true;
      }
      
      override protected function Detach() : void
      {
         super.Detach();
         if(attachedBody)
         {
            userData(attachedBody.GetUserData()).invisibling = false;
         }
      }
   }
}

