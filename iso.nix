{ config, pkgs, ... }:

{
  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;
}
