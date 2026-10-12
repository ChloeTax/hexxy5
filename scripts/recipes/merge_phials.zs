
import crafttweaker.api.item.IItemStack;

val dustMultiplier = 10000 as long;
val maxMedia = 200000 * dustMultiplier as long;


public function MakePhial(newMaxMedia as long,newMedia as long) as IItemStack {
    return <item:hexcasting:battery>
           .with<long>(<componenttype:hexcasting:media>, newMedia)
           .with<long>(<componenttype:hexcasting:start_media>,newMaxMedia);
}

public function getMedia(phial as IItemStack) as long {
    return phial.getOrDefault<long>(
            <componenttype:hexcasting:media>, 0
        );
}

public function getStartMedia(phial as IItemStack) as long {
    return phial.getOrDefault<long>(
            <componenttype:hexcasting:start_media>, 0
        );
}


val phialInput = <item:hexcasting:battery> | MakePhial(64 * dustMultiplier as long,64 * dustMultiplier as long);

craftingTable.addShapeless(
    "hexxycraft/merge_phials",
    MakePhial(128 * dustMultiplier as long,0 as long),
    [phialInput, phialInput],
    (usualOut as IItemStack, inputs as IItemStack[]) => {
        val phial0Media = getMedia(inputs[1]);
        val phial0StartMedia = getStartMedia(inputs[1]);
        val phial1Media = getMedia(inputs[0]);
        val phial1StartMedia = getStartMedia(inputs[0]);
        //Are both phials full otherwise return nothing
        if(phial0Media == phial0StartMedia & phial1Media == phial1StartMedia) {
            val newStartMedia = (phial0Media + phial1Media) as long;
            //If the phials combined totel is more than 1 phial can have return 2 phials with the average of their capacity
            //otherwise return a new phial with thare combined capacity
            if(newStartMedia > maxMedia ) {
                return MakePhial(newStartMedia / 2 as long,0 as long) * 2;
            } else {
                return MakePhial(newStartMedia as long,0 as long);
            }
        }
        return <item:minecraft:air>;
    }
);