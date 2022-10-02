/**
 * DIN rail case
 *
 * I choose to split the box in different parts to make it easier to design.
 * The box is composed like this schema:
 *   _____
 *  _|   |C|
 * | |   |
 * |A| B |
 * |_|   |_
 *   |___|D|
 *
 */
$fn=100;

// DIN rail width is 35mm
din_rail_width=35;
// A module width is 18mm but it's recommended to use 17.5 to garantie compatibility
width=17.5;
// box wall thickness
wall_thickness=1.5;
double_wall_thickness=2*wall_thickness;

// Parts variables 
A_height=45;
A_depth=16;
B_height=81;
B_depth=44;
C_height=22.5;
C_hook_height=5;
C_depth=5;
D_height=22.5;
D_depth=5;
hook_height=36;
hook_pin_height=5;
hook_base_depth=function (size) width*size*2/3;
hook_top_depth=function (size) hook_base_depth(size)*0.7;
cover_depth=A_depth+B_depth;
screw_pole_width=6;
screw_hole_radius=1;
screw_hole_offset=screw_pole_width/2+wall_thickness;

complete_set(size=2, terminal_number=1, screw=true);

module complete_set(size=1, terminal_number=undef, screw=true) {
    box(size, terminal_number, screw);
    translate([A_depth+B_depth+C_depth+10, 0, 0]) hook(size);
    translate([A_depth+B_depth+C_depth+10+hook_base_depth(size)+10, 0, 0]) cover(screw);
}

/**
 * Create a "size" (module number) case 
 */
module box(size=1, terminal_number=undef, screw=true) {
    translate([0, (B_height-A_height)/2, 0]) part_A(size, screw);
    translate([A_depth, 0, 0]) part_B(size, terminal_number, screw);
    translate([A_depth+B_depth, B_height-C_height-C_hook_height, 0]) part_C(size);
    translate([A_depth+B_depth, 0, 0]) part_D(size);
}

/**
 * Part A
 */
module part_A(size=1, screw=true) {
    w=width*size-wall_thickness;
    difference() {
        cube([A_depth, A_height, w]);
        translate([wall_thickness, wall_thickness, wall_thickness])
            cube([A_depth, A_height - double_wall_thickness, w]);
    }
    translate([0, 0, w]) cube([wall_thickness, A_height, wall_thickness]);
    if (screw) {
        difference() {
            translate([wall_thickness, wall_thickness, 0]) cube([screw_pole_width, screw_pole_width, w-wall_thickness]);
            translate([screw_hole_offset, screw_hole_offset, 1]) cylinder(w, screw_hole_radius, screw_hole_radius);
        }
        difference() {
            translate([wall_thickness, A_height-screw_pole_width-wall_thickness, 0]) cube([screw_pole_width, screw_pole_width, w-wall_thickness]);
            translate([screw_hole_offset, A_height-screw_hole_offset, 1]) cylinder(w, screw_hole_radius, screw_hole_radius);
        }
    }
}

/**
 * Part B
 */
module part_B(size=1, terminal_number=undef, screw=true) {
    w=width*size-wall_thickness;
    terminal_width=10;
    terminal_block_number=terminal_number==undef ? floor((width-double_wall_thickness)*size/terminal_width) : terminal_number;
    terminal_hole_width=terminal_block_number*terminal_width;
    difference() {
        // exterior
        cube([B_depth, B_height, w]);
        // interior
        translate([wall_thickness, wall_thickness, wall_thickness])
            cube([B_depth - double_wall_thickness, B_height - double_wall_thickness, w]);
        // separation wall between A and B
        translate([-1, (B_height-A_height)/2 + wall_thickness, wall_thickness])
            cube([double_wall_thickness, A_height - double_wall_thickness, w]);
        // terminals parts
        // terminal cables holes
        translate([5.5, -1, wall_thickness]) cube([6, wall_thickness+2, terminal_hole_width]); // TODO use variables
        translate([5.5, B_height-wall_thickness-1, wall_thickness]) cube([6, wall_thickness+2, terminal_hole_width]); // TODO use variables
        // terminal screws holes
        translate([-1, 2.5, wall_thickness]) cube([double_wall_thickness, 6, terminal_hole_width]); // TODO use variables
        translate([-1, B_height-6-2.5, wall_thickness]) cube([double_wall_thickness, 6, terminal_hole_width]); // TODO use variables
    }
    // terminal walls
    difference() {
        // walls
        union() {
            // bottom
            translate([wall_thickness, wall_thickness+8, wall_thickness]) cube([wall_thickness+10, wall_thickness, terminal_hole_width+wall_thickness]);
            translate([wall_thickness+10, wall_thickness, wall_thickness]) cube([wall_thickness, wall_thickness+8, terminal_hole_width+wall_thickness]);
            // top
            translate([wall_thickness, B_height-double_wall_thickness-8, wall_thickness]) cube([wall_thickness+10, wall_thickness, terminal_hole_width+wall_thickness]);
            translate([wall_thickness+10, B_height-double_wall_thickness-8, wall_thickness]) cube([wall_thickness, wall_thickness+8, terminal_hole_width+wall_thickness]);
        }
        // terminals pins hole
        // bottom
        translate([wall_thickness+9, wall_thickness+3, wall_thickness]) cube([wall_thickness+2, 2, terminal_hole_width+wall_thickness+1]);
        // top
        translate([wall_thickness+9, B_height-double_wall_thickness-3, wall_thickness]) cube([wall_thickness+2, 2, terminal_hole_width+wall_thickness+1]);
    }
    if (screw) {
        difference() {
            translate([B_depth-screw_pole_width-wall_thickness, wall_thickness, 0]) cube([screw_pole_width, screw_pole_width, w-wall_thickness]);
            translate([B_depth-screw_hole_offset, screw_hole_offset, 1]) cylinder(w, screw_hole_radius, screw_hole_radius);
        }
        difference() {
            translate([B_depth-screw_pole_width-wall_thickness, B_height-screw_pole_width-wall_thickness, 0]) cube([screw_pole_width, screw_pole_width, w-wall_thickness]);
            translate([B_depth-screw_hole_offset, B_height-screw_hole_offset, 1]) cylinder(w, screw_hole_radius, screw_hole_radius);
        }
    }
}

/**
 * Part C
 */
module part_C(size=1) {
    hook_space=2;
    w=width*size-wall_thickness;
    translate([hook_space, 0, 0]) cube([C_depth-hook_space, C_hook_height, w]);
    translate([0, C_hook_height, 0]) cube([C_depth, C_height, width*size]);
    difference() {
        translate([-1.6, 1.6, 0]) cylinder(w, 2, 2);
        translate([-4, -4, -1]) cube([4, 8, w+2]);
    }
}

/**
 * Part D
 */
module part_D(size=1) {
    difference() {
        cube([D_depth, D_height, width*size]);
        offset=(width*size-hook_base_depth(size))/2;
        translate([0, -1, hook_base_depth(size)+offset])
            rotate([0, 90, 0])
                hook(size, offset=0);
    }
}

/**
 * Hook mobile part
 */
module hook(size=1, offset=0.25) {
    a=hook_base_depth(size) - offset;
    b=hook_top_depth(size) - offset;
    h=D_depth-wall_thickness - offset;
    // main part
    trapeze(
        a,
        b,
        hook_height,
        h
    );
    // pin part
    pin_base=5;
    pin_top=pin_base+hook_pin_height;
    translate([(a-b)/2+b, hook_height+(pin_top-pin_base)/2, h])
        rotate([0, 180, 90])
            trapeze(
                pin_top,
                pin_base,
                b, 
                h
            );
    // TODO hanging hole
}

module cover(screw=true) {
    screw_countersunk_radius=screw_pole_width/2;
    translate([A_depth+B_depth-wall_thickness, 0, 0]) mirror([1, 0, 0]) {
        translate([0, (B_height-A_height)/2, 0])
            difference() {
                union() {
                    cube([A_depth-wall_thickness, A_height, wall_thickness]);
                    if (screw) {
                        // screw poles
                        translate([0, wall_thickness, 0]) cube([screw_pole_width, screw_pole_width, double_wall_thickness]);
                        translate([0, A_height-screw_pole_width-wall_thickness, 0]) cube([screw_pole_width, screw_pole_width, double_wall_thickness]);
                    }
                }
                if (screw) {
                    // screw thread holes
                    translate([screw_hole_offset-wall_thickness, screw_hole_offset, -1]) cylinder(wall_thickness*3, screw_hole_radius, screw_hole_radius);
                    translate([screw_hole_offset-wall_thickness, A_height-screw_hole_offset, -1]) cylinder(wall_thickness*3, screw_hole_radius, screw_hole_radius);
                    // screw head holes
                    translate([screw_hole_offset-wall_thickness, screw_hole_offset, -1]) cylinder(wall_thickness+1, screw_countersunk_radius, screw_countersunk_radius);
                    translate([screw_hole_offset-wall_thickness, A_height-screw_hole_offset, -1]) cylinder(wall_thickness+1, screw_countersunk_radius, screw_countersunk_radius);
                }
            }
        translate([A_depth-wall_thickness, 0, 0])
            difference() {
                union() {
                    cube([B_depth, B_height, wall_thickness]);
                    if (screw) {
                        // screw poles
                        translate([B_depth-screw_pole_width-wall_thickness, wall_thickness, 0]) cube([screw_pole_width, screw_pole_width, double_wall_thickness]);
                        translate([B_depth-screw_pole_width-wall_thickness, B_height-screw_pole_width-wall_thickness, 0]) cube([screw_pole_width, screw_pole_width, double_wall_thickness]);
                    }
                }
                if (screw) {
                    // screw thread holes
                    translate([B_depth-screw_hole_offset, screw_hole_offset, -1]) cylinder(wall_thickness*3, screw_hole_radius, screw_hole_radius);
                    translate([B_depth-screw_hole_offset, B_height-screw_hole_offset, -1]) cylinder(wall_thickness*3, screw_hole_radius, screw_hole_radius);
                    // screw head holes
                    translate([B_depth-screw_hole_offset, screw_hole_offset, -1]) cylinder(wall_thickness+1, screw_countersunk_radius, screw_countersunk_radius);
                    translate([B_depth-screw_hole_offset, B_height-screw_hole_offset, -1]) cylinder(wall_thickness+1, screw_countersunk_radius, screw_countersunk_radius);
                }
            }
    }
}

module trapeze(bottom_lenght, top_lenght, width, height) {
    top_offset=(bottom_lenght-top_lenght)/2;
    translate([0, width, 0])
    rotate([90, 0, 0])
    linear_extrude(height = width) {
        polygon(
            points = [
                [0, 0],
                [bottom_lenght, 0],
                [bottom_lenght-top_offset, height],
                [top_offset, height]
            ]
        );
    }
}
