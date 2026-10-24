package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class DrainHeal extends Trigger
   {
      
      public function DrainHeal()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         ud.maxhealth = 10000;
         ud.health = 1;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc6_:Vector.<MyLittleParticle> = null;
         var _loc7_:MyLittleParticle = null;
         var _loc8_:b2Body = null;
         var _loc9_:userData = null;
         var _loc10_:b2Vec2 = null;
         var _loc11_:b2Vec2 = null;
         var _loc12_:int = 0;
         var _loc13_:b2Body = null;
         super.trigger(param1,param2);
         var _loc3_:Number = param2.triggerRadius;
         var _loc4_:Array = Body.GetAroundPoint(pixelCenter,_loc3_,_loc3_,false);
         var _loc5_:Boolean = false;
         _loc6_ = BoxUtils.AoEParticles(param1,"blood",10);
         for each(_loc7_ in _loc6_)
         {
            _loc7_.friction = 0.9;
            _loc7_.health = 20;
         }
         for each(_loc8_ in _loc4_)
         {
            if(param2.ignored.indexOf(_loc8_) == -1)
            {
               if(param2.connected.indexOf(_loc8_) == -1)
               {
                  _loc9_ = userData(_loc8_.GetUserData());
                  if(_loc9_.alive)
                  {
                     if(_loc9_.health >= param2.triggerForce)
                     {
                        _loc5_ = true;
                        _loc10_ = pixelCenter.Copy();
                        _loc11_ = _loc8_.GetWorldCenter().Copy();
                        _loc11_.Multiply(Physics.scale);
                        BoxUtils.randomSlopeParticles("blood",BoxUtils.pixelPosition(_loc8_),pixelCenter,5);
                        _loc9_.health -= param2.triggerForce;
                        param2.health += param2.triggerForce;
                     }
                  }
               }
            }
         }
         if(_loc5_)
         {
            _loc12_ = 1 + Math.random() * 4;
            sounds.play("drain" + _loc12_.toString(),null,pixelCenter,Math.random() * 0.5 + 0.1,false);
         }
         if(param2.health > param2.triggerForce)
         {
            for each(_loc13_ in param2.connected)
            {
               if(userData(_loc13_.GetUserData()).health < userData(_loc13_.GetUserData()).maxhealth - param2.triggerForce)
               {
                  userData(_loc13_.GetUserData()).health = userData(_loc13_.GetUserData()).health + param2.triggerForce;
                  param2.health -= param2.triggerForce;
                  if(param2.health <= 0)
                  {
                     param2.health = 0;
                     break;
                  }
                  _loc6_ = BoxUtils.randomSlopeParticles("heal",pixelCenter,BoxUtils.pixelPosition(_loc13_),Math.random() * 10,2,0.2);
                  for each(_loc7_ in _loc6_)
                  {
                     _loc7_.health = 20;
                  }
               }
            }
         }
      }
   }
}

