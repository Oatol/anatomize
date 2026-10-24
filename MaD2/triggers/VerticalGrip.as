package triggers
{
   import Box2D.Common.Math.b2Vec2;
   
   public class VerticalGrip extends WeaponMount
   {
      
      public function VerticalGrip()
      {
         super();
         hand1 = new b2Vec2(0,-12 / Physics.scale);
         ray1 = new b2Vec2(0,-22 / Physics.scale);
         rayRange = 4;
      }
   }
}

