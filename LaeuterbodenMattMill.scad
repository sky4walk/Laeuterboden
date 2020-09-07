// Andre Betz
// github@AndreBetz.de

BottichDurchmesser       = 450;
BottichDistanz           = 1.5;
BlechDicke               = 2;
BlechRand                = 10;
SchlitzLaenge            = 27;
SchlitzBreite            = 1.2;
SchlitzAbstandX          = 42;
SchlitzAbstandY          = 4;
SchlitzVersatz           = 20;

$fn=100;

module RundBlech(
    d, 
    ab, 
    rand, 
    hoehe)
{
    durchm = d - ab*2 - rand*2;
    cylinder(h=hoehe,r=durchm/2,center=false);
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

module Schlitze(
    laenge,
    breite,
    hoehe,
    d2,
    abstandX,
    abstandY,
    versatz)
{
    cx = d2 / abstandX;
    cy = d2 / abstandY;
    for ( y = [0 : cy] ) 
    {
        for ( x = [0 : cx] ) 
        {
            if ( y % 2 == 0 ) 
            {
                Schlitz(
                    laenge,
                    breite,
                    hoehe,
                    x*abstandX-d2/2,
                    y*abstandY-d2/2);
            } 
            else 
            {
                Schlitz(
                    laenge,
                    breite,
                    hoehe,
                    x*abstandX-d2/2+versatz,
                    y*abstandY-d2/2);
            }
        }
    }
}

module BlechSchlitze(
    d, 
    ab, 
    rand, 
    hoehe,
    laenge,
    breite,
    abstandX,
    abstandY,
    versatz)
{
    difference()
    {
        RundBlech(
            d,
            0,
            0,
            hoehe);
        translate([0,0,-1])
            RundBlech(
                d,
                ab,
                rand,
                hoehe+2);
    }

    difference()
    {
        RundBlech(
            d,
            ab,
            rand,
            hoehe);
        Schlitze(
            laenge,
            breite,
            hoehe,
            d,
            abstandX,
            abstandY,
            versatz);        
    }

}

BlechSchlitze(
    BottichDurchmesser,
    BottichDistanz,
    BlechRand,
    BlechDicke,
    SchlitzLaenge,
    SchlitzBreite,
    SchlitzAbstandX,
    SchlitzAbstandY,
    SchlitzVersatz);
