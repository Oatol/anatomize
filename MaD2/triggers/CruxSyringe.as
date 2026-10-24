package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2Joint;
   import Box2D.Dynamics.b2Body;
   
   public class CruxSyringe extends Trigger
   {
      
      internal var bods:Vector.<b2Body> = new Vector.<b2Body>();
      
      public function CruxSyringe()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:b2Vec2 = null;
         var _loc9_:userData = null;
         var _loc10_:b2Body = null;
         super.trigger(param1,param2);
         if(param2.health > 0)
         {
            if(this.bods.length == 0)
            {
               _loc3_ = bodyCenter;
               _loc4_ = Math.cos(bodyAngle + Math.PI / 2);
               _loc5_ = Math.sin(bodyAngle + Math.PI / 2);
               _loc6_ = _loc3_.x * Physics.scale;
               _loc7_ = _loc3_.y * Physics.scale;
               _loc8_ = new b2Vec2(_loc6_ - 12 * param2.size * _loc4_,_loc7_ - 12 * param2.size * _loc5_);
               --param2.health;
               GameState.particles.addParticles(_loc8_.x,_loc8_.y,1,"blood",-_loc4_ * 4,-_loc5_ * 4,1,1);
            }
            else
            {
               for each(_loc10_ in this.bods)
               {
                  _loc9_ = userData(_loc10_.GetUserData());
                  if(_loc9_.alive)
                  {
                     if(_loc9_.health < _loc9_.maxhealth)
                     {
                        ++_loc9_.health;
                        --param2.health;
                     }
                  }
               }
            }
         }
      }
      
      override public function OnSharp(param1:b2Body, param2:Number = 0) : void
      {
         super.OnSharp(param1);
         var _loc3_:userData = userData(param1.GetUserData());
         if(!_loc3_.alive)
         {
            return;
         }
         if(_loc3_.health > 0 && ud.health < ud.maxhealth)
         {
            _loc3_.health -= 50;
            ud.health += 50;
         }
      }
      
      override public function OnJoint(param1:b2Body, param2:String) : Boolean
      {
         if(!super.OnJoint(param1,param2))
         {
            return false;
         }
         if(this.bods.indexOf(param1) == -1)
         {
            this.bods.push(param1);
         }
         return true;
      }
      
      override public function OnJointDelete(param1:b2Joint) : void
      {
         var _loc2_:b2Body = param1.GetBody1();
         if(_loc2_ == body)
         {
            _loc2_ = param1.GetBody2();
         }
         super.OnJointDelete(param1);
         var _loc3_:int = this.bods.indexOf(_loc2_);
         if(_loc3_ == -1)
         {
            this.bods.splice(_loc3_,1);
         }
      }
   }
}

