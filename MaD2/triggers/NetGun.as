package triggers
{
   import Box2D.Dynamics.b2Body;
   import Gun.Firearm;
   
   public class NetGun extends Gun
   {
      
      public var net:int = 0;
      
      public var nets:Vector.<Vector.<b2Body>>;
      
      public function NetGun(param1:Firearm)
      {
         super(param1);
         this.nets = new Vector.<Vector.<b2Body>>();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
      }
   }
}

