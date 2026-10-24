package triggers
{
   import Box2D.Common.Math.b2Vec2;
   
   public class FoldableStock extends WeaponMount
   {
      
      public function FoldableStock()
      {
         super();
         hand1 = new b2Vec2(-26 / Physics.scale,-6 / Physics.scale);
         ray1 = new b2Vec2(-28 / Physics.scale,-6 / Physics.scale);
         rayRange = 2;
      }
   }
}

