package net.codeengine.windowmanagement {
    import mx.controls.Label;

    [ExcludeClass]
    public class AbstractGroup extends Background {
        public function AbstractGroup() {
            this.setStyle("cornerRadius", 2);
            this.setStyle("borderColor", 0xc2c2c2);
            this.setStyle("borderStyle", "solid");
        }
    }
}