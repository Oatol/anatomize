package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class ChristmasPresent extends Trigger
   {
      
      public function ChristmasPresent()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         var _loc3_:* = ["halo","candycane","tinytree","coal","balloon","present","ornamentgun","santahat","firework","fireworklauncher","throwflake","elfhat","gingerbreadman","hamshank","piggybank","woodentoygun","toyrocketship","skate","imad","phone","skateboard","canepole","xmasdecoration","moneypack","moneysack","sled","walkietalkie","jingleball"];
         Body.Destroy(param1,"present");
         var _loc4_:b2Body = GameState.objects.spawnObject(_loc3_[int(Math.random() * _loc3_.length)],pixelCenter.x,pixelCenter.y,bodyAngle * Vars.toDegrees,Math.random() > 0.5,true);
      }
   }
}

