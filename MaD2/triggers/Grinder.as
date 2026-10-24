package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Grinder extends Trigger
   {
      
      public function Grinder()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = new b2Vec2(-40 * param2.size,-20 * param2.size);
         var _loc4_:b2Vec2 = new b2Vec2(40 * param2.size,-20 * param2.size);
         var _loc5_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc6_:b2Vec2 = BoxUtils.rotateVec(_loc4_,bodyAngle);
         var _loc7_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc5_.x,pixelCenter.y + _loc5_.y);
         var _loc8_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc6_.x,pixelCenter.y + _loc6_.y);
         var _loc9_:Array = Body.GetAround(param1,50 * param2.size,20 * param2.size,false);
         if(_loc9_.length == 0)
         {
            return;
         }
         var _loc10_:b2Body = b2Body(_loc9_[0]);
         if(_loc10_ == param1)
         {
            return;
         }
         if(userData(_loc10_.GetUserData()).hasBeenCut && _loc10_.GetMass() < 0.5)
         {
            Body.Disintegrate(_loc10_,"inherit");
            return;
         }
         if(Math.random() > 0.9)
         {
            GameState.madeby = "grinder";
            if(Math.random() > 0.5)
            {
               GameState.cutter.CustomCut(_loc7_,_loc8_,1,100 * param2.size,0);
            }
            else
            {
               GameState.cutter.CustomCut(_loc8_,_loc7_,1,100 * param2.size,0);
            }
         }
      }
   }
}

