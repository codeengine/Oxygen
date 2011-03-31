
/*
    The ImageRepeatCanvas provides a container in which
    embeded images can be repeated
    as designers do in html tables.
*/

package net.codeengine.windowmanagement {
    import flash.display.Bitmap;
    import flash.display.Graphics;
    
    import spark.components.BorderContainer;

    /**
     *  The ImageRepeatCanvas container gives a way of creating
     * one image that repeat
     *  across either directions.
     *
     *  @mxml
     *
     *
<pre>
     *  <namespace:ImageRepeatCanvas
     *       repeatImage="{EmbededImage Class Reference}"
     *       repeatDirection="horizantal|horizantal"
     *    />
     *</pre>
*/
    [ExcludeClass]
    public class WindowBackground extends BorderContainer {
        //-------------------------------------------------------------
        //  Variables
        //-------------------------------------------------------------
        private var bgImg:Bitmap=new Bitmap();
        private var direction:String=REPEAT_HORIZANAL;
        public var repeatImage:Class;

        //--------------------------------------------------------------
        //  Constants
        //--------------------------------------------------------------
        public static var REPEAT_HORIZANAL:String="horizantal";
        public static var REPEAT_VERTICAL:String="vertical";

        //---------------------------------------------------------------
        //  Constructor
        //---------------------------------------------------------------
        public function WindowBackground() {
            super();
            this.setStyle("backgroundAlpha", 0);
            this.setStyle("dropShadowEnabled", false);
        }

        protected override function createChildren():void {
            super.createChildren();
        }

        

        /**
         *  A setter method to set the direction for repeation of image
         */
        [Inspectable(category="General", enumeration="horizantal,vertical", defaultValue="horizantal")]
        public function set repeatDirection(val:String):void {
            direction=val;
        }

        /**
         *  @private
         */
        override protected function updateDisplayList(w:Number, h:Number):void {
            super.updateDisplayList(w, h);
            bgImg.bitmapData=new repeatImage().bitmapData;
            if (bgImg) {
                switch (direction) {
                    case Background.REPEAT_HORIZANAL:
                        h=bgImg.height;
                        break;
                    case Background.REPEAT_VERTICAL:
                        w=bgImg.width;
                        break;
                }
                var Grpx:Graphics=graphics;
                Grpx.clear();

                Grpx.beginBitmapFill(new repeatImage().bitmapData);
                drawRoundRect(0, 0, this.width, this.height);
                Grpx.endFill();
            }
        }
    }
}
