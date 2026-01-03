include <../lib/relativity.scad/relativity.scad>

$fn = 256;

base_size = [40, 20, 7];
corner_radius = 2;

screw_head_height = 3;
screw_head_diam = 5.7;
screw_body_diam = 3.125;

thermistor_diam = 6;
thermistor_split_size = 3;
thermistor_holder_height = 4;
thermistor_holder_thickness = 2;

module screw_hole(head_height, head_diam, body_height, body_diam) {
  translate([0, 0, body_height]) cylinder(h=head_height + 0.01, r=head_diam / 2);
  translate([0, 0, -0.005]) cylinder(h=body_height + 0.01, r=body_diam / 2);
}

module thermistor_holder(hole_diam, split_width, holder_width, holder_height, holder_thickness) {
  difference() {
    union() {
      translate([0, -holder_width / 2, 0]) cube([holder_thickness, holder_width, holder_height + hole_diam / 2]);
      translate([0, 0, holder_height + hole_diam / 2]) rotate([0, 90, 0]) cylinder(holder_thickness, r=holder_width / 2);
    }

    translate([0, 0, holder_height + hole_diam / 2]) rotate([0, 90, 0]) cylinder(holder_thickness, r=hole_diam);

    translate([0, -split_width / 2, holder_height + hole_diam]) cube([holder_thickness, split_width, hole_diam]);
  }
}

module base(size = [1, 1, 1], radius = 0.5) {
  assert(size.x >= radius * 2);
  assert(size.y >= radius * 2);
  assert(size.z >= radius * 2);

  hull() {
    for (x = [(size.x - radius) / 2, -(size.x - radius) / 2])
      for (y = [(size.y - radius) / 2, -(size.y - radius) / 2]) {
        translate([x, y, 0]) cylinder(h=size.z - radius, r=radius);
        translate([x, y, size.z - radius]) sphere(r=radius);;
      }
  }
}

module main() {
  difference() {
    base(base_size, corner_radius);
    screw_hole(screw_head_height, screw_head_diam, base_size.z - screw_head_height, screw_body_diam);
  }

  for (x = [-(base_size.x / 2 - corner_radius), (base_size.x / 2 - corner_radius)])
    translate([x - thermistor_holder_thickness / 2, 0, base_size.z])
      thermistor_holder(
        thermistor_diam,
        thermistor_split_size,
        base_size.y - corner_radius,
        thermistor_holder_height,
        thermistor_holder_thickness,
      );
}

main();
