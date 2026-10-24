package triggers
{
   import Box2D.Common.Math.b2Vec2;
   
   public class ExtendedStock extends WeaponMount
   {
      
      public function ExtendedStock()
      {
         super();
         hand1 = new b2Vec2(-44 / Physics.scale,-2 / Physics.scale);
         ray1 = new b2Vec2(-46 / Physics.scale,-2 / Physics.scale);
         rayRange = 2;
      }
   }
}

