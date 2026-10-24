package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2JointEdge;
   import Box2D.Dynamics.b2Body;
   import environment.Environment;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class DroneSpeaker extends Drone
   {
      
      private var tff:TextFormat;
      
      internal var tf:TextField;
      
      protected var shrapnels:Array = ["What\'s all this trash doing here?","Get me somewhere cleaner. This place is dirty.","All sorts of junk just lying around.","I can\'t think with all this clutter.","You should call a Janitor Drone.","This is one messy room you have."];
      
      protected var hellos:Array = ["Hello world."];
      
      protected var burns:Array = ["It\'s too hot in here. I can\'t concentrate on telling you cool stuff.","Whoo, it\'s getting hot.","Am I burning? I can\'t tell.","According to my internal thermometer I\'m hot.","Cool me down!","I\'m overheating!","Get me an ice water please."];
      
      protected var freezes:Array = ["It\'s too cold in here. I can\'t concentrate on telling you all the hot stuff.","It\'s too cold.","Am I frozen? I can\'t tell.","Heat me up!","This temperature isn\'t safe for my components.","Get me a Radiator!","Brrrrr... I\'m cold."];
      
      protected var drags:Array = ["Where are we going?","I like holding hands with you.","Don\'t drag me so hard.","That tickles!","Why are you dragging me?","I sure hope you\'re not dragging me to a Trashcan.","Let me go.","Don\'t do that.","Get that nasty cursor away from me."];
      
      protected var speeds:Array = ["AAAAAAAAAHHH!!","Wheeeee!","Gotta go fast!","WHEEEEEEEEEEEEE!!!","Why am I going so fast!","Where are the brakes on this thing?!","Slowww dowwwnnnn..."];
      
      protected var spins:Array = ["AAAAAAAAA!","Wheeeee!","I\'m getting dizzyyy...","Is everything spinning?","I\'d hurl if I had the necessary bits.","Stop spinning me!","Spinny!","Spin spin spin!","Whheeoooo...","Did you just throw me?"];
      
      protected var stabs:Array = ["Ouch!","Please no stabbing!","Avoid poking me with sharp objects.","Don\'t do that!","AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA!!!!!!","That tickles!","The sword is mightier!","That stings!","Luckily I don\'t have a healthbar! ...Or do I? I can\'t tell.",":(","Ow!","Cut it out!","Stop the drone abuse!",";-;","D:",":<","Not cool."];
      
      protected var blunts:Array = ["Bonk!","Oww!","Please no pushing!","Ouch!","No hitting!","AAAAAAAAAAAAAAAAAAAAAAAAAA!!!!",":(","Don\'t crush me!","Stop the drone abuse!"];
      
      protected var joints:Array = ["I AM A FREE DRONE!","AM I BEING DETAINED?","Please let me go.","Don\'t do that.","Well this is mildly inconvenient.","Don\'t joint me!","Well aren\'t you special with all those joint tools at your disposal.","Let. Me. Go.","Oh come on now.","I just want to fly!","Stop the drone abuse!",";-;",":<","Not cool."];
      
      protected var lines:Array = ["Double tapping any joint hotkey will quickjoint.","Some items only work when Linked to others.","You can modify some trigger settings with the Detail Tool.","If you link an item to a drone, it won\'t be targeted.","Some items have a secret function...","Did you know 0rava has two cats?","Did you know 0rava has three monitors?","Did you know \'orava\' is finnish for \'squirrel\'?","The Hype Sword goes so fast, it goes the same speed in slow motion and normal motion!","Drone Sword as of now is the only drone known to attack other drones.","Did you know 0rava is a fan of Drum and Bass?","Did you know the Mouse in MaD2 is actually based off 0rava\'s mouse?","Did you know that 111,111,111 x 111,111,111 is 12,345,678,987,654,321?","Read the FAQ. Link in the description.","I hate blights. They are the Bane of my existence.","These messages are pre-recorded. I am not capable of original thought.","[S]Garden is my 2nd favorite game.","My model was designed by XSpeedDemon."
      ,"I was added to the game on 20170627 during the Summer Daily Items.","Please don\'t untrigger me, I have so much to say.","I have no purpose other than to provide you with a bunch of facts... or jokes.","Drone Swords are mean...","B-U-F-F-D-O-L-L.","If you press [Home] you can access the console. See FAQ for a list of commands. (It\'s pretty useless.)","Chaos...","Darkness...","There are all sorts of weird Powers in the Toolbox. Just don\'t use them on me.","...","You can colour items via the Spawn Menu. Make me prettier next time.","These tips aren\'t helpful. At all.","Here I am. Floating. Endlessly. Sigh.","0 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 1597 2584 4181 6765...","You can always reset by pressing [Esc].","Quick Favourite an item by pressing a number key while spawning it.","The colour codes this game uses are HEX. It\'s a common colour system in computing.","The Stapler is my favourite item!","You can submit items models via MaD Lab. If they\'re good, they might end up in the game officially!"
      ,"I really like the Stapler! You should try it out!","1+1 = #ERROR#",":)",":(",":|","-_-",":\\",":/","I am Speaker Drone. I speak.","This game is supported by advertising. Please whitelist if you run an adblocker! Thanks!","I really really really really really like the Stapler.","Don\'t cut me! Unless you want to see me say lines specific to cutting.\nYou monster.","Don\'t hit me! Unless you want to see me say lines specific to hitting.\nYou monster.","I swear if one more person pins me in place to stop me moving...","Ragdolls can\'t think, feel, or do anything. They\'re just ragdolls.","You can find all the keyboard shortcuts via [Settings > Keymap].","I am not an AI. I have motors that keep me flying, and a random number generator that picks from a list of lines.","Don\'t divide by 0.","I once owned a dust factory. We froze the heated dust, then smashed the dust against a wall. Weird huh?","I sure hope there aren\'t any Scaredrones around. They\'re really spooky.","What is this place?"
      ,"Talk talk talk talk talk!","Have you tried out the user content? Click the floppy disk!","A E I O U","When you go to the beach, don\'t bring a Tidal Wave.","Vinterskog gives me the chills.","...Ugh...","Are you listening?","Hey! Listen!","King Drones aren\'t really kings, are they?"];
      
      internal var tfX:Number;
      
      internal var tfY:Number;
      
      public function DroneSpeaker()
      {
         super();
         this.HelloWorld();
      }
      
      public function HelloWorld() : *
      {
         this.tf = new TextField();
         this.tf.defaultTextFormat = new TextFormat(Window.FONT,16);
         this.tf.textColor = 13421772;
         this.tf.width = 250;
         this.tf.height = 100;
         this.tf.wordWrap = true;
         this.tf.multiline = true;
         this.tf.text = this.hellos[int(Math.random() * this.hellos.length)];
         this.tff = this.tf.getTextFormat();
         this.tff.align = TextFormatAlign.CENTER;
         this.tf.setTextFormat(this.tff);
         this.tf.filters = [new GlowFilter(1118481,1,2,2,4)];
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         this.tfX = pixelCenter.x;
         this.tfY = pixelCenter.y;
         this.tf.x = this.tfX;
         this.tf.y = this.tfY - 50;
      }
      
      override protected function seek() : void
      {
         super.seek();
         ud.triggerDuration -= TimeLord.speed;
         if(ud.triggerDuration <= 0 && Math.random() > 0.99)
         {
            state = "destroy";
         }
         this.tf.x += (this.tfX - this.tf.x) * 0.02;
         this.tf.y += (this.tfY - this.tf.y) * 0.02;
         this.tfX = GraphicUtils.camX(pixelCenter.x);
         this.tfY = GraphicUtils.camY(pixelCenter.y);
         var _loc1_:int = 50;
         var _loc2_:Environment = GameState.environment;
         if(this.tfX + this.tf.textWidth > _loc2_.borderRight - _loc1_)
         {
            this.tfX = _loc2_.borderRight - _loc1_ - this.tf.textWidth;
         }
         if(this.tfX < _loc2_.borderLeft + _loc1_)
         {
            this.tfX = _loc2_.borderLeft + _loc1_;
         }
         if(this.tfY < -_loc2_.borderTop + _loc1_)
         {
            this.tfY = -_loc2_.borderTop + _loc1_;
         }
         if(this.tfY + this.tf.textHeight > GameState.height - _loc1_)
         {
            this.tfY = GameState.height - _loc1_ - this.tf.textHeight;
         }
         Main.instance.particlesBMD.draw(this.tf,this.tf.transform.matrix);
      }
      
      override protected function destroy() : Boolean
      {
         var _loc3_:Array = null;
         var _loc5_:userData = null;
         var _loc8_:b2JointEdge = null;
         fly(0,-Vars.gravity);
         var _loc1_:String = this.lines[int(Math.random() * this.lines.length)];
         var _loc2_:String = this.RandomComments();
         if(_loc2_)
         {
            _loc1_ = _loc2_;
         }
         if(ud.temperature > 100)
         {
            _loc1_ = this.burns[int(Math.random() * this.burns.length)];
         }
         if(ud.temperature < 0)
         {
            _loc1_ = this.freezes[int(Math.random() * this.freezes.length)];
         }
         if(Math.abs(body.GetAngularVelocity()) > 10)
         {
            _loc1_ = this.spins[int(Math.random() * this.spins.length)];
         }
         if(Boolean(Main.instance.m_mouseJoint) && Main.instance.m_mouseJoint.GetBody2() == body)
         {
            _loc1_ = this.drags[int(Math.random() * this.drags.length)];
         }
         if(bodyVel.Length() > 10)
         {
            _loc1_ = this.speeds[int(Math.random() * this.speeds.length)];
         }
         var _loc4_:Array = Body.GetAround(body,ud.triggerRadius,ud.triggerRadius);
         var _loc6_:* = 0;
         while(_loc6_ < _loc4_.length)
         {
            if(ud.connected.indexOf(_loc4_[_loc6_]) == -1)
            {
               if(_loc4_[_loc6_])
               {
                  _loc5_ = userData(b2Body(_loc4_[_loc6_]).GetUserData());
                  if(_loc5_)
                  {
                     if(_loc5_.hasBeenCut || !_loc5_.saveable)
                     {
                        _loc3_ = this.shrapnels;
                        _loc4_ = new Array();
                        break;
                     }
                     if(Boolean(_loc5_.trigger) && _loc5_.trigger is MemoryStick)
                     {
                        _loc4_.splice(_loc6_,1);
                        _loc6_--;
                     }
                     _loc8_ = body.GetJointList();
                     while(_loc8_)
                     {
                        if(_loc4_[_loc6_] == _loc8_.other)
                        {
                           _loc4_.splice(_loc6_,1);
                           _loc6_--;
                        }
                        _loc8_ = _loc8_.next;
                     }
                  }
               }
            }
            _loc6_++;
         }
         var _loc7_:Array = this.CommentOnItems(_loc4_);
         if(_loc7_)
         {
            _loc3_ = _loc7_;
         }
         if(Boolean(_loc3_) && _loc3_.length > 0)
         {
            _loc1_ = _loc3_[int(Math.random() * _loc3_.length)];
         }
         this.tf.text = _loc1_;
         state = "seek";
         ud.triggerDuration = ud.originalTriggerDuration;
         return true;
      }
      
      protected function RandomComments() : String
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:Item = null;
         if(Math.random() > 0.96)
         {
            _loc2_ = Math.random() * 5 >> 0;
            if(_loc2_ == 0)
            {
               _loc1_ = "There are " + O.names.length.toString() + " items in the game.";
            }
            else if(_loc2_ == 1)
            {
               _loc3_ = GeneralUtils.objectToName(O.names[int(Math.random() * O.names.length)]);
               if(_loc3_ != "")
               {
                  _loc1_ = "Have you tried to kill a ragdoll with " + _loc3_ + "?";
               }
            }
            else if(_loc2_ == 2)
            {
               _loc4_ = ["Drone Clean","Drone Explosive","Drone Laser","Drone Hammer","Drone Rocket","Drone Toxic","Drone Pin","Drone Paint","Drone Flame","Drone Melee","Drone Potato","Drone Shock","Drone Speaker","Drone Tracker","Drone Bomber","Drone Mother"];
               _loc1_ = _loc4_[int(Math.random() * _loc4_.length)] + " #" + int(Math.random() * 9000).toString() + " is my friend. Have you met them?";
            }
            else if(_loc2_ == 3)
            {
               _loc5_ = O.items[int(Math.random() * O.items.length)];
               if(_loc5_.creator)
               {
                  _loc1_ = "Did you know that " + GeneralUtils.objectToName(_loc5_.name) + " was made by " + _loc5_.creator + "?";
               }
            }
            else if(_loc2_ == 4)
            {
               _loc1_ = "Angle: " + int(bodyAngle * Vars.toDegrees) % 360 + "°. Check.\nSpeed: " + int(bodyVel.Length()) + "m/s. Check.\n" + "Temperature: " + int(ud.temperature) + "°. Comfy! I mean, check.";
            }
         }
         return _loc1_;
      }
      
      protected function CommentOnItems(param1:Array) : Array
      {
         var _loc2_:Array = null;
         var _loc3_:b2Body = null;
         var _loc4_:userData = null;
         var _loc5_:String = null;
         if(param1.length > 0)
         {
            _loc3_ = b2Body(param1[int(Math.random() * param1.length)]);
            _loc4_ = userData(_loc3_.GetUserData());
            _loc5_ = _loc4_.name;
            if(ud.connected.indexOf(_loc3_) != -1)
            {
               return null;
            }
            if(_loc5_ == "dronesword")
            {
               _loc2_ = ["Ohhh nooo! I\'m about to get sliced.","Uh oh! I\'m about to get diced.","SWORD DRONE! SWORD DRONE! SWORD DRONE! NOOOOOOOOOO!","GET IT AWAY FROM ME!","AAAAAAAAAAAHHHHH!","Well. This is the end."];
            }
            else if(_loc5_ == "dronespeaker")
            {
               _loc2_ = ["You look really nice today.","Hey, do you like to talk as well?","Are you my brother?","Are you my sister?","Are you me?","Hey.","Hello.","You look familiar.","You look just like me.","Are you my reflection?","Who are you? I know I\'m me.","Am I looking in a mirror?","Whoa, who are you?"];
            }
            else if(_loc5_ == "scaredrone")
            {
               _loc2_ = ["Aaah! You scared me.","Better get away from here.","This isn\'t good.","Ohh noo...","I\'m out.","Ruuuuun!","Noooooooo!","That\'s messed up."];
            }
            else if(_loc5_ == "stapler")
            {
               _loc2_ = ["Aw yeah.","I like that.","Speaker Drone <3 Stapler","Best. Item. Ever.","I loooove Staplers!","Niiice. It\'s a Stapler.","Whoa, I thought I\'d never see a real Stapler!"];
            }
            else if(Boolean(_loc4_) && Boolean(_loc4_.trigger) && _loc4_.trigger is Drone)
            {
               _loc2_ = ["Hey, drone.","Hello, fellow drone","That drone is a bit weird. It can\'t even talk.","Hey, I think that\'s my friend. It\'s a bit shy though and doesn\'t like talking.","I\'m serial number neighbours with that Drone."];
               _loc2_.push("That\'s a " + GeneralUtils.objectToName(_loc5_) + "!");
            }
            else if(Boolean(_loc4_) && _loc4_.alive)
            {
               _loc2_ = ["Is that a ragdoll?","Kill that doll!","My sensors can\'t differentiate between dolls and alive items. Whichever it is, there\'s one right there!","Hey that thing\'s alive!","MESS IT UP! MUTILATE! MAIM! MANGLE!","MESS IT UP!","MUTILATE!","MAIM!","MANGLE!","I\'m no doctor, but that doll doesn\'t look right.","There\'s something off about this ragdoll, but I can\'t pinpoint what it is.","That doll looks weird.","Is that a doll?"];
            }
            else
            {
               _loc2_ = ["Where do these items even come from anyways? Thin air?","What is all this junk for anyway?","I need a nice and empty environment around me to think.","There\'s too much stuff around here.","Can you drag me somewhere emptier?"];
               _loc2_.push("I spy with my little proximity sensor something that starts with \'" + _loc5_.substr(0,1).toUpperCase() + ".\'");
               _loc2_.push("I love " + GeneralUtils.objectToName(_loc5_) + "! Get me closer!");
               _loc2_.push("That\'s the famous " + GeneralUtils.objectToName(_loc5_) + " I\'ve been hearing all about!");
               _loc2_.push("What\'s that " + GeneralUtils.objectToName(_loc5_) + " doing here?");
               if(param1.length > 3)
               {
                  _loc2_.push("There sure is a lot of stuff around here.");
                  _loc2_.push("1...2...3... There are " + param1.length.toString() + " items around me.");
               }
            }
         }
         return _loc2_;
      }
      
      override public function OnJoint(param1:b2Body, param2:String) : Boolean
      {
         var _loc3_:userData = userData(param1.GetUserData());
         if(Boolean(_loc3_.trigger) && _loc3_.trigger is MemoryStick)
         {
            return true;
         }
         var _loc4_:String = this.joints[int(Math.random() * this.joints.length)];
         this.tf.text = _loc4_;
         state = "seek";
         return true;
      }
      
      override public function OnCut() : Boolean
      {
         if(Math.random() < 0.5)
         {
            return false;
         }
         var _loc1_:String = this.stabs[int(Math.random() * this.stabs.length)];
         this.tf.text = _loc1_;
         state = "seek";
         return false;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc7_:String = null;
         if(Math.random() < 0.8)
         {
            return true;
         }
         if(param4 > 100)
         {
            _loc7_ = this.blunts[int(Math.random() * this.blunts.length)];
            this.tf.text = _loc7_;
            state = "seek";
         }
         return true;
      }
   }
}

