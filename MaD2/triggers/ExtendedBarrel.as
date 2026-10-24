package triggers
{
   import Box2D.Common.Math.b2Vec2;
   
   public class ExtendedBarrel extends BarrelAttachment
   {
      
      public function ExtendedBarrel()
      {
         super();
         rayFrom = new b2Vec2(24 / Physics.scale,0);
         rayTo = new b2Vec2(25 / Physics.scale,0);
         rayRange = 6;
      }
   }
}

