package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2DistanceJoint;
   import Box2D.Dynamics.Joints.b2JointEdge;
   import Box2D.Dynamics.b2Body;
   
   public class Snare extends Trigger
   {
      
      public function Snare()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:userData = null;
         var _loc6_:b2Body = null;
         var _loc7_:int = 0;
         var _loc8_:b2JointEdge = null;
         var _loc9_:b2Vec2 = null;
         var _loc10_:b2Vec2 = null;
         var _loc11_:b2DistanceJoint = null;
         super.trigger(param1,param2);
         if(param2.resistSnare)
         {
            param2.trigger.reset();
            return;
         }
         if(param2.triggerDuration <= 0)
         {
            param2.trigger = null;
            return;
         }
         if(Math.random() > 0.9)
         {
            _loc3_ = 0;
            _loc4_ = Body.GetAround(param1,100,100,true);
            if(param2.alive)
            {
               Body.Damage(param1,Math.random() * 20 + 20,null,null,null,false);
            }
            if(Math.random() > 0.7)
            {
               Body.Growth(param1);
            }
            for each(_loc6_ in _loc4_)
            {
               if(_loc6_ != param1)
               {
                  _loc5_ = userData(_loc6_.GetUserData());
                  if(_loc5_.saveable)
                  {
                     if(!_loc5_.resistSnare)
                     {
                        _loc7_ = 0;
                        _loc8_ = _loc6_.GetJointList();
                        while(_loc8_)
                        {
                           if(jointUserData(_loc8_.joint.GetUserData()).name == "snarejoint")
                           {
                              _loc7_++;
                           }
                           _loc8_ = _loc8_.next;
                        }
                        if(!(_loc7_ > 1 && _loc5_.alive))
                        {
                           _loc3_++;
                           _loc5_.trigger = new Snare();
                           --param2.triggerDuration;
                           _loc5_.triggered = true;
                           param2.trigger = null;
                           _loc9_ = bodyCenter.Copy();
                           _loc9_.Add(BoxUtils.rotateVec(new b2Vec2((Math.random() * param2.width - param2.width * 0.5) / Physics.scale,(Math.random() * param2.height - param2.height * 0.5) / Physics.scale),bodyAngle));
                           _loc10_ = _loc6_.GetWorldCenter().Copy();
                           _loc10_.Add(BoxUtils.rotateVec(new b2Vec2((Math.random() * _loc5_.width - _loc5_.width * 0.5) / Physics.scale,(Math.random() * _loc5_.height - _loc5_.height * 0.5) / Physics.scale),_loc6_.GetAngle()));
                           _loc11_ = Joints.Distance("snarejoint",param1,_loc6_,_loc9_,_loc10_,1,1,true);
                           if(_loc11_)
                           {
                              jointUserData(_loc11_.GetUserData()).forceLimit = 1000;
                           }
                           break;
                        }
                        _loc5_.stabilise = false;
                        _loc5_.trigger = new Concussion(300);
                        _loc5_.triggered = true;
                     }
                  }
               }
            }
            if(_loc3_ <= 0)
            {
               if(Boolean(_loc5_) && !_loc5_.resistSnare)
               {
                  _loc5_.trigger = null;
                  _loc5_.triggerDuration = 0;
               }
               param2.trigger = null;
               param2.triggerDuration = 0;
            }
         }
      }
   }
}

