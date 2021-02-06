// Andre Betz
// github@AndreBetz.de
// Bottich Umfang aussen gemessen an 
// der Stelle mit Massband
BottichUmfang            = 1376;
BottichWandDicke         = 0.8;
BottichDistanz           = 2.6; // adopted to d=431mm 
BlechDicke               = 1;
BlechRand                = 8;
SchlitzLaenge            = 31;
SchlitzBreite            = 1.3;
SchlitzAbstandX          = 50;
SchlitzAbstandY          = 4;
SchlitzVersatz           = 25;
SchraubeM5               = 5.5;

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

module Bohrloch(
    d,
    posX,
    posY,
    hoehe) 
{
    translate([posX,posY,-1])
        cylinder(
            hoehe,
            d/2,
            d/2,
            center = false);
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
    durchm = d - 2*ab;
    echo ( "D=", durchm );
    difference()
    {
        
        RundBlech(
            durchm,
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

module BlechSchlitzeLoecher(
    d, 
    wandDicke,
    wandDist,
    rand, 
    hoehe,
    laenge,
    breite,
    abstandX,
    abstandY,
    versatz,
    ds)
{   
    ab = wandDicke+wandDist;
    rPos = d/2 - ab - rand; 
    rPos2 = (d*3/4-rand) / 2;
    difference()
    {
        union ()
        {
            BlechSchlitze(
                d, 
                ab,
                rand, 
                hoehe,
                laenge,
                breite,
                abstandX,
                abstandY,
                versatz);
            
            translate([0,0,hoehe/2]) 
            {
                cube([d-2*ab,rand,hoehe],true);
                cube([rand,d-2*ab,hoehe],true);
                rotate([0,0,45])
                  cube([rand,d-2*ab,hoehe],true);
                rotate([0,0,-45])
                  cube([rand,d-2*ab,hoehe],true);
            }
            difference()
            {
                RundBlech(
                  d*3/4,
                  0,
                  0,
                  hoehe);
                translate([0,0,-hoehe/2]) 
                {
                  RundBlech(
                    d*3/4-rand*2,
                    0,
                    0,
                    hoehe*3);
                }
            }
        }
        Bohrloch(
            ds,
            0,
            0,
            hoehe*3);
        Bohrloch(
            ds,
            rPos2,
            0,
            hoehe*3);
        Bohrloch(
            ds,
            -rPos2,
            0,
            hoehe*3);
        Bohrloch(
            ds,
            0,
            rPos2,
            hoehe*3);
        Bohrloch(
            ds,
            0,
            -rPos2,
            hoehe*3);
        Bohrloch(
            ds,
            rPos2*sin(45),
            rPos2*cos(45),
            hoehe*3);
        Bohrloch(
            ds,
            rPos2*sin(45),
            -rPos2*cos(45),
            hoehe*3);
        Bohrloch(
            ds,
            -rPos2*sin(45),
            rPos2*cos(45),
            hoehe*3);
        Bohrloch(
            ds,
            -rPos2*sin(45),
            -rPos2*cos(45),
            hoehe*3);        
    }
}
projection()
{
    BlechSchlitzeLoecher(
        BottichUmfang / PI,
        BottichWandDicke,
        BottichDistanz,        
        BlechRand,
        BlechDicke,
        SchlitzLaenge,
        SchlitzBreite,
        SchlitzAbstandX,
        SchlitzAbstandY,
        SchlitzVersatz,
        SchraubeM5);
}