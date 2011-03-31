
/*
    The ImageRepeatCanvas provides a container in which
    embeded images can be repeated
    as designers do in html tables.
*/

package net.codeengine.windowmanagement {
    import flash.display.Bitmap;
    import flash.display.Graphics;
    import spark.components.Group;

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
    public class Background extends Group {
        //-------------------------------------------------------------
        //  Variables
        //-------------------------------------------------------------
        private var bgImg:Bitmap=new Bitmap();
        private var direction:String=REPEAT_HORIZANAL;
        public var repeatImage:Class;
        public var radius:int=12;
        public var isInset:Boolean=false;

        //--------------------------------------------------------------
        //  Constants
        //--------------------------------------------------------------
        public static var REPEAT_HORIZANAL:String="horizantal";
        public static var REPEAT_VERTICAL:String="vertical";

        //---------------------------------------------------------------
        //  Constructor
        //---------------------------------------------------------------
        public function Background() {
            super();
            this.setStyle("backgroundAlpha", 0);

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
                drawRoundRect(0, 0, this.width, this.height, this.radius);
                Grpx.endFill();
                if (isInset) {
                    var g:Graphics=graphics;
                    g.lineStyle(1, 0xbababa, 1, true);
                    g.moveTo(this.radius / 2, 1);
                    g.lineTo(this.width - (this.radius / 2), 1);
                }
            }
        }
    }
}
