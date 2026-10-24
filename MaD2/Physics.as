package
{
   import Box2D.Dynamics.b2World;
   
   public class Physics
   {
      
      public static var world:b2World;
      
      public static var scale:Number;
      
      public static var contactFilter:CustomContactFilter;
      
      public function Physics()
      {
         super();
      }
   }
}

