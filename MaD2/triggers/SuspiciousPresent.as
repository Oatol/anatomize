package triggers
{
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class SuspiciousPresent extends Trigger
   {
      
      public function SuspiciousPresent()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc10_:b2Body = null;
         var _loc11_:String = null;
         var _loc12_:int = 0;
         var _loc13_:String = null;
         super.trigger(param1,param2);
         var _loc3_:Number = Vars.objSize;
         var _loc4_:Array = [];
         if(param2.size < 0.3)
         {
            Vars.objSize = 0.2;
            GameState.objects.spawnObject("violin",pixelCenter.x,pixelCenter.y,bodyAngle,param2.flipped,true);
            Vars.objSize = _loc3_;
            param2.dead = true;
            if(sounds.isPlaying("violin"))
            {
               sounds.stop("violin");
            }
            sounds.play("violin",param1,pixelCenter,0.5);
            _loc4_.push("a brand new shiny stapler");
            _loc4_.push("a brand new shiny stapler");
            _loc4_.push("a brand new shiny stapler");
            _loc4_.push("a brand new shiny stapler");
            _loc4_.push("a pink assault rifle");
            _loc4_.push("a zombie");
            _loc4_.push("a car");
            _loc4_.push("artificial intelligence");
            _loc4_.push("a stapler");
            _loc4_.push("a stapler");
            _loc4_.push("a square");
            _loc4_.push("a square");
            _loc4_.push("one million dollars");
            _loc4_.push("one million euros");
            _loc4_.push("world peace");
            _loc4_.push("a gift");
            _loc4_.push("a surprise gift");
            _loc4_.push("a potato");
            _loc4_.push("a friend");
            _loc4_.push("a hug");
            _loc4_.push("a drone");
            _loc4_.push("a sword");
            _loc4_.push("a hammer");
            _loc4_.push("a knife");
            _loc4_.push("a warm hat");
            _loc4_.push("nothing");
            _loc4_.push("a normal violin");
            _loc4_.push("a snowman");
            _loc4_.push("snowy xmas");
            _loc4_.push("an apple");
            _loc4_.push("a crossbow");
            _loc12_ = 0;
            while(_loc12_ < 70)
            {
               _loc11_ = GeneralUtils.objectToName(O.names[int(Math.random() * O.names.length)]);
               _loc11_ = _loc11_.toLowerCase();
               if("aeoiu".indexOf(_loc11_.toLowerCase().substr(0,1)) == -1)
               {
                  _loc11_ = "a " + _loc11_;
               }
               else
               {
                  _loc11_ = "an " + _loc11_;
               }
               _loc4_.push(_loc11_);
               _loc12_++;
            }
            _loc13_ = "Dear Recipient,\n\nYour request for\n\'";
            _loc13_ = _loc13_ + _loc4_[int(Math.random() * _loc4_.length)];
            _loc13_ = _loc13_ + "\'\nhas been denied on account of you not being good this year.\n\nPlease find attached the world\'s smallest violin.\n\n-S";
            GameState.ui.showTooltip(param2.graphic,_loc13_,10,9000,250);
            return;
         }
         var _loc5_:Vector.<Array> = GameState.objects.spawnSkin;
         Vars.objSize = param2.size * 0.85;
         var _loc6_:Vector.<Array> = new Vector.<Array>();
         _loc6_.push(["dd4f65","FFFFFF"]);
         _loc6_.push(["ca495c","FFFFFF"]);
         _loc6_.push(["cac2c3","FFFFFF"]);
         _loc6_.push(["bbb4b5","FFFFFF"]);
         var _loc7_:uint = uint(Math.random() * 16777215);
         var _loc8_:uint = uint(Math.random() * 16777215);
         _loc6_ = BoxUtils.replaceSkinColour(_loc6_,"CAC2C3",_loc7_.toString(16));
         _loc6_ = BoxUtils.replaceSkinColour(_loc6_,"BBB4B5",GraphicUtils.scalehex(_loc7_,0.9).toString(16));
         _loc6_ = BoxUtils.replaceSkinColour(_loc6_,"DD4F65",_loc8_.toString(16));
         _loc6_ = BoxUtils.replaceSkinColour(_loc6_,"CA495C",GraphicUtils.scalehex(_loc8_,0.9).toString(16));
         GameState.objects.spawnSkin = _loc6_;
         GameState.objects.spawnObject("suspiciouspresent",pixelCenter.x,pixelCenter.y,bodyAngle,param2.flipped,true,_loc6_);
         Vars.objSize = _loc3_;
         GameState.objects.spawnSkin = _loc5_;
         var _loc9_:Vector.<b2Body> = Body.Decompose(param1);
         for each(_loc10_ in _loc9_)
         {
            userData(_loc10_.GetUserData()).name = BoxUtils.shapeNameToColour(userData(_loc10_.GetUserData()).name,param2.skin).toString(16);
            userData(_loc10_.GetUserData()).dead = true;
            Body.Disintegrate(_loc10_,"inherit",50,1,1);
         }
         sounds.play("rustle",param1,pixelCenter,Math.random() * 1.5 + 0.5);
      }
   }
}

