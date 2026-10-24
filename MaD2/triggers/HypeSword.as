package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2JointEdge;
   import Box2D.Dynamics.b2Body;
   
   public class HypeSword extends Trigger
   {
      
      public function HypeSword()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:jointUserData = null;
         var _loc11_:b2Vec2 = null;
         super.trigger(param1,param2);
         var _loc4_:String = "hype";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc4_ = param2.pfx.getParticle();
         }
         var _loc5_:Boolean = false;
         var _loc6_:b2JointEdge = param1.GetJointList();
         while(_loc6_)
         {
            _loc5_ = true;
            _loc3_ = jointUserData(_loc6_.joint.GetUserData());
            if(_loc3_.name != "mouse")
            {
               GameState.particles.addParticles(_loc6_.joint.GetAnchor1().x * Physics.scale,_loc6_.joint.GetAnchor1().y * Physics.scale,1,_loc4_,0,0,2,2);
               if(Math.random() > 0.95)
               {
                  Physics.world.DestroyJoint(_loc6_.joint);
               }
            }
            _loc6_ = _loc6_.next;
         }
         if(_loc5_)
         {
            return;
         }
         var _loc7_:b2Vec2 = triggerPos;
         var _loc8_:b2Vec2 = param1.GetPosition();
         var _loc9_:Number = _loc7_.x - _loc8_.x;
         var _loc10_:Number = _loc7_.y - _loc8_.y;
         _loc11_ = param1.GetLinearVelocity();
         if(Math.random() > 0.9)
         {
            _loc11_.x += Math.random() * 100 - 50;
            _loc11_.y += Math.random() * 100 - 50;
         }
         if(pixelCenter.y > GameState.height)
         {
            bodyCenter.y = GameState.height / Physics.scale;
            _loc11_.y *= -1;
         }
         else if(pixelCenter.y < -GameState.environment.borderTop + GameState.height)
         {
            bodyCenter.y = (-GameState.environment.borderTop + GameState.height) / Physics.scale;
            _loc11_.y *= -1;
         }
         if(pixelCenter.x > GameState.environment.borderRight)
         {
            bodyCenter.x = GameState.environment.borderRight / Physics.scale;
            _loc11_.x *= -1;
         }
         else if(pixelCenter.x < GameState.environment.borderLeft)
         {
            bodyCenter.x = GameState.environment.borderLeft / Physics.scale;
            _loc11_.x *= -1;
         }
         param1.SetXForm(bodyCenter,Math.atan2(param1.GetLinearVelocity().y,param1.GetLinearVelocity().x) + Math.PI * 0.5);
         _loc11_.Multiply(2);
         if(_loc11_.Length() > 10)
         {
            this.OnTrigger();
         }
      }
      
      public function OnTrigger() : void
      {
         var _loc4_:userData = null;
         var _loc5_:b2Vec2 = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:String = null;
         var _loc1_:Number = ud.triggerRadius * ud.size;
         var _loc2_:Array = Body.GetAround(body,_loc1_,_loc1_,false);
         var _loc3_:b2Body = _loc2_[Math.random() * _loc2_.length >> 0];
         if(Boolean(_loc3_) && _loc3_ != body)
         {
            _loc4_ = userData(_loc3_.GetUserData());
            _loc4_.trigger = new Hyped(100);
            _loc4_.triggered = true;
            _loc4_.triggerDuration = 12;
            Body.Damage(_loc3_,Math.random() * 48 + 24,new b2Vec2(),new b2Vec2(),new b2Vec2(),false);
            _loc5_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,20 * ud.size,Math.random() * 360);
            _loc6_ = _loc3_.GetWorldCenter().Copy();
            _loc6_.Multiply(Physics.scale);
            _loc7_ = "hype";
            if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
            {
               _loc7_ = ud.pfx.getParticle();
            }
            GameState.particles.addParticles(_loc6_.x,_loc6_.y,1,_loc7_,0,0,2,2);
         }
      }
   }
}

