package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class StasisBullet extends GenericBullet
   {
      
      public function StasisBullet()
      {
         super("forcefield");
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:b2Vec2 = null;
         var _loc5_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(Boolean(param2.connected) && param2.connected.length > 0)
         {
            _loc3_ = 500;
            _loc4_ = new b2Vec2(Math.random() * _loc3_ - _loc3_ * 0.5,Math.random() * _loc3_ - _loc3_ * 0.5 - 2);
            _loc4_.Multiply(param1.GetMass());
            param1.ApplyForce(_loc4_,bodyCenter);
            _loc5_ = param2.connected[0].GetPosition().Copy();
            GraphicUtils.efla(Main.instance.particlesBMD,pixelCenter.x + Main.instance.m_sprite.x,pixelCenter.y + Main.instance.m_sprite.y,_loc5_.x * Physics.scale + Main.instance.m_sprite.x,_loc5_.y * Physics.scale + Main.instance.m_sprite.y,Math.random() * 255 << 24 | 0x94FF);
         }
      }
   }
}

