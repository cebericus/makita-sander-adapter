//
// nelsoncs 2014Jul20 - NCSAppSoft.com
// 
// vacuum adapter for makita palm sander model BO4552 - attaches where the
// useless bag was to go, and meant to fit your "average" household vacuum
// cleaner wand (NOT a shop vac).
//
// Don't forget that it requires template punched holes in the sand paper.
//

sander_fitting_corner = 1.5;
wall_thickness        = 4;
anti_manifold         = 8;

sander_fitting_width  = 32;
sander_fitting_height = 11;
sander_fitting_length = 12;
sander_diff_cube =      [sander_fitting_width,
                        sander_fitting_length,
                        sander_fitting_height
                        ];

sander_fitting_wall   = [sander_fitting_width + wall_thickness,
                        sander_fitting_length,
                        sander_fitting_height + wall_thickness
                        ];

vacuum_diameter       = 35.5;
taper                 = 2;
vacuum_length         = 30;



module fillet(r, h) {
    translate([r/2, r/2, 0])
    difference() {
       cube([r + 0.01, r + 0.01, h], center = true);

       translate([r/2, r/2, 0])
           cylinder(r = r, h = h + 1, center = true);
    }
}

module hull_inside() {
    hull() {
        rotate( [90,0,0] )
        translate( [0, 0, 15] )
        cylinder( d1 = vacuum_diameter, 
                  d2 = vacuum_diameter + taper,
                  h  = vacuum_length
                  );
        
        translate( [ 0, 0, -((vacuum_diameter/2)-wall_thickness) ] )
        cube( size = sander_diff_cube, center=true);
    }
}

module hull_outside() {
    hull() {
        rotate( [90,0,0] )
        translate( [0, 0, 15] )
        cylinder( d1 = vacuum_diameter+wall_thickness, 
                  d2 = vacuum_diameter+wall_thickness + taper,
                  h  = vacuum_length
                  );
        
        translate( [ 0, 0, -((vacuum_diameter/2)-wall_thickness) ] )          
        cube( size = sander_fitting_wall, center=true);
                  
    }
}


module assembly() {
    union() {
    
        //
        // vacuum attachment and hull to sander side
        //
        difference() {
            hull_outside();
            hull_inside();
        }
    
        //
        // sander attachment with fillets
        //
        union() {
            translate( [ 0, sander_fitting_length, -((vacuum_diameter/2)-wall_thickness) ] )
            difference() {                
                cube( size = sander_fitting_wall, center=true);
                cube( size = sander_diff_cube, center=true);
            }
        
            //
            // inside chamfers to match sander
            //
            translate( [0, sander_fitting_length, -((vacuum_diameter/2) + wall_thickness/2) + 0.5] )
            rotate( [90,0,0] )
             {
                translate( [sander_fitting_width/2, 0, 0] ) {
                    
                    //
                    // upper left
                    //
                    rotate( [0, 0, 90] )
                    fillet( 1.5, sander_fitting_length);

                    //
                    //  lower left
                    //
                    translate( [0, sander_fitting_height, 0] ) {
                        rotate( [0, 0, 180] )
                        fillet( 1.5, sander_fitting_length);
                    }
                }
                
                translate( [-sander_fitting_width/2, 0, 0] ) {
                    
                    //
                    // upper right
                    //
                    fillet( 1.5, sander_fitting_length);
                
                    //
                    //  lower right
                    //
                    translate( [0, sander_fitting_height, 0] ) {
                        rotate( [0, 0, -90] )
                        fillet( 1.5, sander_fitting_length);
                    }
                }
            }
        }  // sander attachment
    } // top level union
}

assembly();

