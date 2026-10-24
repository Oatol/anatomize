package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Repel extends Trigger
   {
      
      public function Repel()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc12_:b2Body = null;
         var _loc13_:b2Vec2 = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:b2Vec2 = null;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param1.IsStatic())
         {
            return false;
         }
         var _loc7_:String = "gravity";
         if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
         {
            _loc7_ = ud.pfx.getParticle();
         }
         var _loc8_:int = 0;
         while(_loc8_ < 10)
         {
            GameState.particles.addParticles(param5.x * Physics.scale,param5.y * Physics.scale,2,_loc7_,Math.random() * 8 - 4,Math.random() * 8 - 4,1,1);
            _loc8_++;
         }
         var _loc9_:Number = ud.triggerRadius / Physics.scale;
         var _loc10_:Array = BoxUtils.selectCompound(body);
         var _loc11_:Array = Body.GetMultiple(new b2Vec2(param5.x - _loc9_ * 0.5,param5.y - _loc9_ * 0.5),_loc9_,_loc9_);
         for each(_loc12_ in _loc11_)
         {
            if(_loc10_.indexOf(_loc12_) == -1)
            {
               if(!userData(_loc12_.GetUserData()).resistGust)
               {
                  _loc13_ = new b2Vec2(_loc12_.GetWorldCenter().x - param5.x,_loc12_.GetWorldCenter().y - param5.y);
                  _loc14_ = _loc13_.Normalize();
                  _loc15_ = (_loc9_ * Physics.scale - _loc14_) / (_loc9_ * Physics.scale) * 10 * ud.triggerForce;
                  _loc16_ = new b2Vec2(_loc13_.x * _loc15_,_loc13_.y * _loc15_);
                  _loc12_.ApplyForce(_loc16_,_loc12_.GetWorldCenter());
               }
            }
         }
         return true;
      }
   }
}

