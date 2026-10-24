package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class BiscuitBox extends Trigger
   {
      
      public var biscuits:Array = ["cookie","cookie","cookie","cookie","cookie","cookie","cookie","cookie","cookie","cookie","petitbeurre","petitbeurre","petitbeurre","doughnut","fruitcake","ginormouscookie","gingerbreadman","gingerbreadman","gingerbreadman","gingerbreadman","gingerbreadman","gingerbreadman","doughnut2","icecreamcone","muffin","pancake","empirebiscuit","empirebiscuit","empirebiscuit"];
      
      public function BiscuitBox()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(param2.triggerDuration > 0)
         {
            param2.triggerDuration -= TimeLord.speed;
            return;
         }
         if(param2.originalTriggerDuration < 10)
         {
            param2.originalTriggerDuration = 10;
         }
         param2.triggerDuration = param2.originalTriggerDuration;
         var _loc3_:String = this.biscuits[int(Math.random() * this.biscuits.length)];
         var _loc4_:Item = O.getItem(_loc3_);
         var _loc5_:b2Vec2 = param2.triggerPos.Copy();
         var _loc6_:b2Vec2 = BoxUtils.rotateVec(_loc5_,bodyAngle);
         var _loc7_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc6_.x,pixelCenter.y + _loc6_.y);
         var _loc8_:b2Body = GameState.objects.spawnItem(_loc4_.vertices,[0.5],_loc4_.scale * param2.size,_loc3_,_loc7_.x,_loc7_.y,bodyAngle,_loc4_.colours);
         var _loc9_:b2Vec2 = new b2Vec2(_loc7_.x - pixelCenter.x,_loc7_.y - pixelCenter.y);
         _loc9_.Multiply(param2.triggerForce);
         _loc8_.ApplyForce(_loc9_,_loc8_.GetWorldCenter());
         userData(_loc8_.GetUserData()).ignore = param2.name;
         userData(_loc8_.GetUserData()).trigger = new MilkCookie();
         param2.triggered = false;
      }
   }
}

