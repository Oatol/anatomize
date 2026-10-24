package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Gun.Firearm;
   
   public class MagnetGun extends Firearm
   {
      
      public var target:Vector.<b2Body>;
      
      internal var shots:int = 0;
      
      public function MagnetGun(param1:b2Body)
      {
         super("magnetgun",param1,3,50,1,5,"magnet",1,1);
         this.target = new Vector.<b2Body>();
      }
      
      override public function shoot() : Boolean
      {
         var _loc1_:userData = null;
         var _loc2_:b2Vec2 = null;
         var _loc3_:b2Vec2 = null;
         if(super.shoot())
         {
            _loc1_ = userData(body.GetUserData());
            if(this.target.length == 0 || !this.target[0])
            {
               this.target = new Vector.<b2Body>();
               return true;
            }
            _loc2_ = body.GetPosition().Copy();
            _loc2_.Subtract(this.target[0].GetPosition());
            _loc2_.Multiply(_loc1_.triggerForce);
            this.target[0].ApplyImpulse(_loc2_,this.target[0].GetPosition());
            _loc3_ = body.GetPosition();
            _loc3_.Multiply(Physics.scale);
            this.target = new Vector.<b2Body>();
            return false;
         }
         return false;
      }
   }
}

