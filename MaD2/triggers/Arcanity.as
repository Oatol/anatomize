package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class Arcanity extends Trigger
   {
      
      private var needsCutting:Boolean;
      
      private var starts:Vector.<b2Vec2>;
      
      private var ends:Vector.<b2Vec2>;
      
      private var lens:Vector.<Number>;
      
      public function Arcanity()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         this.starts = new Vector.<b2Vec2>();
         this.ends = new Vector.<b2Vec2>();
         this.lens = new Vector.<Number>();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc6_:int = 0;
         super.trigger(param1,param2);
         var _loc3_:Sprite = new Sprite();
         var _loc4_:uint = 15592941;
         var _loc5_:Vector.<Array> = ud.skin;
         if((Boolean(_loc5_)) && _loc5_.length > 0)
         {
            _loc4_ = BoxUtils.getSkinColour(_loc5_,"ededed");
         }
         _loc6_ = 0;
         while(_loc6_ < this.starts.length)
         {
            _loc3_.graphics.lineStyle(1,_loc4_,0.5);
            _loc3_.graphics.moveTo(GraphicUtils.camX(Math.random() + 10 - 5 + this.starts[_loc6_].x + camPos.x),GraphicUtils.camY(Math.random() + 10 - 5 + this.starts[_loc6_].y + camPos.y));
            _loc3_.graphics.lineTo(GraphicUtils.camX(Math.random() + 10 - 5 + this.ends[_loc6_].x + camPos.x),GraphicUtils.camY(Math.random() + 10 - 5 + this.ends[_loc6_].y + camPos.y));
            Main.instance.particlesBMD.draw(_loc3_);
            _loc6_++;
         }
         if(!this.needsCutting)
         {
            return;
         }
         if(ud.triggerState == 1)
         {
            ud.triggerState = 0;
            ud.triggered = false;
         }
         this.needsCutting = false;
         var _loc7_:Vector.<b2Body> = ud.connected.slice();
         _loc7_.push(body);
         _loc6_ = 0;
         while(_loc6_ < this.starts.length)
         {
            GameState.madeby = "arcanity";
            GameState.cutter.Exclude(_loc7_);
            GameState.cutter.CustomCut(this.starts[_loc6_],this.ends[_loc6_],1,this.lens[_loc6_],0);
            _loc6_++;
         }
         if(ud.triggerCustom == "destroy")
         {
            Body.Destroy(body,"functionality");
            return;
         }
         this.starts = new Vector.<b2Vec2>();
         this.ends = new Vector.<b2Vec2>();
         this.lens = new Vector.<Number>();
      }
      
      override public function onUntrigger() : void
      {
         super.onUntrigger();
         this.needsCutting = true;
         ud.triggered = true;
         ud.triggerState = 1;
      }
      
      override public function OnSharp(param1:b2Body, param2:Number = 0) : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc4_:b2Vec2 = null;
         var _loc5_:Number = NaN;
         super.OnSharp(param1);
         if(!param1)
         {
            return;
         }
         if(param1.IsStatic())
         {
            if(ud.triggerCustom == "destroy")
            {
               this.needsCutting = true;
            }
            return;
         }
         if(!ud.triggered)
         {
            return;
         }
         var _loc6_:Number = ud.triggerRadius * ud.size;
         _loc5_ = Math.random() * 72 + 36;
         _loc3_ = new b2Vec2(param1.GetPosition().x * Physics.scale + Math.random() * _loc6_ - _loc6_ * 0.5,param1.GetPosition().y * Physics.scale + Math.random() * _loc6_ - _loc6_ * 0.5);
         _loc4_ = new b2Vec2(param1.GetPosition().x * Physics.scale + Math.random() * _loc6_ - _loc6_ * 0.5,param1.GetPosition().y * Physics.scale + Math.random() * _loc6_ - _loc6_ * 0.5);
         this.starts.push(_loc3_);
         this.ends.push(_loc4_);
         this.lens.push(_loc5_);
         if(this.starts.length > ud.triggerForce)
         {
            this.needsCutting = true;
         }
      }
   }
}

