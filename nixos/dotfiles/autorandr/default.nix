{ config, lib, pkgs, ... }:

{
  programs.autorandr = {
    enable = true;
    profiles = {
      "docked-single" = {
        fingerprint = {
          DP2 = "00ffffffffffff0022f02633010000001f1a0103803c22782a1e50a756519c26115054a10800d1c0b300a9c095008180810081c00101023a801871382d40582c450056502100001e000000fd00323c1e5011000a202020202020000000fc00485020323765730a2020202020000000ff0033434d3633313052574b202020012e020319b149901f0413031201021167030c0020000022e2002b023a801871382d40582c450056502100001e023a80d072382d40102c458056502100001e011d007251d01e206e28550056502100001e011d00bc52d01e20b828554056502100001e8c0ad08a20e02d10103e9600565021000018000000000000000000000000d0";
        };
        config = {
          eDP1.enable = false;
          DP1.enable = false;
          DP3.enable = false;
          DP2 = {
            enable = true;
            crtc = 0;
            position = "0x0";
            mode = "1920x1080";
            rate = "60.00";
            primary = true;
          };
        };
      };
      "undocked" = {
        fingerprint = {
          eDP1 = "00ffffffffffff0006af2b2800000000001c0104a51d117802ee95a3544c99260f50540000000101010101010101010101010101010152d000a0f0703e803020350025a51000001a000000000000000000000000000000000000000000fe0039304e544880423133335a414e0000000000024103a8011100000b010a20200006";
        };
        config = {
          DP1.enable = false;
          DP2.enable = false;
          DP3.enable = false;
          eDP1 = {
            enable = true;
            crtc = 0;
            position = "0x0";
            mode = "1280x720";
            rate = "60.00";
            primary = true;
          };
        };
      };
    };
  };
}
