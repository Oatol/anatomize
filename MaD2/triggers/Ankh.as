package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   import shiny.PFXFirefly;
   import shiny.ParticleEffect;
   
   public class Ankh extends Trigger
   {
      
      public function Ankh()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         var _loc4_:ParticleEffect = null;
         super.init(param1,param2);
         var _loc3_:b2Vec2 = param1.GetWorldCenter().Copy();
         _loc3_.Add(ud.triggerPos);
         _loc4_ = new PFXFirefly(param1,_loc3_);
         _loc4_.attachParticles(1,"petrify");
         _loc4_.size = 1;
         _loc4_.speed = 1;
         _loc4_.amount = 1;
         param2.pfx = _loc4_;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(ud.triggerState == 0)
         {
            ud.triggerDuration -= TimeLord.speed;
            if(ud.triggerDuration <= 0)
            {
               ud.triggerState = 1;
            }
            return;
         }
         if(ud.triggerForce > 10)
         {
            ud.triggerForce -= TimeLord.speed * 0.5;
         }
         var _loc3_:Number = ud.triggerForce * 0.01;
         if(_loc3_ < 0.1)
         {
            _loc3_ = 0.1;
         }
         ud.pfx.speed = _loc3_;
         ud.pfx.size = ud.triggerForce / 450;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if(!_loc7_)
         {
            return false;
         }
         if(!_loc7_.alive)
         {
            return false;
         }
         if(ud.triggerState == 0)
         {
            return false;
         }
         Body.Damage(param1,ud.triggerForce * 2,param5,new b2Vec2(),new b2Vec2(1,1),false);
         if(ud.triggerForce > 500)
         {
            sounds.play("crash",body,param5,ud.triggerForce / 900,false);
         }
         ud.triggerState = 0;
         if(ud.triggerForce > 900)
         {
            ud.triggerForce = 900;
         }
         ud.triggerForce += 50;
         ud.triggerDuration = ud.originalTriggerDuration;
         return true;
      }
   }
}

