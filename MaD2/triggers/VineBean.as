package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2DistanceJoint;
   import Box2D.Dynamics.b2Body;
   
   public class VineBean extends Trigger
   {
      
      public function VineBean()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc8_:int = 0;
         var _loc9_:uint = 0;
         var _loc10_:Vector.<Array> = null;
         var _loc11_:userData = null;
         var _loc12_:b2Vec2 = null;
         var _loc13_:b2DistanceJoint = null;
         super.trigger(param1,param2);
         var _loc3_:Vector.<b2Body> = new Vector.<b2Body>();
         var _loc4_:int = 5;
         var _loc5_:int = 50;
         var _loc6_:Number = pixelCenter.x;
         var _loc7_:Number = pixelCenter.y - 60;
         _loc8_ = 0;
         while(_loc8_ < _loc4_)
         {
            _loc9_ = 8494657;
            _loc10_ = param2.skin;
            if((Boolean(_loc10_)) && _loc10_.length > 0)
            {
               _loc9_ = BoxUtils.getSkinColour(_loc10_,"819e41");
            }
            _loc11_ = Properties.objectProperties(_loc9_.toString());
            _loc12_ = new b2Vec2(0,-(_loc4_ * _loc5_ * 0.5) + _loc8_ * _loc5_);
            param1 = Spawn.circle(_loc6_ + _loc12_.x,_loc7_ + _loc12_.y,2,_loc11_,[_loc8_ == 0 ? 0 : 2,1,1]);
            if(param1)
            {
               userData(param1.GetUserData()).sticky = true;
               userData(param1.GetUserData()).saveable = false;
               _loc3_.push(param1);
            }
            _loc8_++;
         }
         _loc8_ = 0;
         while(_loc8_ < _loc3_.length - 1)
         {
            _loc13_ = Joints.Distance("vinejoint",_loc3_[_loc8_],_loc3_[_loc8_ + 1],_loc3_[_loc8_].GetPosition(),_loc3_[_loc8_ + 1].GetPosition(),10,1.9);
            if(_loc13_)
            {
               jointUserData(_loc13_.GetUserData()).lineColour = _loc9_;
            }
            _loc8_++;
         }
         param2.dead = true;
      }
   }
}

