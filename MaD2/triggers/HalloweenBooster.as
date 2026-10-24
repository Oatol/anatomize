package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class HalloweenBooster extends TradingBooster
   {
      
      public function HalloweenBooster()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         openParticle = "bat";
         itemPool = ["halloweenbooster","largecauldron","emptyflask","witchwand","3dglasses_armour","alienhead","antenna","antennae","antantennae","aviatorsunglasses_armour","openpaperbag","yinyang","ballisticgoogles","bandana","bigflower","feather","brimstonehorns","burnthorns","chefhat","chefapron","cpui","bigcloud","partyhat2","icecube","genericcorntriangle","breadslice","crystalskull","curvedhorns","darkgnomemask","artdecoclock","desertskullmask","desertwrap","scarecrow","disguiseglasses","headmask","dronemask","dropbearmask","earpiece_armour","fishbowl_armour","futuregasmask4","gasmask2","glow","gnomemask","hazmathelmet","headband_armour","junglemask","leafyheadband","lettucehat","lightvisor","maskofbloodlust","maskoflies","deathorb","moaimask","bolts","satansmushroom","necromancermask","noctovisor","observervisor","gasmask","oneholebalaclava","papazambo","pineheadpiece","basicarrow","policehat","scouter","questmarker","cassettetape","raiderwrap","splicermask","robothelmet","rustybuckethelmet"
         ,"actualscarecrow","scarycrow","shinyunihorn","dragonstooth","skimask","sunglasses","tinycrown","tribalmask","tribalskirt","twoholebalaclava","futuristicmask","wastelandgasmask","watch","waterpolocap","wheatstraw","you"];
         super.init(param1,param2);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         ratios = [0.95,0.5,0.3,0.1];
         var _loc3_:Vector.<Array> = new Vector.<Array>();
         _loc3_.push(["9b8360","3d2111"]);
         _loc3_.push(["59482b","111111"]);
         _loc3_.push(["47391f","222222"]);
         _loc3_.push(["666666","ba5b1b"]);
         var _loc4_:Vector.<Array> = GameState.objects.spawnSkin.slice();
         GameState.objects.spawnSkin = _loc3_;
         super.trigger(param1,param2);
         GameState.objects.spawnSkin = _loc4_;
      }
   }
}

