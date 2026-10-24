package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Contacts.b2ContactEdge;
   import Box2D.Dynamics.b2Body;
   
   public class EarthquakeMaker extends Trigger
   {
      
      public function EarthquakeMaker()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc6_:b2Body = null;
         var _loc7_:b2ContactEdge = null;
         var _loc8_:b2Vec2 = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius,param2.triggerRadius);
         var _loc4_:Number = param2.triggerForce * 10;
         var _loc5_:Boolean = false;
         for each(_loc6_ in _loc3_)
         {
            _loc5_ = false;
            _loc7_ = _loc6_.m_contactList;
            while(_loc7_)
            {
               if(_loc7_.other.IsStatic())
               {
                  _loc5_ = true;
                  break;
               }
               _loc7_ = _loc7_.next;
            }
            if(_loc5_)
            {
               _loc6_.WakeUp();
               _loc8_ = new b2Vec2(Math.random() * _loc4_ - _loc4_ * 0.5,Math.random() * _loc4_ - _loc4_ * 0.5);
               _loc8_.Multiply(_loc6_.GetMass());
               _loc6_.ApplyForce(_loc8_,_loc6_.GetPosition());
            }
         }
      }
   }
}

