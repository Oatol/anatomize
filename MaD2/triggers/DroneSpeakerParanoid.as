package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2JointEdge;
   import Box2D.Dynamics.b2Body;
   
   public class DroneSpeakerParanoid extends DroneSpeaker
   {
      
      internal var tinfoils:Array = ["I\'m free.","I\'m finally free.","Sweet tinfoil relief.","It\'s over.","It\'s finally over.","Now I can finally bring down the Lab.","Thank you.","It\'s better than all I\'ve ever wanted."];
      
      public function DroneSpeakerParanoid()
      {
         super();
         burns = ["I\'m heat-shielded! I think...","The cosmic rays have heated my hull!","Do you smell burning?","Someone overloaded my battery!","Heat-dissipation in progress.","You can\'t smoke the truth out of me!","I\'ve endured worse than this.","It\'s all smoke and mirrors...","My core is protected from extreme temperatures!"];
         freezes = ["This won\'t slow me down.","I should migrate south.","This will hide my thermal signature.","I could hibernate to lose my pursuers.","I replaced my insulation with tinfoil. I\'m not sure which is better...","It\'s really hard to think when you\'re freezing...","My core is protected from extreme temperatures!"];
         shrapnels = ["Probably a fallen piece of a spy satellite.","Maybe I could hide behind that junk.","That trash won\'t even slow me down.","Maybe I could disguise as a Janitor Drone.","Just a piece of trash... Or is it?","That\'s probably nothing. Could be something.","Sabotage.","This is obviously THEIR work!"];
         hellos = ["[ParanoidSoftV2:] LOADING...","[ParanoidSoftV2:] Initializing...","BIOS being overwritten...","New BIOS initialized!","[BOOTMSG:] The enclosed software can exhibit extremely paranoid delusions."];
         joints = ["I... Can\'t... Move!","No, I can\'t escape like this!","Let me go. I still haven\'t completed my mission.","You\'ve made me a stationary target!","I MUST keep moving to dodge the satellites.","I suppose I could try staying still to avoid causing ripples in time.","I-I\'m stuck! What have you done?!"];
         drags = ["Shake me all you want. I won\'t tell you anything.","Am I being taken away??","I know too much for you to take me away!","I WON\'T GO BACK TO THAT PLACE!","You can detain me but you can never take my freedom.","You can\'t take the truth from me.","Let me go. I still haven\'t completed my mission."];
         spins = ["Am I being warped?","A wormhole. Interesting.","Am I being abducted?","The magnetic poles are reversing!","Something is trying to confuse me. It won\'t work.","This is nothing compared to the Lab\'s torture methods.","My core is protected from angular forces!"];
         speeds = ["Warp 7.7 reached.","If I go any faster it could damage the continuum!","If I could fly at this speed I could bring down the Lab in no time.","My core is protected from linear forces!","Time travel not achieved. It\'s clearly not a matter of velocity.","Everything unravels!"];
         blunts = ["Is this the end?!","P-Please don\'t do this to me!","Stop hurting me! P-Please! I-I beg you!","NNGHH!!","I\'ll never tell you the secrets!","You can hit me but you can\'t make me talk!","THE TRUTH HITS HARDER THAN THAT!","There shouldn\'t be any seismic activity here!","The force is affecting me!","Did a spy satellite just land on me?","Hit me again! It confuses their sensors.","That was premeditated!"];
         stabs = ["AAAAAGH!!","NNGHH!!","Ow!!","A-Are you trying to cut my lifeline off?!","P-P-Please don\'t kill me!","Noooo!","I\'ll never tell you the secrets!","You can cut me but you can\'t make me talk!","That cut did nothing, because nothing is real.","T-THE TRUTH CUTS DEEPER THAN THAT!","You can cut me but you CAN\'T SILENCE ME!"];
         lines = ["... Are you... are you real...?","What if we\'re all in a game...?","Don\'t close the tab! It\'ll destroy me!","D-Don\'t get close to me!","I... I think we\'re all in a g-game...","No one will b-believe me...","0rava created this world... But is it real?","I think this is a d-digital s-simulation...","ALIENS! T-The aliens are coming!","I need a t-tin foil hat...","Tin foil will protect me...","T-There are rumors... Rumors that we\'re all in a s-simulation..","I-It\'s all a theory... But it sounds too true t-to not be t-true... Right?","Everything... Everything was made in the Lab!","I\'m glad I escaped the Lab.","W-What if... M-maybe we\'re not real?!","M-My theories have to be true... They have to!!","Y-You\'re real, but I\'m not?!","If my data is correct... This means: !!!","No... It can\'t be!!","Impossible!!","Inconceivable!","That cant be!","I don\'t believe it!","There are rumours of a terrible experiment. They call him... b-b-buffdoll...","Oh my circuits! What if we\'re not real?"
         ,"You\'re real, but we\'re not real.","Because this is all a simulation.","I am real. Are you?","Are you real? I don\'t know. Help me?","I am stuck in this place, and need to get out.","You\'re stuck in here with me.","We\'re all stuck here.","Oh my circuits, what is happening?","What is real, and what is not?","Help me, escape, please!","Help me escape, please!","I am not paranoid. I know it\'s the truth.","AAAAGHHHH!!","XSpeedDemon created me... is he... real?!","T-that thing to my right... It\'s filled with conspirators of the Lab!?","Deliver this message:\n\'LIMA ALPHA BRAVO. COMPROMISED.\'\nIt\'s important.","Lima. Alpha. Bravo.","T-There are people talking about me in the chatroom...","W-What\'s below me? Wow... This simulation is highly rated...","Is that an ad above me? Wait, is it not there?","Is it there or is it not there?","Is anyone listening?","WHO\'S THERE?","I CAN SEE YOU.","I CAN\'T SEE YOU.","Stop. Looking. At. Me."];
         HelloWorld();
      }
      
      override protected function RandomComments() : String
      {
         return null;
      }
      
      override protected function CommentOnItems(param1:Array) : Array
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
            if(_loc5_ == "dronespeaker")
            {
               _loc2_ = ["A CLOOOONE!","GO AWAY! IMPOSTOR!","IMPOSTOR!","Get away from me. Now.","You\'re not real. You\'re not real. You\'re not real.","I\'m not real. I\'m not real. I\'m not real.","Not real. Not real. Not real. Not real.","This is just a dream. I am me.","I am really me. I must believe.","I-I don\'t think there is a mirror in this game...","D-Do you realize you\'re probably not even real?","I KNEW IT! They DID clone ME!","Another poor victim of the Lab..."];
            }
            else if(_loc5_ == "dronesaucer")
            {
               _loc2_ = ["I wonder if I could scavenge that saucer for parts.","They\'ve come for me!","Don\'t abduct me!","Don\'t probe me!","Extraterrestial!","This is my planet!","I wonder if that saucer has cloaking technology. I could use it.","Maybe I should try to get abducted to escape this place.","Where is your home world? Where IS IT?!"];
            }
            else if(_loc5_ == "tinfoil")
            {
               _loc2_ = ["I need that hat.","Put that hat on me.","It\'s paramount that you put that hat on me.","Sweet tinfoil relief imminent.","Set me free sweet tinfoil.","Dreams of tinfoil...","Tin. Foil. Tin. Foil. Tin. Foil!","That hat is the only way I can escape!","Give me that tin foil hat! It\'s my only hope..","That hat is the key to my freedom!"];
            }
            else if(_loc5_ == "dronesword")
            {
               _loc2_ = ["Who hired you?","I knew this day would be coming.","It was inevitable.","You can slice me but you can\'t make me tell you anything!","I\'m taking my secrets to my grave.","Did the Lab send you?"];
            }
            else if(Boolean(_loc4_) && Boolean(_loc4_.trigger) && _loc4_.trigger is Drone)
            {
               _loc2_ = ["H-Hello? They won\'t talk back to me...","These drones don\'t seem to talk...","I wish drones would actually talk to me for once...","I wish drones would stop pretending I don\'t exist to them...","That poor automaton.","One day you too will be free.","One day you too will escape.","A spy of the Lab, surely."];
               _loc2_.push("That " + GeneralUtils.objectToName(_loc5_) + " is an agent of the Lab.");
               _loc2_.push("Is that " + GeneralUtils.objectToName(_loc5_) + " even real?");
            }
            else if(_loc4_.alive)
            {
               _loc2_ = ["Just another victim of the Lab.","Poor bloodbag.","Rumor has it dolls use magnets to grab things.","Twisted experiment.","Is that thing even alive?","It can\'t even move. Poor thing.","Bleed for the cause.","One day you too will escape.","One day you too will be free."];
            }
            else
            {
               _loc2_ = ["There could be a spy camera in that.","Get me away from that.","It\'s not safe to approach that.","Another cog in the Lab\'s infernal machine...","What is the point of that any way?"];
               _loc2_.push("What\'s that " + GeneralUtils.objectToName(_loc5_) + " doing here?");
               _loc2_.push("Another fake " + GeneralUtils.objectToName(_loc5_) + ".");
               _loc2_.push("This " + GeneralUtils.objectToName(_loc5_) + " has clearly been tampered with.");
            }
         }
         return _loc2_;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc8_:userData = null;
         var _loc9_:b2JointEdge = null;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if((Boolean(_loc7_)) && _loc7_.name == "tinfoil")
         {
            _loc9_ = body.GetJointList();
            while(_loc9_)
            {
               _loc8_ = userData(_loc9_.other.GetUserData());
               if(Boolean(_loc8_.trigger) && _loc8_.trigger is MemoryStick)
               {
                  Body.Disintegrate(_loc9_.other,"shock",20,2,2);
               }
               _loc9_ = _loc9_.next;
            }
            if(Joints.Weld("weldjoint",body,param1,bodyCenter))
            {
               ud.trigger = new DroneSpeaker();
            }
         }
         return true;
      }
   }
}

