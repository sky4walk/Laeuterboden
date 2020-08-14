// Andre Betz
// github@AndreBetz.de

BottichDurchmesserDeckel = 350;
BottichDurchmesserBoden  = 322;
BottichHoehe             = 382;
LaeuterblechDicke        = 1;
LaeuterblechWinkel       = 120;
LaeuterblechAuflage      = 120;
SchlitzLaenge            = 27;
SchlitzBreite            = 1.2;
SchlitzAbstandX          = 42;
SchlitzAbstandY          = 4;
SchlitzVersatz           = 20;
LaeuterblechRand         = 6;

//$fn=20;

module Laeuterbottich(hoehe, d_oben, d_unten)
{
    cylinder(h=hoehe, r1=d_unten/2, r2=d_oben/2, center=false);
}

module Ebene(dicke, breite, winkel,auflage)
{
    wb = ( 180 - winkel ) / 2;
    radius = breite / 2;
    abstand = radius - sqrt(radius*radius - (auflage/2)*(auflage/2));
    translate([-radius+abstand,-breite,0])
        rotate ([0,-wb,0])
            cube([breite*2,breite*2,1],center=false);
}

module BottichSchnitt(hohe,d1,d2,dicke,winkel,auflage)
{
    intersection()
    {
        Ebene( dicke, d2, winkel,auflage);
        Laeuterbottich(hohe,d1,d2);
    }
}

module BlechHalbe(hohe,d1,d2,dicke,winkel,auflage)
{
    difference()
    {
        BottichSchnitt(hohe,d1,d2,dicke,winkel,auflage);
        translate([0,-d1/2,0])
            cube([d1,d1,hohe],center=false);
    }
}

module BlechHalbe3DSpiegeln(hohe,d1,d2,dicke,winkel,auflage)
{
    BlechHalbe(hohe,d1,d2,dicke,winkel,auflage);
    mirror([1,0,0])
        BlechHalbe(hohe,d1,d2,dicke,winkel,auflage);
}

module BlechHalbeFlach(hohe,d1,d2,dicke,winkel,auflage)
{
    wb = ( 180 - winkel ) / 2;
    radius = d2 / 2;
    abstand = radius - sqrt(radius*radius - (auflage/2)*(auflage/2));
    echo(abstand);
    translate([-radius-abstand,0,0])
        rotate([0,wb,0])
            translate([radius-abstand,0,0])
                BlechHalbe(hohe,d1,d2,dicke,winkel,auflage);
}

module BlechHalbe2DSpiegeln(hohe,d1,d2,dicke,winkel,auflage)
{
    BlechHalbeFlach(hohe,d1,d2,dicke,winkel,auflage);
    mirror([1,0,0])
        BlechHalbeFlach(hohe,d1,d2,dicke,winkel,auflage);
}

module Schlitz(laenge,breite,hoehe,posX,posY) 
{
    translate([posX,posY,-hoehe/4])
        minkowski()
        {
            cube([laenge,breite/2,hoehe]);
            cylinder(r=breite/4,hoehe/2);
        }  
}

module SchlitzeXDir(laenge,breite,hoehe,d2,auflage,winkel, abstand, start, posY)
{
    wb = ( 180 - winkel ) / 2;
    radius = d2 / 2;
    distBoden = sqrt(radius*radius - (auflage/2)*(auflage/2));
    lenC = distBoden / cos(wb);
    count = lenC * 2 / abstand;
    echo(lenC);
    echo(count);
    for ( x = [0 : count-1] ) {        
        Schlitz(laenge,breite,hoehe,start + abstand * x,posY);
    }
}

module SchlitzeYDir(
    laenge,
    breite,
    hoehe,d1,d2,
    bHoehe,
    auflage,
    winkel, 
    abstandX, 
    abstandY, 
    versatz)
{
    wb = ( 180 - winkel ) / 2;
    radius = d2 / 2;
    distBoden = sqrt(radius*radius - (auflage/2)*(auflage/2));
    lenH = distBoden * tan(wb);
    echo(distBoden);
    echo(lenH);
    
    deltaD = d1 - d2;
    rh = (deltaD/2 * lenH / bHoehe)*2 + d2;
    echo(rh);
    count = rh / abstandY;
    for ( x = [0 : count-1] ) {
       if ( x % 2 == 0) { 
        SchlitzeXDir(
            laenge,
            breite,
            hoehe,
            d2,
            auflage,
            winkel,
            abstandX,
            0,
            x*abstandY);
       } else {
        SchlitzeXDir(
            laenge,
            breite,
            hoehe,
            d2,
            auflage,
            winkel,
            abstandX,
            versatz,
            x*abstandY);
       }
    }
}
module Schlitze(
    lange, 
    breite, 
    dicke, 
    d1, d2, 
    bHoehe, 
    auflage, 
    winkel,
    abstandX,
    abstandY,
    versatz ) 
{

    intersection()
    { 
        cylinder(
            dicke, 
            d2/2, 
            d2/2, 
            center=true);
        translate([-d2/2,-d2/2,-2])
            SchlitzeYDir(
                lange,
                breite,
                dicke+3,
                d1,
                d2,
                bHoehe,
                auflage,
                winkel,
                abstandX,
                abstandY,
                versatz);
    }

}

module LaeuterBlechNeu(
    lange, 
    breite, 
    dicke, 
    d1, d2, 
    bHoehe, 
    auflage, 
    winkel,
    abstandX,
    abstandY,
    versatz)
{
    difference()
    {
    BlechHalbe2DSpiegeln(bHoehe,d1,d2,dicke,winkel,auflage);
    translate([0,0,-1])
        Schlitze(
            lange,
            breite,
            dicke+4,
            d1,
            d2,
            bHoehe,
            auflage,
            winkel,
            abstandX,
            abstandY,
            versatz);
        
    }   
}

LaeuterBlechNeu(
    SchlitzLaenge,
    SchlitzBreite,
    LaeuterblechDicke,
    BottichDurchmesserDeckel,
    BottichDurchmesserBoden,
    BottichHoehe,
    LaeuterblechAuflage,
    LaeuterblechWinkel,
    SchlitzAbstandX,
    SchlitzAbstandY,
    SchlitzVersatz);
