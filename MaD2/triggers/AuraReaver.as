package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class AuraReaver extends Trigger
   {
      
      private var needsCutting:Boolean;
      
      public function AuraReaver()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc4_:b2Vec2 = null;
         var _loc5_:Number = NaN;
         super.trigger(param1,param2);
         if(!this.needsCutting)
         {
            return;
         }
         this.needsCutting = false;
         var _loc6_:Number = triggerRadius * ud.size;
         var _loc7_:b2Vec2 = ud.triggerPos.Copy();
         _loc7_.Multiply(ud.size);
         var _loc8_:b2Vec2 = BoxUtils.rotateVec(_loc7_,bodyAngle);
         _loc8_.Add(pixelCenter);
         _loc8_.x += (Math.random() * ud.triggerRadius - ud.triggerRadius * 0.5) * ud.size;
         _loc8_.y += (Math.random() * ud.triggerRadius - ud.triggerRadius * 0.5) * ud.size;
         var _loc9_:int = 0;
         while(_loc9_ < 12)
         {
            _loc5_ = Math.random() * 12 + 2;
            _loc3_ = new b2Vec2(_loc8_.x + Math.random() * _loc6_ - _loc6_ * 0.5,_loc8_.y + Math.random() * _loc6_ - _loc6_ * 0.5);
            _loc4_ = new b2Vec2(_loc8_.x + Math.random() * _loc6_ - _loc6_ * 0.5,_loc8_.y + Math.random() * _loc6_ - _loc6_ * 0.5);
            GameState.madeby = "rendgrenade";
            GameState.cutter.ExcludeSingle(body);
            GameState.cutter.CustomCut(_loc3_,_loc4_,1,_loc5_,360);
            _loc9_++;
         }
      }
      
      override public function OnSharp(param1:b2Body, param2:Number = 0) : void
      {
         super.OnSharp(param1);
         if(!param1)
         {
            return;
         }
         if(param1.IsStatic())
         {
            return;
         }
         if(!ud.triggered)
         {
            return;
         }
         this.needsCutting = true;
      }
   }
}

